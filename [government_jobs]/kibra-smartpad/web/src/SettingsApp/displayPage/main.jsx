import React, { useState, useEffect } from 'react';
import './main.css';
import { callNui } from '../../nui';

const DisplayPart = ({bright, setBright, theme, themeMode, setNewTheme, lang, setData, dataX}) => {
    const [selectedTheme, setSelectedTheme] = useState('dark');
    const [brightness, setBrightness] = useState(50);


    useEffect(() => {
        if(bright){
            setBrightness(bright);
        }
    }, [bright])

    const handleChange = (e) => {
        setBright(e.target.value)
        setBrightness(e.target.value);
    };

    useEffect(() => {
        if(theme){
            setSelectedTheme(theme);
        }
    }, [theme])
    
    const UpdateTheme = (theme) => {
        setNewTheme(theme);
        setSelectedTheme(theme);
        callNui("UpdateTabletData", {
            datatype: 'theme',
            result: theme
        })
    };

    return (
        <>
            <div style={{display: 'flex', flexDirection: 'column'}}>
                <span className={`devsirme ${theme ? 'li' : ''}`}>Display & Brightness</span>
                <span className={`setpage-x ${theme ? 'li' : ''}`}>Appearance</span>
                <div className={`setpage-themepart ${theme ? 'light' : ''}`}>
                    <div className='setpage-themes'>
                        <div
                            className={`theme-optionx ${selectedTheme === 'light' ? 'selected' : ''}`}
                        >
                            <img src='/web/build/light-theme-preview.png' alt='Light Theme' />
                            <span className={`theme-nam ${theme ? 'li' : ''}`}>Light</span>
                            {selectedTheme === 'light' ? (
                                <div className="theme-indicator seced">
                                    <i className="fa-solid fa-check"></i>
                                </div>
                                ) : (
                                <div onClick={() => UpdateTheme('light')} className="theme-indicator"></div>
                            )}

                        </div>

                        <div
                            className={`theme-optionx ${selectedTheme === 'dark' ? 'selected' : ''}`}
                        >
                            <img src='/web/build/dark-theme-preview.png' alt='Dark Theme' />
                            <span className={`theme-nam ${theme ? 'li' : ''}`}>Dark</span>
                            {selectedTheme === 'dark' ? (
                                <div className="theme-indicator seced">
                                    <i className="fa-solid fa-check"></i>
                                </div>
                                ) : (
                                <div onClick={() => UpdateTheme('dark')} className="theme-indicator"></div>
                            )}


                        </div>
                    </div>
                </div>

                <span className={`setpage-x ${theme ? 'li' : ''}`}>{lang.brightness}</span>
                <div className={`setpage-themepart ${theme ? 'light' : ''}`} style={{height: '1.2rem'}}>
                     <div className="brightness-slider-wrap">
                        <i className="fa-regular fa-sun dim-icon" />
                        <input
                            type="range"
                            min="0"
                            max="100"
                            value={brightness}
                            onChange={handleChange}
                            className="brightness-slider"
                            style={{
                                background: `linear-gradient(to right, #0a84ff ${brightness}%, #333 ${brightness}%)`
                            }}
                        />

                        <i className="fa-solid fa-sun bright-icon" />
                    </div>
                </div>

                <div className={`settings-app-general-items ${theme ? 'light' : ''}`} style={{height: '3rem', width: '43rem'}}>
                    <div className='settings-app-general-item'>
                        <div className='settings-tabbar gray'>
                            <i className="fa-solid fa-person-walking-luggage"></i>
                        </div>
                        <span className='op-name'>{lang.widgets}</span>
                        <div style={{top: '.9rem', right: '1rem'}} className='right--x'>
                            <label className="plane-toggle">
                                <input onChange={() => setData("widgets")}  type="checkbox" checked={dataX.widgets ? 'checked' : ''}/>
                                <span className="plane-slider"></span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
};

export default DisplayPart;
