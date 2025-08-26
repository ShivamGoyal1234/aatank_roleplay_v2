import React, {useEffect, useState, useRef} from 'react';
import './main.css';
import { motion, AnimatePresence } from 'framer-motion';
import { callNui } from '../../nui';

const PasswordX = ({isOpened, lang, tabData, theme}) => {
    const [passEntered, setPassEntered] = useState(false);
    const [passcode, setPasscode] = useState('');
    const [shake, setShake] = useState(false);
    const [correctPassword, setPassword] = useState('Amına Kodumun Allahı');
    const containerRef = useRef(null);
    const [tabletHasPass, setHasPass] = useState(false);
    const [currentScreen, setCurrentScreen] = useState('main'); // 'main', 'changePassword', 'removePassword'

    const setCurrent = (screen) => {
        setCurrentScreen(screen);
        setPasscode('');
    }

    useEffect(() => {
        if (tabData.data.passcode !== 'nopass') {
            setHasPass(true);
            setPassword(tabData.data.passcode);
        } else {
            setHasPass(false);
        }
    }, [tabData.data.passcode]);    

    useEffect(() => {
        const handleKeyDown = (event) => {
            if (!isNaN(event.key) && event.key !== ' ') {
                setPasscode((prev) => {
                    if (prev.length < 6) {
                        const newPasscode = prev + event.key;                        
                        if (newPasscode.length === 6) {
                            if(currentScreen === 'main'){
                                if (Number(newPasscode) === Number(correctPassword)) {
                                    setPassEntered(true);
                                } else {
                                    setShake(true);
                                    setTimeout(() => {
                                        setShake(false);
                                        setPasscode('');
                                    }, 500);
                                }
                            } else if (currentScreen === 'removePassword'){
                                if(Number(newPasscode) === Number(correctPassword)) {
                                    setPassword('');
                                    setCurrent('main');
                                    setHasPass(false);
                                    setPassEntered(true);
                                    callNui('UpdateTabletMainData', {
                                        datatype: 'passcode',
                                        result: 'nopass'
                                    });
                                } else {
                                    setShake(true);
                                    setTimeout(() => {
                                        setShake(false);
                                        setPasscode('');
                                    }, 500);
                                }
                            } else if(currentScreen === 'changePassword'){
                                setPassword(newPasscode);
                                setCurrent('main');
                                setPassEntered(false);
                                callNui('UpdateTabletMainData', {
                                    datatype: 'passcode',
                                    result: newPasscode
                                });
                            } else if(currentScreen == 'createPassword'){
                                setPassword(newPasscode);
                                setCurrent('main');
                                setHasPass(true);
                                callNui('UpdateTabletMainData', {
                                    datatype: 'passcode',
                                    result: newPasscode
                                });
                            }
                        }
                        return newPasscode;
                    }
                    return prev; // Eğer zaten 6 haneye ulaştıysa, yeni karakter ekleme
                });
            } else if (event.key === 'Backspace') {
                setPasscode((prev) => prev.slice(0, -1));
            }
        };
    
        window.addEventListener('keydown', handleKeyDown);
        return () => {
            window.removeEventListener('keydown', handleKeyDown);
        };
    }, [correctPassword, currentScreen]); // passcode bağımlılıktan çıkarıldı
    
    
    

    useEffect(() => {
        if (containerRef.current) {
            containerRef.current.focus();
        }
    }, []);

    return (
    <div className={`password-screen-frame ${isOpened ? 'opened' : 'hidden'}`}>
        {!passEntered && tabletHasPass && (
            <div className={`password-enter-container ${theme == 'dark' ? 'dark' : ''}`}>
                <span className='enter-tablet-pass'>{lang.enterCurrentPass}</span>
                <span className='verify-info'>{lang.requireForYou}</span>
                <div className={`password-dots ${shake ? 'shake' : ''}`}>
                    {[...Array(6)].map((_, i) => (
                        <div key={i} className={`dot ${passcode.length > i ? 'filled' : ''}`}></div>
                    ))}
                </div>
            </div>
        )}

        {passEntered && tabletHasPass && (
            <motion.div 
                key="settings" 
                initial={{ opacity: 0, y: 20 }} 
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -20 }}
                className='password-settings'
            >
                <span className='password-label'>{lang.password}</span>
                <div className={`password-entry ${theme == 'dark' ? 'dark' : ''}`} onClick={() => setCurrent('changePassword')}>
                    <div style={{ float: 'left' }}>{lang.changePass}</div>
                    <div style={{ float: 'right' }}>
                        <i style={{ color: 'gray' }} className="fa-solid fa-chevron-right"></i>
                    </div>
                </div>
                <div className={`password-entry ${theme == 'dark' ? 'dark' : ''}`} style={{ height: '4rem' }} onClick={() => setCurrent('removePassword')}>
                    <div style={{ float: 'left', display: 'flex', flexDirection: 'column' }}>{lang.removePass} <span style={{ fontWeight: '500' }}>{lang.notRecom}</span></div>
                    <div style={{ float: 'right', padding: '24px' }}>
                        <i style={{ color: 'gray' }} className="fa-solid fa-chevron-right"></i>
                    </div>
                </div>
            </motion.div>
        )}

        {!tabletHasPass && (
            <motion.div 
                key="settings" 
                initial={{ opacity: 0, y: 20 }} 
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -20 }}
                className='password-settings'
            >
                <span className='password-label'>{lang.password}</span>
                <div className={`password-entry ${theme == 'dark' ? 'dark' : ''}`} onClick={() => setCurrent('createPassword')}>
                    <div style={{ float: 'left' }}>{lang.createPass}</div>
                    <div style={{ float: 'right' }}>
                        <i style={{ color: 'gray' }} className="fa-solid fa-chevron-right"></i>
                    </div>
                </div>
               
            </motion.div>
        )}
        
        <AnimatePresence>
            {currentScreen === 'changePassword' && (
                <motion.div 
                    key="change-password"
                    initial={{ opacity: 0, y: 20 }} 
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -20 }}
                    className={`password-enter-container ${theme == 'dark' ? 'dark' : ''}`}
                >
                    <span className='enter-tablet-pass'>{lang.enterNewPass}</span>
                    <div className={`password-dots ${shake ? 'shake' : ''}`}>
                        {[...Array(6)].map((_, i) => (
                            <div key={i} className={`dot ${passcode.length > i ? 'filled' : ''}`}></div>
                        ))}
                    </div>
                    <button className='passiptal' onClick={() => setCurrent('main')}>{lang.cancel}</button>
                </motion.div>
            )}
            {currentScreen === 'removePassword' && (
                <motion.div 
                    key="remove-password"
                    initial={{ opacity: 0, y: 20 }} 
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -20 }}
                    className={`password-enter-container ${theme == 'dark' ? 'dark' : ''}`}
                >
                    <span className='enter-tablet-pass'>{lang.confirmPass}</span>
                    <div className={`password-dots ${shake ? 'shake' : ''}`}>
                        {[...Array(6)].map((_, i) => (
                            <div key={i} className={`dot ${passcode.length > i ? 'filled' : ''}`}></div>
                        ))}
                    </div>
                    <button className='passiptal' onClick={() => setCurrentScreen('main')}>{lang.cancel}</button>
                </motion.div>
            )}
            {currentScreen === 'createPassword' && (
                <motion.div 
                    key="create-password"
                    initial={{ opacity: 0, y: 20 }} 
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -20 }}
                    className={`password-enter-container ${theme == 'dark' ? 'dark' : ''}`}
                >
                    <span className='enter-tablet-pass'>{lang.createNewPass}</span>
                    <div className={`password-dots ${shake ? 'shake' : ''}`}>
                        {[...Array(6)].map((_, i) => (
                            <div key={i} className={`dot ${passcode.length > i ? 'filled' : ''}`}></div>
                        ))}
                    </div>
                    <button className='passiptal' onClick={() => setCurrentScreen('main')}>{lang.cancel}</button>
                </motion.div>
            )}
        </AnimatePresence>
    </div>)
}

export default PasswordX;