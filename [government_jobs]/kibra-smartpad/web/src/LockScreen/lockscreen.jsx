import React, { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion"
import "./lockscreen.css";
import LoadingCircle  from '../utils/loading';
import SplitText from "../utils/SplitText";
import ShinyText from "@/utils/ShinyText";
import { callNui } from "@/nui";

const LockScreen = ({newPad, StartSetupScreen, loading, setNewPad, data, lang, months, days, notifications, background, setLoginX, logined, Notification, batteryLevel}) => {
  const [notifysOpened, setOpened] = useState(false);
  const [password, setPassword] = useState("");
  const [error, setError] = useState(false);
  const [correctPassword, setCorrectPassword] = useState('nopass');
  const [setupTextShowed, setSetupText] = useState(false);
  const [time, setTime] = useState(new Date());
  const [color, setColor] = useState("rgb(237, 237, 237)");
  const [isUnlocked, setIsUnlocked] = useState(false);
  const [showForgot, setShowForgot] = useState(false)
  const [secInput, setSecInput] = useState("")
  const [secError, setSecError] = useState(false)
  const [allowReset, setAllowReset] = useState(false)
  const [newPass, setNewPass] = useState("")
  const [newPassConfirm, setNewPassConfirm] = useState("")
  const [passMatch, setPassMatch] = useState(false)
  const handleAnimationComplete = () => {
  };
  const passValid = /^\d{6}$/.test(newPass);

  const [tabletBackground, setBackground] = useState('');

  useEffect(() => {
    if(background){
      setBackground(background)
    } else {
      setBackground(background);
    }
  }, []);

  useEffect(() => {
    setPassMatch(newPass !== '' && newPass === newPassConfirm)
  }, [newPass, newPassConfirm])

  const formattedTime = `${time.getHours().toString().padStart(2, "0")}:${time
    .getMinutes()
    .toString()
    .padStart(2, "0")}`;

  useEffect(() => {
    if (!newPad) {
      if (data) {
        if(data.data.passcode == 'nopass'){
          setIsUnlocked(true);
          setLoginX(true);
        } else {
          setCorrectPassword(data.data.passcode);
        }
      } else {
        setCorrectPassword('allah');
      }
    }
  }, [newPad, data, isUnlocked, logined]); 

  const handleSecSubmit = () => {
    if (secInput === data.data.security.answer) setAllowReset(true)
    else {
      setSecError(true)
      setTimeout(() => setSecError(false), 300)
    }
  }

  -- Notification

  const handleResetSubmit = () => {
      setCorrectPassword(newPass);
      setShowForgot(false);
      callNui('UpdateTabletMainData', {
        datatype: 'passcode',
        result: newPass
    });
  }
    
  
  const formattedDate = `${days[time.getDay()]}, ${time.getDate()} ${
    months[time.getMonth()]
  } ${time.getFullYear()}`;

  useEffect(() => {
      const interval = setInterval(() => {
        setTime(new Date());
      }, 1000);
  
      return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    const interval = setInterval(() => {
      setColor(generateRandomGray());
    }, 400); // Her 1 saniyede bir renk değişir.

    return () => clearInterval(interval); // Temizleme işlemi
  }, []);

  const generateRandomGray = () => {
    const grayValue = Math.floor(Math.random() * 156) + 100; // 100-255 arası bir değer
    return `rgb(${grayValue}, ${grayValue}, ${grayValue})`;
  };

  const handlePasswordSubmit = () => {
    if (parseInt(password) == correctPassword) {
      setError(false);
      setOpened(true);
      setLoginX(true);
      setIsUnlocked(true); // Kilidi aç
    } else {
      setError(true);
      setLoginX(false);
      setIsUnlocked(false); // Yanlış şifre girildiğinde kilidi kapalı tut
      setTimeout(() => setError(false), 300);
    }
  };
  

  return (
    <>
   <div
  className="tablet-frame-lockscreen"
  style={{
   position: 'absolute',
top: '0px',
left: '0px',
width: '100%',
height: '100%',
backgroundImage: `url("/web/build/${tabletBackground}-background.jpg")`,
backgroundSize: '100% 100%',
backgroundRepeat: 'no-repeat',
backgroundPosition: 'center center',
borderRadius: '28px',
userSelect: 'none',
zIndex: '1'
  }}
>


      {!newPad && !loading && (<>
        <div className="lockscreen-info">
          <div className="lockscreen-time">{formattedTime}</div>
          <div className="lockscreen-date">{formattedDate}</div>
        </div>
        <div className="lock-icon">
          {isUnlocked ? (
            <i className="fas fa-unlock"></i> 
          ) : (
            <i className="fas fa-lock"></i> 
          )}
        </div>


        {!logined && (
          <>
            <div className="login-container">
              <div className="avatar-container">
              <img
                src={`/web/pimg/${data.owner}.png`}
                onError={(e) => {
                  e.currentTarget.onerror = null;
                  e.currentTarget.src = '/web/pimg/avatar.png';
                }}
                className="user-avatar"
              />

              </div>
              {/* <div className="username">Ahmet Hakan</div>  */}
              <div className="username">{data.data.ownername}</div> 
              <div className="password-container">
                <div className="password-input-wrapper">
                  <input
                    type="password"
                    className={`password-input ${error ? "shake" : ""}`}
                    placeholder={lang.enterYourPass}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                  />
                  <button className="password-submit" onClick={handlePasswordSubmit}>
                    <i className="fa-solid fa-arrow-right"></i>
                  </button>
                </div>
                <span onClick={() => setShowForgot(true)} className='forgot'>Forgot Password</span>
              </div>
            </div>
           </>
        )}

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

        {notifysOpened && (
          <div className="notification-container">
            {notifications.map((data) => {
              <div className="notification">
                <div className="notification-icon">
                  <img src={`/web/build/appicons/${data.apphash}`} alt="App Icon" />
                </div>
                <div className="notification-content">
                  <div className="notification-title">{data.appname}</div>
                  <div className="notification-body">
                    {data.text}
                  </div>
                </div>
              </div>
            })}
          </div>
        )}

        <AnimatePresence>
          {showForgot && (
            <motion.div className="modal-backdrop2" initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}>
              <motion.div className="modal-frame2" initial={{ scale: 0.8 }} animate={{ scale: 1 }} exit={{ scale: 0.8 }} transition={{ duration: 0.3 }}>
                <div onClick={() => setShowForgot(false)} className='delete-x'><i className="fa-solid fa-xmark"></i></div>
                {!allowReset ? (
                  <div className="modal-content2">
                    <div className="modal-title2">{lang.secqu}</div>
                    <span className='helal'><strong>{lang.question}: </strong>{data.data.security.question}</span>
                    <input type="text" placeholder={lang.secanswer} className={`sec-input ${secError ? "shake" : ""}`} value={secInput} onChange={e => setSecInput(e.target.value)} />
                    <button disabled={!secInput} onClick={handleSecSubmit}>{lang.submit}</button>
                  </div>
                ) : (
                  <div className="modal-content2">
                    <input type="password" placeholder={lang.newPass} value={newPass} onChange={e => setNewPass(e.target.value)} />
                    <input type="password" placeholder={lang.confirmPass} value={newPassConfirm} onChange={e => setNewPassConfirm(e.target.value)} />
                    {/* {newPass && newPassConfirm && (!passMatch ? <span className="shake2">{lang.noMatch}</span> : <span>{lang.match}</span>)} */}
                    <button disabled={!(passMatch && passValid)} onClick={handleResetSubmit}>{lang.confirm}</button>
                  </div>
                )}
              </motion.div>
            </motion.div>
          )}
        </AnimatePresence>
      </>)}

      {newPad && (<>
        <div  onClick={() => {
  setNewPad(false);
  if (newPad) StartSetupScreen();
}}
className="newpadscreen-frame">
            <div 
            onMouseEnter={() => setSetupText(true)}
            onMouseLeave={() => setSetupText(false)} 
            style={{
              color: color, // Dinamik renk değişimini korur (şimdilik şeffaf olduğundan etkili değil)
              WebkitTextStrokeColor: color, // Dinamik olarak stroke rengini değiştirir
              transition: "color 0.5s ease, -webkit-text-stroke-color 0.5s ease",
            }}
            className='newpadscreen-frame-text'>
           <SplitText
              text={lang.hello}
              className="text-2xl font-semibold text-center"
              delay={150}
              animationFrom={{ opacity: 0, transform: 'translate3d(0,50px,0)' }}
              animationTo={{ opacity: 1, transform: 'translate3d(0,0,0)' }}
              easing="easeOutCubic"
              threshold={0.2}
              rootMargin="-50px"
              onLetterAnimationComplete={handleAnimationComplete}
            />
            </div>
            {setupTextShowed && (
              <div
               
                className="newpadscreen-setuptext"
              >
                <ShinyText text={lang.setupYourTablet} disabled={false} speed={3} className='custom-class' />
                
              </div>
            )}
        </div>
      </>)}

      {loading && <div className="loading-container"><LoadingCircle /></div>}
    </div>
    </>
  );
};

export default LockScreen;
