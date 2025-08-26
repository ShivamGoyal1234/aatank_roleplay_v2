import React, {useEffect, useState, useRef, useCallback, useMemo} from 'react'
import './main.css';
import { useNui, callNui } from '../nui';
import { motion, AnimatePresence } from "framer-motion";

const CameraApp = ({allGallery, galleryLastPhoto, lang, customState}) => {
    const [isLoaded, setIsLoaded] = useState(false);
    const [screenshotUrl, setScreenshotUrl] = useState(null);
    const [flashEffect, setFlashEffect] = useState(false);
    const [lastPhoto, setLastPhoto] = useState('');
    const [currentMode, setMode] = useState('photo');
    const [isRecording, setIsRecording] = useState(false);
    const [videoStartTime, setVideoStartTime] = useState(null);
    const [videoDuration, setVideoDuration] = useState("00:00");
    const [videoTime, setVideoTime] = useState(0);
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [currentIndex, setCurrentIndex] = useState(0);
    const [recordingInterval, setRecordingInterval] = useState(null);
    const [isTakingScreenshot, setIsTakingScreenshot] = useState(false);
    
    // Refs
    const errorLoggedUrls = useRef(new Set());
    const canvasRef = useRef(null);
    const renderInitialized = useRef(false);
    const frameCache = useRef(new Map());
    const lastProcessedGalleryLength = useRef(0);

    // Component unmount olduğunda cleanup
    useEffect(() => {
        return () => {
            // Render'ı durdur
            if (window.MainRender) {
                window.MainRender.stop();
                window.isAnimated = false;
            }
            
            // Video kaydını durdur
            if (recordingInterval) {
                clearInterval(recordingInterval);
            }
            
            // Canvas'ı temizle
            if (canvasRef.current) {
                const ctx = canvasRef.current.getContext('2d');
                ctx.clearRect(0, 0, canvasRef.current.width, canvasRef.current.height);
            }
            
            // Cache'i temizle
            frameCache.current.clear();
            errorLoggedUrls.current.clear();
        };
    }, []);

    // Canvas initialization - sadece bir kez çalışır
    useEffect(() => {
        if (renderInitialized.current) return;
        
        const initCanvas = () => {
            const canvas = document.getElementById("gameview-canvas");
            if (canvas && window.MainRender) {
                canvasRef.current = canvas;
                window.MainRender.renderToTarget(canvas);
                renderInitialized.current = true;
                window.isAnimated = true; // Global değişkeni set et
            }
        };

        // MainRender'ın yüklenmesini bekle
        const checkInterval = setInterval(() => {
            if (window.MainRender) {
                clearInterval(checkInterval);
                initCanvas();
            }
        }, 100);
        
        return () => {
            clearInterval(checkInterval);
            // Component unmount olurken render'ı durdur
            if (window.MainRender && renderInitialized.current) {
                window.MainRender.stop();
                window.isAnimated = false;
                renderInitialized.current = false;
            }
        };
    }, []);

    // Memoized video validation
    const isValidVideoUrl = useCallback((url) => {
        return url && typeof url === 'string' && url.length > 8 && url.endsWith('.webm');
    }, []);

    // Optimized frame extraction with caching
    const extractFirstFrame = useCallback((videoUrl, cb) => {
        if (!isValidVideoUrl(videoUrl)) {
            cb && cb("web/public/black.png");
            return;
        }

        // Cache kontrolü
        if (frameCache.current.has(videoUrl)) {
            cb && cb(frameCache.current.get(videoUrl));
            return;
        }
        
        const video = document.createElement("video");
        video.crossOrigin = "anonymous";
        video.muted = true;
        video.preload = "metadata"; // "auto" yerine "metadata"
        video.src = videoUrl;
        
        const clean = () => {
            video.pause();
            video.src = "";
            video.load();
            video.remove();
        }
        
        video.onloadedmetadata = () => {
            video.currentTime = 0;
        };
        
        video.onseeked = () => {
            // Canvas oluşturma işlemini requestAnimationFrame ile ertele
            requestAnimationFrame(() => {
                const canvas = document.createElement("canvas");
                canvas.width = video.videoWidth;
                canvas.height = video.videoHeight;
                const ctx = canvas.getContext("2d");
                ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
                const imageUrl = canvas.toDataURL("image/png");
                
                // Cache'e ekle
                frameCache.current.set(videoUrl, imageUrl);
                
                cb && cb(imageUrl);
                canvas.remove();
                clean();
            });
        };
        
        video.onerror = () => {
            clean();
            cb && cb("web/public/black.png");
            
            if (!errorLoggedUrls.current.has(videoUrl)) {
                errorLoggedUrls.current.add(videoUrl);
            }
        };
    }, [isValidVideoUrl]);

    // Gallery update optimization - sadece yeni itemlar için çalışır
    useEffect(() => {
        if (!allGallery || !allGallery.length) {
            setLastPhoto("web/public/black.png");
            return;
        }

        // Sadece yeni eklenenleri kontrol et
        if (allGallery.length <= lastProcessedGalleryLength.current) return;
        
        const last = allGallery[allGallery.length - 1];
        if (last.type === 'video') {
            if (isValidVideoUrl(last.url)) {
                extractFirstFrame(last.url, (frameUrl) => setLastPhoto(frameUrl));
            }
        } else {
            setLastPhoto(last.url);
        }
        
        lastProcessedGalleryLength.current = allGallery.length;
    }, [allGallery, extractFirstFrame, isValidVideoUrl]);

    // Memoized callbacks
    const updateMode = useCallback((mode) => {
        setMode(mode);
    }, []);

    const openModal = useCallback((index) => {
        setCurrentIndex(index);
        setIsModalOpen(true);
    }, []);

    const nextMedia = useCallback(() => {
        setCurrentIndex((prevIndex) => 
            prevIndex >= allGallery.length - 1 ? prevIndex : prevIndex + 1
        );
    }, [allGallery.length]);
    
    const prevMedia = useCallback(() => {
        setCurrentIndex((prevIndex) => 
            prevIndex <= 0 ? prevIndex : prevIndex - 1
        );
    }, []);

    // Screenshot optimization
    const takeScreenshot = useCallback(async () => {
        if (!window.MainRender || isTakingScreenshot) return;
        
        try {
            setIsTakingScreenshot(true);
            setFlashEffect(true);
            
            const imageUrl = await window.MainRender.requestScreenshot();
            
            setScreenshotUrl(imageUrl);
            
            callNui('SaveGalleryPhoto', {
                url: imageUrl,
                type: 'photo',
                custom: customState
            }, (x) => {
                if(x) {
                    // Last photo will be updated via updateLastPhoto NUI event
                    // from the render.js after successful upload
                }
            });
            
            // Flash effect'i kaldır
            setTimeout(() => {
                setFlashEffect(false);
                setIsTakingScreenshot(false);
            }, 300);
            
        } catch (error) {
            setIsTakingScreenshot(false);
            setFlashEffect(false);
        }
    }, [customState, isTakingScreenshot]);

    // Video recording callbacks
    const startVideoRecording = useCallback(() => {
        if (!window.MainRender || isRecording) return;
        
        setIsRecording(true);
        setVideoStartTime(Date.now());
        setVideoTime(0);
        window.MainRender.startRecording();
        
        const interval = setInterval(() => {
            setVideoTime(prevTime => prevTime + 1);
        }, 1000);
        setRecordingInterval(interval);
    }, [isRecording]);

    const stopVideoRecording = useCallback(() => {
        if (!window.MainRender || !isRecording) return;
        
        setIsRecording(false);
        setVideoStartTime(null);
        setVideoTime(0);
        setVideoDuration("00:00");
        window.MainRender.stopRecording();
        
        if (recordingInterval) {
            clearInterval(recordingInterval);
            setRecordingInterval(null);
        }
    }, [isRecording, recordingInterval]);

    // Video kaydı açıkken component unmount olursa durdur
    useEffect(() => {
        return () => {
            if (isRecording) {
                stopVideoRecording();
            }
        };
    }, [isRecording, stopVideoRecording]);

    // NUI listener
    useEffect(() => {
        const handler = (data) => {
            if (data.url.endsWith(".webm")) {
                extractFirstFrame(data.url, setLastPhoto);
            } else {
                setLastPhoto(data.url);
            }
        };
        
        useNui("updateLastPhoto", handler);
    }, [extractFirstFrame]);

    // Keyboard handler
    useEffect(() => {
        const handleKeyPress = (event) => {
            if (event.key === "Enter") {
                if (currentMode === "photo") {
                    takeScreenshot();
                } else {
                    isRecording ? stopVideoRecording() : startVideoRecording();
                }
            }
        };
        
        window.addEventListener("keydown", handleKeyPress);
        return () => window.removeEventListener("keydown", handleKeyPress);
    }, [currentMode, isRecording, takeScreenshot, startVideoRecording, stopVideoRecording]);

    // Video duration formatting
    useEffect(() => {
        const minutes = String(Math.floor(videoTime / 60)).padStart(2, "0");
        const seconds = String(videoTime % 60).padStart(2, "0");
        setVideoDuration(`${minutes}:${seconds}`);
    }, [videoTime]);

    // Memoized current media
    const currentMedia = useMemo(() => 
        allGallery[currentIndex] || null, 
        [allGallery, currentIndex]
    );

    return (
        <div className='CameraAppContainer'>
            <div className={`flash-overlay ${flashEffect ? "active" : ""}`}>
                {flashEffect && (
                    <div className="flash-loading">
                        <div className="loading-circle"></div>
                    </div>
                )}
            </div>
            
            <canvas id="gameview-canvas"></canvas>
            
            {currentMode === "video" && isRecording && (
                <div className="video-time">{videoDuration}</div>
            )}
            
            <div className='camera-bottom-bar'>
                <div className='cover-o'>
                    <i className="fa-solid fa-arrows-rotate"></i>
                </div>
                
                {currentMode === "photo" ? (
                    <div 
                        onClick={takeScreenshot} 
                        className="camera-button-radius"
                        style={{ pointerEvents: isTakingScreenshot ? 'none' : 'auto' }}
                    >
                        <div className="camera-capture"></div>
                    </div>
                ) : (
                    <div
                        onClick={isRecording ? stopVideoRecording : startVideoRecording}
                        className={`camera-button-radius ${isRecording ? "recording" : ""}`}
                    >
                        <div className={`camera-capture ${isRecording ? "red" : "white"}`}></div>
                    </div>
                )}
                
                <div 
                    onClick={() => openModal(allGallery.length - 1)} 
                    className='camera-last-photo'
                >
                    <img src={lastPhoto} alt="Last capture" />
                </div>
                
                <div className='camera-modes-bar'>
                    <div 
                        onClick={() => updateMode('photo')} 
                        className={`camera-mode-but ${currentMode === 'photo' ? 'selectedmode' : ''}`}
                    >
                        {lang.photo}
                    </div>
                    {customState !== 'forMdt' && (
                        <div 
                            onClick={() => updateMode('video')} 
                            className={`camera-mode-but ${currentMode === 'video' ? 'selectedmode' : ''}`}
                        >
                            {lang.video}
                        </div>
                    )}
                </div>
            </div>

            <AnimatePresence>
                {isModalOpen && currentMedia && (
                    <motion.div 
                        className='camera-app-minigallery'
                        initial={{ opacity: 0, scale: 0.8, y: -50 }}
                        animate={{ opacity: 1, scale: 1, y: 0 }}
                        exit={{ opacity: 0, scale: 0.8, y: 50 }}
                        transition={{ duration: 0.2, ease: "easeInOut" }}
                    >
                        {currentMedia.type === 'photo' ? (
                            <img src={currentMedia.url} alt="Gallery item" />
                        ) : (
                            <video src={currentMedia.url} controls />
                        )}

                        <div 
                            onClick={() => setIsModalOpen(false)} 
                            className='camera-app-close'
                        >
                            <i className="fa-solid fa-xmark"></i>
                        </div>
                        
                        <div 
                            onClick={prevMedia} 
                            style={{left: '2rem'}} 
                            className='minigallery-button'
                        >
                            <i className="fa-solid fa-chevron-left"></i>
                        </div>
                        
                        <div 
                            onClick={nextMedia} 
                            style={{right: '2rem'}} 
                            className='minigallery-button'
                        >
                            <i className="fa-solid fa-chevron-right"></i>
                        </div>
                    </motion.div>
                )}
            </AnimatePresence>
        </div>
    );
};

export default CameraApp;