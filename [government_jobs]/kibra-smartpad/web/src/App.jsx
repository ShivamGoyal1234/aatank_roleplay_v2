import { useEffect, useState, createContext, useCallback, useRef } from 'react';
import './App.css';
import { motion, AnimatePresence, useDragControls } from "framer-motion";
import { Convert } from "./utils/pedshot";
import LockScreen from "./LockScreen/lockscreen";
import SetupScreen from "./SetupScreen/main";
import MainScreenX from "./MainScreen/main";
import MdtAppX from './MdtApp/main';
import CreatingHersey from './creatingEverythink/main';
import SettingsApp from './SettingsApp/main';
import { useNui, callNui } from "./nui";
import NotificationModal from "./alertNotification/main";
import CameraApp from './CameraApp/main';
import GalleryApp from './GalleryApp/main';
import Notification from './Notification/main';
import NoteApp from './NoteApp/main';
import GunLicenseCard from './gunLicense/main';
import EmsApp from './EmsApp/main';
import NewGallery from './NewGallery/main';
import BillingApp from './BillingApp/main';
import MailApp from './MailApp/main';
import ColdModal from './SettingsApp/coldModal/main';
import CalculatorApp from './CalculatorApp/main';
import MapApp from './MapApp/main';
import BossDesk from './BossDesk/main';
import BatteryDeadScreen from './ChargeOver/main';
import DOJApp from './DojApp/main';
import WeazelNewsApp from './WeazelNews/main';
import HackerMinigame from './MinigameApp/main';
import SmartTabBrowser from './Browser/main';
import InsuranceApp from './InsuranceApp/main';

