import React, {useEffect, useState, useCallback} from 'react';
import './main.css';
import AboutDeviceScreen from './aboutDevice/main';
import OverviewPageScreen from './overview/main';
import ThemePage from './themes/main';
import Avatar from '/public/avatar.png'
import WallpaperPage from './wallpaperPage/main';
import PasswordX from './password/main';
import { motion, AnimatePresence } from 'framer-motion';
import DisplayPart from './displayPage/main';
import ColdModal from './coldModal/main';
import { callNui } from '@/nui';

const SettingsApp = ({bright, setBright, tabletTheme, setThemeMode, apps, themeMode, settings, setSettings, background, setBackground, allBackgrounds, lang, tabData, allLang, Notification, job}) => {
    const [showTabletInfo, setTabletInfo] = useState(false);
    const [isOpenedOverview, setOverview] = useState(true);
    const [isOpenedThemes, setBackgroundPage] = useState(false);
    const [passScreen, setPassScreen] = useState(false);
    const [forceUpdate, setForceUpdate] = useState(false);
    const [currentMenu, setCurrentMenu] = useState('general');
    const [themePart, setThemePart] = useState(false);
    const [generalPage, setGeneral] = useState(true);
    const [backPage, setBackPage] = useState(false);
    const [modTheme, setModTheme] = useState(false);
    const fillColor = modTheme ? '#000' : '#fff';
    const [showModa, setShowModa] = useState(false);
    const [resetModal, setResetModal] = useState(false);

    useEffect(() => {
        if(themeMode == 'light'){
            setModTheme(true)
        } else {
            setModTheme(false)
        }
    }, []);

    const CheckVersion = () => {
        setShowModa(true);
    }

    const ResetModalX = () => {
        setResetModal(true);
    }

    const setNewTheme = (theme) => {
        setThemeMode(theme);
        if(theme == 'light'){
            setModTheme(true)
        } else {
            setModTheme(false)
        }
        setForceUpdate(prev => !prev);
    };

    const hideAll = () => {
        setOverview(false);
        setThemePart(false);
        setPassScreen(false);
        setGeneral(false);
        setTabletInfo(false);
        setThemePart(false);
        setBackPage(false);
        setBackgroundPage(false);
    }

    const setPage = (page) => {
        switch (page) {
            case "general":
                hideAll();
                setGeneral(true)
                setCurrentMenu("general");
                break;
            case "background":
                hideAll();
                setBackPage(true)
                setCurrentMenu("background");
                break;
            case "password":
                hideAll();
                setPassScreen(true)
                setCurrentMenu("password");
                break;
            case "theme":
                hideAll();
                setThemePart(true)
                setCurrentMenu("theme");
                break;
            case "about":
                hideAll();
                setTabletInfo(true);
                break;
            default:
                break;
        }
    }
    
    const handleToggle = (key) => {
        setSettings((prev) => {
            const newSettings = {
                ...prev,
                [key]: !prev[key],
            };
    
            callNui("UpdateTabletData", {
                datatype: key,
                result: newSettings[key],
            });
    
            return newSettings;
        });
    };

    const resetAllData = () => {
        callNui('resetTablet', {}, (data) => {
            
        });
    }

    const [time, setTime] = useState(new Date());
    const formattedTime = `${time.getHours().toString().padStart(2, "0")}:${time
        .getMinutes()
        .toString()
        .padStart(2, "0")}`;

    return (
        <div className={`settings-app-frame ${modTheme ? 'light' : 'dark'}`}>
             <div className='header-icon-time-part'>
                <span className={`time-string ${modTheme ? 'li' : ''}`}>{formattedTime}</span>
            </div>
            <div className='header-icon-part'>
                <div className='header-icons'>
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="10" viewBox="0 0 18 10" fill={fillColor}>
                        <path d="M14.5227 0.617317C14.4465 0.801088 14.4465 1.03406 14.4465 1.5V8.5C14.4465 8.96594 14.4465 9.19891 14.5227 9.38268C14.6241 9.62771 14.8188 9.82239 15.0638 9.92388C15.2476 10 15.4806 10 15.9465 10C16.4125 10 16.6454 10 16.8292 9.92388C17.0742 9.82239 17.2689 9.62771 17.3704 9.38268C17.4465 9.19891 17.4465 8.96594 17.4465 8.5V1.5C17.4465 1.03406 17.4465 0.801088 17.3704 0.617317C17.2689 0.372288 17.0742 0.177614 16.8292 0.0761205C16.6454 0 16.4125 0 15.9465 0C15.4806 0 15.2476 0 15.0638 0.0761205C14.8188 0.177614 14.6241 0.372288 14.5227 0.617317Z" fill="white"/>
                        <path d="M9.94653 3.5C9.94653 3.03406 9.94653 2.80109 10.0227 2.61732C10.1241 2.37229 10.3188 2.17761 10.5638 2.07612C10.7476 2 10.9806 2 11.4465 2C11.9125 2 12.1454 2 12.3292 2.07612C12.5742 2.17761 12.7689 2.37229 12.8704 2.61732C12.9465 2.80109 12.9465 3.03406 12.9465 3.5V8.5C12.9465 8.96594 12.9465 9.19891 12.8704 9.38268C12.7689 9.62771 12.5742 9.82239 12.3292 9.92388C12.1454 10 11.9125 10 11.4465 10C10.9806 10 10.7476 10 10.5638 9.92388C10.3188 9.82239 10.1241 9.62771 10.0227 9.38268C9.94653 9.19891 9.94653 8.96594 9.94653 8.5V3.5Z" fill="white"/>
                        <path d="M5.52265 4.61732C5.44653 4.80109 5.44653 5.03406 5.44653 5.5V8.5C5.44653 8.96594 5.44653 9.19891 5.52265 9.38268C5.62415 9.62771 5.81882 9.82239 6.06385 9.92388C6.24762 10 6.48059 10 6.94653 10C7.41247 10 7.64545 10 7.82922 9.92388C8.07424 9.82239 8.26892 9.62771 8.37041 9.38268C8.44653 9.19891 8.44653 8.96594 8.44653 8.5V5.5C8.44653 5.03406 8.44653 4.80109 8.37041 4.61732C8.26892 4.37229 8.07424 4.17761 7.82922 4.07612C7.64545 4 7.41247 4 6.94653 4C6.48059 4 6.24762 4 6.06385 4.07612C5.81882 4.17761 5.62415 4.37229 5.52265 4.61732Z" fill="white"/>
                        <path d="M1.02265 6.11732C0.946533 6.30109 0.946533 6.53406 0.946533 7V8.5C0.946533 8.96594 0.946533 9.19891 1.02265 9.38268C1.12415 9.62771 1.31882 9.82239 1.56385 9.92388C1.74762 10 1.98059 10 2.44653 10C2.91247 10 3.14545 10 3.32922 9.92388C3.57424 9.82239 3.76892 9.62771 3.87041 9.38268C3.94653 9.19891 3.94653 8.96594 3.94653 8.5V7C3.94653 6.53406 3.94653 6.30109 3.87041 6.11732C3.76892 5.87229 3.57424 5.67761 3.32922 5.57612C3.14545 5.5 2.91247 5.5 2.44653 5.5C1.98059 5.5 1.74762 5.5 1.56385 5.57612C1.31882 5.67761 1.12415 5.87229 1.02265 6.11732Z" fill="white"/>
                    </svg>
                </div>
                <div className='header-icons'>
                    <svg xmlns="http://www.w3.org/2000/svg" width="15" height="10" viewBox="0 0 15 10" fill={fillColor}>
                        <path d="M12.9512 4.246C13.0647 4.3525 13.2397 4.353 13.3502 4.243L14.4142 3.179C14.5287 3.064 14.5292 2.8745 14.4112 2.763C12.6022 1.0505 10.1607 0 7.47322 0C4.78572 0 2.34422 1.0505 0.535223 2.763C0.417223 2.8745 0.417723 3.064 0.532223 3.179L1.59622 4.243C1.70672 4.353 1.88172 4.3525 1.99522 4.246C3.42972 2.9015 5.35672 2.077 7.47322 2.077C9.58972 2.077 11.5167 2.9015 12.9512 4.246Z" fill="white"/>
                        <path d="M10.5043 6.69645C10.6198 6.79945 10.7923 6.80045 10.9018 6.69095L11.9643 5.62845C12.0798 5.51295 12.0803 5.32045 11.9603 5.20995C10.7793 4.12445 9.20385 3.46145 7.47334 3.46145C5.74285 3.46145 4.16735 4.12445 2.98635 5.20995C2.86635 5.32045 2.86685 5.51295 2.98235 5.62845L4.04485 6.69095C4.15435 6.80045 4.32685 6.79945 4.44235 6.69645C5.24835 5.97695 6.31035 5.53845 7.47334 5.53845C8.63634 5.53845 9.69835 5.97695 10.5043 6.69645Z" fill="white"/>
                        <path d="M9.5082 7.6611C9.6337 7.7661 9.6327 7.9616 9.5167 8.0776L7.6787 9.9156C7.5662 10.0281 7.3832 10.0281 7.2707 9.9156L5.4327 8.0776C5.3167 7.9616 5.3152 7.7661 5.4412 7.6611C5.9917 7.2006 6.7007 6.9231 7.4747 6.9231C8.2487 6.9231 8.9572 7.2006 9.5082 7.6611Z" fill="white"/>
                    </svg>
                </div>
                {/* <div className='header-icons'>
                    <svg xmlns="http://www.w3.org/2000/svg" width="15" height="10" viewBox="0 0 15 10" fill="none">
                        <path d="M12.9512 4.246C13.0647 4.3525 13.2397 4.353 13.3502 4.243L14.4142 3.179C14.5287 3.064 14.5292 2.8745 14.4112 2.763C12.6022 1.0505 10.1607 0 7.47322 0C4.78572 0 2.34422 1.0505 0.535223 2.763C0.417223 2.8745 0.417723 3.064 0.532223 3.179L1.59622 4.243C1.70672 4.353 1.88172 4.3525 1.99522 4.246C3.42972 2.9015 5.35672 2.077 7.47322 2.077C9.58972 2.077 11.5167 2.9015 12.9512 4.246Z" fill="white"/>
                        <path d="M10.5043 6.69645C10.6198 6.79945 10.7923 6.80045 10.9018 6.69095L11.9643 5.62845C12.0798 5.51295 12.0803 5.32045 11.9603 5.20995C10.7793 4.12445 9.20385 3.46145 7.47334 3.46145C5.74285 3.46145 4.16735 4.12445 2.98635 5.20995C2.86635 5.32045 2.86685 5.51295 2.98235 5.62845L4.04485 6.69095C4.15435 6.80045 4.32685 6.79945 4.44235 6.69645C5.24835 5.97695 6.31035 5.53845 7.47334 5.53845C8.63634 5.53845 9.69835 5.97695 10.5043 6.69645Z" fill="white"/>
                        <path d="M9.5082 7.6611C9.6337 7.7661 9.6327 7.9616 9.5167 8.0776L7.6787 9.9156C7.5662 10.0281 7.3832 10.0281 7.2707 9.9156L5.4327 8.0776C5.3167 7.9616 5.3152 7.7661 5.4412 7.6611C5.9917 7.2006 6.7007 6.9231 7.4747 6.9231C8.2487 6.9231 8.9572 7.2006 9.5082 7.6611Z" fill="white"/>
                    </svg>
                </div> */}
            </div>

            <div className={`settings-app-left-bar ${modTheme ? 'light' : 'dark'}`}>
                <span className='appa-title'>{lang.settingsAppLabel}</span>
                <div className='logar-part'>
                    <img
                        src={`/web/pimg/${tabData.owner}.png`}
                        onError={(e) => {
                            e.currentTarget.onerror = null;
                            e.currentTarget.src = '/web/pimg/avatar.png';
                        }}
                    />
                    <div style={{display: 'flex', flexDirection: 'column'}}>
                        <span className={`hesap-title ${modTheme ? 'li' : ''}`}>{tabData.data.ownername}</span>
                        <span className='hesap-info-txt'>{tabData.email}</span>
                    </div>
                    <div className='settings'>
                        <div className={`settings-item ${modTheme ? 'light' : 'dark'}`}>
                            <div className={`setting-item-logo`}>
                                <i className="fa-solid fa-plane"></i>
                            </div> 
                            <span className='app-namex'>{lang.planeMode}</span>
                            <label className="plane-toggle">
                                <input onChange={() => handleToggle("planemode")}  checked={settings.planemode ? 'checked' : ''} type="checkbox" />
                                <span className="plane-slider"></span>
                            </label>
                        </div>


                        <div className={`settings-item ${modTheme ? 'light' : 'dark'} ${currentMenu == 'general' ? 'selected': ''}`} onClick={() => setPage('general')}>
                            <div className='setting-item-logo gray'>
                                <svg xmlns="http://www.w3.org/2000/svg" width="15" height="20" viewBox="0 0 21 20" fill="none">
                                    <path d="M10.0547 18.5951C10.2656 18.5951 10.4678 18.5776 10.6875 18.56L11.1797 19.4916C11.2852 19.7289 11.5225 19.8432 11.7949 19.808C12.0498 19.7641 12.2256 19.5707 12.2607 19.3071L12.4102 18.2612C12.8232 18.1557 13.2275 17.9975 13.6143 17.8305L14.3877 18.5248C14.5723 18.7094 14.8271 18.7358 15.082 18.6039C15.3018 18.4721 15.3896 18.2348 15.3457 17.9711L15.126 16.9516C15.4688 16.7055 15.8027 16.433 16.1191 16.1342L17.0684 16.5297C17.3232 16.6352 17.5605 16.5737 17.7539 16.3539C17.9121 16.1694 17.9385 15.9057 17.7979 15.6772L17.2441 14.7895C17.4814 14.4467 17.6836 14.0688 17.8682 13.6733L18.9229 13.726C19.1777 13.7436 19.4062 13.5942 19.4941 13.3481C19.582 13.102 19.4941 12.8471 19.292 12.6889L18.4746 12.0385C18.5801 11.6342 18.6592 11.2123 18.6943 10.7729L19.6875 10.4565C19.9424 10.3686 20.1006 10.1664 20.1006 9.90276C20.1006 9.63909 19.9424 9.43694 19.6875 9.34905L18.6943 9.03264C18.6592 8.59319 18.5713 8.18011 18.4746 7.76702L19.292 7.11663C19.4941 6.96722 19.5732 6.72112 19.4941 6.47503C19.4062 6.22014 19.1777 6.07073 18.9229 6.08831L17.8682 6.12347C17.6836 5.73675 17.4814 5.36761 17.2441 5.01604L17.7979 4.11956C17.9297 3.90862 17.9121 3.64495 17.7539 3.46038C17.5605 3.24065 17.3232 3.17913 17.0684 3.2846L16.1104 3.67132C15.8027 3.38128 15.4688 3.10003 15.126 2.86272L15.3457 1.84319C15.3896 1.57073 15.3018 1.33343 15.0732 1.21038C14.8271 1.07854 14.5723 1.09612 14.3877 1.28948L13.6143 1.97503C13.2275 1.79925 12.8232 1.65862 12.4102 1.54436L12.2607 0.516043C12.2256 0.252371 12.0498 0.0590119 11.7949 0.00627753C11.5225 -0.0288787 11.2939 0.0853791 11.1797 0.305106L10.6875 1.24554C10.4678 1.22796 10.2656 1.21917 10.0547 1.21917C9.82617 1.21917 9.62402 1.22796 9.4043 1.24554L8.91211 0.305106C8.80664 0.0853791 8.56934 -0.0288787 8.29688 0.0150666C8.04199 0.0590119 7.86621 0.252371 7.83105 0.516043L7.68164 1.54436C7.27734 1.65862 6.87305 1.79925 6.47754 1.97503L5.71289 1.28948C5.51953 1.10491 5.26465 1.07854 5.01855 1.21038C4.79883 1.33343 4.70215 1.57073 4.74609 1.84319L4.96582 2.86272C4.62305 3.10003 4.28906 3.38128 3.98145 3.67132L3.02344 3.2846C2.77734 3.17913 2.53125 3.24065 2.34668 3.46038C2.17969 3.64495 2.16211 3.90862 2.29395 4.11956L2.85645 5.01604C2.61914 5.36761 2.41699 5.73675 2.22363 6.12347L1.17773 6.08831C0.914062 6.07073 0.685547 6.22014 0.606445 6.47503C0.518555 6.72112 0.588867 6.96722 0.799805 7.11663L1.62598 7.76702C1.52051 8.18011 1.43262 8.59319 1.40625 9.03264L0.413086 9.34905C0.149414 9.43694 0 9.6303 0 9.90276C0 10.1664 0.149414 10.3686 0.413086 10.4565L1.40625 10.7729C1.43262 11.2123 1.52051 11.6342 1.62598 12.0385L0.808594 12.6889C0.597656 12.8383 0.527344 13.0932 0.606445 13.3393C0.685547 13.5942 0.914062 13.7436 1.17773 13.726L2.22363 13.6733C2.4082 14.0688 2.61914 14.4467 2.85645 14.7895L2.29395 15.686C2.15332 15.9057 2.17969 16.1694 2.34668 16.3539C2.53125 16.5737 2.77734 16.6352 3.02344 16.5297L3.98145 16.1342C4.28906 16.433 4.62305 16.7055 4.96582 16.9516L4.74609 17.9711C4.70215 18.2348 4.79004 18.4721 5.01855 18.6039C5.26465 18.7358 5.51953 18.7094 5.71289 18.5248L6.47754 17.8305C6.87305 17.9975 7.26855 18.1557 7.68164 18.2699L7.83105 19.3071C7.86621 19.5707 8.04199 19.7641 8.30566 19.808C8.56934 19.8432 8.80664 19.7289 8.91211 19.5004L9.4043 18.56C9.62402 18.5776 9.82617 18.5951 10.0547 18.5951ZM12.3486 9.20843C11.918 8.07464 11.0391 7.4594 10.002 7.4594C9.85254 7.4594 9.69434 7.47698 9.42188 7.5385L7.04883 3.46038C7.9541 3.0385 8.96484 2.8012 10.0459 2.8012C13.7637 2.8012 16.6816 5.59612 17.0156 9.20843H12.3486ZM3.0498 9.91155C3.0498 7.55608 4.13086 5.49065 5.84473 4.19866L8.23535 8.28557C7.76953 8.79534 7.5498 9.35784 7.5498 9.93792C7.5498 10.4916 7.75195 11.019 8.23535 11.5551L5.77441 15.5717C4.10449 14.2797 3.0498 12.2319 3.0498 9.91155ZM8.94727 9.92913C8.94727 9.33147 9.44824 8.87444 10.0107 8.87444C10.5996 8.87444 11.083 9.33147 11.083 9.92913C11.083 10.5092 10.5996 10.9926 10.0107 10.9926C9.44824 10.9926 8.94727 10.5092 8.94727 9.92913ZM10.0459 17.0131C8.93848 17.0131 7.90137 16.767 6.97852 16.3188L9.41309 12.3285C9.67676 12.3813 9.85254 12.3989 10.002 12.3989C11.0479 12.3989 11.918 11.766 12.3486 10.6059H17.0156C16.6816 14.2182 13.7637 17.0131 10.0459 17.0131Z" fill="white"/>
                                </svg>
                            </div> 
                            <span className='app-namex'>{lang.general}</span>
                        </div>

                        <div className={`settings-item ${modTheme ? 'light' : 'dark'} ${currentMenu == 'background' ? 'selected': ''}`} onClick={() => setPage('background')}>
                            <div className='setting-item-logo blue'>
                                 <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 30 30" fill="none">
                                    <rect width="30" height="30" rx="6" fill="#38ADDE"/>
                                    <path d="M14.5622 17.17C16.0025 17.17 17.1701 16.0025 17.1701 14.5621C17.1701 13.1218 16.0025 11.9541 14.5622 11.9541C13.1219 11.9541 11.9542 13.1218 11.9542 14.5621C11.9542 16.0025 13.1219 17.17 14.5622 17.17Z" stroke="white" stroke-miterlimit="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                    <path d="M15.4318 11.9545C15.4318 11.9545 16.3011 10.2159 16.3011 8.47727C16.3011 6.73864 14.5625 5 14.5625 5C14.5625 5 12.8239 6.73864 12.8239 8.47727C12.8239 10.2159 13.6932 11.9545 13.6932 11.9545" stroke="white" stroke-miterlimit="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                    <path d="M11.9545 13.6932C11.9545 13.6932 10.2159 12.8239 8.47727 12.8239C6.73864 12.8239 5 14.5625 5 14.5625C5 14.5625 6.73864 16.3011 8.47727 16.3011C10.2159 16.3011 11.9545 15.4318 11.9545 15.4318" stroke="white" stroke-miterlimit="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                    <path d="M15.4318 17.1705C15.4318 17.1705 16.3011 18.9091 16.3011 20.6477C16.3011 22.3864 14.5625 24.125 14.5625 24.125C14.5625 24.125 12.8239 22.3864 12.8239 20.6477C12.8239 18.9091 13.6932 17.1705 13.6932 17.1705" stroke="white" stroke-miterlimit="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                    <path d="M17.1705 13.6932C17.1705 13.6932 18.9091 12.8239 20.6477 12.8239C22.3864 12.8239 24.125 14.5625 24.125 14.5625C24.125 14.5625 22.3864 16.3011 20.6477 16.3011C18.9091 16.3011 17.1705 15.4318 17.1705 15.4318" stroke="white" stroke-miterlimit="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                    <path d="M13.3331 12.1039C13.3331 12.1039 12.7184 10.2598 11.489 9.03036C10.2596 7.80096 7.8008 7.80096 7.8008 7.80096C7.8008 7.80096 7.8008 10.2598 9.0302 11.4892C10.2596 12.7186 12.1037 13.3333 12.1037 13.3333" stroke="white" stroke-miterlimit="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                    <path d="M12.1037 15.7919C12.1037 15.7919 10.2596 16.4066 9.03016 17.636C7.80075 18.8654 7.80075 21.3242 7.80075 21.3242C7.80075 21.3242 10.2596 21.3242 11.489 20.0949C12.7184 18.8654 13.333 17.0213 13.333 17.0213" stroke="white" stroke-miterlimit="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                    <path d="M17.0214 15.7919C17.0214 15.7919 18.8655 16.4066 20.0948 17.636C21.3242 18.8654 21.3242 21.3242 21.3242 21.3242C21.3242 21.3242 18.8655 21.3242 17.6361 20.0949C16.4067 18.8654 15.792 17.0213 15.792 17.0213" stroke="white" stroke-miterlimit="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                    <path d="M15.7919 12.1039C15.7919 12.1039 16.4066 10.2598 17.636 9.03036C18.8654 7.80096 21.3242 7.80096 21.3242 7.80096C21.3242 7.80096 21.3242 10.2598 20.0948 11.4892C18.8654 12.7186 17.0213 13.3333 17.0213 13.3333" stroke="white" stroke-miterlimit="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                    <circle cx="14.5" cy="14.5" r="5" stroke="white"/>
                                    <circle cx="14.5" cy="14.5" r="10" stroke="white"/>
                                </svg>
                            </div> 
                            <span className='app-namex'>{lang.background}</span>
                        </div>

                        <div className={`settings-item ${modTheme ? 'light' : 'dark'} ${currentMenu == 'password' ? 'selected': ''}`} onClick={() => setPage('password')}>
                            <div className='setting-item-logo green'>
                                 <i className="fa-solid fa-lock"></i>
                            </div> 
                            <span className='app-namex'>{lang.passsec}</span>
                        </div>

                        <div className={`settings-item ${modTheme ? 'light' : 'dark'} ${currentMenu == 'theme' ? 'selected': ''}`} onClick={() => setPage('theme')}>
                            <div className='setting-item-logo blue'>
                                 <i className="fa-solid fa-sun"></i>
                            </div> 
                            <span className='app-namex'>{lang.dixbri}</span>
                        </div>
                    </div>
                </div>
            </div>

            <div className='settings-app-main-part'>
                {generalPage && (
                    <>
                        <div className={`settings-app-general-header ${modTheme ? 'light' : ''}`}>
                            <div style={{width: '3rem',height: '3rem', borderRadius: '.7rem', margin: '0'}} className='setting-item-logo gray'>
                                <svg xmlns="http://www.w3.org/2000/svg" width="60" height="30" viewBox="0 0 21 20" fill="none">
                                    <path d="M10.0547 18.5951C10.2656 18.5951 10.4678 18.5776 10.6875 18.56L11.1797 19.4916C11.2852 19.7289 11.5225 19.8432 11.7949 19.808C12.0498 19.7641 12.2256 19.5707 12.2607 19.3071L12.4102 18.2612C12.8232 18.1557 13.2275 17.9975 13.6143 17.8305L14.3877 18.5248C14.5723 18.7094 14.8271 18.7358 15.082 18.6039C15.3018 18.4721 15.3896 18.2348 15.3457 17.9711L15.126 16.9516C15.4688 16.7055 15.8027 16.433 16.1191 16.1342L17.0684 16.5297C17.3232 16.6352 17.5605 16.5737 17.7539 16.3539C17.9121 16.1694 17.9385 15.9057 17.7979 15.6772L17.2441 14.7895C17.4814 14.4467 17.6836 14.0688 17.8682 13.6733L18.9229 13.726C19.1777 13.7436 19.4062 13.5942 19.4941 13.3481C19.582 13.102 19.4941 12.8471 19.292 12.6889L18.4746 12.0385C18.5801 11.6342 18.6592 11.2123 18.6943 10.7729L19.6875 10.4565C19.9424 10.3686 20.1006 10.1664 20.1006 9.90276C20.1006 9.63909 19.9424 9.43694 19.6875 9.34905L18.6943 9.03264C18.6592 8.59319 18.5713 8.18011 18.4746 7.76702L19.292 7.11663C19.4941 6.96722 19.5732 6.72112 19.4941 6.47503C19.4062 6.22014 19.1777 6.07073 18.9229 6.08831L17.8682 6.12347C17.6836 5.73675 17.4814 5.36761 17.2441 5.01604L17.7979 4.11956C17.9297 3.90862 17.9121 3.64495 17.7539 3.46038C17.5605 3.24065 17.3232 3.17913 17.0684 3.2846L16.1104 3.67132C15.8027 3.38128 15.4688 3.10003 15.126 2.86272L15.3457 1.84319C15.3896 1.57073 15.3018 1.33343 15.0732 1.21038C14.8271 1.07854 14.5723 1.09612 14.3877 1.28948L13.6143 1.97503C13.2275 1.79925 12.8232 1.65862 12.4102 1.54436L12.2607 0.516043C12.2256 0.252371 12.0498 0.0590119 11.7949 0.00627753C11.5225 -0.0288787 11.2939 0.0853791 11.1797 0.305106L10.6875 1.24554C10.4678 1.22796 10.2656 1.21917 10.0547 1.21917C9.82617 1.21917 9.62402 1.22796 9.4043 1.24554L8.91211 0.305106C8.80664 0.0853791 8.56934 -0.0288787 8.29688 0.0150666C8.04199 0.0590119 7.86621 0.252371 7.83105 0.516043L7.68164 1.54436C7.27734 1.65862 6.87305 1.79925 6.47754 1.97503L5.71289 1.28948C5.51953 1.10491 5.26465 1.07854 5.01855 1.21038C4.79883 1.33343 4.70215 1.57073 4.74609 1.84319L4.96582 2.86272C4.62305 3.10003 4.28906 3.38128 3.98145 3.67132L3.02344 3.2846C2.77734 3.17913 2.53125 3.24065 2.34668 3.46038C2.17969 3.64495 2.16211 3.90862 2.29395 4.11956L2.85645 5.01604C2.61914 5.36761 2.41699 5.73675 2.22363 6.12347L1.17773 6.08831C0.914062 6.07073 0.685547 6.22014 0.606445 6.47503C0.518555 6.72112 0.588867 6.96722 0.799805 7.11663L1.62598 7.76702C1.52051 8.18011 1.43262 8.59319 1.40625 9.03264L0.413086 9.34905C0.149414 9.43694 0 9.6303 0 9.90276C0 10.1664 0.149414 10.3686 0.413086 10.4565L1.40625 10.7729C1.43262 11.2123 1.52051 11.6342 1.62598 12.0385L0.808594 12.6889C0.597656 12.8383 0.527344 13.0932 0.606445 13.3393C0.685547 13.5942 0.914062 13.7436 1.17773 13.726L2.22363 13.6733C2.4082 14.0688 2.61914 14.4467 2.85645 14.7895L2.29395 15.686C2.15332 15.9057 2.17969 16.1694 2.34668 16.3539C2.53125 16.5737 2.77734 16.6352 3.02344 16.5297L3.98145 16.1342C4.28906 16.433 4.62305 16.7055 4.96582 16.9516L4.74609 17.9711C4.70215 18.2348 4.79004 18.4721 5.01855 18.6039C5.26465 18.7358 5.51953 18.7094 5.71289 18.5248L6.47754 17.8305C6.87305 17.9975 7.26855 18.1557 7.68164 18.2699L7.83105 19.3071C7.86621 19.5707 8.04199 19.7641 8.30566 19.808C8.56934 19.8432 8.80664 19.7289 8.91211 19.5004L9.4043 18.56C9.62402 18.5776 9.82617 18.5951 10.0547 18.5951ZM12.3486 9.20843C11.918 8.07464 11.0391 7.4594 10.002 7.4594C9.85254 7.4594 9.69434 7.47698 9.42188 7.5385L7.04883 3.46038C7.9541 3.0385 8.96484 2.8012 10.0459 2.8012C13.7637 2.8012 16.6816 5.59612 17.0156 9.20843H12.3486ZM3.0498 9.91155C3.0498 7.55608 4.13086 5.49065 5.84473 4.19866L8.23535 8.28557C7.76953 8.79534 7.5498 9.35784 7.5498 9.93792C7.5498 10.4916 7.75195 11.019 8.23535 11.5551L5.77441 15.5717C4.10449 14.2797 3.0498 12.2319 3.0498 9.91155ZM8.94727 9.92913C8.94727 9.33147 9.44824 8.87444 10.0107 8.87444C10.5996 8.87444 11.083 9.33147 11.083 9.92913C11.083 10.5092 10.5996 10.9926 10.0107 10.9926C9.44824 10.9926 8.94727 10.5092 8.94727 9.92913ZM10.0459 17.0131C8.93848 17.0131 7.90137 16.767 6.97852 16.3188L9.41309 12.3285C9.67676 12.3813 9.85254 12.3989 10.002 12.3989C11.0479 12.3989 11.918 11.766 12.3486 10.6059H17.0156C16.6816 14.2182 13.7637 17.0131 10.0459 17.0131Z" fill="white"/>
                                </svg>
                            </div>
                            <span className='gen-title'>{lang.general}</span>
                            <span className='genx-span'>{lang.generalInfo}</span>
                        </div>

                        <div className={`settings-app-general-items ${modTheme ? 'light' : ''}`}>
                            <div onClick={() => setPage('about')} className='settings-app-general-item'>
                                <div className='settings-tabbar'>
                                    <i class="fa-solid fa-tablet-screen-button"></i>
                                </div>
                                <span className='op-name'>{lang.aboutDevice}</span>
                                <div className='right--x'>
                                    <i className="fa-solid fa-chevron-right"></i>
                                </div>
                                <div className='settings-bottom'></div>
                            </div>
                            <div onClick={() => CheckVersion()} className='settings-app-general-item'>
                                <div className='settings-tabbar'>
                                    <i className="fa-solid fa-cloud-arrow-up"></i>
                                </div>
                                <span className='op-name'>{lang.softwareupdate}</span>
                                <div className='right--x'>
                                    <i className="fa-solid fa-chevron-right"></i>
                                </div>
                                <div className='settings-bottom'></div>
                            </div>
                            <div className='settings-app-general-item'>
                                <div className='settings-tabbar white'>
                                    <i className="fa-brands fa-creative-commons-share"></i>
                                </div>
                                <span className='op-name'>{lang.airdrop}</span>
                                <div className='right--x'>
                                    <i className="fa-solid fa-chevron-right"></i>
                                </div>
                            </div>
                        </div>

                        <div className={`settings-app-general-items ${modTheme ? 'light' : ''}`} style={{height: '3rem'}}>
                            <div className='settings-app-general-item'>
                                <div className='settings-tabbar gray'>
                                    <i className="fa-solid fa-person-walking-luggage"></i>
                                </div>
                                <span className='op-name'>{lang.useTabletWhileWalking}</span>
                                <div style={{top: '.9rem', right: '1rem'}} className='right--x'>
                                    <label className="plane-toggle">
                                        <input onChange={() => handleToggle("walkanduse")}  type="checkbox" />
                                        <span className="plane-slider"></span>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div onClick={() => setResetModal(true)} className={`settings-app-general-items ${modTheme ? 'light' : ''}`} style={{height: '3rem'}}>
                            <div className='settings-app-general-item'>
                                <div className='settings-tabbar gray'>
                                    <i className="fa-solid fa-rotate-right"></i>
                                </div>
                                <span className='op-name'>{lang.resetpad}</span>
                                <div className='right--x'>
                                    <i className="fa-solid fa-chevron-right"></i>
                                </div>
                            </div>
                        </div>
                    </>
                )}

                {showTabletInfo && (
                    <AboutDeviceScreen 
                        themeMode={themeMode} 
                        lang={lang} 
                        allLang={allLang} 
                        tabData={tabData} 
                        Notification={Notification}
                    ></AboutDeviceScreen>
                )}

                {backPage && (
                    <WallpaperPage
                        theme={tabletTheme}
                        themeMode={themeMode} 
                        setNewTheme={setNewTheme} 
                        background={background} 
                        setTabletBg={setBackground} 
                        allBackgrounds={allBackgrounds} 
                        lang={lang}
                        job={job}
                        Notification={Notification}
                    ></WallpaperPage>
                )}

                <ColdModal
                    appName="SmartPad"
                    title={lang.version}
                    message={lang.latestver}
                    isOpen={showModa}
                    onClose={() => setShowModa(false)}
                    buttons={[
                        { label: lang.ok, onClick: () => setShowModa(false) }
                    ]}
                />

                <ColdModal
                    appName="SmartPad"
                    title={lang.respad}
                    message={lang.willbelost}
                    isOpen={resetModal}
                    onClose={() => setResetModal(false)}
                    buttons={[
                        { label: lang.cancel, onClick: () => setResetModal(false) },
                        { label: lang.reset, onClick: () => resetAllData() }
                    ]}
                />

                {passScreen && 
                    <PasswordX 
                        isOpened={passScreen} 
                        lang={lang} 
                        tabData={tabData} 
                        theme={tabletTheme}>
                    </PasswordX>
                }

                {themePart && 
                    <DisplayPart
                        bright={bright}
                        setBright={setBright}
                        theme={modTheme}
                        dataX={settings}
                        themeMode={themeMode} 
                        setData={handleToggle}
                        setNewTheme={setNewTheme} 
                        background={background} 
                        setTabletBg={setBackground} 
                        allBackgrounds={allBackgrounds} 
                        lang={lang}
                        job={job}
                        Notification={Notification}></DisplayPart>
                }
            </div>
        </div>
    )
}

export default SettingsApp;