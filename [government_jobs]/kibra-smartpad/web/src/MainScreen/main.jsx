import React, { useState, useEffect, useRef, useMemo, useLayoutEffect} from "react";
import "./main.css";
import "../App.css";
import { motion } from "framer-motion";
import ClockWidget from "./clockWidget/clockWidget";

const MainScreen = ({openApp, apps, background, playerApps, days, months, currentData, widgets, mails, lang, batteryLevel}) => {
    const [time, setTime] = useState(new Date());
    const formattedTime = `${time.getHours().toString().padStart(2, "0")}:${time
        .getMinutes()
        .toString()
        .padStart(2, "0")}`;
    const [tabletBack, setBack] = useState('');

    useEffect(() => {
        setBack(background);
    }, [background]);
    
    const formattedDate = `${days[time.getDay()]}, ${time.getDate()} ${
        months[time.getMonth()]
        } ${time.getFullYear()}`;

    useEffect(() => {
        const interval = setInterval(() => {
        setTime(new Date());
        }, 1000);
    
        return () => clearInterval(interval);
    }, []);

    const fastbarApps = playerApps.filter(a => a.Default);
    const sliderRef = useRef(null);
    const [maxDrag, setMaxDrag] = useState(0);

    useEffect(() => {
        if (sliderRef.current) {
            setMaxDrag(
                sliderRef.current.scrollWidth - sliderRef.current.offsetWidth
            )
        }
    }, [playerApps]);

    const pageSize = 10
    const pages = useMemo(() => {
        const filtered = playerApps.filter(app => {
            if (app.Widget) {
                return widgets // sadece widgets açıkken al
            }
            return true // widget değilse her türlü al
        })

        const arr = []
        for (let i = 0; i < filtered.length; i += pageSize) {
            arr.push(filtered.slice(i, i + pageSize))
        }

        return arr
    }, [playerApps, widgets])


    return (
        <>
    <div
        className="tablet-frame-homescreen"
        style={{
            position: 'absolute',
            top: 0,
            left: 0,
            width: '100%',
            height: '100%',
            backgroundImage: tabletBack.startsWith('http')
            ? `url(${tabletBack})`
            : `url(/web/build/${tabletBack}-background.jpg)`,
            backgroundSize: '100% 100%',
            backgroundRepeat: 'no-repeat',
            backgroundPosition: 'center center',
            borderRadius: '8px',
            userSelect: 'none',
            zIndex: 1
        }}
    >

            <div className="tablet-frame-homescreen-header">
                <div className='header-icon-time-part'>
                    <span className='time-string'>{formattedTime}</span>
                </div>
                <div className='header-icon-part'>
                    <div className='header-icons'>
                      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="10" viewBox="0 0 18 10" fill="none">
                        <path d="M14.5227 0.617317C14.4465 0.801088 14.4465 1.03406 14.4465 1.5V8.5C14.4465 8.96594 14.4465 9.19891 14.5227 9.38268C14.6241 9.62771 14.8188 9.82239 15.0638 9.92388C15.2476 10 15.4806 10 15.9465 10C16.4125 10 16.6454 10 16.8292 9.92388C17.0742 9.82239 17.2689 9.62771 17.3704 9.38268C17.4465 9.19891 17.4465 8.96594 17.4465 8.5V1.5C17.4465 1.03406 17.4465 0.801088 17.3704 0.617317C17.2689 0.372288 17.0742 0.177614 16.8292 0.0761205C16.6454 0 16.4125 0 15.9465 0C15.4806 0 15.2476 0 15.0638 0.0761205C14.8188 0.177614 14.6241 0.372288 14.5227 0.617317Z" fill="white"/>
                        <path d="M9.94653 3.5C9.94653 3.03406 9.94653 2.80109 10.0227 2.61732C10.1241 2.37229 10.3188 2.17761 10.5638 2.07612C10.7476 2 10.9806 2 11.4465 2C11.9125 2 12.1454 2 12.3292 2.07612C12.5742 2.17761 12.7689 2.37229 12.8704 2.61732C12.9465 2.80109 12.9465 3.03406 12.9465 3.5V8.5C12.9465 8.96594 12.9465 9.19891 12.8704 9.38268C12.7689 9.62771 12.5742 9.82239 12.3292 9.92388C12.1454 10 11.9125 10 11.4465 10C10.9806 10 10.7476 10 10.5638 9.92388C10.3188 9.82239 10.1241 9.62771 10.0227 9.38268C9.94653 9.19891 9.94653 8.96594 9.94653 8.5V3.5Z" fill="white"/>
                        <path d="M5.52265 4.61732C5.44653 4.80109 5.44653 5.03406 5.44653 5.5V8.5C5.44653 8.96594 5.44653 9.19891 5.52265 9.38268C5.62415 9.62771 5.81882 9.82239 6.06385 9.92388C6.24762 10 6.48059 10 6.94653 10C7.41247 10 7.64545 10 7.82922 9.92388C8.07424 9.82239 8.26892 9.62771 8.37041 9.38268C8.44653 9.19891 8.44653 8.96594 8.44653 8.5V5.5C8.44653 5.03406 8.44653 4.80109 8.37041 4.61732C8.26892 4.37229 8.07424 4.17761 7.82922 4.07612C7.64545 4 7.41247 4 6.94653 4C6.48059 4 6.24762 4 6.06385 4.07612C5.81882 4.17761 5.62415 4.37229 5.52265 4.61732Z" fill="white"/>
                        <path d="M1.02265 6.11732C0.946533 6.30109 0.946533 6.53406 0.946533 7V8.5C0.946533 8.96594 0.946533 9.19891 1.02265 9.38268C1.12415 9.62771 1.31882 9.82239 1.56385 9.92388C1.74762 10 1.98059 10 2.44653 10C2.91247 10 3.14545 10 3.32922 9.92388C3.57424 9.82239 3.76892 9.62771 3.87041 9.38268C3.94653 9.19891 3.94653 8.96594 3.94653 8.5V7C3.94653 6.53406 3.94653 6.30109 3.87041 6.11732C3.76892 5.87229 3.57424 5.67761 3.32922 5.57612C3.14545 5.5 2.91247 5.5 2.44653 5.5C1.98059 5.5 1.74762 5.5 1.56385 5.57612C1.31882 5.67761 1.12415 5.87229 1.02265 6.11732Z" fill="white"/>
                    </svg>
                    </div>
                    <div className="header-icons battery">
                        <div className="battery-shell">
                            <div
                            className="battery-level"
                            style={{
                                width: `${batteryLevel}%`,
                                backgroundColor: batteryLevel < 20 ? 'red' : 'rgb(227 227 227)',
                            }}
                            ></div>
                        </div>
                        <span className="battery-percent">{batteryLevel}%</span>
                    </div>
                    <div className='header-icons'>
                         <svg xmlns="http://www.w3.org/2000/svg" width="15" height="10" viewBox="0 0 15 10" fill="none">
                            <path d="M12.9512 4.246C13.0647 4.3525 13.2397 4.353 13.3502 4.243L14.4142 3.179C14.5287 3.064 14.5292 2.8745 14.4112 2.763C12.6022 1.0505 10.1607 0 7.47322 0C4.78572 0 2.34422 1.0505 0.535223 2.763C0.417223 2.8745 0.417723 3.064 0.532223 3.179L1.59622 4.243C1.70672 4.353 1.88172 4.3525 1.99522 4.246C3.42972 2.9015 5.35672 2.077 7.47322 2.077C9.58972 2.077 11.5167 2.9015 12.9512 4.246Z" fill="white"/>
                            <path d="M10.5043 6.69645C10.6198 6.79945 10.7923 6.80045 10.9018 6.69095L11.9643 5.62845C12.0798 5.51295 12.0803 5.32045 11.9603 5.20995C10.7793 4.12445 9.20385 3.46145 7.47334 3.46145C5.74285 3.46145 4.16735 4.12445 2.98635 5.20995C2.86635 5.32045 2.86685 5.51295 2.98235 5.62845L4.04485 6.69095C4.15435 6.80045 4.32685 6.79945 4.44235 6.69645C5.24835 5.97695 6.31035 5.53845 7.47334 5.53845C8.63634 5.53845 9.69835 5.97695 10.5043 6.69645Z" fill="white"/>
                            <path d="M9.5082 7.6611C9.6337 7.7661 9.6327 7.9616 9.5167 8.0776L7.6787 9.9156C7.5662 10.0281 7.3832 10.0281 7.2707 9.9156L5.4327 8.0776C5.3167 7.9616 5.3152 7.7661 5.4412 7.6611C5.9917 7.2006 6.7007 6.9231 7.4747 6.9231C8.2487 6.9231 8.9572 7.2006 9.5082 7.6611Z" fill="white"/>
                        </svg>
                    </div>
                </div>
            </div>
            <div className="timeShareder">
                <span className='time-count'>{formattedTime}</span>
                <span className='time-descript'>{formattedDate}</span>
            </div>
            <div
                style={{
                    position: 'relative',
                    overflow: 'hidden',
                    height: 'calc(100% - 200px)',
                    width: '54rem',
                    margin: '3rem auto 0px',
                    boxSizing: 'border-box'
                }}
            >                
            <motion.div ref={sliderRef} drag="x" dragConstraints={{ left: -maxDrag, right: 0 }} style={{ display: "flex", height: "100%" }}>
                {pages.map((page, pi) => (
                    <div
                        key={pi}
                        style={{
                            minWidth: '57rem',
                            boxSizing: 'border-box',
                            placeContent: 'flex-start',
                            marginLeft: '4rem',
                            gap: '0rem 4rem',
                            display: 'flex',
                            flexWrap: 'wrap',
                            padding: '0.5rem 1rem'
                        }}
                    >
                        {page.map((app, ai) =>
                            app.Widget ? (
                                widgets ? (
                                    app.AppHash === 'weather' ? (
                                        <div className="weather-widget" key={ai}>
                                            <div className="weather-top">
                                                <div className="weather-location">{currentData.location}</div>
                                                <div className="weather-temp">{currentData.weather}</div>
                                            </div>
                                            <div className="weather-bottom">
                                                <div className="weather-icon">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none">
                                                        <circle cx="7.99999" cy="7.99999" r="4.06349" fill="#F2C800"/>
                                                        <rect x="7.61905" width="0.761905" height="3.04762" rx="0.380952" fill="#F2C800"/>
                                                        <rect x="7.61905" y="12.9524" width="0.761905" height="3.04762" rx="0.380952" fill="#F2C800"/>
                                                        <rect x="12.9524" y="7.61905" width="3.04762" height="0.761905" rx="0.380952" fill="#F2C800"/>
                                                        <rect x="11.1746" y="4.35536" width="2.53968" height="0.761905" rx="0.380952" transform="rotate(-45 11.1746 4.35536)" fill="#F2C800"/>
                                                        <rect x="3.07843" y="2.53968" width="2.53968" height="0.761905" rx="0.380952" transform="rotate(45 3.07843 2.53968)" fill="#F2C800"/>
                                                        <rect x="11.7133" y="11.1746" width="2.53968" height="0.761905" rx="0.380952" transform="rotate(45 11.7133 11.1746)" fill="#F2C800"/>
                                                        <rect x="2.53967" y="12.9704" width="2.53968" height="0.761905" rx="0.380952" transform="rotate(-45 2.53967 12.9704)" fill="#F2C800"/>
                                                        <rect y="7.61905" width="3.04762" height="0.761905" rx="0.380952" fill="#F2C800"/>
                                                    </svg>
                                                </div>
                                                <div className="weather-desc">
                                                    <div>{currentData.wstring}</div>
                                                    <div className="weather-range">H:30° L:13°</div>
                                                </div>
                                            </div>
                                        </div>
                                    ) : app.AppHash === 'clock' ? (
                                        <ClockWidget key={ai} />
                                    ) : app.AppHash === 'mail' ? (
                                        <div className='mail-widgets' key={ai}>
                                            <div className='mail-widgets'>
                                        <div className='mail-widgets-header'>
                                            <i style={{fontSize: '10px'}} className="fa-regular fa-user"></i> &nbsp; {lang.allbox}
                                        </div>
                                        <div onClick={() => openApp('mail')} className='mail-boxes'>
                                            {mails.length === 0 ? (
                                                <div style={{textAlign: 'center',marginTop: '2rem',color: '#565656'}}>
                                                    {lang.emptymailbox}
                                                </div>
                                            ) : (
                                                mails.slice(-2).map((element, index) => (
                                                    <div className='mail-item' key={index}>
                                                        <span className='mail-hex'>
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="11" height="11" viewBox="0 0 11 11" fill="none">
                                                                <path d="M5.30396 10.8474C3.97787 10.8474 2.7061 10.3206 1.76842 9.38295C0.830739 8.44526 0.303955 7.17349 0.303955 5.84741C0.303955 4.52133 0.830739 3.24956 1.76842 2.31188C2.7061 1.3742 3.97787 0.847412 5.30396 0.847412C6.63004 0.847412 7.90181 1.3742 8.83949 2.31188C9.77717 3.24956 10.304 4.52133 10.304 5.84741C10.304 7.17349 9.77717 8.44526 8.83949 9.38295C7.90181 10.3206 6.63004 10.8474 5.30396 10.8474Z" fill="#0478FF"/>
                                                            </svg> &nbsp; {
                                                (() => {
                                                    const msg = (element.data.subject || '').trim().replace(/\s+/g, ' ');
                                                    const words = msg.split(' ');
                                                    return words.length > 3
                                                    ? words.slice(0, 3).join(' ') + '...'
                                                    : msg;
                                                })()
                                            }
                                                        </span>
                                                        {element.data.message ? (
                                                            <span className='mail-cor'>{
                                                (() => {
                                                    const msg = (element.data.message || '').trim().replace(/\s+/g, ' ');
                                                    const words = msg.split(' ');
                                                    return words.length > 10
                                                    ? words.slice(0, 10).join(' ') + '...'
                                                    : msg;
                                                })()
                                            }</span>
                                                        ) : (
                                                            <span className='mail-cor'>{element.from_name}</span>
                                                        )}
                                                    </div>
                                                ))
                                            )}
                                        </div>
                                    </div>
                                        </div>
                                    ) : null
                                ) : null
                            ) : (
                                <div className="app-box" key={ai} onClick={() => openApp(app.AppHash)}>
                                    <div
                                        className="app-icon"
                                        style={{ backgroundImage: `url(/web/build/appicons/${app.Icon})` }}
                                    />
                                    <span className="app-name">{app.App}</span>
                                </div>
                            )
                        )}
                        </div>
                    ))}
                </motion.div>
            </div>
        </div>
           <div className="fastbar">
                {fastbarApps
                    .filter(app => !app.Widget)
                    .map((app, idx) => (
                    <div
                        key={idx}
                        className="fastbar-app"
                        onClick={() => openApp(app.AppHash)}
                    >
                        <div
                        className="app-icon"
                        style={{ backgroundImage: `url(/web/build/appicons/${app.Icon})` }}
                        />
                    </div>
                ))}
            </div>

        </>
    )
}

export default MainScreen; 

