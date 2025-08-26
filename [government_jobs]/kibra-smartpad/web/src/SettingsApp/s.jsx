import React, {useEffect, useState, useCallback} from 'react';
import './main.css';
import AboutDeviceScreen from './aboutDevice/main';
import OverviewPageScreen from './overview/main';
import ThemePage from './themes/main';
import Avatar from '/public/avatar.png'
import PasswordX from './password/main';
import { motion, AnimatePresence } from 'framer-motion';

const SettingsApp = ({tabletTheme, setThemeMode, apps, themeMode, background, setBackground, allBackgrounds, lang, tabData, allLang, Notification, job}) => {
    const [showTabletInfo, setTabletInfo] = useState(false);
    const [isOpenedOverview, setOverview] = useState(true);
    const [isOpenedThemes, setThemePage] = useState(false);
    const [passScreen, setPassScreen] = useState(false);
    const [forceUpdate, setForceUpdate] = useState(false);

    const setNewTheme = (theme) => {
        setThemeMode(theme);
        setForceUpdate(prev => !prev);
    };
    
    const ChangePageInSettings = (page) => {
        switch(page){
            case "overview":
                setPassScreen(false);
                setTabletInfo(false);
                setThemePage(false);
                setOverview(true);
                break;
            case "themes":
                setPassScreen(false);
                setTabletInfo(false);
                setOverview(false);
                setThemePage(true);
                break;
            case "about":
                setPassScreen(false);
                setThemePage(false);
                setOverview(false);
                setTabletInfo(true)
                break;
            case "password":
                setThemePage(false);
                setOverview(false);
                setTabletInfo(false);
                setPassScreen(true);
                break;
            default: break;
        }
    }


    return (
        <div className={`settings-frame ${tabletTheme == 'dark' ? 'set-dark' : 'set-white'}`} key={forceUpdate ? "force1" : "force2"}>
            <div className={`settings-app-topbar ${tabletTheme == 'dark' ? 'set-dark' : 'settings-top-left-loginpart-white'} `}></div>
            <div className={`settings-app-main `}>
                <div className={`settings-top-left ${tabletTheme == 'dark' ? 'set-dark' : 'set-white-topbar'}`}>
                    <div className={`settings-top-left-loginpart ${tabletTheme == 'light' ? 'settings-top-left-loginpart-white':''}`}>
                        <img  src={`/web/pimg/${tabData.owner}.png`}
              onError={e=>{e.currentTarget.onerror=null;e.currentTarget.src='/web/pimg/player.jpg'}}></img>
                        <div style={{display: 'flex',
flexDirection: 'column',
marginLeft: '1rem',
marginTop: '.5rem'}}>
                            <span className='sign-tablet'>{tabData.data.ownername}</span> 
                            <span className='sign-tablet-setup'>{tabData.owner}</span>
                        </div>
                    </div>
                    {/* <div className='menu-navbar'>
                        <div onClick={() => ChangePageInSettings('overview')} className='menu-navbar-item'>
                            <div className='menu-navbar-item-setlogo green'>
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none">
                                    <path d="M8 10C9.10457 10 10 9.10457 10 8C10 6.89543 9.10457 6 8 6C6.89543 6 6 6.89543 6 8C6 9.10457 6.89543 10 8 10Z" stroke="white"/>
                                    <path d="M1.80867 7.048C2.15985 7.2552 2.38556 7.6094 2.38556 8C2.38556 8.3906 2.15985 8.7448 1.80867 8.952C1.57034 9.0941 1.41591 9.2068 1.30677 9.3412C1.18805 9.48711 1.10097 9.65363 1.05053 9.83127C1.00008 10.0089 0.987245 10.1942 1.01276 10.3765C1.05137 10.6523 1.22436 10.9351 1.5696 11.5C1.91633 12.0649 2.08932 12.347 2.32319 12.5171C2.47795 12.629 2.65457 12.7111 2.84299 12.7587C3.0314 12.8063 3.22791 12.8184 3.42128 12.7943C3.59947 12.7719 3.77989 12.7033 4.02935 12.5787C4.20788 12.4866 4.40832 12.4388 4.61183 12.4397C4.81535 12.4407 5.01526 12.4905 5.19278 12.5843C5.55138 12.7803 5.76447 13.1408 5.77932 13.5314C5.78971 13.7974 5.81644 13.9794 5.88549 14.1355C5.96012 14.3055 6.06954 14.4599 6.20751 14.59C6.34548 14.7201 6.50929 14.8232 6.68957 14.8936C6.96205 15 7.30803 15 8 15C8.69197 15 9.03795 15 9.31043 14.8936C9.49072 14.8232 9.65452 14.7201 9.79249 14.59C9.93046 14.4599 10.0399 14.3055 10.1145 14.1355C10.1828 13.9794 10.2103 13.7974 10.2207 13.5314C10.2355 13.1408 10.4486 12.7796 10.8072 12.5843C10.9847 12.4905 11.1847 12.4407 11.3882 12.4397C11.5917 12.4388 11.7921 12.4866 11.9706 12.5787C12.2201 12.7033 12.4013 12.7719 12.5795 12.7943C12.9698 12.8427 13.3645 12.743 13.6768 12.5171C13.9107 12.3477 14.0837 12.0649 14.4297 11.5C14.5841 11.248 14.7036 11.0527 14.7927 10.8889M14.1913 8.9527C14.0175 8.85309 13.8734 8.71347 13.7725 8.54695C13.6716 8.38043 13.6172 8.19247 13.6144 8.0007C13.6144 7.6094 13.8401 7.2552 14.1913 7.0473C14.4297 6.9059 14.5833 6.7932 14.6932 6.6588C14.812 6.51289 14.899 6.34637 14.9495 6.16873C14.9999 5.99109 15.0128 5.80582 14.9872 5.6235C14.9486 5.3477 14.7756 5.0649 14.4304 4.5C14.0837 3.9351 13.9107 3.653 13.6768 3.4829C13.5221 3.37096 13.3454 3.28887 13.157 3.24131C12.9686 3.19374 12.7721 3.18164 12.5787 3.2057C12.4005 3.2281 12.2201 3.2967 11.9699 3.4213C11.7915 3.51329 11.5912 3.56104 11.3878 3.56006C11.1844 3.55908 10.9847 3.5094 10.8072 3.4157C10.6323 3.31763 10.4868 3.17927 10.3842 3.0136C10.2816 2.84793 10.2253 2.66039 10.2207 2.4686C10.2103 2.2026 10.1836 2.0206 10.1145 1.8645C10.0399 1.69453 9.93046 1.54009 9.79249 1.41001C9.65452 1.27993 9.49072 1.17676 9.31043 1.1064C9.03795 1 8.69197 1 8 1C7.30803 1 6.96205 1 6.68957 1.1064C6.50929 1.17676 6.34548 1.27993 6.20751 1.41001C6.06954 1.54009 5.96012 1.69453 5.88549 1.8645C5.81718 2.0206 5.78971 2.2026 5.77932 2.4686C5.77469 2.66039 5.71844 2.84793 5.61584 3.0136C5.51324 3.17927 5.36766 3.31763 5.19278 3.4157C5.01526 3.50953 4.81535 3.55927 4.61183 3.56025C4.40832 3.56123 4.20788 3.51342 4.02935 3.4213C3.77989 3.2967 3.59873 3.2281 3.42054 3.2057C3.03025 3.15731 2.63554 3.25701 2.32319 3.4829C2.09006 3.653 1.91633 3.9351 1.57034 4.5C1.41591 4.752 1.29638 4.9473 1.20728 5.1111" stroke="white" stroke-width="1.2" stroke-linecap="round"/>
                                </svg>
                            </div>
                            <span className='mdt-finito'>{lang.generalSettings}</span>
                        </div>
                        00000
                        <div onClick={() => ChangePageInSettings('password')} className='menu-navbar-item'>
                            <div className='menu-navbar-item-setlogo purple'>
                                <svg fill="#ffffff" xmlns="http://www.w3.org/2000/svg" width="11" height="14" viewBox="0 0 11 14">
                                    <path d="M1.75 13.75C1.40625 13.75 1.11198 13.6276 0.867188 13.3828C0.622396 13.138 0.5 12.8438 0.5 12.5V6.25C0.5 5.90625 0.622396 5.61198 0.867188 5.36719C1.11198 5.1224 1.40625 5 1.75 5H2.375V3.75C2.375 2.88542 2.67969 2.14844 3.28906 1.53906C3.89844 0.929687 4.63542 0.625 5.5 0.625C6.36458 0.625 7.10156 0.929687 7.71094 1.53906C8.32031 2.14844 8.625 2.88542 8.625 3.75V5H9.25C9.59375 5 9.88802 5.1224 10.1328 5.36719C10.3776 5.61198 10.5 5.90625 10.5 6.25V12.5C10.5 12.8438 10.3776 13.138 10.1328 13.3828C9.88802 13.6276 9.59375 13.75 9.25 13.75H1.75ZM1.75 12.5H9.25V6.25H1.75V12.5ZM5.5 10.625C5.84375 10.625 6.13802 10.5026 6.38281 10.2578C6.6276 10.013 6.75 9.71875 6.75 9.375C6.75 9.03125 6.6276 8.73698 6.38281 8.49219C6.13802 8.2474 5.84375 8.125 5.5 8.125C5.15625 8.125 4.86198 8.2474 4.61719 8.49219C4.3724 8.73698 4.25 9.03125 4.25 9.375C4.25 9.71875 4.3724 10.013 4.61719 10.2578C4.86198 10.5026 5.15625 10.625 5.5 10.625ZM3.625 5H7.375V3.75C7.375 3.22917 7.19271 2.78646 6.82812 2.42188C6.46354 2.05729 6.02083 1.875 5.5 1.875C4.97917 1.875 4.53646 2.05729 4.17188 2.42188C3.80729 2.78646 3.625 3.22917 3.625 3.75V5Z" fill="#ffffff"/>
                                </svg>
                            </div>
                            <span className='mdt-finito'>{lang.password}</span>
                        </div> 
                        <div onClick={() => ChangePageInSettings('themes')} className='menu-navbar-item'>
                            <div className='menu-navbar-item-setlogo gray'>
                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 14 14" fill="none">
                                 <path d="M14 9.1V12.6C14 12.9713 13.8525 13.3274 13.5899 13.5899C13.3274 13.8525 12.9713 14 12.6 14H11.9V11.9C11.9 11.7143 11.8263 11.5363 11.695 11.405C11.5637 11.2737 11.3857 11.2 11.2 11.2C11.0143 11.2 10.8363 11.2737 10.705 11.405C10.5737 11.5363 10.5 11.7143 10.5 11.9V14H7.7V11.9C7.7 11.7143 7.62625 11.5363 7.49497 11.405C7.3637 11.2737 7.18565 11.2 7 11.2C6.81435 11.2 6.6363 11.2737 6.50503 11.405C6.37375 11.5363 6.3 11.7143 6.3 11.9V14H3.5V11.9C3.5 11.7143 3.42625 11.5363 3.29497 11.405C3.1637 11.2737 2.98565 11.2 2.8 11.2C2.61435 11.2 2.4363 11.2737 2.30503 11.405C2.17375 11.5363 2.1 11.7143 2.1 11.9V14H1.4C1.0287 14 0.672601 13.8525 0.41005 13.5899C0.1475 13.3274 0 12.9713 0 12.6V9.1H14ZM7.7 0C8.0713 0 8.4274 0.1475 8.68995 0.41005C8.9525 0.672601 9.1 1.0287 9.1 1.4V4.2C9.1 4.38565 9.17375 4.5637 9.30503 4.69497C9.4363 4.82625 9.61435 4.9 9.8 4.9H12.6C12.9713 4.9 13.3274 5.0475 13.5899 5.31005C13.8525 5.5726 14 5.9287 14 6.3V7.7H0V6.3C0 5.9287 0.1475 5.5726 0.41005 5.31005C0.672601 5.0475 1.0287 4.9 1.4 4.9H4.2C4.38565 4.9 4.5637 4.82625 4.69497 4.69497C4.82625 4.5637 4.9 4.38565 4.9 4.2V1.4C4.9 1.0287 5.0475 0.672601 5.31005 0.41005C5.5726 0.1475 5.9287 0 6.3 0H7.7Z" fill="white"/>
                                </svg>
                            </div>
                            <span className='mdt-finito'>{lang.themes}</span>
                        </div>
                        <div onClick={() => ChangePageInSettings('about')} className='menu-navbar-item'>
                            <div className='menu-navbar-item-setlogo gray'>
                                <i style={{color: '#fff'}} className="fa-regular fa-tablet"></i>
                            </div>
                            <span className='mdt-finito'>{lang.aboutDevice}</span>
                        </div>
                    </div> */}

                    {/* <div className={`storage-container ${tabletTheme == 'dark' ? 'set-dark' : 'set-white'}`}>
                        <div className="storage-title">{lang.tabletStorage}</div>
                        <div className="storage-bar">
                            <div className="applications"></div>
                            <div className="photos"></div>
                            <div className="other"></div>
                        </div>
                        <div className="storage-info">
                            <div style={{display: 'flex', flexDirection: 'column'}}>
                                <div className="legend-container">
                                    <div className="legend">
                                        <div className="color applications-color"></div> {lang.applications}
                                    </div>
                                    <div className="legend">
                                        <div className="color photos-color"></div> {lang.photos}
                                    </div>
                                    <div className="legend">
                                        <div className="color other-color"></div> {lang.other}
                                    </div>
                                </div>
                                <span className='spen'>53,17 GB of 128 GB used</span>
                            </div>
                        </div>
                    </div> */}
                </div>
                <div className='settingapp-overview'>
                    <AnimatePresence>
                        {showTabletInfo && 
                            <motion.div
                                key="aboutdevice"
                                initial={{ opacity: 0, y: 20 }} 
                                animate={{ opacity: 1, y: 0 }}
                                exit={{ opacity: 0, y: -10 }}
                                transition={{ duration: 0.1 }}
                            >
                                <AboutDeviceScreen 
                                    themeMode={themeMode} 
                                    lang={lang} 
                                    allLang={allLang} 
                                    tabData={tabData} 
                                    Notification={Notification}
                                ></AboutDeviceScreen>
                            </motion.div>
                        }

                        {isOpenedOverview && 
                            <motion.div
                                key="overviewpage"
                                initial={{ opacity: 0, y: 20 }} 
                                animate={{ opacity: 1, y: 0 }}
                                exit={{ opacity: 0, y: -10 }}
                                transition={{ duration: 0.1 }}
                            >
                                <OverviewPageScreen 
                                    apps={apps} 
                                    themeMode={themeMode} 
                                    lang={lang} 
                                    tabData={tabData}>
                                </OverviewPageScreen>
                            </motion.div>
                        }

                        {isOpenedThemes && 
                            <motion.div
                                key="themepage"
                                initial={{ opacity: 0, y: 20 }} 
                                animate={{ opacity: 1, y: 0 }}
                                exit={{ opacity: 0, y: -10 }}
                                transition={{ duration: 0.1 }}
                            >
                                <ThemePage 
                                    themeMode={themeMode} 
                                    setNewTheme={setNewTheme} 
                                    background={background} 
                                    setTabletBg={setBackground} 
                                    allBackgrounds={allBackgrounds} 
                                    lang={lang}
                                    job={job}
                                    Notification={Notification}
                                    >
                                </ThemePage>
                            </motion.div>
                        }

                        {passScreen && 
                            <PasswordX 
                                isOpened={passScreen} 
                                lang={lang} 
                                tabData={tabData} 
                                theme={tabletTheme}>
                            </PasswordX>
                        }

                        </AnimatePresence>
                </div>
            </div>
        </div>
    )
}

export default SettingsApp;