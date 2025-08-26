//! CONFIG
import urls from '../../shared/camera.json'

const uploadUrl = urls.photoUrl; 
const uploadField = "file"; //? default upload field
const videoUrl = urls.videoUrl;
//! CONFIG

import { CfxTexture, LinearFilter, Mesh, NearestFilter, OrthographicCamera, PlaneBufferGeometry, RGBAFormat, Scene, ShaderMaterial, UnsignedByteType, WebGLRenderTarget, WebGLRenderer } from "/module/Three.js";
import { callNui } from "./nui";

var isAnimated = false;
var MainRender;
var scId = 0;
let isTakingScreenshot = false; // Aktif screenshot olup olmadığını kontrol etmek için değişken

// from https://stackoverflow.com/a/12300351
function dataURItoBlob(dataURI) {
    const byteString = atob(dataURI.split(',')[1]);
    const mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]

    const ab = new ArrayBuffer(byteString.length);
    const ia = new Uint8Array(ab);
  
    for (let i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
    }
  
    const blob = new Blob([ab], {type: mimeString});
    return blob;
}

// citizenfx/screenshot-basic
class GameRender {
    constructor() {
        this.resize = this.resize.bind(this); // <-- BURAYA KOY
        window.addEventListener('resize', this.resize);
        window.addEventListener('resize', this.resize);

        this.recorder = null;
        this.recordedBlobs = [];
        this.isRecording = false;
        this.videoDuration = 5000; // 5 saniyelik video kaydı
        
        // PERFORMANS: Frame limiter ekle
        this.lastRenderTime = 0;
        this.targetFPS = 30;
        this.frameInterval = 1000 / this.targetFPS;

        const cameraRTT = new OrthographicCamera(window.innerWidth / -2, window.innerWidth / 2, window.innerHeight / 2, window.innerHeight / -2, -10000, 10000);
        cameraRTT.position.z = 0;
        cameraRTT.setViewOffset(window.innerWidth, window.innerHeight, 0, 0, window.innerWidth, window.innerHeight);

        const sceneRTT = new Scene();
        
        // PERFORMANS: Render target boyutunu küçült
        const scaleFactor = 0.7;
        const rtWidth = Math.floor(window.innerWidth * scaleFactor);
        const rtHeight = Math.floor(window.innerHeight * scaleFactor);
        
        const rtTexture = new WebGLRenderTarget(rtWidth, rtHeight, {
            minFilter: NearestFilter,
            magFilter: NearestFilter,
            format: RGBAFormat,
            type: UnsignedByteType,
            generateMipmaps: false // PERFORMANS
        });

        const gameTexture = new CfxTexture();
        gameTexture.needsUpdate = true;

        const material = new ShaderMaterial({
            uniforms: { "tDiffuse": { value: gameTexture } },
            vertexShader: `
                varying vec2 vUv;
                void main() {
                    vUv = vec2(uv.x, 1.0-uv.y);
                    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
                }
            `,
            fragmentShader: `
                varying vec2 vUv;
                uniform sampler2D tDiffuse;
                void main() {
                    gl_FragColor = texture2D(tDiffuse, vUv);
                }
            `
        });

        const aspectRatio = 16 / 9;
        const plane = new PlaneBufferGeometry(window.innerWidth, window.innerWidth / aspectRatio);
        const quad = new Mesh(plane, material);
        quad.position.z = -100;
        sceneRTT.add(quad);

        const renderer = new WebGLRenderer({
            powerPreference: "low-power",
            antialias: false,
            precision: "lowp",
            preserveDrawingBuffer: true
        });

        renderer.setPixelRatio(window.devicePixelRatio / 1.5);
        renderer.setSize(window.innerWidth, window.innerHeight);
        renderer.autoClear = false;

        let appendArea = document.createElement("div");
        appendArea.id = "three-game-render";
        document.body.append(appendArea);
        appendArea.appendChild(renderer.domElement);
        appendArea.style.display = 'none';

        this.renderer = renderer;
        this.rtTexture = rtTexture;
        this.sceneRTT = sceneRTT;
        this.cameraRTT = cameraRTT;
        this.gameTexture = gameTexture;
        this.canvas = renderer.domElement;
        this.scaleFactor = scaleFactor; // PERFORMANS: Scale factor'ü sakla

        this.animate = this.animate.bind(this);
        requestAnimationFrame(this.animate);
    }

    resize() {
        if(this.rtTexture) this.rtTexture.dispose();
        if(this.renderer) this.renderer.dispose();
        const aspectRatio = 16 / 9;
        const width = window.innerHeight * aspectRatio;
        
        // PERFORMANS: Scale factor ile resize
        const rtWidth = Math.floor(window.innerWidth * this.scaleFactor);
        const rtHeight = Math.floor(window.innerHeight * this.scaleFactor);
    
        const cameraRTT = new OrthographicCamera(
            -width / 2, width / 2,
            window.innerHeight / 2, -window.innerHeight / 2,
            -10000, 10000
        );
    
        cameraRTT.setViewOffset(window.innerWidth, window.innerHeight, 0, 0, window.innerWidth, window.innerHeight);
        this.cameraRTT = cameraRTT;
    
        this.rtTexture = new WebGLRenderTarget(rtWidth, rtHeight, {
            minFilter: LinearFilter,
            magFilter: NearestFilter,
            format: RGBAFormat,
            type: UnsignedByteType,
            generateMipmaps: false // PERFORMANS
        });
    
        this.renderer.setSize(window.innerWidth, window.innerHeight);
    }

