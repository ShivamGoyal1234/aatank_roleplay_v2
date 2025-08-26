import React, { useState, useEffect, useRef } from "react";
import "./main.css";
import { useNui, callNui } from "../nui";
import {
    Stepper,
    StepperIndicator,
    StepperItem,
    StepperSeparator,
    StepperTrigger,
  } from "@/components/ui/stepper";
  
const steps = [1, 2, 3, 4, 5, 6];

const SetupScreen = ({ isOpened, onCloseV2, setLoading, Notification, keepMounted, style, lang, allLang, setLoginX, prefix, allmails}) => {
    const [langScreen, SetLangScreen] = useState(true); // İlk ekran dil seçimi olacak
    const [currentLang, setCurrentLang] = useState(lang || {}); // Seçilen dil objesi
    const [wifiPart, WifiScreen] = useState(false)
    const [chooseTheme, ChooseScreen] = useState(false) // Tema seçimi dil seçiminden sonra
    const [selectedTheme, setSelectedTheme] = useState("light");
    const [passwordScreen, setPasswordScreen] = useState(false); 
    const [faceidscreen, faceIdScreen] = useState(false);
    const [createPasswordScreen, SetCreatePasswordSc] = useState(false);
    const [securityPart, setSecurityPart] = useState(false);
    const [tabletNamePart, setTabletNameScreen] = useState(false);
    const [passcode, setPasscode] = useState("");
    const [allMails, setAllMails] = useState([]);
    const [welcomeScreen, setWelcomeScreen] = useState(false);
    const containerRef = useRef(null);
    const [tabletNameValue, setTabletNameValue] = useState('');
    const [registeredTablets, setRegisteredTablets] = useState([]);
    const [selectedTablet, onSelectTablet] = useState(null);
    const [showTabletList, setShowTabletList] = useState(false);
    const [isMailInUse, setIsMailInUse] = useState(false);
    const [icloudScreen, setIcloudScreen] = useState(false);
    const [icloudSignIn, setIcloudSignIn] = useState(false);
    const [icloudCreateAccount, setIcloudCreateAccount] = useState(false);
    const [icloudData, setIcloudData] = useState({
        email: '',
        password: '',
        firstName: '',
        lastName: '',
        emailPrefix: '',
        emailPrefixChanged: false,
        birthDate: '',
        confirmPassword: ''
    });

    useEffect(() => {
        if (!isOpened) {
            SetLangScreen(true)
            WifiScreen(false)
            ChooseScreen(false)
            faceIdScreen(false)
            setPasswordScreen(false)
            SetCreatePasswordSc(false)
            setSecurityPart(false)
            setTabletNameScreen(false)
            setWelcomeScreen(false)
            setIcloudScreen(false)
            setIcloudSignIn(false)
            setIcloudCreateAccount(false)
            setShowTabletList(false)
            onSelectTablet(null)
            setIsMailInUse(false)
            setIcloudData({
                email: '',
                password: '',
                firstName: '',
                lastName: '',
                emailPrefix: '',
                emailPrefixChanged: false,
                birthDate: '',
                confirmPassword: ''
            })
        }
    }, [isOpened])


    const [showPassword, setShowPassword] = useState(false);
    const [isCreatingAccount, setIsCreatingAccount] = useState(false);
    
    const [settings, setSettings] = useState({
        language: 'en',
        region: 'US',
        wifi: null,
        privacy: false,
        icloudAccount: null
    });

    const notificationRef = useRef(Notification);
    useEffect(() => {
        notificationRef.current = Notification;
    }, [Notification]);

    // Dil seçimi fonksiyonu
    const selectLanguage = (langTag) => {
        setSettings(prev => ({ ...prev, language: langTag }));
        
        // Client'e seçilen dili gönder ve yeni dil paketini al
        callNui('selectLanguage', { language: langTag }, (response) => {
            if (response && response.langData) {
                setCurrentLang(response.langData);
                handleSettingChange('language');
            }
        });
    }

    const updateTabletNamePart = (e) => {
        setTabletNameValue(e.target.value);
    }

    useEffect(() => {
        setAllMails(allmails);
    }, [allMails])

    useEffect(() => {
        if (!icloudCreateAccount) return;
        const checkMail = `${icloudData.emailPrefix}@${prefix}`;
        setIsMailInUse(allMails.some(x => x.mail === checkMail));
    }, [icloudData.emailPrefix, allMails, prefix, icloudCreateAccount]);


    const handleIcloudInput = (field, value) => {
        let updated;
        setIcloudData(prev => {
            updated = { ...prev, [field]: value };

            if ((field === 'firstName' || field === 'lastName') && !prev.emailPrefixChanged) {
                const first = field === 'firstName' ? value : updated.firstName;
                const last = field === 'lastName' ? value : updated.lastName;
                updated.emailPrefix = `${first.toLowerCase()}.${last.toLowerCase()}`;
            }

            if (field === 'emailPrefix') {
                updated.emailPrefixChanged = true;
            }
            return updated;
        });

        // emailPrefix değişince hemen kontrol et
        if (field === 'emailPrefix') {
            const checkMail = `${value}@${prefix}`;
            setIsMailInUse(allMails.some(x => x.mail === checkMail));
        }
        // firstName ve lastName değişince de kontrol et, otomatik prefix güncelliyorsa:
        if ((field === 'firstName' || field === 'lastName')) {
            let autoPrefix = field === 'firstName'
                ? `${value.toLowerCase()}.${icloudData.lastName.toLowerCase()}`
                : `${icloudData.firstName.toLowerCase()}.${value.toLowerCase()}`;
            const checkMail = `${autoPrefix}@${prefix}`;
            setIsMailInUse(allMails.some(x => x.mail === checkMail));
        }
    };


    const validateEmail = (email) => {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }
    
    const handleIcloudSignIn = async () => {
        if (!icloudData.email || !icloudData.password) {
            Notification(currentLang.invalid || 'Invalid', currentLang.fillAllFields || 'Please fill all fields');
            return;
        }

        if (!validateEmail(icloudData.email)) {
            Notification(currentLang.invalid || 'Invalid', currentLang.invalidEmail || 'Please enter a valid email');
            return;
        }

        callNui('checkAccount', {
            email: icloudData.email,
            password: icloudData.password
        }, (response) => {
            if (!response) {
                Notification(currentLang.invalid || 'Invalid', currentLang.invalidLogin || 'Email or password is incorrect');
                return;
            }

            if (response.export && response.data.length > 0) {
                setRegisteredTablets(response.data);
                setShowTabletList(true);
            } else {
                proceedWithPasswordCreation();
            }
        });
    };

    const proceedWithPasswordCreation = () => {
        setSettings(prev => ({ ...prev, icloudAccount: icloudData.email }));
        setIcloudSignIn(false);
        handleSettingChange('password');
    };
    
    const TabletListModal = ({ tablets, onClose, onContinue, onAddNewTablet, lang }) => {
        const [selectedSerial, setSelectedSerial] = useState(null);

        const handleTabletClick = (serial) => {
            setSelectedSerial(serial);
        };

        const handleAddNewTablet = () => {
            setSelectedSerial("new");
            onAddNewTablet();
        };

        return (
            <div className="icloud-tablet-list-modal">
                <div className="icloud-modal-content">
                    <div className="icloud-modal-header">
                        <h3>{lang.registeredTablets || 'Registered Tablets'}</h3>
                    </div>
                    <div className="icloud-registered-tablets-container">
                        {tablets.map((tablet, index) => (
                            <div
                                key={index}
                                className={`icloud-tablet-item ${selectedSerial === tablet.serial ? 'selected' : ''}`}
                                onClick={() => handleTabletClick(tablet.serial)}
                            >
                                <div className="icloud-tablet-device-name">{tablet.tabname}</div>
                                <div className="icloud-tablet-serial-number">{tablet.serial}</div>
                            </div>
                        ))}
                        <div
                            className={`icloud-tablet-item add-new ${selectedSerial === 'new' ? 'selected' : ''}`}
                            onClick={handleAddNewTablet}
                        >
                            <span className="icloud-tablet-add-icon">+</span>
                            <span className="icloud-tablet-add-text">{lang.addNewTablet || "Add New Tablet"}</span>
                        </div>
                    </div>
                    <div className="icloud-modal-action-buttons">
                        <button className="icloud-modal-cancel-btn" onClick={onClose}>
                            {lang.cancel || 'Cancel'}
                        </button>
                        <button className="icloud-modal-continue-btn" onClick={onContinue}>
                            {lang.continue || 'Continue'}
                        </button>
                    </div>
                </div>
            </div>
        );
    };


    const handleIcloudCreate = () => {
        const fullEmail = `${icloudData.emailPrefix}@${prefix}`;

        if (!icloudData.emailPrefix || !icloudData.password || !icloudData.confirmPassword || 
            !icloudData.firstName || !icloudData.lastName || !icloudData.birthDate) {
            Notification(currentLang.invalid || 'Invalid', currentLang.fillAllFields || 'Please fill all fields');
            return;
        }

        if (!validateEmail(fullEmail)) {
            Notification(currentLang.invalid || 'Invalid', currentLang.invalidEmail || 'Please enter a valid email');
            return;
        }

        if (icloudData.password !== icloudData.confirmPassword) {
            Notification(currentLang.invalid || 'Invalid', currentLang.passwordMismatch || 'Passwords do not match');
            return;
        }

        if (icloudData.password.length < 8) {
            Notification(currentLang.invalid || 'Invalid', currentLang.passwordTooShort || 'Password must be at least 8 characters');
            return;
        }

        setIsCreatingAccount(true);
        
        setTimeout(() => {
            setSettings(prev => ({ ...prev, icloudAccount: fullEmail }));
            setIcloudCreateAccount(false);
            setIsCreatingAccount(false);
            handleSettingChange('password');
        }, 2000);
    };

    
    const handleSettingChange = (key) => {
        switch(key){
            case "language":
                SetLangScreen(false);
                ChooseScreen(true);
                break; 
            case "icloud":
                ChooseScreen(false);
                setIcloudScreen(true);
                break;
            case "icloud-signin":
                setIcloudScreen(false);
                setIcloudSignIn(true);
                break;
            case "icloud-create":
                setIcloudScreen(false);
                setIcloudCreateAccount(true);
                break;
            case "skip-icloud":
                setIcloudScreen(false);
                handleSettingChange('password');
                break;
            case "password":
                setIcloudScreen(false);
                setIcloudSignIn(false);
                setIcloudCreateAccount(false);
                ChooseScreen(false);
                setTabletNameScreen(false);
                // Face ID ekranını atla, direkt PIN kodu oluşturma ekranına geç
                setPasswordScreen(false);
                SetCreatePasswordSc(true);
                break;
            case "faceid":
                setTabletNameScreen(false);
                setPasswordScreen(false);
                faceIdScreen(true);
                break;
            case "cancel-faceid":
                faceIdScreen(false);
                setPasswordScreen(true);
                break;
            case "pincode":
                setPasswordScreen(false);
                ChooseScreen(false);
                SetCreatePasswordSc(true);
                break;
            case 'welcomeScreen':
                if (!secQuest.trim() || !secAnswer.trim()) {
                    Notification(currentLang.invalid, currentLang.fillAllFields)
                } else {
                    setSecurityPart(false)
                    setWelcomeScreen(true)
                }
                break;
            case 'securityPart':
                setTabletNameScreen(false)
                setSecurityPart(true)
                break
            case "finish":
                setWelcomeScreen(false);
                onCloseV2(false);
                setLoading(true);
                setLoginX(true);
                callNui('saveNewTablet', {
                    lang: settings.language,
                    passcode: passcode,
                    theme: selectedTheme,
                    deviceName: tabletNameValue,
                    securityQuest: secQuest,
                    secAnswer: secAnswer,
                    selectedtab: selectedTablet,
                    icloudAccount: settings.icloudAccount,
                    icloudData: icloudData
                })
                break;
            case "giveTabletName":
                setPasswordScreen(false);
                SetCreatePasswordSc(false);
                setTabletNameScreen(true);
                break;
            default: break;
        }
    };

    useEffect(()=>{
        const handleKeyDown=e=>{
          if(!isNaN(e.key)&&e.key!==" " && createPasswordScreen){
            setPasscode(prev=>{
              if(prev.length<6){
                const next=prev+e.key
                if(next.length===6)handleSettingChange('giveTabletName')
                return next
              }
              return prev
            })
          }else if(e.key==="Backspace" && createPasswordScreen){
            setPasscode(prev=>prev.slice(0,-1))
          }
        }
        window.addEventListener("keydown",handleKeyDown)
        return()=>window.removeEventListener("keydown",handleKeyDown)
      },[createPasswordScreen])

    const handleThemeChange = (theme) => {
        setSelectedTheme(theme);
    };

    const [secQuest,setSecQuest]=useState('')
    const [secAnswer,setSecAnswer]=useState('');

    return (
        <div className={`setupscreen-frame ${isOpened ? "show" : "hide"}`} style={{ display: isOpened ? "block" : "none" }}>
            <div className={`setupscreen-modal ${selectedTheme == 'dark' ? 'dark-mode' : ''}`}>
                {langScreen && (<>
                    <div className='select-lang-part'>
                        <i style={{fontSize: '4rem'}} className="fa-solid fa-globe"></i>
                    </div>
                    <div className="language-list">
                        {Object.entries(allLang).map(([tag, lang]) => (
                            <div key={tag} onClick={() => selectLanguage(tag)} className="language-list-item">
                                <span className="language-list-item-text">{lang}</span>
                                <i className="language-list-item-icon fas fa-chevron-right"></i>
                            </div>
                        ))}
                    </div>
                </>)}

                {icloudScreen && (
                    <div className="icloud-main-screen minimal">
                        <div className="icloud-card">
                            <div className="icloud-minimal-icon">
                                <i className="fa-solid fa-circle-notch"></i>
                            </div>
                            <h1 className="icloud-minimal-title">
                                {currentLang.signInWithAppleId || 'Sign in with Apple ID'}
                            </h1>
                            <p className="icloud-minimal-desc">
                                {currentLang.icloudDescription || 'Sign in to access your photos, purchases, iCloud, and more.'}
                            </p>
                            <div className="icloud-minimal-buttons">
                                <button 
                                    className="minimal-btn primary"
                                    onClick={() => handleSettingChange('icloud-signin')}
                                >
                                    {currentLang.signIn || 'Sign In'}
                                </button>
                                <button 
                                    className="minimal-btn secondary"
                                    onClick={() => handleSettingChange('icloud-create')}
                                >
                                    {currentLang.createAppleId || 'Create Apple ID'}
                                </button>
                                {/* <button 
                                    className="minimal-btn ghost"
                                    onClick={() => handleSettingChange('skip-icloud')}
                                >
                                    {currentLang.setupLater || 'Set Up Later'}
                                </button> */}
                            </div>
                        </div>
                    </div>
                )}

                {icloudSignIn && (
                    <div className="icloud-card-container">
                        <div className="icloud-card">
                            <div className="apple-logo-gradient">
                                <div className="gradient-circle"></div>
                                <i style={{fontSize: '42px'}} className="fa-solid fa-circle-notch"></i>
                            </div>
                            <h1 className="icloud-card-title">
                                {currentLang.signInWithAppleId || 'Sign in with Apple ID'}
                            </h1>
                            <form className="icloud-card-form">
                                <input
                                    type="email"
                                    className="apple-input"
                                    placeholder={currentLang.appleId || 'Apple ID'}
                                    value={icloudData.email}
                                    onChange={(e) => handleIcloudInput('email', e.target.value)}
                                />
                                <div className="password-input-wrapper">
                                    <input
                                        type={showPassword ? "text" : "password"}
                                        className="apple-input"
                                        placeholder={currentLang.password || 'Password'}
                                        value={icloudData.password}
                                        onChange={(e) => handleIcloudInput('password', e.target.value)}
                                    />
                                    <button
                                        type="button"
                                        className="password-toggle-btn"
                                        onClick={() => setShowPassword(!showPassword)}
                                    >
                                        <i className={`fas fa-${showPassword ? 'eye-slash' : 'eye'}`}></i>
                                    </button>
                                </div>
                                <div className="keep-signed-in">
                                    <input type="checkbox" id="keepSignedIn" className="apple-checkbox" />
                                    <label htmlFor="keepSignedIn">{currentLang.keepSignedIn || 'Keep me signed in'}</label>
                                </div>
                                <a href="#" className="forgot-apple-id">
                                    {currentLang.forgotAppleId || 'Forgotten your Apple ID or password?'}
                                </a>
                                <button 
                                    type="button"
                                    className="apple-continue-btn"
                                    onClick={handleIcloudSignIn}
                                >
                                    <i className="fas fa-arrow-right"></i>
                                </button>
                            </form>
                            <div className="create-apple-id-link">
                                <span>{currentLang.dontHaveAppleId || "Don't have an Apple ID?"} </span>
                                <a href="#" onClick={() => {setIcloudSignIn(false); setIcloudCreateAccount(true);}}>
                                    {currentLang.createYours || 'Create yours now.'}
                                </a>
                            </div>
                        </div>
                    </div>
                )}

                {icloudCreateAccount && (
                    <div className="icloud-card-container">
                        <div className="icloud-card create-account">
                            <button 
                                className="apple-back-btn"
                                onClick={() => {setIcloudCreateAccount(false); setIcloudScreen(true);}}
                            >
                                <i className="fas fa-chevron-left"></i>
                                <span>{currentLang.back || 'Back'}</span>
                            </button>
                            
                            <h1 className="icloud-card-title">
                                {currentLang.createNewAppleId || 'Create a new Apple ID'}
                            </h1>
                            
                            <form className="icloud-create-form">
                                <div className="form-row">
                                    <input
                                        type="text"
                                        className="apple-input half"
                                        placeholder={currentLang.firstName || 'First Name'}
                                        value={icloudData.firstName}
                                        onChange={(e) => handleIcloudInput('firstName', e.target.value)}
                                    />
                                    <input
                                        type="text"
                                        className="apple-input half"
                                        placeholder={currentLang.lastName || 'Last Name'}
                                        value={icloudData.lastName}
                                        onChange={(e) => handleIcloudInput('lastName', e.target.value)}
                                    />
                                </div>
                                
                                <input
                                    type="text"
                                    className="apple-input"
                                    placeholder="mm/dd/yyyy"
                                    value={icloudData.birthDate}
                                    onChange={(e) => handleIcloudInput('birthDate', e.target.value)}
                                />
                                
                                <div className="form-divider"></div>
                                
                                <div className="email-input-wrapper">
                                    <input
                                        type="text"
                                        className="apple-input email-prefix"
                                        placeholder={currentLang.email || 'Email'}
                                        value={icloudData.emailPrefix}
                                        onChange={(e) => handleIcloudInput('emailPrefix', e.target.value)}
                                    />
                                    <span className="email-suffix">@{prefix}</span>
                                </div>
                                {isMailInUse && (
                                    <div style={{color: "red", fontSize: "0.9rem", marginTop: "2px"}}>
                                        {currentLang.mailInUse || "This email is already in use"}
                                    </div>
                                )}

                                
                                <div className="form-row">
                                    <input
                                        type="password"
                                        className="apple-input half"
                                        placeholder={currentLang.password || 'Password'}
                                        value={icloudData.password}
                                        onChange={(e) => handleIcloudInput('password', e.target.value)}
                                    />
                                    <input
                                        type="password"
                                        className="apple-input half"
                                        placeholder={currentLang.confirmPassword || 'Confirm'}
                                        value={icloudData.confirmPassword}
                                        onChange={(e) => handleIcloudInput('confirmPassword', e.target.value)}
                                    />
                                </div>
                                
                                <button 
                                    type="button"
                                    className="apple-create-btn"
                                    onClick={handleIcloudCreate}
                                    disabled={isCreatingAccount || isMailInUse}
                                >
                                    {isCreatingAccount ? 
                                        (currentLang.creating || 'Creating...') : 
                                        (currentLang.createAccount || 'Create Account')
                                    }
                                </button>
                            </form>
                        </div>
                    </div>
                )}

                {securityPart && (
                    <div className="security-part">
                        <div className="security-label">{currentLang.secpart}</div>
                        <p>{currentLang.infosec}</p>
                        <div className="ios-input-group">
                            <input
                                type="text"
                                placeholder={currentLang.secquestion}
                                value={secQuest}
                                onChange={e=>setSecQuest(e.target.value)}
                                className="sec-input"
                            />
                            <input
                                type="text"
                                placeholder={currentLang.secanswer}
                                value={secAnswer}
                                onChange={e=>setSecAnswer(e.target.value)}
                                className="sec-input"
                            />
                        </div>
                        <button
                            disabled={!secQuest||!secAnswer}
                            onClick={()=>handleSettingChange('welcomeScreen')}
                            className="next-btn"
                        >
                            {currentLang.nextStep}
                        </button>
                    </div>
                )}

                {wifiPart && (<>
                    <div className="wifi-selection">
                        <div className="header">
                            <i className="fas fa-chevron-left back-icon"></i>
                            <span>{currentLang.back}</span>
                        </div>
                        <h1 className="title"><i className="fa-sharp fa-regular fa-wifi"></i></h1>
                        <div className="wifilist">
                            <div className="wifi-item">
                            <span>WiFi</span>
                            <i className="fas fa-wifi wifi-icon"></i>
                            </div>
                            <div className="wifi-item link">
                            <span>{currentLang.choseAnotherNetwork}</span>
                            </div>
                        </div>
                    </div>
                </>)}

                {tabletNamePart && <>
                    <div className="theme-selection-container">
                        <div className="theme-selection-header">
                            <span className={`theme-selection-text ${selectedTheme === 'dark' ? 'dark-mode-st' : ''}`}>{currentLang.customizeTablet}</span>
                            <p className="theme-selection-paragraph">
                                {currentLang.giveTabletName}
                            </p>
                        </div>
                        <div className='tablet-name-givepart'>
                            <input className={`theme-selection-text ${selectedTheme === 'dark' ? 'dark-mode-input' : ''}`} placeholder={currentLang.giveTabletName || "Give Tablet Name"} value={tabletNameValue} onChange={(e) => updateTabletNamePart(e)}></input>
                        </div>
                        <button onClick={() => handleSettingChange('securityPart')} className="continue-button">{currentLang.continue}</button>
                    </div>
                </>}

                {showTabletList && (
                    <TabletListModal 
                        tablets={registeredTablets}
                        lang={currentLang}
                        onClose={() => setShowTabletList(false)}
                        onAddNewTablet={() => setSelectedTablet('new')}
                        onContinue={() => {
                            setShowTabletList(false);
                            proceedWithPasswordCreation();
                        }}
                    />
                )}

                {chooseTheme && (<>
                    <div className="theme-selection-container">
                        <div className="theme-selection-header">
                            <span className={`theme-selection-text ${selectedTheme === 'dark' ? 'dark-mode-st' : ''}`}>{currentLang.lightOrDisplay}</span>
                            <p className="theme-selection-paragraph">
                                {currentLang.choselight}
                            </p>
                        </div>
                        <div className="theme-options">
                            <div
                            className={`theme-option ${selectedTheme === "light" ? "selected6" : ""}`}
                            onClick={() => handleThemeChange("light")}
                            >
                            <div className="theme-preview light"></div>
                            <span className={`theme-label ${selectedTheme === 'dark' ? 'dark-mode-st' : ''}`}>{currentLang.light}</span>
                            <input
                                type="radio"
                                name="theme"
                                value="light"
                                checked={selectedTheme === "light"}
                                readOnly
                            />
                            </div>
                            <div
                                className={`theme-option ${selectedTheme === "dark" ? "selected6" : ""}`}
                                onClick={() => handleThemeChange("dark")}
                            >
                            <div className="theme-preview dark"></div>
                            <span className={`theme-label ${selectedTheme === 'dark' ? 'dark-mode-st' : ''}`}>{currentLang.dark}</span>

                            <input
                                type="radio"
                                name="theme"
                                value="dark"
                                checked={selectedTheme === "dark"}
                                readOnly
                            />
                            </div>
                        </div>
                        <button onClick={() => handleSettingChange('icloud')} className="continue-button">{currentLang.continue}</button>
                    </div>
                </>)}

                {passwordScreen && (<>
                    <div className="faceid-screen">
                        <i 
                        style={{'fontSize': '3.5rem', 'paddingTop': '3.5rem', 'color': '#0a5cc2'}}
                        className="fa-duotone fa-solid fa-face-viewfinder"></i>
                        <span className={`faceid-text ${selectedTheme == 'dark' ? 'dark-mode-st' : ''}`}>{currentLang.faceIdd}</span>
                            <p>{currentLang.faceid}</p>
                        <div className="buttoncon prime" onClick={() => handleSettingChange('faceid')}>{currentLang.continue}</div>
                        <div className="buttoncon" onClick={() => handleSettingChange('pincode')}>{currentLang.setupLater}</div>
                    </div>
                </>)}

                {faceidscreen && (<>
                    <div className="faceid-container">
                        <h1 className="faceid-headerText">{currentLang.setupFaceId}</h1>
                        <div className="faceid-avatarContainer">
                            <img
                            src="https://encrypted-tbn0.gstatic.com./build?q=tbn:ANd9GcTZpOFpjuJ3nwUs2h2pK75HtzQfioB7dY1wyg&s"
                            alt="Avatar Placeholder"
                            className="faceid-avatar"
                            />
                        </div>
                        <p className="faceid-description">
                            {currentLang.faceidInfo}
                        </p>
                        <button onClick={() => handleSettingChange('cancel-faceid')} className="faceid-setupButton">{currentLang.cancel}</button>
                    </div>
                </>)}

                {createPasswordScreen && (<>
                    <div
                        className="passcode-container"
                        tabIndex="0"
                        ref={containerRef}
                        onClick={() => containerRef.current.focus()}
                        >
                        <h1 className={`passcode-headerText ${selectedTheme == 'dark' ? 'dark-mode-st' : ''}`}>{currentLang.createPasscode}</h1>
                        <p className="passcode-description">
                            {currentLang.passcodeEntry}
                        </p>
                        <div className="passcode-inputContainer">
                            {[...Array(6)].map((_, index) => (
                            <div
                                key={index}
                                className={`passcode-circle ${index < passcode.length ? "filled" : ""}`}
                            ></div>
                            ))}
                        </div>
                        <button className="passcode-backButton" onClick={() => setPasscode("")}>
                            {currentLang.back}
                        </button>
                    </div>
                </>)}

                {welcomeScreen && (<> 
                    <div className='welcomeScreen'>
                        <span className={`welcome-string ${selectedTheme == 'dark' ? 'dark-mode-st' : ''}`}>{currentLang.welcome}</span>
                        <span className="welcome-desc">{currentLang.yourTablet}</span>
                        <div onClick={() => handleSettingChange('finish')} className="open-tablet">{currentLang.finishSetup}</div>
                    </div>
                </>)}
            </div>
        </div>
    );
};

export default SetupScreen;