import React, { useState, useRef, useEffect, useCallback } from 'react';
import './main.css';
import { callNui } from '../../nui';

const ThemePage = ({ themeMode, setNewTheme, background, setTabletBg, allBackgrounds, job, lang, Notification}) => {
    const [loadingBackground, setLoadingBackground] = useState(null);
    const [customUrl, setCustomUrl] = useState('');
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
        <div className={`theme-page-screen ${themeMode == 'light' ? 'lightmode' : ''}`}>
            <span className="themes-page-header">Themes</span>
            <div className="theme-select-part">
                <div className="dark-or-white-part">
                    <div className={`dark-or-white-part-item ${themeMode == 'light' ? 'lightmode':''}`} onClick={() => UpdateTheme('light')}>
                        <div style={{ float: 'left' }}>
                            <span className="dark-or-white-string">Light Theme</span>
                        </div>
                        <div style={{ float: 'right' }}>
                            {themeMode === 'light' ? (
                                <div className="selectedThemeCircle">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="8" height="7" viewBox="0 0 8 7" fill="none">
                                        <path d="M1 3.57143L2.92857 5.5L7.42857 1" stroke="white" strokeWidth="1.2" />
                                    </svg>
                                </div>
                            ) : (
                                ''
                            )}
                        </div>
                    </div>
                    <div className={`dark-or-white-part-item ${themeMode == 'light' ? 'lightmode':''}`} onClick={() => UpdateTheme('dark')}>
                        <div style={{ float: 'left' }}>
                            <span className="dark-or-white-string">Dark Mode</span>
                        </div>
                        <div style={{ float: 'right' }}>
                            {themeMode === 'dark' ? (
                                <div className="selectedThemeCircle">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="8" height="7" viewBox="0 0 8 7" fill="none">
                                        <path d="M1 3.57143L2.92857 5.5L7.42857 1" stroke="white" strokeWidth="1.2" />
                                    </svg>
                                </div>
                            ) : (
                                ''
                            )}
                        </div>
                    </div>
                </div>
                <span className="wallpaper-part-header">Wallpaper</span>
                <div className='custom-map'>
                    <input className={`input-url ${themeMode == 'light' ? 'lightmode':''}`} placeholder={lang.enterUrl} value={customUrl} onChange={(e)=>setCustomUrl(e.target.value)}></input> 
                    <button onClick={updateBackgroundCustom} className='input-but'><i class="fa-solid fa-check"></i></button>
                </div>
                <div className={`wallpaper-list ${themeMode == 'light' ? 'lightmode':''}`} ref={wallpaperListRef} onWheel={handleWheel}>
                {allBackgrounds
                    .filter(row=>!row.jobs||row.jobs.includes(job))
                    .map(row=>(
                        <div
                        key={row.label}
                        onClick={()=>UpdateBackground(row.label)}
                        style={{
                            backgroundImage:"url('"+row.url+"')",
                            backgroundSize:'cover',
                            backgroundPosition:'center',
                            borderRadius:'6px'
                        }}
                        className={`wallpaper-list-item ${row.label===background?'selected':''}`}
                        >
                        {row.label===background?(
                            loadingBackground===row.label?(
                            <div className="wallpaper-list-item-selected">
                                <div className="loading-circle2"></div>
                            </div>
                            ):(
                            <div className="wallpaper-list-item-selected">
                                <i style={{fontSize:'10px'}} className="fa-solid fa-check"></i>
                            </div>
                            )
                        ):''}
                        </div>
                    ))
                    }

                </div>
            </div>
        </div>
    );
};

export default ThemePage;