function App() {
  const [tabletVisible, setTabletVisible] = useState(false);  // düzelt
  const [lockScreenShow, SetLockScreen] = useState(true); // düzelt
  const [newPad, setNewPad] = useState(false);
  const [prefixMail, setPrefixMail] = useState('0resmon.com');
  const [mailAppX, setMailApp] = useState(false);
  const [setupScreen, setSetupScreen] = useState(false);
  const [openedNoteApp, setNoteApp] = useState(false);
  const [cameraOpened, setCameraOpen] = useState(false); // new;
  const [bossDeskApp, setBossDeskApp] = useState(false);
  const [minigame, setMiniGame] = useState(false);
  const [dojApp, setDojApp] = useState(false);
  const [galleryOpened, setGalleryOpen] = useState(false);
  const [MainScreen, setMainScreen] = useState(false);
  const [allMails, setAllMails] = useState([]);
  const [hackMode, setHackMode] = useState(false);
  const [invoiceBoss, setInvoiceBoss] = useState(false);
  const [currentWeatherData, setWeatherData] = useState([]);
  const [isPolice, setPolice] = useState(false);
  const [isDojApp, setDoj] = useState(false);
  const [MdtApp, setMdtApp] = useState(false);
  const [sentedMails, setSentedMails] = useState([]);
  const [tabletNews, setTabletNews] = useState([]);
  const [calApp, setCalApp] = useState(false);
  const [mapApp, setMapApp] = useState(false);
  const [tabletInvoices, setInvoices] = useState([]);
  const [browser, setBrowserApp] = useState(false);
  const [judMode, setJustMode] = useState('POLICE');
  const [isNews, setNewsApp] = useState(false);
  const [tabletLang, setTabletLang] = useState('en');
  const [applications, setApplications] = useState([]);
  const [mdtChatData, setMdtChatData] = useState([]);
  const [noteLimit, setNotLimit] = useState(0);
  const [isClosing, setIsClosing] = useState(false);
  const [billingApp, setBillingApp] = useState(false); // new
  const [courtRooms, setCourtRooms] = useState(false);
  const [loading, setLoading] = useState(false);
  const [time, setTime] = useState(new Date());
  const [housing, setHousing] = useState(false);
  const [bright, setBright] = useState(100);
  const [allNotes, setAllNotes] = useState([]);
  const [emsData, setEmsData] = useState([]);
  const [emsDispatches, setEmsDispatches] = useState(false); 
  const [mug, setMug] = useState('pimg/default.png')
  const [allDataMails, setAllDataMails] = useState([]);
  const [animate, setIsAnimating] = useState(false);
  const [allGallery, setGallery] = useState([]);
  const [startY, setStartY] = useState([]);
  const [allLang, setAllLang] = useState([]);
  const [days, setDays] = useState([]);
  const [tabMails, setTabMails] = useState([]);
  const [emsChatData, setEmsChatData] = useState([]);
  const [judgeCourts, setCourtJudges] = useState([]);
  const [months, setMonths] = useState([]);
  const [tabletData, setTabletData] = useState([]);
  const [isEmsApp, setEmsApp] = useState(false);
  const [tabletNotifications, setNotifys] = useState([]);
  const [settingsAppScreen, setSettingsApp] = useState(false);
  const [allBackgrounds, setAllBackgrounds] = useState([]);
  const [IsCreatingHersey, SetCreatingHersey] = useState(false);
  const [tabletBackground, setTabletBackground] = useState('city');
  const [tabletTheme, setThemeMode] = useState('light');
  const [tabletApps, setApps] = useState([]);
  const [isMdtLoaded, setIsMdtLoaded] = useState(false);
  const [dispatches, setDispatches] = useState([]);
  const [dbMails, setDatabaseMails] = useState([]);
  const [mdtMail, setMdtMail] = useState('');
  const [dojMail, setDojMail] = useState('');
  const [padress, setPadress] = useState('');
  const [insuranceApp, setInsuranceApp] = useState(false);
  const [insuranceData, setInsuranceData] = useState({});
  const [isMainScreenLoaded, setIsMainScreenLoaded] = useState(false);
  const [logined, setLogined] = useState(false);
  const [isSettingsLoaded, setIsSettingsLoaded] = useState(false);
  const [showModal, setShowModal] = useState(false);
  const [customDurum, setCustomDurum] = useState('');
  const [batteryLevel, setBatteryLevel] = useState(100);
  const batteryRef = useRef(batteryLevel);
  const [newBoss, setNewBoss] = useState(false);
  const [tabJob, setTabJob] = useState('');
  const [mdtCrimes, setMDTCrimes] = useState([]);
  const [mdtVehCrimes, setMDTVehCrimes] = useState([]);
  const [clientJobGrade, setJobGrade] = useState('');
  const [gunCardLang, setGunCardLang] = useState([]);
  const [settings, setSettings] = useState([]);
  const [notificationData, setNotificationData] = useState({
    message: '',
    title: '',
    options: []
  });
  const [batteryDrainInterval, setBatteryTime] = useState(60000);
  const [showGunCard, setGunCard] = useState(false);
  const [weaponLicenseData, setWeaponData] = useState([]);
  const [mdtData, setMdtData] = useState([])

  useEffect(() => {
  if (!tabletVisible || batteryLevel <= 0) return;

  const interval = setInterval(() => {
    setBatteryLevel(prev => Math.max(0, prev - 1));
  }, batteryDrainInterval);

  return () => clearInterval(interval);
  }, [tabletVisible, batteryDrainInterval, batteryLevel]);

  useEffect(() => {
    batteryRef.current = batteryLevel;
  }, [batteryLevel]);

  useEffect(() => {
    if (tabletVisible && batteryLevel <= 0) {
        setEmsApp(false);
        setNoteApp(false);
        setBrowserApp(false);
        setMiniGame(false);
        setNewsApp(false);
        setDojApp(false);
        setBossDeskApp(false);
        setMapApp(false);
        setCalApp(false);
        setMailApp(false);
        setCameraOpen(false);
        setBillingApp(false);
        setGalleryOpen(false);
        setSettingsApp(false);
        SetLockScreen(false);
        setMdtApp(false);
        setMainScreen(false);
        callNui('updateBatteryLevel', {});
    }
  }, [batteryLevel, tabletVisible]);

  useEffect(() => {
    if (batteryLevel <= 0) {
        setEmsApp(false);
        setNoteApp(false);
        setBrowserApp(false);
        setMiniGame(false);
        setNewsApp(false);
        setDojApp(false);
        setBossDeskApp(false);
        setMapApp(false);
        setCalApp(false);
        setMailApp(false);
        setCameraOpen(false);
        setBillingApp(false);
        setGalleryOpen(false);
        setSettingsApp(false);
        SetLockScreen(false);
        setMdtApp(false);
        setMainScreen(false);
    }
  }, []);

  useEffect(() => {
    if (MdtApp) {
      setTimeout(() => setIsMdtLoaded(true), 300); // 300ms bekleyerek yüklemeyi tamamlama hissi ver
    } else {
      setIsMdtLoaded(false);
    }
  
    if (MainScreen) {
      setTimeout(() => setIsMainScreenLoaded(true), 300);
    } else {
      setIsMainScreenLoaded(false);
    }
  
    if (settingsAppScreen) {
        setTimeout(() => setIsSettingsLoaded(true), 300);
      } else {
        setIsSettingsLoaded(false);
      }
    }, [MdtApp, MainScreen, settingsAppScreen]);

  const updateNotification = (newData) => {
    setNotificationData((prevData) => ({
      ...prevData,
      ...newData,
    }));
    setShowModal(true);
  };

  const NotificationX = useCallback((titleOrObj, msg) => {
    if (titleOrObj && typeof titleOrObj === 'object') {
      setNotificationData({
        title: titleOrObj.title || '',
        message: titleOrObj.message || '',
        options: titleOrObj.options || []
      });
    } else {
      setNotificationData({
        title: titleOrObj,
        message: msg,
        options: []
      });
    }
    setShowModal(true);
  }, []);

  const [clientTabletDefData, setDefDataFromLua] = useState([]);

  const apps = [
    { name: "Settings", icon: "/web/build/appicons/settings.png", appName: 'settings'},
    { name: "MDT", icon: "/web/build/appicons/mdt.png", appName: 'mdt'},
    { name: "Housing", icon: "/web/build/appicons/houseapp.png", appName: 'housing'},
    { name: "MyApartment", icon: "/web/build/appicons/myapartment.png", appName: 'apartment'},
    { name: "EMS", icon: "/web/build/appicons/ems.png", appName: 'ems'},
  ];
  

  const openSetupScreen = () => {
     if (!newPad) return;
    SetLockScreen(false);
    setLoading(true); 
    setTimeout(() => {
      setLoading(false); 
      setSetupScreen(true); 
    }, 400);
  };

  const updateLogined = (logined) => {
    setLogined((prev) => {
      if (prev === logined) return prev; 
      return logined;
    });
  };

  const hideSetupScreen = () => {
    setSetupScreen(false);
  };
  
  const showCreatingHersey = () => {
    SetCreatingHersey(true); 
    setTimeout(() => {
      SetCreatingHersey(false); 
      setMainScreen(true); // Başka modülü aç
    }, 5000);
  };

  const onExit = () => {
    SetLockScreen(true);  // Kilit ekranını göster
    setMainScreen(false); // Ana ekranı kapat
  };

  const handleTouchStart = (e) => {
    setStartY(e.touches[0]?.clientY); // Parmağın ilk dokunduğu Y koordinatını al
  };

  const handleTouchMove = (e) => {
    const currentY = e.touches[0]?.clientY;
    if (startY !== null && startY - currentY > 50) {
      handleHomeIndicatorAction(); // Kaydırma ile ana sayfaya dön
    }
  };
  
  const handleMouseMove = (e) => {
    if (startY !== null) {
      const currentY = e.clientY;
      if (startY - currentY > 50) {
        handleHomeIndicatorAction(); // Fare ile kaydırma sırasında ana sayfaya dön
      }
    }
  };
  
  const handleHomeIndicatorAction = () => {
    SetLockScreen(true);  // Kilit ekranına dön
    setSettingsApp(false);
    setEmsApp(false);
    setMapApp(false);
    setNoteApp(false);
    setBrowserApp(false);
    setMiniGame(false);
    setNewsApp(false);
    setDojApp(false);
    setBossDeskApp(false);
    setCalApp(false);
    setBillingApp(false);
    setMailApp(false);
    setMainScreen(false); // Ana ekranı kapat
    setMdtApp(false);     // MDT uygulamasını kapat
    SetCreatingHersey(false); // Her şey oluşturma modülünü kapat
    callNui('CloseCameraApp', {});
    if (window.MainRender) {
        window.MainRender.stop();
        window.isAnimated = false;
    }
    callNui('mapAppState', {state: false});
  };
  

  const handleTouchEnd = () => {
    setStartY(null); // Parmağı kaldırdığında başlangıç koordinatını sıfırla
  };

  const handleMouseDown = (e) => {
    setStartY(e.clientY); // Fare imlecinin Y koordinatını al
  };

  const handleMouseUp = () => {
    setStartY(null); 
  };


  useEffect(() => {
    useNui("updateallNote", (data) => {
      setAllNotes(data.data);
    });

    useNui("openMiniGame", (data) => {
      
    })

    useNui("updateCharge", (data) => {
      setBatteryLevel(data.batteryLevel);
    })

    useNui("updateBills", (data) => {
      setInvoices([...data.data].reverse());
    });

    useNui("updateMails", (data) => {
      setTabMails([...data.data].reverse());
      setSentedMails([...data.data2].reverse());
    });

    useNui("updateLang", (data) => {
      setTabletLang(data.data);
    });

    useNui("updateCrimeData", (data) => {
      setMDTCrimes(prev =>
        prev.map(crime =>
          crime.crime_id === data.id
            ? { ...crime, ...data.dataLand }
            : crime
        )
      );
    });

    useNui("addNewCourt", (data) => { 
      setCourtJudges(prev => 
        prev.map(crime => 
          crime.case_id === data.id
            ? { ...crime, ...data.dataa }
            : crime
        )
      );
    });

    useNui("openTablet", (data) => {
      setNewPad(data.newTablet);
      setBatteryTime(data.chargeDrainInterval);
      setTabletVisible(true);
      setTabletLang(data.lang);
      setAllBackgrounds(data.backgrounds);
      setAllLang(data.allLang);
      setPrefixMail(data.prefix);
      setAllDataMails(data.dbmails)
      setDefDataFromLua(data.tabletDefaultData);
      setCourtRooms(data.courtrooms);
      if(data.tabletData){
        setHackMode(data.hackMode);
        if(data.hackMode === undefined){
          setMiniGame(false);
          SetLockScreen(true);
        } else {
          SetLockScreen(false)
          setMiniGame(true);
        }
        setBatteryLevel(data.tabCharge);
        setApps(data.apps);
        setGallery(data.tabletData.gallery);
        setTabJob(data.tabletData.job);
        setTabletData(data.tabletData);
        setNewBoss(data.newsBoss);
        setNotifys(data.tabletData.notifications);
        setJustMode(data.justMode);
        setWeatherData(data.currentData);
        setTabletNews(data.news)
        setDatabaseMails(data.dataMails);
        setApplications(data.applicationsnews);
        setInvoiceBoss(data.checkInvoice);
        setNotLimit(data.noteLimit);
        setSentedMails([...data.sentedMails].reverse());
        setAllMails(data.allmails);
        setJobGrade(data.myJobGrade);
        setSettings({
            planemode: data.tabletData.data.planemode,
            notifications: data.tabletData.data.notifications,
            walkanduse: data.tabletData.data.walkanduse,
            widgets: data.tabletData.data.widgets
        })
        setAllNotes([...data.allNotes].reverse());        
        setInvoices([...data.tabletData.invoices].reverse());
        setTabMails([...data.tabletData.mails].reverse());
        setThemeMode(data.tabletData.data.theme);
        setTabletBackground(data.tabletData.data.background);
        setPadress(data.padress);
        if(data.anyLaw){
          setDoj(true);
        } else {
          setDoj(false);
        }
        if(data.anyMdt){
          setPolice(true);
        } else {
          setPolice(false);
        }
        if(data.anyMdt || data.anyLaw){
          setMdtData(data.mdtData);
          setMDTCrimes(data.mdtData.mdtDatabase.mdtData_crimeRecords);
          setCourtJudges(data.mdtData.mdtDatabase.governmentData_court_hearings);
          setMdtMail(data.policeMail);
          setDojMail(data.dojMail);
          setMDTVehCrimes(data.mdtData.mdtDatabase.mdtData_vehicleCrimes)
          setDispatches(data.dispatches);
          setMdtChatData(data.mdtData.mdtchat);
        } 
        if(data.anyEms){
          setEmsData(data.emsData);
          setEmsChatData(data.emsData.emschat);
          setEmsDispatches(data.emsData.emsDispatches);
        }
        if(data.insuranceData){
          setInsuranceData(data.insuranceData);
        }
      } else {
        setTabletBackground(data.tabletDefaultData.defaultTheme);
      }
      setMonths(data.aylar);
      setDays(data.gunler);
    });

    useNui("newGallery", (data) => {
      setGallery(data.data);
    })

    useNui("updateApplications", (data) => {
      setApplications(prev => [...prev, data.data]);
    })

    useNui("updateMessages", (data) => {
      setEmsChatData(prev => [...prev, data.messageData]);
    });

    useNui("updateMessagesMdt", (data) => {
      setMdtChatData(prev => [...prev, data.messageData]);
    })

    useNui("showGunCard", (data) => {
      setGunCardLang(data.lang);
      setWeaponData(data.data);
      setGunCard(true);
    });

    useNui("closeGunCard", (data) => {
      setWeaponData([]);
      setGunCard(false);
    })

    useNui('refreshMug', id => {
      setMug(`pimg/${id}.png?ts=${Date.now()}`)
    })
  
    const handleKeyDown = (event) => {
      if (event.key === "Escape" && !isClosing) {
          closeTablet();
      }
    };
    
    useNui("updtbck", (data) => {
        setTabletBackground(data.data);
    });

    useNui("updateGallery", (data) => {
        setGallery(data.gallery);
    });

    useNui("usedPowerbank", (data) => {
      setBatteryLevel(data.charge);
      SetLockScreen(true);
    });

    useNui("closeTablet", (data) => {
      closeTablet();
    });

    useNui("updateTabletData", (data) => {
        setTabletData(data.alldata);
        setApps(data.apps);
    });

    useNui("updateTabletMainData", (data) => {
      setTabletData(data.data);
    })

   useNui("addNewComments", (data) => {
    setTabletNews(prev =>
      prev.map(article => {
        if (article.code === data.code) {
          return {
            ...article,
            comments: [...article.comments, data.datax]
          };
        }
        return article;
      })
    );
  });


    useNui("tabletNotify", (data) => {
      updateNotification({
          message: data.message,
          title: data.title,
          options: data.options
      });
    });

    useNui("setAllNews", (data) => {
      setTabletNews(prev => [...prev, data]);
    });
  
    document.addEventListener("keydown", handleKeyDown);
    return () => {
      document.removeEventListener("keydown", handleKeyDown);
    };
  }, [isClosing]);

  useEffect(() => {
    if (MainScreen) {
      setGalleryOpen(false);
      setCameraOpen(false);
      setSettingsApp(false);
      setEmsApp(false);
      setMapApp(false);
      setNoteApp(false);
      setBrowserApp(false);
      setMiniGame(false);
      setNewsApp(false);
      setDojApp(false);
      setBossDeskApp(false);
      setCalApp(false);
      setMailApp(false);
      setBillingApp(false);
      setMdtApp(false);
      SetLockScreen(false);
      callNui('CloseCameraApp', {});
      callNui('mapAppState', {state: false});
    }
  }, [MainScreen]);
  

  const closeTablet = () => {
     setIsClosing(true); // Kapanış animasyonunu başlat
      setTimeout(() => {
        setEmsApp(false);
        setMapApp(false);
        setSettingsApp(false);
        setMdtApp(false);
        setNoteApp(false);
        setBrowserApp(false);
        setMiniGame(false);
        setNewsApp(false);
        setDojApp(false);
        setBossDeskApp(false);
        setCalApp(false);
        setMailApp(false);
        setBillingApp(false);
        setGalleryOpen(false);
        setCameraOpen(false);
        setMainScreen(false);
        setLogined(false);
        setGallery([]);""
        SetLockScreen(true);
        setTabletVisible(false);
        setIsClosing(false); // Tekrar açıldığında sorunsuz olması için sıfırla
        callNui('mapAppState', {state: false});
        callNui("closeTablet", {batteryLevel: batteryRef.current});
      }, 500); // 500ms sonra kapat
  }

  const openApp = (app, custom) => {
    setIsAnimating(true); // Animasyon başladığında durumu güncelle
    switch (app) {
      case "mdt":
        if(custom == 'openmdtforcamera'){
          setCameraOpen(false);
          setCustomDurum(custom);
        }
        setMainScreen(false);
        setTimeout(() => {
          setMdtApp(true);
          setIsAnimating(false); // Animasyon tamamlandı
        }, 500); // Animasyon süresi
        break;
      case "mainsc":
        setEmsApp(false);
        setNoteApp(false);
        setBrowserApp(false);
        setMiniGame(false);
        setNewsApp(false);
        setDojApp(false);
        setBossDeskApp(false);
        setMapApp(false);
        setCalApp(false);
        setMailApp(false);
        setCameraOpen(false);
        setBillingApp(false);
        setGalleryOpen(false);
        setSettingsApp(false);
        SetLockScreen(false);
        setMdtApp(false);
        callNui('mapAppState', {state: false});
        callNui('CloseCameraApp', {});
        if (window.MainRender) {
            window.MainRender.stop();
            window.isAnimated = false;
        }
        setTimeout(() => {
          setMainScreen(true);
          setIsAnimating(false);
        }, 500);
        break;
      case "settings":
        setMainScreen(false);
        setTimeout(() => {
          setSettingsApp(true);
          setIsAnimating(false); // Animasyon tamamlandı
        }, 500); // Animasyon süresi
        break;
      case "dojapp":
        setMainScreen(false);
        setTimeout(() => {
          setDojApp(true);
          setIsAnimating(false); // Animasyon tamamlandı
        }, 500); // Animasyon süresi
        break;
      case "bossdesk":
        setMainScreen(false);
        setTimeout(() => {
          setBossDeskApp(true);
          setIsAnimating(false); // Animasyon tamamlandı
        }, 500); // Animasyon süresi
        break;
      case "mail":
        setMainScreen(false);
        setTimeout(() => {
          setMailApp(true);
          setIsAnimating(false); // Animasyon tamamlandı
        }, 500); // Animasyon süresi
        break;
      case "housing":
        setHousing(true);
        break;
      case "myapartment":
        setHousing(true);
        break;
      case "notes":
        setMainScreen(false);
        setTimeout(() => {
          setNoteApp(true);
          setIsAnimating(false); // Animasyon tamamlandı
        }, 500); // Animasyon süresi
        break;
      case "browser":
        setMainScreen(false);
        setTimeout(() => {
          setBrowserApp(true);
          setIsAnimating(false);
        }, 500)
        break;
      case "minigame":
        setMainScreen(false);
        setTimeout(() => {
          setMiniGame(true);
          setIsAnimating(false); // Animasyon tamamlandı
        }, 500); // Animasyon süresi
        break;
      case "news":
        setMainScreen(false);
        setTimeout(() => {
          setNewsApp(true);
          setIsAnimating(false); // Animasyon tamamlandı
        }, 500); // Animasyon süresi
        break;
      case "calculator":
        setMainScreen(false);
        setTimeout(() => {
          setCalApp(true);
          setIsAnimating(false); // Animasyon tamamlandı
        }, 500); // Animasyon süresi
        break;
      case "billing":
        setMainScreen(false);
        setTimeout(() => {
          setBillingApp(true);
          setIsAnimating(false); // Animasyon tamamlandı
        }, 500); // Animasyon süresi
        break;
      case "map":
        setMainScreen(false);
        setTimeout(() => {
          setMapApp(true);
          callNui('mapAppState', {state: true});
          setIsAnimating(false); // Animasyon tamamlandı
        }, 500); // Animasyon süresi
        break;
      case "gallery":
          setCameraOpen(false);
          setMainScreen(false);
          setTimeout(() => {
            setGalleryOpen(true);
            setIsAnimating(false); 
          }, 500); 
          break;
      case "ems":
        setMainScreen(false);
        setTimeout(() => {
          setEmsApp(true);
          setIsAnimating(false); // Animasyon tamamlandı
        }, 500); // Animasyon süresi
        break;
      case "insurance":
        setMainScreen(false);
        setTimeout(() => {
          setInsuranceApp(true);
          setIsAnimating(false); // Animasyon tamamlandı
        }, 500); // Animasyon süresi
        break;
      case "camera":
        if(custom == 'forMdt'){
          setMdtApp(false);
          setCustomDurum(custom);
        }
        setMainScreen(false);
        setTimeout(() => {
            setCameraOpen(true);
            setIsAnimating(false);
            callNui('ToggleCameraAppModule', {});
            const canvas = document.getElementById("gameview-canvas");
            if (canvas && MainRender) {
                MainRender.renderToTarget(canvas);
            }
        }, 1000);
        break;
      default: break;
    }
  };
  
  const screenVariants = {
    hidden: { opacity: 0, scale: 0.9 },
    visible: { opacity: 1, scale: 1 },
    exit: { opacity: 0, scale: 0.9 },
  };

  const handleHomeIndicatorClick = () => {
    setMainScreen(true); 
    setMdtApp(false);    
    SetLockScreen(false);
    setEmsApp(false);
    setMapApp(false);
    callNui('mapAppState', {state: false});
    setNoteApp(false);
    setMiniGame(false);
    setDojApp(false);
    setBossDeskApp(false);
    setCalApp(false);
    setMailApp(false);
    setBillingApp(false);
    setSettingsApp(false);
    setInsuranceApp(false);
  };

  const dragControls = useDragControls()
  const TABLET_W = 1400
  const TABLET_H = 900
  const [tabletTranslation, setTabletTranslation] = useState({
    x: (window.innerWidth - TABLET_W) / 2,
    y: (window.innerHeight - TABLET_H) / 2
  })
  
  useEffect(()=>{
    const cx=(window.innerWidth - TABLET_W)/2
    const cy=(window.innerHeight - TABLET_H)/2
    setTabletTranslation({ x: cx, y: cy })
  },[])
  
  
  return ( 
    <>
      {tabletVisible && (
        <motion.div
        className="tablet-frame"
        initial={{
          x: tabletTranslation.x,
          y: tabletTranslation.y,
          opacity: 0,
          scale: 0.9
        }}
        animate={{
          x: tabletTranslation.x,
          y: tabletTranslation.y,
          opacity: 1,
          scale: 1
        }}
        style={{ filter: `brightness(${bright}%)` }}
        transition={{ duration: 0.6, ease: [0.22, 1, 0.36, 1] }}
        drag
        dragListener={false}
        dragControls={dragControls}
        exit={{
          opacity: 0,
          scale: 0.95,
          transition: { duration: 0.5, ease: "easeInOut" }
        }}
      >
       
      <div className="tablet-notch macbook-notch" onPointerDown={e => dragControls.start(e)} style={{ cursor: 'grab' }}></div>
            <AnimatePresence>
              {lockScreenShow && batteryLevel > 0 && (
                  <LockScreen
                    newPad={newPad}
                    StartSetupScreen={openSetupScreen}
                    isloading={loading}
                    setNewPad={setNewPad}
                    Notification={NotificationX} 
                    batteryLevel={batteryLevel}
                    data={tabletData}
                    lang={tabletLang}
                    months={months}
                    days={days}
                    notifications={tabletNotifications}
                    background={tabletBackground}
                    setLoginX={updateLogined}
                    logined={logined}
                  />
              )}

              {cameraOpened && batteryLevel > 0 && (
                <motion.div
                  key="cameraopened"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <CameraApp 
                    allGallery={allGallery}
                    batteryLevel={batteryLevel}
                    galleryLastPhoto={tabletData.gallery.at(-1)}
                    customState={customDurum}
                    lang={tabletLang}
                  />
                </motion.div>
              )}

              {calApp && batteryLevel > 0 && (
                <motion.div
                  key="calapp"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <CalculatorApp
                    // allGallery={allGallery}
                    // galleryLastPhoto={tabletData.gallery.at(-1)}
                    // customState={customDurum}
                    // lang={tabletLang}
                    batteryLevel={batteryLevel}
                  />
                </motion.div>
              )}

              {mapApp && batteryLevel > 0 && (
                <motion.div
                  key="mapapp"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <MapApp
                    // allGallery={allGallery}
                    // galleryLastPhoto={tabletData.gallery.at(-1)}
                    // customState={customDurum}
                    pName={tabletData.data.ownername}
                    lang={tabletLang}
                    batteryLevel={batteryLevel}
                  />
                </motion.div>
              )}

              {billingApp && batteryLevel > 0 && (
                <motion.div
                  key="billingapp"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <BillingApp
                    // allGallery={allGallery}
                    // galleryLastPhoto={tabletData.gallery.at(-1)}
                    // customState={customDurum}
                    checkInvoice={invoiceBoss}
                    batteryLevel={batteryLevel}
                    players={tabletData.players}
                    ownerJob={tabJob}
                    invoices={tabletInvoices}
                    lang={tabletLang}
                  />
                </motion.div>
              )}

              {isEmsApp && batteryLevel > 0 && (
                <motion.div
                  key="emsapp"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <EmsApp
                    lang={tabletLang}
                    emsData={emsData}
                    batteryLevel={batteryLevel}
                    allMessages={emsChatData}
                    tabOwnerName={tabletData.data.ownername}
                    emsDispatch={emsDispatches}
                  />
                </motion.div>
              )}

              {insuranceApp && batteryLevel > 0 && (
                <motion.div
                  key="insuranceapp"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <InsuranceApp
                    lang={tabletLang}
                    insuranceData={insuranceData}
                    tabOwner={tabletData.data.ownername}
                    tabletTheme={tabletTheme}
                  />
                </motion.div>
              )}

              {openedNoteApp && batteryLevel > 0 && (
                <motion.div
                  key="noteapp"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <NoteApp
                    lang={tabletLang}
                    tabletTheme={tabletTheme}
                    batteryLevel={batteryLevel}
                    allNotes={allNotes}
                    myLimit={noteLimit}
                  />
                </motion.div>
              )}

              {isNews && batteryLevel > 0 && (
                <motion.div
                  key="noteapp"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <WeazelNewsApp
                    lang={tabletLang}
                    tabletTheme={tabletTheme}
                    batteryLevel={batteryLevel}
                    allNotes={allNotes}
                    myLimit={noteLimit}
                    isBoss={newBoss}
                    news={tabletNews}
                    applications={applications}
                    playerGalleryData={tabletData.gallery}
                  />
                </motion.div>
              )}

              {browser && (
                <motion.div
                  key="noteapp"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <SmartTabBrowser
                    // lang={tabletLang}
                    // tabletTheme={tabletTheme}
                    // batteryLevel={batteryLevel}
                    // allNotes={allNotes}
                    // myLimit={noteLimit}
                    // isBoss={newBoss}
                    // news={tabletNews}
                    // applications={applications}
                    // playerGalleryData={tabletData.gallery}
                  />
                </motion.div>
              )}

              { minigame && (
                <motion.div
                  key="minigame"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <HackerMinigame
                    lang={tabletLang}
                    // tabletTheme={tabletTheme}
                    batteryLevel={batteryLevel}
                    // allNotes={allNotes}
                    openApp={openApp}
                    // myLimit={noteLimit}
                    // isBoss={newBoss}
                    // news={tabletNews}
                    // applications={applications}
                    // playerGalleryData={tabletData.gallery}
                  />
                </motion.div>
              )}

              {/* {galleryOpened && (
                <motion.div
                  key="galleryOpened"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <GalleryApp
                    allGallery={allGallery}
                    lang={tabletLang}
                    theme={tabletTheme}
                  />
                </motion.div>
              )} */}

              {galleryOpened && batteryLevel > 0 && (
                <motion.div
                  key="galleryOpened"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <NewGallery
                    allGallery={allGallery}
                    lang={tabletLang}
                    batteryLevel={batteryLevel}
                    theme={tabletTheme}
                    pname={tabletData.data.ownername}
                    albumsv={tabletData.albums}
                  />
                </motion.div>
            )}
            

            {dojApp && batteryLevel > 0 && (
                <motion.div
                  key="dojapp"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <DOJApp
                      // allGallery={allGallery}
                      lang={tabletLang}
                      batteryLevel={batteryLevel}
                      allPersonelCrimes={mdtCrimes}
                      allVehicleCrimes={mdtVehCrimes}
                      allCourtCalendar={mdtData.mdtDatabase.governmentData_court_hearings}
                      allPlayers={mdtData.players}
                      courtRooms={courtRooms}
                      allDataCourts={judgeCourts}
                      allVehicles={mdtData.vehicles}
                      allWeaponLicenses={mdtData.mdtDatabase.mdtData_weaponLicenses}
                      allCrimes={mdtData.cidcrimes}
                      // theme={tabletTheme}
                      tabJob={tabJob}
                      pname={tabletData.data.ownername}
                      // albumsv={tabletData.albums}
                  />
                </motion.div>
            )}

             {batteryLevel <= 0 && (
                <motion.div
                  key="galleryOpened"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <BatteryDeadScreen
                    // allGallery={allGallery}
                    lang={tabletLang}
                    // batteryLevel={batteryLevel}
                    // theme={tabletTheme}
                    // pname={tabletData.data.ownername}
                    // albumsv={tabletData.albums}
                  />
                </motion.div>
            )}

            <ColdModal
                appName="SmartPad"
                title={tabletLang.success}
                message={tabletLang.soon}
                isOpen={housing}
                onClose={() => setHousing(false)}
                buttons={[
                    { label: tabletLang.ok, onClick: () => setHousing(false) }
                ]}
            />

            {mailAppX && (
                <motion.div
                  key="galleryOpened"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <MailApp
                    batteryLevel={batteryLevel}
                    lang={tabletLang}
                    allMails={allMails}
                    sentedMails={sentedMails}
                    tabOwner={tabletData.owner}
                    policeMail={mdtMail}
                    dojMail={dojMail}
                    dbMails={dbMails}
                    tabMails={tabMails}
                    myMail={tabletData.email}
                    isPolice={isPolice}
                    isDojApp={isDojApp}
                  />
                </motion.div>
              )}

              {bossDeskApp && (
                <motion.div
                  key="bossdesk"
                  variants={screenVariants}
                  initial="hidden"
                  animate="visible"
                  exit="exit"
                  transition={{ duration: 0.5 }}
                >
                  <BossDesk
                    // lang={tabletLang}
                    // allMails={allMails}
                    // sentedMails={sentedMails}
                    // tabOwner={tabletData.owner}
                    // tabMails={tabMails}
                    // myMail={tabletData.email}
                  />
                </motion.div>
              )}

              {showModal && (
                  <NotificationModal
                    title={notificationData.title}
                    message={notificationData.message}
                    okay="Ok"
                    onCancel={() => setShowModal(false)}
                    onConfirm={() => {
                        setShowModal(false);
                    }}
                  />
              )}

              <SetupScreen 
                  key={setupScreen ? 'setup' : 'closed'} 
                  isOpened={setupScreen}
                  setLoading={showCreatingHersey} 
                  onCloseV2={hideSetupScreen} 
                  allmails={allDataMails}
                  Notification={NotificationX} 
                  setLoginX={updateLogined}
                  prefix={prefixMail}
                  lang={tabletLang}
                  allLang={allLang}
              />

              {IsCreatingHersey && <CreatingHersey isVisible={showCreatingHersey} />}

                {MdtApp && isMdtLoaded && (
                  <motion.div
                    key="mdtapp"
                    variants={screenVariants}
                    initial="hidden"
                    animate="visible"
                    exit="exit"
                    transition={{ duration: 0.3 }}
                  >
                    <MdtAppX judMode={judMode} batteryLevel={batteryLevel} setMdtPersonelCrimes={setMDTCrimes} setMdtVehCrimes={setMDTVehCrimes} mdtCrimes={mdtCrimes} mdtVehCrimes={mdtVehCrimes} tabOwnerName={tabletData.data.ownername} allMessages={mdtChatData} theme={tabletTheme} lang={tabletLang} mdtData={mdtData} disData={dispatches} padres={padress} NotificationX={NotificationX} openApp={openApp} clientJobGrade={clientJobGrade}/>
                  </motion.div>
                )}

                {MainScreen && isMainScreenLoaded && (
                  <motion.div
                    key="mainscreen"
                    variants={screenVariants}
                    initial="hidden"
                    animate="visible"
                    exit="exit"
                    transition={{ duration: 0.5 }}
                  >
                    <MainScreenX batteryLevel={batteryLevel} widgets={settings.widgets} lang={tabletLang} mails={tabMails} currentData={currentWeatherData} openApp={openApp} apps={apps} playerApps={tabletApps} background={tabletBackground} days={days} months={months} />
                  </motion.div>
                )}

                {settingsAppScreen && isSettingsLoaded && (
                  <motion.div
                    key="settingsapp"
                    variants={screenVariants}
                    initial="hidden"
                    animate="visible"
                    exit="exit"
                    transition={{ duration: 0.5 }}
                  >
                    <SettingsApp batteryLevel={batteryLevel} settings={settings} setSettings={setSettings} bright={bright} setBright={setBright} tabletTheme={tabletTheme} job={tabJob} openApp={openApp} apps={apps} themeMode={tabletTheme} setThemeMode={setThemeMode} background={tabletBackground} setBackground={setTabletBackground} allBackgrounds={allBackgrounds} lang={tabletLang} tabData={tabletData} allLang={allLang} Notification={NotificationX}/>
                  </motion.div>
                )}

              </AnimatePresence>

              {logined && batteryLevel > 0 && (
                  <div 
                    className="home-indicator" 
                    onTouchStart={handleTouchStart}
                    onTouchMove={handleTouchMove}  // Kaydırma işlemini takip ediyor
                    onTouchEnd={handleTouchEnd}
                    onMouseDown={handleMouseDown}
                    onMouseMove={handleMouseMove} // Fare hareketlerini takip ediyor
                    onMouseUp={handleMouseUp}
                    onClick={handleHomeIndicatorClick} // Tıklama olayını ele alıyor
                  ></div>
              )}

            {tabletVisible &&
              <Notification>
                  tabletOpened={tabletVisible}
              </Notification>
            }
        </motion.div>
      )}
        {!tabletVisible &&
          <Notification>
              tabletOpened={tabletVisible}
          </Notification>
        }

        {showGunCard && <GunLicenseCard lang={gunCardLang} isOpen={showGunCard} data={weaponLicenseData}></GunLicenseCard>}
    </>
  );
}

export default App;""
