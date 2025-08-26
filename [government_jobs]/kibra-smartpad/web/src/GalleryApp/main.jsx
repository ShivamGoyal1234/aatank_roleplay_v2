import React, {useState, useEffect} from 'react';
import './main.css';
import black from '/public/black.png'
import ShareModal from "./sharemodal";
import ImageViewer from './imageviewer';
import { motion, AnimatePresence } from "framer-motion";
import { useNui, callNui } from '@/nui';

const GalleryApp = ({allGallery, lang, theme}) => {
    const [selectedPhotos, setSelectedPhotos] = useState([]);
    const [showActions, setShowActions] = useState(false);
    const [showShareModal, setShowShareModal] = useState(false);
    const [viewerIndex, setViewerIndex] = useState(null);
    const [photos, setPhotos] = useState([])
    const [justPhotos, setJustPhotos] = useState(0);
    const [justVideos, setJustVideos] = useState(0);
    const [longPressTimer, setLongPressTimer] = useState(null);
    const [longPressActive, setLongPressActive] = useState(false);
    const [players, setPlayers] = useState([]);

    useEffect(() => {
        setPhotos(allGallery); 
    
        let videoCount = 0;
        let photoCount = 0;
    
        allGallery.forEach((element) => {
            if (element.type === 'video') {
                videoCount++;
            } else {
                photoCount++;
            }
        });
    
        setJustVideos(videoCount);
        setJustPhotos(photoCount);
    
    }, [allGallery]);
    
    useEffect(() => {
        callNui('openedGallery', {});

        useNui("getNearest", (data) => {
            setPlayers(data.players);
        });
    }, []);

    useEffect(() => {    
        const prepareData = async () => {
            const licenses = players;
    
            const newData = await Promise.all(licenses.map(async (element) => {
                const photo = await returnPlayerPhoto(element.cid);
                return { ...element, avatar: photo };
            }));
    
            setPlayers(newData.reverse());
        };
    
        prepareData();
    }, [players]);

    const returnPlayerPhoto = (cid) => {
        const path = `/web/pimg/${cid}.png`;
        const img = new Image();
        img.src = path;
        
        return new Promise((resolve) => {
            img.onload = () => resolve(path);
            img.onerror = () => resolve(Avatar);
        });
    }
    
    const devices = [
        { name: "MacBook Air", icon: "/icons/macbook.png" }
    ];

    const handleLongPressStart = (id) => {
        const timer = setTimeout(() => {
            setLongPressActive(true);
            setSelectedPhotos((prev) => {
                const updatedSelection = prev.includes(id) 
                    ? prev.filter(photoId => photoId !== id) 
                    : [...prev, id];

                setShowActions(updatedSelection.length > 0);
                return updatedSelection;
            });
        }, 500);
        setLongPressTimer(timer);
    };

    const handleLongPressEnd = () => {
        clearTimeout(longPressTimer);
        setTimeout(()=>setLongPressActive(false), 0);
    };

    const handleDelete = () => {
        setSelectedPhotos([]);
        setShowActions(false);
    };

    const deletePhoto = () => {
        if (viewerIndex !== null && viewerIndex < photos.length) {
            callNui('deleteGalleryMedia',{code:photos[viewerIndex].code, type: 1});
            closeViewer();
        }
    }

    const handleShare = () => {
        setShowShareModal(true);
    };

    useEffect(() => {
        if (selectedPhotos.length === 0) {
            setShowActions(false);
        }
    }, [selectedPhotos]);

    const openViewer = (index) => {
        setViewerIndex(index);
    };
    
    const closeViewer = () => {
        setViewerIndex(null);
    };
    
    const nextImage = () => {
        setViewerIndex((prevIndex) => {
            if (!photos || photos.length === 0) return prevIndex;
            return prevIndex < photos.length - 1 ? prevIndex + 1 : prevIndex;
        });
    };
    
    const prevImage = () => {
        setViewerIndex((prevIndex) => {
            if (!photos || photos.length === 0) return prevIndex;
            return prevIndex > 0 ? prevIndex - 1 : prevIndex;
        });
    };

    const extractFirstFrame = async (videoUrl) => {
        try {
            const video = document.createElement("video");
            video.src = videoUrl;
            video.crossOrigin = "anonymous"; 
            video.muted = true;
            video.preload = "auto";
    
            await new Promise((resolve, reject) => {
                video.onloadeddata = resolve;
                video.onerror = () => reject("❌ Video yüklenirken hata oluştu!");
            });
    
            video.currentTime = 0;
    
            await new Promise((resolve) => (video.onseeked = resolve));
    
            const canvas = document.createElement("canvas");
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            const ctx = canvas.getContext("2d");
            ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
    
            return canvas.toDataURL("image/png"); // ✅ Doğrudan link döndürür
        } catch (error) {
            console.error(error);
            return "fallback_image.png"; // Eğer hata olursa bir yedek resim döndür
        }
    };
    
    
    const [thumbnails, setThumbnails] = useState({});

    useEffect(() => {
        const fetchThumbnails = async () => {
            let newThumbnails = {};
            for (const photo of photos) {
                if (photo.type === "video") {
                    const image = await extractFirstFrame(photo.url);
                    newThumbnails[photo.url] = image;
                }
            }
            setThumbnails(newThumbnails);
        };
        fetchThumbnails();
    }, [photos]);

    return (
        <div className='gallery-app-container'>
            <div className='gallery-app-topbar'>
                <div className='gallery-top-bar-icons'>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="12" viewBox="0 0 16 12" fill="none">
                        <path d="M0 3.31091L1.45455 4.76545C5.06909 1.15091 10.9309 1.15091 14.5455 4.76545L16 3.31091C11.5855 -1.10364 4.42182 -1.10364 0 3.31091ZM5.81818 9.12909L8 11.3109L10.1818 9.12909C9.89557 8.84208 9.55551 8.61437 9.18112 8.459C8.80672 8.30363 8.40535 8.22365 8 8.22365C7.59465 8.22365 7.19328 8.30363 6.81888 8.459C6.44449 8.61437 6.10443 8.84208 5.81818 9.12909ZM2.90909 6.22L4.36364 7.67454C5.32834 6.71064 6.63627 6.1692 8 6.1692C9.36373 6.1692 10.6717 6.71064 11.6364 7.67454L13.0909 6.22C10.2836 3.41273 5.72364 3.41273 2.90909 6.22Z" fill="white"/>
                    </svg>
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="12" viewBox="0 0 20 12" fill="none">
                        <path d="M14.375 0C15.2038 0 15.9987 0.316071 16.5847 0.87868C17.1708 1.44129 17.5 2.20435 17.5 3V3.9996L18.9587 4.0032C19.2349 4.0032 19.4998 4.10851 19.695 4.29598C19.8903 4.48344 20 4.73769 20 5.0028V7.0032C20 7.26831 19.8903 7.52256 19.695 7.71002C19.4998 7.89749 19.2349 8.0028 18.9587 8.0028L17.5 8.0004V9C17.5 9.79565 17.1708 10.5587 16.5847 11.1213C15.9987 11.6839 15.2038 12 14.375 12H3.125C2.2962 12 1.50134 11.6839 0.915291 11.1213C0.32924 10.5587 0 9.79565 0 9V3C0 2.20435 0.32924 1.44129 0.915291 0.87868C1.50134 0.316071 2.2962 0 3.125 0H14.375ZM14.6875 1.1352H3.125C2.3125 1.1352 1.36875 1.7304 1.26 2.4912L1.25 2.6352V9.2292C1.25 10.0056 1.865 10.6452 2.6525 10.722L2.8125 10.7292H14.6875C15.0741 10.7291 15.4469 10.5914 15.7339 10.3427C16.0209 10.094 16.2017 9.75199 16.2412 9.3828L16.25 9.2292V2.6352C16.2499 2.26406 16.1064 1.90614 15.8474 1.63064C15.5883 1.35513 15.2321 1.18161 14.8475 1.1436L14.6875 1.1352ZM3.5425 2.3388H12.705C13.2387 2.3388 13.6775 2.7204 13.7425 3.2148L13.75 3.3408V8.5332C13.7502 8.77726 13.6576 9.01299 13.4896 9.19615C13.3216 9.37931 13.0897 9.49731 12.8375 9.528L12.7063 9.5352H3.54375C3.28931 9.53568 3.04345 9.44691 2.8524 9.2856C2.66134 9.12428 2.53824 8.90152 2.50625 8.6592L2.5 8.532V3.3408C2.5 2.8296 2.89875 2.4084 3.4125 2.346L3.5425 2.3388Z" fill="white"/>
                    </svg>
                </div>
            </div>
            <div className='gallery-photo-list'>
                <div className='gallery-photo-infos'>
                    <span className='galler-photo-infos-label'>{lang.photosAndVideos}</span>
                    <span className='galler-photo-infos-label2'>{justPhotos} {lang.photoss}, {justVideos} {lang.videoss}</span>
                </div>
                <div className={`gallery-photo-list-item`}>
                    <img src={black} alt="Gallery Item" />
                </div>
                <div className={`gallery-photo-list-item`}>
                    <img src={black} alt="Gallery Item" />
                </div>
                <div className={`gallery-photo-list-item`}>
                    <img src={black} alt="Gallery Item" />
                </div>
                <div className={`gallery-photo-list-item`}>
                    <img src={black} alt="Gallery Item" />
                </div>
                <div className={`gallery-photo-list-item`}>
                    <img src={black} alt="Gallery Item" />
                </div>
                <div className={`gallery-photo-list-item`}>
                    <img src={black} alt="Gallery Item" />
                </div>
                <div className={`gallery-photo-list-item`}>
                    <img src={black} alt="Gallery Item" />
                </div>
                <div className={`gallery-photo-list-item`}>
                    <img src={black} alt="Gallery Item" />
                </div>
                <div className={`gallery-photo-list-item`}>
                    <img src={black} alt="Gallery Item" />
                </div>
                {photos.map((photo, index) => (
                    <div
                        key={index}
                        className={`gallery-photo-list-item ${selectedPhotos.includes(index) ? 'selected' : ''}`}
                        onPointerDown={() => handleLongPressStart(index)}
                        onPointerUp={handleLongPressEnd}
                        onPointerLeave={handleLongPressEnd}
                        onClick={() => { if (!longPressActive) openViewer(index); }}
                    >
                        {photo.type === "video" ? (
                            <>
                                <img src={thumbnails[photo.url] || "fallback_image.png"} alt="Gallery Item" />
                                <div className="video-overlay">
                                    <span class="material-symbols-outlined">
                                        play_arrow
                                    </span>
                                </div>
                            </>
                        ) : (
                            <img src={photo.url} alt="Gallery Item" />
                        )}

                        {selectedPhotos.includes(index) && (
                            <div className="photo-selected-checkmark">
                                <span class="material-symbols-outlined">
                                    check
                                </span>
                            </div>
                        )}
                    </div>
                ))}

            </div>

            {showActions && (
                <div className="gallery-actions">
                    <button className="gallery-delete" onClick={handleDelete}><i class="fa-solid fa-trash"></i>&nbsp; {lang.delete}</button>
                    <button className="gallery-share" onClick={handleShare}><i class="fa-solid fa-share"></i>&nbsp; {lang.share}</button>
                </div>
            )}
            
            <ShareModal 
                show={showShareModal} 
                onClose={() => setShowShareModal(false)}
                people={players}
                devices={devices}
                theme={theme}
            />

            <motion.div
                key="imageviewer"
                initial={{ opacity: 0, y: 20 }} 
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -10 }}
                transition={{ duration: 0.1 }}>
                    <ImageViewer 
                    show={viewerIndex !== null && viewerIndex < photos.length} 
                    imageSrc={viewerIndex !== null && viewerIndex < photos.length ? photos[viewerIndex].url : ""}
                    type={viewerIndex !== null && viewerIndex < photos.length ? photos[viewerIndex].type : "photo"} 
                    onClose={closeViewer}
                    onNext={nextImage}
                    onPrev={prevImage}
                    share={handleShare}
                    date={viewerIndex !== null && viewerIndex < photos.length ? photos[viewerIndex].date : ""}
                    deletePhoto={deletePhoto}
                />
            </motion.div>


        </div>
    )
}

export default GalleryApp;