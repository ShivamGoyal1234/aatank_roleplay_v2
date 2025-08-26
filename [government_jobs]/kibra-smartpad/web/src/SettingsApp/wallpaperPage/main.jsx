import React, { useRef, useState, useEffect } from 'react';
import './main.css';
import { callNui } from '../../nui';

const WallpaperPage = ({theme, themeMode, setNewTheme, background, setTabletBg, allBackgrounds, job, lang, Notification}) => {
    const scrollRef = useRef(null);
    const [customUrl, setCustomUrl] = useState('');
    const [selected, setSelected] = useState(background || (allBackgrounds?.[0] || null));
    const [loadingBackground, setLoadingBackground] = useState(null);
    const [modTheme, setModTheme] = useState(false);

    useEffect(() => {
        if(theme == 'light'){
            setModTheme(true);
        } else {
            setModTheme(false);
        }
    }, [theme])

    useEffect(() => {
        if (allBackgrounds && allBackgrounds.length > 0 && !selected) {
            setSelected(allBackgrounds[0]);
        }
    }, [allBackgrounds]);

    const scrollLeft = () => {
        scrollRef.current.scrollBy({ left: -200, behavior: 'smooth' });
    };

    const scrollRight = () => {
        scrollRef.current.scrollBy({ left: 200, behavior: 'smooth' });
    };

    const wallpaperListRef = useRef(null);
    
    useEffect(() => {
        setCustomUrl(background);
    }, [background]);

    const handleWheel = (event) => {
        if (event.deltaY !== 0) {
            event.preventDefault();
            wallpaperListRef.current.scrollLeft += event.deltaY;
        }
    };

    const UpdateTheme = (theme) => {
        setNewTheme(theme);
        callNui("UpdateTabletData", {
            datatype: 'theme',
            result: theme
        })
    };

    const updateBackgroundCustom = () => {
        if (!customUrl.trim()) {
            Notification(lang.invalid, lang.validlink)
            return
        }

        callNui("UpdateTabletData", {
            datatype: 'background',
            result: customUrl
        })
        setTabletBg(customUrl); 
    }

    const UpdateBackground = (theme) => {
        setTabletBg(theme); // Anında seçimi uygula
        setLoadingBackground(theme); // Loading animasyonu başlat
        setTimeout(() => {
            setLoadingBackground(null); // 3 saniye sonra loading durumunu kaldır
        }, 3000);
        callNui("UpdateTabletData", {
            datatype: 'background',
            result: theme
        })
    };

    return (
        <>
            <div className={`settings-wallpaper-box ${modTheme ? 'light' : ''}`}>
                <span className={`wallpaper-ti ${modTheme ? 'li' : ''}`}>Wallpaper</span>
                <span className='wallpaper-info'>You can change the tablet background here.</span>

                <div className='wallpaper-carousel-wrapper'>
                    <button className='chevron-btn left' onClick={scrollLeft}>
                        <i className="fa-solid fa-chevron-left"></i>
                    </button>

                    <div className='wallpapers' ref={scrollRef}>
                        {allBackgrounds
                            .filter(row => !row.jobs || row.jobs.includes(job))
                            .map((row, index) => (
                                <div
                                key={index}
                                className={`wallpaper-container ${background === row.label ? 'selected' : ''}`}
                                onClick={() => UpdateBackground(row.label)}
                                >
                                <div
                                    className="wallpaper-img"
                                    style={{
                                        backgroundImage: `url('${row.url}')`,
                                        backgroundSize: 'cover',
                                        backgroundPosition: 'center',
                                        opacity: background === row.label ? 1 : 0.5,
                                        borderRadius: '12px',
                                    }}
                                />

                                {background === row.label && (
                                    <div className="tick-overlay">
                                    {loadingBackground === row.label ? (
                                        <div className="loading-circle2" />
                                    ) : (
                                        <i className="fa-solid fa-check" />
                                    )}
                                    </div>
                                )}
                                </div>
                            ))}

                    </div>

                    <button className='chevron-btn right' onClick={scrollRight}>
                        <i className="fa-solid fa-chevron-right"></i>
                    </button>
                </div>

                <div className='wallpaper-dots'>
                    {allBackgrounds.map((_, index) => (
                        <div
                            key={index}
                            className={`dotx ${selected === allBackgrounds[index] ? 'active' : ''} ${modTheme ? 'light' : ''}`}
                        ></div>
                    ))}
                </div>

            </div>

            <div className='custom-back'>
                <span className={`setxz ${modTheme ? 'li' : ''}`}>Custom Background</span>
                <div className='settings-app-general-items' style={{height: '3rem', width: '41rem'}}>
                    <div className={`settings-app-general-item ${modTheme ? 'light' : ''}`} style={{borderRadius: '10rem'}}>
                        <div className='settings-tabbar gray'>
                            <i className="fa-regular fa-file-image"></i>
                        </div>
                        <input className='op-put' style={{width: '20rem'}} value={customUrl} placeholder='Enter Url' onChange={(e) => setCustomUrl(e.target.value)}></input>
                        <div onClick={updateBackgroundCustom} className='right--xx'>
                            <i className="fa-solid fa-check"></i>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
};

export default WallpaperPage;
