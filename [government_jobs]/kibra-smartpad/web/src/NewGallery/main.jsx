import React, {useState, useEffect, useRef} from 'react';
import './main.css';
import Avatar from '/public/resim.png'
import TabletFrame from '/public/ipad.png';
import { useNui, callNui } from '@/nui';

const NewGallery = ({allGallery, lang, theme, albumsv, pname}) => {
    const [selectedPart, setPart] = useState('arşiv');
    const [openedAirDrop, setAirDrop] = useState(null);
    const [editMode, setEditMode] = useState(false);
    const [albums, setAlbums] = useState([]);
    const [editingIndex, setEditingIndex] = useState(null);
    const [editingName, setEditingName] = useState('');
    const [showAllPhotos, setShowAll] = useState(true);
    const pressTimer = useRef();
    const [selectedPhotos, setSelectedPhotos] = useState([]);
    const [time, setTime] = useState(new Date());
    const [photos, setPhotos] = useState([])
    const [viewerIndex, setViewerIndex] = useState(null);
    const [justPhotos, setJustPhotos] = useState(0);
    const [justVideos, setJustVideos] = useState(0);
    const [players, setPlayers] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [albumName, setAlbumName] = useState('');
    const [selectedAlbumData, setAlbumData] = useState([]);
    const [nearest, setNearest] = useState([]);
    const [showAddToAlbum, setShowAddToAlbum] = useState(false);
    const [longPressTriggered, setLongPressTriggered] = useState(false);
    const [showFavs, setShowFavs] = useState(false);
    const [favPhotos, setFavPhotos] = useState([]);

    const deletePhoto = () => {
        if(!showFavs){
            if(showAllPhotos){
                if (viewerIndex !== null && viewerIndex < photos.length) {
                    callNui('deleteGalleryMedia',{code:photos[viewerIndex].code, type: 1});
                }
            } else {
                if (viewerIndex !== null && viewerIndex < selectedAlbumData.length) {
                    callNui('deleteGalleryMedia',{code:selectedAlbumData[viewerIndex].code, type: 2});
                }
            }
        } else {
            if (viewerIndex !== null && viewerIndex < selectedAlbumData.length) {
                callNui('deleteGalleryMedia', {code:favPhotos[viewerIndex].code, type: 2});
            }
        }
    }

    const addToAlbum = (album) => {
        const codes = selectedPhotos.map(i => photos[i].code);
        callNui('addPhotosToAlbum', {
            albumName: album.name,
            photoCodes: codes
        }, (res) => {
            if (res && res.name) {
                setAlbums(prev => prev.map(a => a.name === res.name ? res : a));
                setShowAddToAlbum(false);
                setSelectedPhotos([]);
            }
        });
    };

    const createNewAlbum = () => {
       setShowModal(true)
    }

    const startPress = (i) => {
        pressTimer.current = setTimeout(() => {
            setSelectedPhotos(prev =>
            prev.includes(i)
                ? prev.filter(x => x !== i)
                : [...prev, i]
            );
            setLongPressTriggered(true);
        }, 800);
    };

    const cancelPress = () => {
        clearTimeout(pressTimer.current);
    };

    const deleteSelected = () => {
        selectedPhotos.forEach(i => {
            callNui('deleteGalleryMedia', {
            code: photos[i].code,
            type: 1
            });
        });
        setSelectedPhotos([]);
    };

    useEffect(() => {
        setPhotos(allGallery); 
        setAlbums(albumsv);

        let videoCount = 0;
        let photoCount = 0;
        const likedMedia = [];

        allGallery.forEach((element) => {
            if (element.type === 'video') {
                videoCount++;
            } else {
                photoCount++;
            }

            if (element.liked) {
                likedMedia.push(element);
            }
        });

        setFavPhotos(likedMedia);
        setJustVideos(videoCount);
        setJustPhotos(photoCount);

    }, [allGallery]);


    const setShowAlbum = (data) => {
        setAlbumData(data);
    }

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


    const addFavourites = () => {
        const updatedPhotos = showFavs ? [...favPhotos] : [...photos];
        const currentPhoto = updatedPhotos[viewerIndex];
        const newLikedState = !currentPhoto.liked;

        callNui('likeMedia', {
            photoCode: currentPhoto.code,
            state: newLikedState
        });

        currentPhoto.liked = newLikedState;
        if (!showFavs) {
            setPhotos(updatedPhotos);
        } else {
            setFavPhotos(updatedPhotos);
        }

        const updatedFavPhotos = newLikedState
            ? favPhotos.some(p => p.code === currentPhoto.code)
                ? favPhotos
                : [...favPhotos, currentPhoto]
            : favPhotos.filter(p => p.code !== currentPhoto.code);

        setFavPhotos(updatedFavPhotos);
    }




    const returnPlayerPhoto = (cid) => {
        const path = `/web/pimg/${cid}.png`;
        const img = new Image();
        img.src = path;
        
        return new Promise((resolve) => {
            img.onload = () => resolve(path);
            img.onerror = () => resolve(Avatar);
        });
    }

    useEffect(() => {
        useNui("addGalleryNewPhoto", (data) => {
            setPhotos(prev => [...prev, data.data]);
        })
    }, []);

    const showFavourites = () => {
        setPart('favs');
        setShowAll(false);
        setShowFavs(true);
    }

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

    const setHairdrop = () => {
        callNui('getNearestForAirDrop', {}, (res) => {
            setNearest(res);
        }); 
        setAirDrop(true);
    };

    const SendPhoto = (data) => {
        callNui('SendAirDropPhoto', {
            photoCode: photos[viewerIndex].code,
            receiverTab: data.serial,
            receiverSource: data.source
        }, (res) => {
            if(res){
                setAirDrop(null);
            }
        })
    }

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

    useEffect(() => {
        if (viewerIndex !== null && viewerIndex >= favPhotos.length) {
            setViewerIndex(null); // geçersiz index temizleniyor
        }
    }, [favPhotos]);

    const formattedTime = `${time.getHours().toString().padStart(2, "0")}:${time
    .getMinutes()
    .toString()
    .padStart(2, "0")}`;

    return (
        <div className='new-gallery-container'>
            <div className="tablet-frame-homescreen-header">
                <div className='header-icon-time-part'>
                    <span className='time-string'>{formattedTime}</span>
                </div>
                <div className='header-icon-part'>
                    <div className='header-icons'>
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="12" viewBox="0 0 16 12" fill="none">
                            <path d="M0 3.31091L1.45455 4.76545C5.06909 1.15091 10.9309 1.15091 14.5455 4.76545L16 3.31091C11.5855 -1.10364 4.42182 -1.10364 0 3.31091ZM5.81818 9.12909L8 11.3109L10.1818 9.12909C9.89557 8.84208 9.55551 8.61437 9.18112 8.459C8.80672 8.30363 8.40535 8.22365 8 8.22365C7.59465 8.22365 7.19328 8.30363 6.81888 8.459C6.44449 8.61437 6.10443 8.84208 5.81818 9.12909ZM2.90909 6.22L4.36364 7.67454C5.32834 6.71064 6.63627 6.1692 8 6.1692C9.36373 6.1692 10.6717 6.71064 11.6364 7.67454L13.0909 6.22C10.2836 3.41273 5.72364 3.41273 2.90909 6.22Z" fill="white"/>
                        </svg>
                    </div>
                    <div className='header-icons'>
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="12" viewBox="0 0 20 12" fill="none">
                            <path d="M14.375 0C15.2038 0 15.9987 0.316071 16.5847 0.87868C17.1708 1.44129 17.5 2.20435 17.5 3V3.9996L18.9587 4.0032C19.2349 4.0032 19.4998 4.10851 19.695 4.29598C19.8903 4.48344 20 4.73769 20 5.0028V7.0032C20 7.26831 19.8903 7.52256 19.695 7.71002C19.4998 7.89749 19.2349 8.0028 18.9587 8.0028L17.5 8.0004V9C17.5 9.79565 17.1708 10.5587 16.5847 11.1213C15.9987 11.6839 15.2038 12 14.375 12H3.125C2.2962 12 1.50134 11.6839 0.915291 11.1213C0.32924 10.5587 0 9.79565 0 9V3C0 2.20435 0.32924 1.44129 0.915291 0.87868C1.50134 0.316071 2.2962 0 3.125 0H14.375ZM14.6875 1.1352H3.125C2.3125 1.1352 1.36875 1.7304 1.26 2.4912L1.25 2.6352V9.2292C1.25 10.0056 1.865 10.6452 2.6525 10.722L2.8125 10.7292H14.6875C15.0741 10.7291 15.4469 10.5914 15.7339 10.3427C16.0209 10.094 16.2017 9.75199 16.2412 9.3828L16.25 9.2292V2.6352C16.2499 2.26406 16.1064 1.90614 15.8474 1.63064C15.5883 1.35513 15.2321 1.18161 14.8475 1.1436L14.6875 1.1352ZM3.5425 2.3388H12.705C13.2387 2.3388 13.6775 2.7204 13.7425 3.2148L13.75 3.3408V8.5332C13.7502 8.77726 13.6576 9.01299 13.4896 9.19615C13.3216 9.37931 13.0897 9.49731 12.8375 9.528L12.7063 9.5352H3.54375C3.28931 9.53568 3.04345 9.44691 2.8524 9.2856C2.66134 9.12428 2.53824 8.90152 2.50625 8.6592L2.5 8.532V3.3408C2.5 2.8296 2.89875 2.4084 3.4125 2.346L3.5425 2.3388Z" fill="white"/>
                        </svg>
                    </div>
                </div>
            </div>
            <div style={{display: 'flex', justifyContent: 'flex-start'}}>
                <div className='new-gallery-left-bar'>
                    <div style={{display: 'flex', alignContent: 'center', justifyContent: 'center', flexDirection: 'column'}}>
                        <span onClick={()=>setEditMode(!editMode)} className='edit-text'>{lang.edit}</span>
                        <div onClick={() => {
                            setPart('arşiv');
                            setShowFavs(false);
                            setShowAll(true);
                            }} className={`photo-bar ${selectedPart == 'arşiv' ? 'selected-bar':''}`}>
                            <i className="fa-regular fa-images"></i> &nbsp; &nbsp; 
                            {lang.archive}
                        </div>
                        <div
                            className={`photo-bar ${selectedPart == 'favs' ? 'selected-bar':''}`}
                            style={{color: '#b5b5b5'}}
                            onClick={() => showFavourites()}
                        >
                            <i className="fa-regular fa-heart"></i>&nbsp;&nbsp; {lang.favourites}
                        </div>
                        <span className='albums-text'>{lang.albums}</span>
                        <div
                            className={`photo-bar`}
                            style={{color: '#b5b5b5'}}
                            onClick={()=> createNewAlbum()}
                        >
                            <i className="fa-solid fa-plus"></i>&nbsp;&nbsp; {lang.addnewalbum}
                        </div>
                        
                        {albums.map((element,i)=>(
                            editingIndex===i
                            ? <div key={i} className='photo-bar'>
                                <input value={editingName} onChange={e=>setEditingName(e.target.value)} className='album-input'/>
                                <button onClick={()=>{const a=[...albums];a[i]=editingName;setAlbums(a);setEditingIndex(null)}} className='save-btn'>{lang.save}</button>
                                </div>
                            : <div
                                key={i}
                                className={`photo-bar ${selectedPart===`album${i+1}`?'selected-bar':''}`}
                                onClick={() => {
                                    setPart(`album${i+1}`);
                                    setShowFavs(false);
                                    setShowAll(false);
                                    setShowAlbum(element.medias);
                                }}

                                onMouseDown={()=>startPress(i,element.name)}
                                onMouseUp={cancelPress}
                                onMouseLeave={cancelPress}
                                onTouchStart={()=>startPress(i,element.name)}
                                onTouchEnd={cancelPress}
                                >
                                {editMode && <div onClick={()=>{}} className='delete-album'>-</div>}
                                <i className="fa-regular fa-image"></i>&nbsp;&nbsp;{element.name}
                                </div>
                            ))}
                    </div>
                </div>

                {selectedPhotos.length > 0 && (
                    <>
                        <button onClick={deleteSelected} className="delete-selected-btn">
                            <i className="fa-regular fa-trash-can"></i> ({selectedPhotos.length})
                        </button>
                        <button onClick={() => setShowAddToAlbum(true)} className="addtoalbum-btn">
                            <i className="fa-regular fa-images"></i>
                        </button>
                    </>
                )}

                <div className='new-gallery-middle-part'>
                    <div style={{display: 'flex',flexDirection: 'column',position: 'absolute',zIndex: '1000'}}>
                        <span className='arc'>{lang.archive}</span>
                        <span className='arc-x'>{justPhotos} {lang.photoss}, {justVideos} {lang.videoss}</span>
                    </div>
                    <div className='photo-list'>
                        {/* <div className='photo-item'>
                            <img src={Black}></img>
                        </div>
                        <div className='photo-item'>
                            <img src={Black}></img>
                        </div>
                        <div className='photo-item'>
                            <img src={Black}></img>
                        </div>
                        <div className='photo-item'>
                            <img src={Black}></img>
                        </div>
                        <div className='photo-item'>
                            <img src={Black}></img>
                        </div>
                        <div className='photo-item'>
                            <img src={Black}></img>
                        </div>
                        <div className='photo-item'>
                            <img src={Black}></img>
                        </div> */}

                        {!showFavs && showAllPhotos && photos.map((photo, i) => (
                            <div
                                key={i}
                                className={`photo-item ${selectedPhotos.includes(i) ? 'selected' : ''}`}
                                onClick={() => {
                                    // eğer long press ile zaten seçtiysek, onClick’i yoksay
                                    if (longPressTriggered) {
                                    setLongPressTriggered(false);
                                    return;
                                    }
                                    if (selectedPhotos.length) {
                                    // selection modu
                                    setSelectedPhotos(prev =>
                                        prev.includes(i)
                                        ? prev.filter(x => x !== i)
                                        : [...prev, i]
                                    );
                                    } else {
                                    // normal tık
                                    setViewerIndex(i);
                                    }
                                }}
                                onMouseDown={() => startPress(i)}
                                onMouseUp={cancelPress}
                                onMouseLeave={cancelPress}
                                onTouchStart={() => startPress(i)}
                                onTouchEnd={cancelPress}
                            >
                                {/* seçildiğinde sol üstte check */}
                                {selectedPhotos.includes(i) && (
                                    <div className="select-check">✓</div>
                                )}

                                {photo.type === "video" ? (
                                <>
                                    <img
                                    src={thumbnails[photo.url] || "fallback_image.png"}
                                    alt="Gallery Item"
                                    />
                                    <div className="video-overlay">
                                        <i className="fa-solid fa-play"></i>
                                    </div>
                                </>
                                ) : (
                                <img src={photo.url} alt="Gallery Item" />
                                )}
                            </div>
                        ))}

                        {!showFavs && !showAllPhotos && selectedAlbumData.map((photo, i) => (
                            <div key={i} className='photo-item' onClick={() => {
                                setViewerIndex(i);
                            }}>

                            {photo.type === "video" ? (
                                <>
                                    <img src={thumbnails[photo.url] || "fallback_image.png"} alt="Gallery Item" />
                                    <div className="video-overlay">
                                        <i className="fa-solid fa-play"></i>
                                    </div>
                                </>
                            ) : (
                                <img src={photo.url} alt="Gallery Item" />
                            )}
                            </div>
                        ))}

                        {showFavs && !showAllPhotos && favPhotos.map((photo, i) => (
                            <div key={i} className='photo-item' onClick={() => {
                                if (favPhotos[i]) {
                                    setViewerIndex(i);
                                }
                                }}
                            >

                            {photo.type === "video" ? (
                                <>
                                    <img src={thumbnails[photo.url] || "fallback_image.png"} alt="Gallery Item" />
                                    <div className="video-overlay">
                                        <i className="fa-solid fa-play"></i>
                                    </div>
                                </>
                            ) : (
                                <img src={photo.url} alt="Gallery Item" />
                            )}
                            </div>
                        ))}
                    </div>
                </div>

                {openedAirDrop && (
                    <div className="airdrop-modal">
                        <div className='airdrop-header'>
                            <img src={Avatar}></img>
                            <div style={{flexDirection: 'column', display: 'flex'}}>
                                <span className='airdropx'>{lang.aidx}</span>
                                <span className='airdx'>{pname}</span>
                            </div>
                            <div onClick={() => setAirDrop(null)} className='close-aidrop'><i className="fa-solid fa-xmark"></i></div>
                        </div>
                        <div className='device-list'>
                            {Object.entries(nearest).map(([key, element], index) => {
                                return (
                                    <div key={index} onClick={() => SendPhoto(element)} className='device-list-item'>
                                        <img src={TabletFrame} />
                                        <span className='cname'>{element.tabName}</span>
                                    </div>
                                );
                            })}
                        </div>
                    </div>
                )}

                {showAddToAlbum && (
                    <div className="album-select-modal" onClick={() => setShowAddToAlbum(false)}>
                        <div className="album-select-content" onClick={e => e.stopPropagation()}>
                        <h3>{lang.selectalbum}</h3>
                        {albums.map((alb, idx) => (
                            <div
                                key={idx}
                                className="album-option"
                                onClick={() => addToAlbum(alb)}
                            >
                            {alb.name}
                            </div>
                        ))}
                        </div>
                    </div>
                )}

                {showModal && (
                    <div className="album-modal-overlay" onClick={() => setShowModal(false)}>
                        <div className="album-modal-content" onClick={(e) => e.stopPropagation()}>
                        <h2 className='albu-tit'>{lang.createnewalbum}</h2>
                        <input
                            type="text"
                            placeholder={lang.enteralbumname}
                            value={albumName}
                            onChange={(e) => setAlbumName(e.target.value)}
                            className="album-inputx"
                        />
                        <div className="album-modal-buttons">
                            <button onClick={() => setShowModal(false)} className="albot">{lang.cancel}</button>
                            <button
                            onClick={() => {
                                if(albumName){
                                    setShowModal(false);
                                    callNui('addNewAlbum', {
                                        albumName: albumName
                                    });
                                    setAlbums(prev => [...prev, {name: albumName, medias: []}]);
                                    setAlbumName('');
                                }
                            }}
                            style={{background: '#0072ff'}}
                            className="albot"
                            >
                            {lang.create}
                            </button>
                        </div>
                        </div>
                    </div>
                )}

                {showAllPhotos && viewerIndex !== null && (
                    <div className='overlay'>
                        <div className='myposx'>
                            <i onClick={() => setViewerIndex(idx=> idx>0? idx-1: idx)} className="fa-solid fa-chevron-left"></i>
                        </div>
                        <div className='myposx-rig'>
                            <i onClick={() => setViewerIndex(idx=> idx<photos.length-1? idx+1: idx)} className="fa-solid fa-chevron-right"></i>
                        </div>

                        <div className='backs'>
                            <div onClick={()=>setViewerIndex(null)} className='ri'>
                                <i className="fa-solid fa-chevron-left"></i>
                            </div>
                            <div onClick={() => {
                                setHairdrop()
                            }} className='ri'>
                                <i className="fa-solid fa-arrow-up-from-bracket"></i>
                            </div>
                            <div onClick={()=> addFavourites()} className='ri'>
                                {photos[viewerIndex].liked ? <i style={{color: '#d11500'}} className="fa-solid fa-heart"></i> : <i className="fa-regular fa-heart"></i>}
                            </div>
                            <div onClick={deletePhoto} className='ri'>
                                <i className="fa-regular fa-trash-can"></i>
                            </div>
                        </div>

                        <div className='date-info'>
                            <span className='location'>{photos[viewerIndex].location}</span>
                            <span className='datez'>{photos[viewerIndex].date}</span>
                        </div>

                        {viewerIndex !== null && (
                            photos[viewerIndex].type === "photo" ? (
                                <img src={photos[viewerIndex].url} className="viewer-image"/>
                            ) : (
                                <video controls className="viewer-video">
                                <source src={photos[viewerIndex].url} type="video/mp4"/>
                                </video>
                            )
                        )}
                    </div>
                )}

                {showFavs && !showAllPhotos && viewerIndex !== null && favPhotos[viewerIndex] && (
                    <div className='overlay'>
                        <div className='myposx'>
                            <i onClick={() => setViewerIndex(idx => idx > 0 ? idx - 1 : idx)} className="fa-solid fa-chevron-left"></i>
                        </div>
                        <div className='myposx-rig'>
                            <i onClick={() => setViewerIndex(idx => idx < favPhotos.length - 1 ? idx + 1 : idx)} className="fa-solid fa-chevron-right"></i>
                        </div>

                        <div className='backs'>
                            <div onClick={() => setViewerIndex(null)} className='ri'>
                                <i className="fa-solid fa-chevron-left"></i>
                            </div>
                            <div onClick={() => setHairdrop()} className='ri'>
                                <i className="fa-solid fa-arrow-up-from-bracket"></i>
                            </div>
                            <div onClick={() => addFavourites()} className='ri'>
                                {favPhotos[viewerIndex]?.liked ? (
                                    <i style={{ color: '#d11500' }} className="fa-solid fa-heart"></i>
                                ) : (
                                    <i className="fa-regular fa-heart"></i>
                                )}
                            </div>
                            <div onClick={deletePhoto} className='ri'>
                                <i className="fa-regular fa-trash-can"></i>
                            </div>
                        </div>

                        <div className='date-info'>
                            <span className='location'>{favPhotos[viewerIndex]?.location || "Konum Yok"}</span>
                            <span className='datez'>{favPhotos[viewerIndex]?.date || "Tarih Yok"}</span>
                        </div>

                        {favPhotos[viewerIndex]?.type === "photo" ? (
                            <img src={favPhotos[viewerIndex].url} className="viewer-image" />
                        ) : (
                            <video controls className="viewer-video">
                                <source src={favPhotos[viewerIndex]?.url} type="video/mp4" />
                            </video>
                        )}
                    </div>
                )}


                {!showAllPhotos && !showFavs && viewerIndex !== null && (
                    <div className='overlay'>
                        <div className='myposx'>
                            <i onClick={() => setViewerIndex(idx=> idx>0? idx-1: idx)} className="fa-solid fa-chevron-left"></i>
                        </div>
                        <div className='myposx-rig'>
                            <i onClick={() => setViewerIndex(idx=> idx<selectedAlbumData.length-1? idx+1: idx)} className="fa-solid fa-chevron-right"></i>
                        </div>

                        <div className='backs'>
                            <div onClick={()=>setViewerIndex(null)} className='ri'>
                                <i className="fa-solid fa-chevron-left"></i>
                            </div>
                            <div onClick={() => {
                                setHairdrop()
                            }} className='ri'>
                                <i className="fa-solid fa-arrow-up-from-bracket"></i>
                            </div>
                            <div className='ri'>
                                <i className="fa-regular fa-heart"></i>
                            </div>
                            <div onClick={deletePhoto} className='ri'>
                                <i className="fa-regular fa-trash-can"></i>
                            </div>
                        </div>

                        <div className='date-info'>
                            <span className='location'>{selectedAlbumData[viewerIndex].location}</span>
                            <span className='datez'>{selectedAlbumData[viewerIndex].date}</span>
                        </div>

                        {viewerIndex !== null && (
                            selectedAlbumData[viewerIndex].type === "photo" ? (
                                <img src={selectedAlbumData[viewerIndex].url} className="viewer-image"/>
                            ) : (
                                <video controls className="viewer-video">
                                <source src={selectedAlbumData[viewerIndex].url} type="video/mp4"/>
                                </video>
                            )
                        )}
                    </div>
                )}
            </div>
        </div>
    )
} 

export default NewGallery;