    startRecording() {
        if (this.isRecording) return;
        this.isRecording = true;
        this.recordedBlobs = [];
    
        const stream = this.canvas.captureStream(30);
        this.recorder = new MediaRecorder(stream, { mimeType: "video/webm" });
    
        this.recorder.ondataavailable = event => {
            if (event.data.size > 0) this.recordedBlobs.push(event.data);
        };
    
        this.recorder.onstop = async () => {
            const blob = new Blob(this.recordedBlobs, { type: "video/webm" });
            this.uploadVideo(blob);
        };
    
        this.recorder.start();
    
        let elapsedTime = 0;
        if (this.setVideoTimer) this.setVideoTimer(elapsedTime);
    
        this.timerInterval = setInterval(() => {
            elapsedTime += 1;
            if (this.setVideoTimer) this.setVideoTimer(elapsedTime);
        }, 1000);
    }    

    stopRecording() {
        if (!this.isRecording) return;
        this.isRecording = false;
    
        clearInterval(this.timerInterval);
        if (this.setVideoTimer) this.setVideoTimer(0);
    
        this.recorder.stop();
    }
    
    async uploadVideo(blob) {
        const formData = new FormData();
        formData.append("file", blob, "video.webm");

        try {
            const response = await fetch(videoUrl, {
                method: "POST",
                body: formData
            });

            const result = await response.json();
            if (result.url) {
                callNui('SaveGalleryPhoto', {
                    url: result.url,
                    type: 'video'
                });
            } else {
                console.error("❌ API başarısız yanıt döndürdü:", JSON.stringify(result, null, 2));
            }
        } catch (error) {
            console.error("❌ Video yükleme hatası:", error);
        }
    }
    
    animate(currentTime) {
        // PERFORMANS: Frame rate limiting
        if (currentTime - this.lastRenderTime < this.frameInterval) {
            requestAnimationFrame(this.animate);
            return;
        }
        this.lastRenderTime = currentTime;

        requestAnimationFrame(this.animate);

        if (isAnimated) {
            this.renderer.clear();
            this.renderer.render(this.sceneRTT, this.cameraRTT, this.rtTexture, true);
    
            // PERFORMANS: Scale edilmiş boyutları kullan
            const readWidth = this.rtTexture.width;
            const readHeight = this.rtTexture.height;
    
            const read = new Uint8Array(readWidth * readHeight * 4);
            this.renderer.readRenderTargetPixels(this.rtTexture, 0, 0, readWidth, readHeight, read);
    
            this.canvas.width = readWidth;
            this.canvas.height = readHeight;
    
            const d = new Uint8ClampedArray(read.buffer);
            const cxt = this.canvas.getContext('2d');
            const imageData = new ImageData(d, readWidth, readHeight);
            cxt.putImageData(imageData, 0, 0);
        }
    }

    createTempCanvas() {
        this.canvas = document.createElement("canvas");
        this.canvas.style.display = 'inline';
        this.canvas.width = window.innerWidth;
        this.canvas.height = window.innerHeight;
    }

    renderToTarget(element) {
        this.resize(false);
        this.canvas = element;
        isAnimated = true;
    }

    requestScreenshot = (url, field) => new Promise(async (res) => {
        console.time("requestScreenshot");
        
        // PERFORMANS: Screenshot sırasında tam çözünürlük kullan
        const originalCanvas = this.canvas;
        this.createTempCanvas();
        
        if (!this.canvas) {
            return res(false);
        }
    
        url = url || uploadUrl;
        field = field || uploadField;
        isAnimated = false;
    
        const ctx = this.canvas.getContext('2d');
        let pixelData = ctx.getImageData(0, 0, 1, 1).data;
    
        if (pixelData[0] === 0 && pixelData[1] === 0 && pixelData[2] === 0) {
            window.MainRender.renderToTarget(this.canvas);
            await new Promise(resolve => setTimeout(resolve, 200));
    
            pixelData = ctx.getImageData(0, 0, 1, 1).data;
            if (pixelData[0] === 0 && pixelData[1] === 0 && pixelData[2] === 0) {
                res(false);
                return;
            }
        }
    
        this.gameTexture.needsUpdate = true;
        
        // PERFORMANS: JPEG kullan, kaliteyi düşür
        const imageURL = this.canvas.toDataURL("image/jpeg", 0.8);
    
        const formData = new FormData();
        formData.append(field, dataURItoBlob(imageURL), "screenshot.jpg");
    
        try {
            const response = await fetch(url, { method: "POST", body: formData });
            const result = await response.json();
    
            if (result.url) {
                console.timeEnd("requestScreenshot");
                
                // Son fotoğrafı güncelle
                callNui('updateLastPhoto', {
                    url: result.url,
                    type: 'photo'
                });
                
                res(result.url);
            } else {
                res(false);
            }
        } catch (error) {
            res(false);
        }
    
        // Canvas'ı eski haline getir
        this.canvas = originalCanvas;
        isAnimated = true;
        if (window.MainRender) {
            window.MainRender.renderToTarget(document.getElementById("gameview-canvas"));
        }
        requestAnimationFrame(this.animate);
    });
    
    stop() {
        isAnimated = false;
        if (this.canvas) {
            if (this.canvas.style.display != "none") {
                this.canvas.style.display = "none";
            }
        }
        this.resize(true);
    }
}

setTimeout(() => {
    MainRender = new GameRender();
    window.MainRender = MainRender;
}, 1000);