import React, { useState, useEffect, useRef } from "react";
import "./main.css";
import "../App.css";
import MyLogo from '/public/appicons/mdt-minilogo.png';
import CitizenQuery from '/src/MdtApp/citizenProfileScreen';
import OfficersScreenX from '/src/MdtApp/officersScreen';
import VehicleQueryPage from "./vehicleQuery/main";
import CrimeTable from './crimesList/main';
import CriminalRecord from '/src/MdtApp/newAddCriminal/main';
import CreateVehicleCrime from "./createVehicleCrime/main";
import CreateWanted from '/src/MdtApp/newAddWanted/main';
import { AnimatePresence, motion } from 'framer-motion';
import Avatar from '/public/avatar.png';
import AddAnnounceModal from "./newAddAnnounce/main";
import { useNui, callNui } from "@/nui";
import WeaponLicenseModal from './newAddWeaponLicense/main'
import CitizenQueryPage from './citizenQuery/main'
import VehicleProfileScreen from "./vehicleDataScreen/main";
import CrimeDatabase from "./crimeDatabase/main";
import MdtHistory from "./mdtHistory/main";
import MDTChat from "./Chat/main";
import ColdModal from "@/SettingsApp/coldModal/main";
import SopApp from "./SopApp/main";

const MdtApp = ({lang, setMdtPersonelCrimes, setMdtVehCrimes, mdtData, mdtCrimes, mdtVehCrimes, NotificationX, disData, padres, openApp, plocation, clientJobGrade, theme, tabOwnerName, allMessages, judMode}) => {
    const [password, setPassword] = useState('');
    const [loginScreen, setLoginScreen] = useState(false); /** MDT Login Screen */
    const [mdtMain, setMainMdt] = useState(false); /** MDT Sol Bar */
    const [mdtOverview, setOverviewPage] = useState(true); /** MDT Overview Page **/ 
    const [citizenProfileScreen, setCitizenProfileScreen] = useState(false); /** Oyuncu Sorgulama Ekranı */
    const [vehicleProfileScreen, setVehProfile] = useState(false);
    const [officersScreen, setOfficersScreen] = useState(false); /** MDT Officer Screen **/ 
    const [isVehicleQueryPage, setIsVehicleQueryPage] = useState(false); /** MDT Vehicles Query **/ 
    const [isCitizenQueryPage, setIsCitizenQueryPage] = useState(false);
    const [isCrimeTableOpen, setCrimeTableOpen] = useState(false); /** MDT Crimes Table **/ 
    const [isModalCreateWantedRecord, setModalCreateWantedRecord] = useState(false); /** Create Wanted Screen **/ 
    const [addAnnounceModal, setAnnounceModal] = useState(false);
    const [mdtAnnouncements, setAnnouncements] = useState([]);
    const [isMenuOpen, setIsMenuOpen] = useState(false);
    const [IscriminalRecordAdd, setCriminalRecordAdd] = useState(false);
    const [weaponModal, setWeaponModal] = useState(false);
    const [openedPage, setLastPage] = useState('mdtMain');
    const [dispatches, setDispatches] = useState([]);
    const [mapUrl, setMapUrl] = useState("https://map.0resmon.org/");
    const [showInput, setShowInput] = useState(false);
    const [showInputVehicle, setShowVehicleInput] = useState(false);
    const [searchValue, setSearchValue] = useState('');
    const [searchInWantedList, setWantedListResult] = useState('');
    const [searchInWantedVehList, setSearchInWantedVehList] = useState('');
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [isMdtChat, setMdtChat] = useState(false);
    const [selectedData, setSelectedData] = useState(null);
    const [wantedList, setWantedList] = useState([]);
    const [weaponlicenses, setWeaponLicenses] = useState([]);
    const [wantedVehicles, setWantedVehicles] = useState([]);
    const [selectedLicense, setSelectedLicense] = useState(null);
    const [isLicenseModalOpen, setIsLicenseModalOpen] = useState(false);
    const [selectedWantedVehicle, setselectedWantedVehicle] = useState(null);
    const [selectedWantedCitizen, setSelectedWantedPeople] = useState(null);
    const [cidProfileData, setCitizenProfileData] = useState(null);
    const [isBoss, setBoss] = useState(false);
    const [vehProfileData, setVehProfileData] = useState(null);
    const [allCrimes, setAllCrimes] = useState([]);
    const [allVehicleCrimes, setVehicleCrimes] = useState([]);
    const [isVehicleCriminalModal, setVehicleCriminalRecordAdd] = useState(false);
    const [vehCrimeList, setVehCrimeList] = useState([]);
    const [cidCrimeList, setCidCrimeList] = useState([]);
    const [isCrimeDatabase, setCrimeDatabase] = useState(false);
    const [mdtHistory, setHistory] = useState([]);
    const [isMdtHistory, setPageHistory] = useState([]);
    const [isSopApp, setSopApp] = useState(false);
    const [openedColdModal, setColdModal] = useState(null);
    const [openedColdModal2, setColdModal2] = useState(null);
    const [isOnDuty, setIsOnDuty] = useState(false);

    useEffect(() => {
    const onlineOfficers = mdtData?.officers?.filter(
        officer => officer.online && officer.coords?.x !== 0 && officer.coords?.y !== 0 && officer.coords?.z !== 0
    );
    let coordsParam = '';

    if (onlineOfficers?.length > 0) {
        coordsParam = onlineOfficers
            .map(officer => `${officer.coords.x},${officer.coords.y},mdt_officer,${encodeURIComponent(officer.name)}`)
            .join("|");
    }

    if (dispatches?.length > 0) {
        const dispatchCoords = dispatches
            .filter(dispatch => dispatch.coordsdecode?.x !== 0 && dispatch.coordsdecode?.y !== 0 && dispatch.coordsdecode?.z !== 0)
            .map(dispatch => {
                const coords = dispatch.coordsdecode;
                const markerName = dispatch.title || 'Dispatch';
                return `${coords.x},${coords.y},mdt_dispatch,${encodeURIComponent(markerName)}`;
            })
            .join("|");

        if (coordsParam && dispatchCoords) {
            coordsParam = coordsParam + "|" + dispatchCoords;
        } else if (dispatchCoords) {
            coordsParam = dispatchCoords;
        }
    }

    if (coordsParam) {
        setMapUrl(`https://map.0resmon.org/?coords=${coordsParam}`);
    } else {
        setMapUrl("https://map.0resmon.org/");
    }

    setVehCrimeList(mdtData.vehcrimes);
    setCidCrimeList(mdtData.cidcrimes);
    setVehicleCrimes(mdtVehCrimes);
    setAllCrimes(mdtCrimes);
    setAnnouncements(mdtData.mdtDatabase.mdtData_announcements);
    setHistory([...mdtData.mdtDatabase.mdtData_history].reverse());
}, [mdtData, dispatches]);


      

    useEffect(() => {
        useNui("setNewCriminal", (data) => {
            setMdtPersonelCrimes(prev => [...prev, data.dataland]);
            setAllCrimes(prev => [...prev, data.dataland]);
        });

        useNui("setNewVehicleCrime", (data) => {
            setMdtVehCrimes(prev => [...prev, data.data]);
            setVehicleCrimes(mdtVehCrimes);
        });
        // Listen live duty updates (optional external broadcast)
        useNui("updateOfficerDuty", (data) => {
            if (data && data.cid && data.state !== undefined) {
                // if needed later, we can sync officers list here
            }
        });
    } ,[])

    const openLicenseModal = (license) => {
        setSelectedLicense(license);
        setIsLicenseModalOpen(true);
    };

    const openWantedVehicleModal = (data) => {
        setselectedWantedVehicle(data);
        setIsLicenseModalOpen(true);
    }

    const checkClientGrade = () => {
        var newData = mdtData.bosslevels
        for (let index = 0; index < newData.length; index++) {
            const element = newData[index];
            if(element === clientJobGrade){
                setBoss(true);
            } else {
                setBoss(false);
            }  
        }
    }

    const openWantedPeople = (data) => {
        setSelectedWantedPeople(data);
        setIsLicenseModalOpen(true);
    }
    
    const closeLicenseModal = () => {
        setIsLicenseModalOpen(false);
        setSelectedLicense(null);
        setselectedWantedVehicle(null);
        setSelectedWantedPeople(null);
    };
    

    useEffect(() => {
        if (!mdtData?.mdtDatabase) return;
        setAnnouncements(mdtData.mdtDatabase.mdtData_announcements);
        setWantedList([...mdtData.mdtDatabase.mdtData_wantedPeople].reverse());
        setWantedVehicles(mdtData.mdtDatabase.mdtData_wantedVehicles);
        setWeaponLicenses(mdtData.mdtDatabase.mdtData_weaponLicenses);    

    }, [mdtData]);
    
    useEffect(() => {
        setDispatches(disData);
        checkClientGrade();
        useNui("newAnnouncements", (data) => {
            setAnnouncements(data.data);
        });

        useNui("newWanteds", (data) => {
            if(data.type == 'citizen'){
                setWantedList(data.data);
            } else if(data.type == 'wlicenses'){    
                const prepareData = async () => {
                    const licenses = data.data;
                
                    const newData = await Promise.all(licenses.map(async (element) => {
                        const photo = await returnPlayerPhoto(element.citizen_id);
                        return { ...element, photoUrl: photo };
                    }));
                
                    setWeaponLicenses(newData.reverse());
                };
                
                prepareData();                
            } else {
                setWantedVehicles(data.data);
            }
        });

        useNui("updateDirect", (data) => {
            if(data.type == 'crimepersonal'){
                setAllCrimes(data.data.data);
            } else if(data.type == 'crimevehicle'){
                setVehicleCrimes(data.data.data);
            } else if(data.type == 'wantedlist'){
                setWantedList(data.data.data);
            } else if(data.type == 'wantedlistveh'){
                setWantedVehicles(data.data.data);
            }
            setHistory([...data.data.history].reverse());
        });

    }, [mdtAnnouncements, weaponlicenses, wantedVehicles, wantedList, mdtHistory, disData]);

    const HideAllMdtPages = () => {
        setLoginScreen(false);
        setOverviewPage(false);
        setCitizenProfileScreen(false);
        setVehProfile(false);
        setCrimeDatabase(false);
        setPageHistory(false);
        setOfficersScreen(false);
        setIsVehicleQueryPage(false);
        setIsCitizenQueryPage(false);
        setMdtChat(false);
        setCrimeTableOpen(false);
        setSopApp(false);
    }

    const handleWantedListVehicleSearch = (e) => {
        setSearchInWantedVehList(e.target.value.toLowerCase());
    };

    const filteredWantedVehicles = wantedVehicles.filter(vehicle =>
        vehicle.plate.toLowerCase().includes(searchInWantedVehList) ||
        vehicle.modellabel.toLowerCase().includes(searchInWantedVehList)
    );

    const ChangePageInMdt = (page) => {
        switch(page){
            case "mdtOverview":
                HideAllMdtPages();
                setOverviewPage(true);
                break;
            case "citizenProfileScreen":
                HideAllMdtPages();
                setCitizenProfileScreen(true);
                break;
            case "officersScreen":
                HideAllMdtPages();
                setOfficersScreen(true);
                break;
            case "mdtchat":
                HideAllMdtPages();
                setMdtChat(true);
                break;
            case "isVehicleQueryPage":
                HideAllMdtPages();
                setIsVehicleQueryPage(true)
                break;
            case "isCitizenQueryPage":
                HideAllMdtPages();
                setIsCitizenQueryPage(true);
                break;
            case "isCrimeTableOpen":
                HideAllMdtPages();
                setCrimeTableOpen(true);
                break;
            case "setPageHistory":
                HideAllMdtPages();
                setPageHistory(true);
                break;
            case "isCrimeDatabase": 
                HideAllMdtPages();
                setCrimeDatabase(true)
                break;
            case "isSopApp":
                HideAllMdtPages();
                setSopApp(true);
                break;
            default: break;
        }
    }

    const ToggleCriminalRecordScreen = (type) => {
        if(type == 'citizen'){
            setCriminalRecordAdd(!IscriminalRecordAdd);
        } else {
            setVehicleCriminalRecordAdd(true);
        }
    }

    const toggleDuty = () => {
        const newState = !isOnDuty;
        callNui('toggleDuty', { state: newState }, (resp) => {
            if (resp && typeof resp.state === 'boolean') {
                setIsOnDuty(resp.state);
                if (NotificationX) {
                    NotificationX({
                        title: lang.success,
                        message: resp.state ? lang.onduty : lang.offduty,
                        options: { app: 'mdt' }
                    });
                }
            }
        });
    }

    useEffect(() => {
        // fetch initial duty state
        callNui('getDutyState', {}, (resp) => {
            if (resp && typeof resp.state === 'boolean') setIsOnDuty(resp.state)
        })
    }, [])

    const addToWantedList = (newEntry) => {
      setWantedList((prev) => [...prev, newEntry]);
    };

    const openModal = (data) => {
        setSelectedData(data);
        setIsModalOpen(true);
    };

    const closeModal = () => {
        setIsModalOpen(false);
        setSelectedData(null);
    };

    const handleSearchClick = () => {
        setShowInput(!showInput);
    };

    const OpenAnnounceModal = () => {
        setIsMenuOpen(false);
        setAnnounceModal(true);
    }

    const CreateWantedModal = () => {
        setIsMenuOpen(false);
        setModalCreateWantedRecord(true);
    }

    const handleWantedListSearch = (e) => {
        const value = e.target.value.toLowerCase();
        setWantedListResult(value);
    
        const filtered = wantedList.filter((item) => {
            const fullName = `${item.first_name} ${item.last_name}`.toLowerCase();
            return fullName.includes(value);
        });
    
        const loadFilteredPhotos = async () => {
            const updatedList = await Promise.all(
                filtered.reverse().map(async (item) => {
                    const url = await returnPlayerPhoto(item.cid);
                    return { ...item, photoUrl: url };
                })
            );
            setDisplayList(updatedList);
        };
    
        loadFilteredPhotos();
    };

    const handleSearchClickVehicle = (e) => {
        setShowVehicleInput(!showInputVehicle);
    }

    const handleSearchChange = (e) => {
        setSearchValue(e.target.value);
    };
    
    const [isWeaponLicenseModalOpen, setIsWeaponLicenseModalOpen] = useState(false);
    
    const [weaponLicenseData, setWeaponLicenseData] = useState({
        applicantName: "",
        weaponType: "Select",
        licenseReason: "",
        officerName: "",
    });

    const setVahcanP = (data) => {
        setVehProfileData(data);
        setIsVehicleQueryPage(false);
    }

    const toggleWeaponLicenseModal = () => {
        setIsWeaponLicenseModalOpen(!isWeaponLicenseModalOpen)
    }

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setWeaponLicenseData({ ...weaponLicenseData, [name]: value });
    };

    const handleFormSubmit = () => {
        closeWeaponLicenseModal();
    };
    
    const [displayList, setDisplayList] = useState([]);

    const returnPlayerPhoto = (cid) => {
        const path = `/web/pimg/${cid}.png`;
        const img = new Image();
        img.src = path;
      
        return new Promise((resolve) => {
          img.onload = () => resolve(path);
          img.onerror = () => resolve(Avatar);
        });
    }

    useEffect(() => {
        if (!mdtData?.mdtDatabase) return;
    
        const prepareData = async () => {
            const licenses = mdtData.mdtDatabase.mdtData_weaponLicenses;
    
            const newData = await Promise.all(licenses.map(async (element) => {
                const photo = await returnPlayerPhoto(element.citizen_id);
                return { ...element, photoUrl: photo };
            }));
    
            setWeaponLicenses(newData.reverse());
        };
    
        prepareData();
    }, [mdtData]);
    
      
    const toggleBaba = () => {
        setCitizenProfileScreen(false);
        setIsCitizenQueryPage(true);
    }

    const toggleVehicleBaba = () => {
        setVehProfile(false);
        setIsVehicleQueryPage(true);
    }

    useEffect(() => {
        const loadPhotos = async () => {
            const updatedList = await Promise.all(
                [...wantedList].reverse().map(async (item) => {
                    const url = await returnPlayerPhoto(item.cid);
                    return { ...item, photoUrl: url };
                })
            );
            setDisplayList(updatedList);
        };
    
        loadPhotos();
    }, [wantedList]);

    const capitalize = (str) => str.charAt(0).toUpperCase() + str.slice(1).toLowerCase()

    return(<>
        <div className={`mdt-app-frame ${theme !== 'dark' ? 'mdt-app-frame-white' : ''}`}>
            {loginScreen && (<>
                <div className='mdt-app-frame-alt'>
                    <div className='mdt-app-login-screen'>
                        <div className='mdt-app-logo'></div>
                        <span className='mdt-login-screen-text'>
                            You are connecting to Los Santos
                            Police Department database
                        </span>
                        <span className='mdt-login-screen-desc'>
                            Please enter password to identify you
                        </span>
                        <div className='password-entered'>
                            <input type="password" onChange={(e) => setPassword(e.target.value)} value={password} placeholder='Enter password'></input>
                            <div className='login-mdt-panel'>
                                <span className="material-symbols-outlined">arrow_forward</span>
                            </div>
                        </div>
                    </div>
                </div>
            </>)}

            {!mdtMain && (<>
                <div className='mdt-app-panelscreen'>
                    <div className={`mdt-app-panelscreen-main ${theme !== 'dark' ? 'leftmain':''}`}>
                        <div className={`mdt-left-panel ${theme !== 'dark' ? 'leftmain':''}`}>
                            <div className={`mdt-left-mainpart ${theme !== 'dark' ? 'leftmain':''}`}>
                                <img src={MyLogo} alt="Los Santos Logo" />
                                <div className="mdt-left-logo-content">
                                    <span className={`mdt-left-logo-header ${theme !== 'dark' ? 'mdt-left-dark': ''}`}>Los Santos</span>
                                    <span className="mdt-left-logo-subheader">Police Department Database</span>
                                </div>
                            </div>
                            <div className='notifications-box'>
                                <div className='announce-box'>
                                    <div style={{marginTop: '.7rem'}}className='announcebox-header'>
                                        <div className={`announcebox-header-icon ${theme !== 'dark' ? 'actionwhite' : ''}`}>
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="14" viewBox="0 0 16 14" fill="none">
                                                <path d="M13.6 4V8.8C14.96 8.8 16 7.76 16 6.4C16 5.04 14.96 4 13.6 4ZM7.2 3.2H1.6C0.72 3.2 0 3.92 0 4.8V8C0 8.88 0.72 9.6 1.6 9.6H2.4V12C2.4 12.88 3.12 13.6 4 13.6H5.6V9.6H7.2L10.4 12.8H12V0H10.4L7.2 3.2Z" fill="#64666F"/>
                                            </svg>
                                        </div>
                                        <div className={`announcebox-header-label ${theme !== 'dark' ? 'anbox-hd-lbl' : ''}`}>
                                            {lang.announcements}
                                        </div>
                                    </div>
                                    <div className='announcebox-notifications'>
                                        {mdtAnnouncements.map((item, index) => 
                                            <div className={`announcebox-notify-item ${theme !== 'dark' ? 'announcebox-notify-item-white' : ''}`}>
                                                <div className="announcebox-notify-header">
                                                    <div className="announcebox-badge">{item.title}</div>
                                                    <div className="announcebox-user">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none">
                                                            <path d="M8 0L9.856 5.49H15.8L10.972 8.884L12.828 14.373L8 10.98L3.172 14.373L5.028 8.884L0.2 5.49H6.144L8 0Z"/>
                                                        </svg>
                                                        <span className={`announcebox-username ${theme !== 'dark' ? 'anbox-user-white': ''}`}>{item.created_by}</span>
                                                    </div>
                                                </div>
                                                <div className={`announcebox-notify-content ${theme !== 'dark' ? 'text-white': ''}`}>
                                                   {item.message}
                                                </div>
                                                <div className="announcebox-notify-date">{item.created_at}</div>
                                            </div>
                                        )}
                                    </div>
                                </div>
                                <div className='announce-box'>
                                    <div className='announcebox-header'>
                                        <div className={`announcebox-header-icon ${theme !== 'dark' ? 'actionwhite' : ''}`}>
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="14" viewBox="0 0 16 14" fill="none">
                                                <path d="M13.6 4V8.8C14.96 8.8 16 7.76 16 6.4C16 5.04 14.96 4 13.6 4ZM7.2 3.2H1.6C0.72 3.2 0 3.92 0 4.8V8C0 8.88 0.72 9.6 1.6 9.6H2.4V12C2.4 12.88 3.12 13.6 4 13.6H5.6V9.6H7.2L10.4 12.8H12V0H10.4L7.2 3.2Z" fill="#64666F"/>
                                            </svg>
                                        </div>
                                        <div className={`announcebox-header-label ${theme !== 'dark' ? 'anbox-hd-lbl' : ''}`}>
                                            {lang.activityHistory}
                                        </div>
                                    </div>
                                    <div className='announcebox-notifications'>
                                        {disData.map((element, index) => 
                                            <div className={`announcebox-notify-item ${theme !== 'dark' ? 'thedark':''}`}>
                                                <div className="announcebox-timestamp">{element.timestring}</div>
                                                <div className="announcebox-header">
                                                    <span className={`announcebox-header-bold ${theme !== 'dark' ? 'announcebox-dark' : ''}`}>{element.title}</span> 
                                                </div>
                                                <div className="announcebox-details">
                                            
                                                    <div className="announcebox-detail">
                                                        <span className={`detail-label ${theme !== 'dark' ? 'detail-label-white': ''}`}>{lang.gender}:</span>
                                                        <span className={`detail-value ${theme !== 'dark' ? 'detail-white': ''}`}>{element.gender}</span>
                                                    </div>
                                                    <div className="announcebox-detail">
                                                        <span className={`detail-label ${theme !== 'dark' ? 'detail-label-white': ''}`}>{lang.location}</span>
                                                        <span className={`detail-value ${theme !== 'dark' ? 'detail-white': ''}`}>{element.address}</span>
                                                    </div>
                                                </div>
                                            </div>
                                        )}
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div className='mdt-homepage-box'>
                            <div className={`mdt-homepage-box-header ${theme !== 'dark' ? 'leftmain':''}`}>
                                <div onClick={() => ChangePageInMdt('mdtOverview')} className={`mdt-homepage-box-header-item ${mdtOverview ? 'selected':''}`}>{lang.overview}</div>
                                {isBoss && <div onClick={() => ChangePageInMdt('officersScreen')} className={`mdt-homepage-box-header-item ${officersScreen ? 'selected':''}`}>{lang.officers}</div>}
                                <div onClick={() => ChangePageInMdt('isCitizenQueryPage')} className={`mdt-homepage-box-header-item ${isCitizenQueryPage ? 'selected':''}`}>{lang.citizens}</div>
                                <div onClick={() => ChangePageInMdt('isVehicleQueryPage')} className={`mdt-homepage-box-header-item`}>{lang.vehicles}</div>
                                <div onClick={() => ChangePageInMdt('isCrimeDatabase')} className={`mdt-homepage-box-header-item`}>{lang.cdatabase}</div>
                                <div onClick={() => ChangePageInMdt('isSopApp')} className={`mdt-homepage-box-header-item ${isSopApp ? 'selected':''}`}>{lang.sop}</div>
                                <div onClick={() => ChangePageInMdt('mdtchat')}  className={`mdt-homepage-box-header-item`}>{lang.chat}</div>
                                <div onClick={() => ChangePageInMdt('isCrimeTableOpen')}  className={`mdt-homepage-box-header-item`}>{lang.crimelist}</div>
                                {isBoss && <div onClick={() => ChangePageInMdt('setPageHistory')} className={`mdt-homepage-box-header-item ${isMdtHistory ? 'selected':''}`}>{lang.history}</div>}
                                <div 
                                    onClick={() => setIsMenuOpen(!isMenuOpen)} 
                                    className="mdt-homepage-box-header-item"
                                >
                                    {lang.creat} {
                                        !isMenuOpen ? <i className="fa-solid fa-chevron-down"></i> : <i className="fa-solid fa-chevron-right"></i>
                                    }
                                </div>

                                <div className={`duty-toggle ${isOnDuty ? 'on' : 'off'}`} onClick={toggleDuty}>
                                    <div className="dot"></div>
                                    <span>{isOnDuty ? lang.onduty : lang.offduty}</span>
                                </div>

                                <div className={`dropdown-menuv ${theme !== 'dark' ? 'dropx-white' : ''} ${isMenuOpen ? "open" : "closed"}`}>
                                    <div onClick={() => CreateWantedModal()}>{lang.cwanted}</div>
                                    {isBoss && <div onClick={() => OpenAnnounceModal()}>{lang.cannounce}</div>}
                                </div>
                            </div>

                            {mdtOverview && (
                            <div className={`mdt-overview-part ${mdtOverview ? 'show' : ''}`}>
                                <iframe
                                    src={mapUrl}
                                    loading="lazy"
                                    style={{
                                        border: "0px",
                                        borderRadius: "4px",
                                        width: "100%",
                                        height: "22rem",
                                        marginTop: ".4rem",
                                        willChange: "transform"
                                    }}
                                ></iframe>
                                <div className='mdt-homepage-box-subbox'>
                                    <div className='mdt-homepage-box-subbox-item'>
                                        <div className='mdt-homepage-box-subbox-item-header'>
                                            <div className={`announcebox-header-icon ${theme !== 'dark' ? 'actionwhite' : ''}`}>
                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 14 14" fill="none">
                                                    <path d="M7 0C6.10169 0 5.24016 0.335648 4.60496 0.933106C3.96976 1.53056 3.6129 2.34089 3.6129 3.18582C3.6129 4.03076 3.96976 4.84108 4.60496 5.43854C5.24016 6.036 6.10169 6.37165 7 6.37165C7.89831 6.37165 8.75984 6.036 9.39504 5.43854C10.0302 4.84108 10.3871 4.03076 10.3871 3.18582C10.3871 2.34089 10.0302 1.53056 9.39504 0.933106C8.75984 0.335648 7.89831 0 7 0ZM3.3871 8.07076C2.48878 8.07076 1.62726 8.4064 0.992058 9.00386C0.356854 9.60132 0 10.4116 0 11.2566V12.2658C0 12.9064 0.493161 13.4518 1.16516 13.5546C5.02916 14.1485 8.97084 14.1485 12.8348 13.5546C13.1601 13.5048 13.4559 13.3478 13.6693 13.1117C13.8828 12.8756 14 12.5758 14 12.2658V11.2566C14 10.4116 13.6431 9.60132 13.0079 9.00386C12.3727 8.4064 11.5112 8.07076 10.6129 8.07076H10.3058C10.1387 8.07076 9.97252 8.09624 9.81445 8.14382L9.03226 8.38424C7.7117 8.78967 6.2883 8.78967 4.96774 8.38424L4.18555 8.14382C4.02717 8.09534 3.86165 8.07068 3.6951 8.07076H3.3871Z" fill="#64666E"/>
                                                </svg>
                                            </div>
                                            <div className={`announcebox-header-label ${theme !== 'dark' ? 'anbox-hd-lbl' : ''}`}>
                                                {lang.wlist}
                                            </div>
                                            <div onClick={() => handleSearchClick()}  className='announcebox-header-righticon'>
                                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none">
                                                    <path fillRule="evenodd" clipRule="evenodd" d="M7.20365 2.69638e-08C6.05284 0.000124636 4.91881 0.27593 3.89648 0.804329C2.87415 1.33273 1.99328 2.09834 1.32761 3.03708C0.661933 3.97582 0.230825 5.06037 0.0703713 6.19994C-0.090082 7.3395 0.0247894 8.50093 0.405369 9.58698C0.785949 10.673 1.42116 11.6521 2.25783 12.4423C3.09451 13.2324 4.10829 13.8106 5.21432 14.1285C6.32035 14.4464 7.48644 14.4947 8.61497 14.2694C9.74351 14.0441 10.8016 13.5517 11.7008 12.8335L14.6426 15.7753C14.7936 15.9211 14.9958 16.0018 15.2057 16C15.4156 15.9981 15.6163 15.914 15.7648 15.7655C15.9132 15.6171 15.9974 15.4163 15.9992 15.2065C16.001 14.9966 15.9203 14.7944 15.7745 14.6434L12.8327 11.7016C13.6796 10.6416 14.21 9.36406 14.3628 8.01594C14.5157 6.66782 14.2847 5.30395 13.6966 4.0813C13.1084 2.85866 12.187 1.82695 11.0383 1.10491C9.88962 0.382882 8.5604 -0.000117334 7.20365 2.69638e-08ZM2.4007 7.20443C2.4007 6.57369 2.52493 5.94914 2.7663 5.36642C3.00767 4.7837 3.36145 4.25422 3.80745 3.80823C4.25344 3.36223 4.78292 3.00845 5.36564 2.76708C5.94836 2.52571 6.57292 2.40148 7.20365 2.40148C7.83438 2.40148 8.45894 2.52571 9.04166 2.76708C9.62438 3.00845 10.1539 3.36223 10.5998 3.80823C11.0458 4.25422 11.3996 4.7837 11.641 5.36642C11.8824 5.94914 12.0066 6.57369 12.0066 7.20443C12.0066 8.47825 11.5006 9.6999 10.5998 10.6006C9.69912 11.5014 8.47747 12.0074 7.20365 12.0074C5.92983 12.0074 4.70818 11.5014 3.80745 10.6006C2.90672 9.6999 2.4007 8.47825 2.4007 7.20443Z" fill="#64666E"/>
                                                </svg>
                                            </div>
                                        </div>
                                        <div className='box-lists'>
                                            {showInput && (
                                                <div style={{height: '36px'}} className='slide-down box-lists-item'>
                                                    <input 
                                                        placeholder="Search in List"
                                                        value={searchInWantedList}
                                                        onChange={(e) => handleWantedListSearch(e)}>
                                                    </input>
                                                </div>
                                            )}

                                            {[...displayList].reverse().map((element, index) => 
                                                <div className={`box-lists-item ${theme !== 'dark' ? 'thedark' : ''}`} key={index}>
                                                    <div className="box-lists-item-content">
                                                        <img src={element.photoUrl} alt="Profile Picture" className="box-lists-item-image" />
                                                        <div className="box-lists-item-details">
                                                            <div className={`box-lists-item-title ${theme !== 'dark' ? 'dark-title' : ''}`}>{element.first_name} {element.last_name}</div>
                                                            <div className="box-lists-item-subtitle">
                                                                {element.wanted_since} ·{" "}
                                                                <span className={element.status === 0 ? 'status-pending' : 'status-wanted'}>
                                                                {element.status === 0 ? lang.aapproval : lang.wntd}
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div onClick={() => openWantedPeople(element)} className="box-lists-item-icon">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none">
                                                            <path d="M8 0C10.1217 0 12.1566 0.842855 13.6569 2.34315C15.1571 3.84344 16 5.87827 16 8C16 10.1217 15.1571 12.1566 13.6569 13.6569C12.1566 15.1571 10.1217 16 8 16C5.87827 16 3.84344 15.1571 2.34315 13.6569C0.842854 12.1566 0 10.1217 0 8C0 5.87827 0.842854 3.84344 2.34315 2.34315C3.84344 0.842855 5.87827 0 8 0ZM9.19991 4.91165C9.79416 4.91165 10.2764 4.49911 10.2764 3.88772C10.2764 3.27634 9.79301 2.8638 9.19991 2.8638C8.60567 2.8638 8.12571 3.27634 8.12571 3.88772C8.12571 4.49911 8.60567 4.91165 9.19991 4.91165ZM9.40904 11.342C9.40904 11.2198 9.45132 10.9021 9.42733 10.7215L8.48797 11.8026C8.29369 12.0071 8.05028 12.1488 7.936 12.1111C7.88416 12.0921 7.84082 12.0551 7.8138 12.0069C7.78677 11.9587 7.77783 11.9025 7.78859 11.8483L9.35419 6.90236C9.48218 6.27498 9.13021 5.70245 8.38397 5.62931C7.5966 5.62931 6.43783 6.42811 5.73273 7.44175C5.73273 7.56289 5.70988 7.86458 5.73388 8.04514L6.67209 6.96293C6.86637 6.76066 7.09264 6.61781 7.20691 6.65667C7.26322 6.67688 7.30935 6.71835 7.33542 6.77219C7.36148 6.82603 7.3654 6.88795 7.34633 6.94465L5.79444 11.8666C5.61503 12.4425 5.95443 13.0071 6.77723 13.1351C7.98857 13.1351 8.70395 12.3557 9.41018 11.342H9.40904Z" fill="#343434"/>
                                                        </svg>
                                                    </div>
                                                </div>
                                            )}
                                        </div>
                                    </div>
                                    <div className='mdt-homepage-box-subbox-item'>
                                        <div className='mdt-homepage-box-subbox-item-header'>
                                            <div className={`announcebox-header-icon ${theme !== 'dark' ? 'actionwhite' : ''}`}>
                                                <i className="imx fa-solid fa-car"></i>
                                            </div>
                                            <div className={`announcebox-header-label ${theme !== 'dark' ? 'anbox-hd-lbl' : ''}`}>
                                                {lang.wvehicles}
                                            </div>
                                            <div onClick={() => handleSearchClickVehicle()}  className='announcebox-header-righticon'>
                                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none">
                                                    <path fillRule="evenodd" clipRule="evenodd" d="M7.20365 2.69638e-08C6.05284 0.000124636 4.91881 0.27593 3.89648 0.804329C2.87415 1.33273 1.99328 2.09834 1.32761 3.03708C0.661933 3.97582 0.230825 5.06037 0.0703713 6.19994C-0.090082 7.3395 0.0247894 8.50093 0.405369 9.58698C0.785949 10.673 1.42116 11.6521 2.25783 12.4423C3.09451 13.2324 4.10829 13.8106 5.21432 14.1285C6.32035 14.4464 7.48644 14.4947 8.61497 14.2694C9.74351 14.0441 10.8016 13.5517 11.7008 12.8335L14.6426 15.7753C14.7936 15.9211 14.9958 16.0018 15.2057 16C15.4156 15.9981 15.6163 15.914 15.7648 15.7655C15.9132 15.6171 15.9974 15.4163 15.9992 15.2065C16.001 14.9966 15.9203 14.7944 15.7745 14.6434L12.8327 11.7016C13.6796 10.6416 14.21 9.36406 14.3628 8.01594C14.5157 6.66782 14.2847 5.30395 13.6966 4.0813C13.1084 2.85866 12.187 1.82695 11.0383 1.10491C9.88962 0.382882 8.5604 -0.000117334 7.20365 2.69638e-08ZM2.4007 7.20443C2.4007 6.57369 2.52493 5.94914 2.7663 5.36642C3.00767 4.7837 3.36145 4.25422 3.80745 3.80823C4.25344 3.36223 4.78292 3.00845 5.36564 2.76708C5.94836 2.52571 6.57292 2.40148 7.20365 2.40148C7.83438 2.40148 8.45894 2.52571 9.04166 2.76708C9.62438 3.00845 10.1539 3.36223 10.5998 3.80823C11.0458 4.25422 11.3996 4.7837 11.641 5.36642C11.8824 5.94914 12.0066 6.57369 12.0066 7.20443C12.0066 8.47825 11.5006 9.6999 10.5998 10.6006C9.69912 11.5014 8.47747 12.0074 7.20365 12.0074C5.92983 12.0074 4.70818 11.5014 3.80745 10.6006C2.90672 9.6999 2.4007 8.47825 2.4007 7.20443Z" fill="#64666E"/>
                                                </svg>
                                            </div>
                                        </div>
                                        <div className='box-lists'>
                                            {showInputVehicle && (
                                                <div style={{height: '36px'}} className='slide-down box-lists-item'>
                                                    <input 
                                                        placeholder="Search in List"
                                                        value={searchInWantedVehList}
                                                        onChange={(e) => handleWantedListVehicleSearch(e)}>
                                                    </input>
                                                </div>
                                            )}
                                            
                                            {filteredWantedVehicles.map((element, index) => (
                                                <div key={index} className={`box-lists-item ${theme !== 'dark' ? 'thedark' : ''}`}>
                                                    <div className="box-lists-item-content">
                                                        <img src={`https://docs.fivem.net/vehicles/${element.model}.webp`} alt="Profile Picture" className="box-lists-item-image" />
                                                        <div className="box-lists-item-details">
                                                            <div className={`box-lists-item-title ${theme !== 'dark' ? 'dark-title' : ''}`}>{element.modellabel}</div>
                                                            <div className="box-lists-item-subtitle">
                                                                {element.plate} ·{" "}
                                                                <span className={element.status === 0 ? 'status-pending' : 'status-wanted'}>
                                                                {element.status === 0 ? lang.aapproval : lang.wntd}
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div onClick={() => openWantedVehicleModal(element)} className="box-lists-item-icon">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none">
                                                            <path d="M8 0C10.1217 0 12.1566 0.842855 13.6569 2.34315C15.1571 3.84344 16 5.87827 16 8C16 10.1217 15.1571 12.1566 13.6569 13.6569C12.1566 15.1571 10.1217 16 8 16C5.87827 16 3.84344 15.1571 2.34315 13.6569C0.842854 12.1566 0 10.1217 0 8C0 5.87827 0.842854 3.84344 2.34315 2.34315C3.84344 0.842855 5.87827 0 8 0ZM9.19991 4.91165C9.79416 4.91165 10.2764 4.49911 10.2764 3.88772C10.2764 3.27634 9.79301 2.8638 9.19991 2.8638C8.60567 2.8638 8.12571 3.27634 8.12571 3.88772C8.12571 4.49911 8.60567 4.91165 9.19991 4.91165ZM9.40904 11.342C9.40904 11.2198 9.45132 10.9021 9.42733 10.7215L8.48797 11.8026C8.29369 12.0071 8.05028 12.1488 7.936 12.1111C7.88416 12.0921 7.84082 12.0551 7.8138 12.0069C7.78677 11.9587 7.77783 11.9025 7.78859 11.8483L9.35419 6.90236C9.48218 6.27498 9.13021 5.70245 8.38397 5.62931C7.5966 5.62931 6.43783 6.42811 5.73273 7.44175C5.73273 7.56289 5.70988 7.86458 5.73388 8.04514L6.67209 6.96293C6.86637 6.76066 7.09264 6.61781 7.20691 6.65667C7.26322 6.67688 7.30935 6.71835 7.33542 6.77219C7.36148 6.82603 7.3654 6.88795 7.34633 6.94465L5.79444 11.8666C5.61503 12.4425 5.95443 13.0071 6.77723 13.1351C7.98857 13.1351 8.70395 12.3557 9.41018 11.342H9.40904Z" fill="#343434"/>
                                                        </svg>
                                                    </div>
                                                </div>
                                            ))}

                                        </div>
                                    </div>
                                    <div className='mdt-homepage-box-subbox-item'>
                                        <div className='mdt-homepage-box-subbox-item-header'>
                                            <div className={`announcebox-header-icon ${theme !== 'dark' ? 'actionwhite' : ''}`}>
                                                <i className="imx fa-solid fa-gun"></i>
                                            </div>
                                            <div className={`announcebox-header-label ${theme !== 'dark' ? 'anbox-hd-lbl' : ''}`}>
                                                {lang.wlicenses}
                                            </div>
                                            <div onClick={() => setWeaponModal(true)} className='announcebox-header-righticon'>
                                                <i style={{}} className="imx fa-regular fa-plus"></i>
                                            </div>
                                        </div>
                                        <div className='box-lists'>
                                            {weaponlicenses.map((element, index) => 
                                                <div className={`box-lists-item ${theme !== 'dark' ? 'thedark' : ''}`}>
                                                <div className="box-lists-item-content">
                                                    <img src={element.photoUrl} alt="Profile Picture" className="box-lists-item-image" />
                                                    <div className="box-lists-item-details">
                                                        <div className={`box-lists-item-title ${theme !== 'dark' ? 'dark-title' : ''}`}>{element.playername}</div>
                                                        <div className="box-lists-item-subtitle">{lang.type}: {capitalize(element.weapon_type)}</div>
                                                    </div>
                                                </div>
                                                <div  onClick={() => openLicenseModal(element)} className="box-lists-item-icon">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none">
                                                        <path d="M8 0C10.1217 0 12.1566 0.842855 13.6569 2.34315C15.1571 3.84344 16 5.87827 16 8C16 10.1217 15.1571 12.1566 13.6569 13.6569C12.1566 15.1571 10.1217 16 8 16C5.87827 16 3.84344 15.1571 2.34315 13.6569C0.842854 12.1566 0 10.1217 0 8C0 5.87827 0.842854 3.84344 2.34315 2.34315C3.84344 0.842855 5.87827 0 8 0ZM9.19991 4.91165C9.79416 4.91165 10.2764 4.49911 10.2764 3.88772C10.2764 3.27634 9.79301 2.8638 9.19991 2.8638C8.60567 2.8638 8.12571 3.27634 8.12571 3.88772C8.12571 4.49911 8.60567 4.91165 9.19991 4.91165ZM9.40904 11.342C9.40904 11.2198 9.45132 10.9021 9.42733 10.7215L8.48797 11.8026C8.29369 12.0071 8.05028 12.1488 7.936 12.1111C7.88416 12.0921 7.84082 12.0551 7.8138 12.0069C7.78677 11.9587 7.77783 11.9025 7.78859 11.8483L9.35419 6.90236C9.48218 6.27498 9.13021 5.70245 8.38397 5.62931C7.5966 5.62931 6.43783 6.42811 5.73273 7.44175C5.73273 7.56289 5.70988 7.86458 5.73388 8.04514L6.67209 6.96293C6.86637 6.76066 7.09264 6.61781 7.20691 6.65667C7.26322 6.67688 7.30935 6.71835 7.33542 6.77219C7.36148 6.82603 7.3654 6.88795 7.34633 6.94465L5.79444 11.8666C5.61503 12.4425 5.95443 13.0071 6.77723 13.1351C7.98857 13.1351 8.70395 12.3557 9.41018 11.342H9.40904Z" fill="#343434"/>
                                                    </svg>
                                                </div>
                                            </div>)}
                                        </div>
                                    </div>
                                </div>
                            </div>
                            )}
                           
                            {isCrimeTableOpen && <CrimeTable theme={theme} lang={lang} crimeList={mdtData.cidcrimes} vehCrimes={mdtData.vehcrimes}></CrimeTable>}
                            {officersScreen && <OfficersScreenX theme={theme} officers={mdtData.officers} lang={lang} grades={mdtData.allgrades}></OfficersScreenX>}
                            {citizenProfileScreen && <CitizenQuery theme={theme} crimes={allCrimes} lang={lang} onClose={() => toggleBaba()} data={cidProfileData} onOpen={() => ToggleCriminalRecordScreen('citizen')}></CitizenQuery>}
                            {vehicleProfileScreen && <VehicleProfileScreen theme={theme} onClose={toggleVehicleBaba} crimes={allVehicleCrimes} lang={lang} data={vehProfileData} onOpen={() => ToggleCriminalRecordScreen('vehicle')}></VehicleProfileScreen>}
                            {isVehicleQueryPage && <VehicleQueryPage theme={theme} onClose={() => setIsVehicleQueryPage(false)} vehicles={mdtData.vehicles} lang={lang} setVehicleProfileData={setVahcanP} isVehicleProfileScreen={setVehProfile} isOpened={isVehicleQueryPage}></VehicleQueryPage>}
                            {isCitizenQueryPage && <CitizenQueryPage theme={theme} onClose={() => setIsCitizenQueryPage(false)} isCitizenProfile={citizenProfileScreen} setCitizenProfile={setCitizenProfileScreen} setProfileData={setCitizenProfileData} isOpened={isCitizenQueryPage} players={mdtData.players} lang={lang}></CitizenQueryPage>}
                            {isCrimeDatabase && <CrimeDatabase theme={theme} wantedVehicles={wantedVehicles} wantedList={wantedList} cidCrimes={allCrimes} vehCrimes={allVehicleCrimes} lang={lang}></CrimeDatabase>}
                            {isSopApp && <SopApp theme={theme} lang={lang}></SopApp>}
                            {isMdtHistory && <MdtHistory theme={theme} history={mdtHistory} lang={lang}></MdtHistory>}
                            {isMdtChat && <MDTChat lang={lang} playerName={tabOwnerName} allMessages={allMessages}></MDTChat>}

                        </div>                    
                    </div>

                    {isLicenseModalOpen && selectedLicense && (
                        <div className="license-modal-overlay" onClick={closeLicenseModal}>
                            <div className="license-modal-content" onClick={(e) => e.stopPropagation()}>
                            <img
                                src={selectedLicense.photoUrl || Avatar}
                                alt="Profile"
                                className="license-modal-photo"
                            />
                            <h2 style={{marginBottom: '.5rem'}}>{selectedLicense.playername}</h2>
                            <div className='ayir'></div>
                            <div className='parts'>
                                <div className='partone'>
                                    <h3>{lang.wtype}</h3>
                                    <span className='weapon-type'>{capitalize(selectedLicense.weapon_type)}</span>
                                </div>
                                <div className='partone'>
                                    <h3>{lang.lnumber}</h3>
                                    <span className='weapon-type'>{selectedLicense.license_number || 'N/A'}</span>
                                </div> 
                                <div className='partone'>
                                    <h3>{lang.addedby}</h3>
                                    <span className='weapon-type'>{selectedLicense.issued_by || 'Unknown Officer'}</span>
                                </div>
                                <div className='partone'>
                                    <h3>{lang.dateofissue}</h3>
                                    <span className='weapon-type'>{selectedLicense.issued_at || 'N/A'}</span>
                                </div>
                                <div className='partone'>
                                    <h3>{lang.expirationdate}</h3>
                                    <span className='weapon-type'>{selectedLicense.expiration_date || 'N/A'}</span>
                                </div>
                                <div className='partone'>
                                    <h3>{lang.status}</h3>
                                    <span className='weapon-type'>{selectedLicense.status || 'Unknown'}</span>
                                </div>
                            </div>
                            <div onClick={closeLicenseModal} className="close-btn">{lang.close}</div>
                            </div>
                        </div>
                    )}


                    {isLicenseModalOpen && selectedWantedVehicle && (
                        <div className="license-modal-overlay" onClick={closeLicenseModal}>
                            <div className="license-modal-content" onClick={(e) => e.stopPropagation()}>
                            <div onClick={closeLicenseModal} className="close-btn-5" style={{float: 'right', cursor: 'pointer'}}><i class="fa-solid fa-xmark"></i></div>
                            <img
                                src={selectedWantedVehicle.photoUrl || Avatar}
                                alt="Profile"
                                className="license-modal-photo"
                            />
                            <h2>{selectedWantedVehicle.modellabel}</h2>
                            <p>Created by {selectedWantedVehicle.added_by}</p>
                            <div className='ayir'></div>
                            <div className='parts'>
                                <div className='partone'>
                                    <h3>{lang.plate}</h3>
                                    <span className='weapon-type'>{selectedWantedVehicle.plate}</span>
                                </div>
                                <div className='partone'>
                                    <h3>{lang.color}</h3>
                                    <span className='weapon-type'>{selectedWantedVehicle.color}</span>
                                </div> 
                                <div className='partone'>
                                    <h3>{lang.llocation}</h3>
                                    <span className='weapon-type'>{selectedWantedVehicle.last_seen_location}</span>
                                </div>
                                <div className='partone'>
                                    <h3>{lang.wsince}</h3>
                                    <span className='weapon-type'>{selectedWantedVehicle.wanted_since}</span>
                                </div>
                                <div className='partone'>
                                    <h3>{lang.wlevel}</h3>
                                    <span className='weapon-type'>{selectedWantedVehicle.danger_level}</span>
                                </div>
                                <div className='partone'>
                                    <h3>{lang.reason}</h3>
                                    <span className='weapon-type'>{selectedWantedVehicle.reason}</span>
                                </div>
                            </div>
                            <div className='fotolar'>
                                <span>{lang.media}</span>
                                    <div className='photos'>
                                        {selectedWantedVehicle.medias.map((element, index) => (
                                            <img key={element.id} src={element.url} />
                                        ))}
                                    </div>
                                </div>
                            </div>
                        </div>
                    )}

                    { isLicenseModalOpen && selectedWantedCitizen && (
                        <div className="license-modal-overlay" onClick={closeLicenseModal}>
                            <div className="license-modal-content" onClick={(e) => e.stopPropagation()}>
                                <div onClick={closeLicenseModal} className="close-btn-5" style={{float: 'right', cursor: 'pointer'}}><i class="fa-solid fa-xmark"></i></div>
                                <img
                                    src={selectedWantedCitizen.photoUrl || Avatar}
                                    alt="Profile"
                                    className="license-modal-photo"
                                />
                                <h2>{selectedWantedCitizen.first_name} {selectedWantedCitizen.last_name}</h2>
                                <p>{selectedWantedCitizen.cid}</p>
                                <div className='ayir'></div>
                                <div className='parts'>
                                    <div className='partone'>
                                        <h3>{lang.wsince}</h3>
                                        <span className='weapon-type'>{selectedWantedCitizen.wanted_since}</span>
                                    </div>
                                    <div className='partone'>
                                        <h3>{lang.identitynum}</h3>
                                        <span className='weapon-type'>{selectedWantedCitizen.cid}</span>
                                    </div> 
                                    <div className='partone'>
                                        <h3>{lang.llocation}</h3>
                                        <span className='weapon-type'>{selectedWantedCitizen.last_seen_location}</span>
                                    </div>
                                    <div className='partone'>
                                        <h3>{lang.wlevel}</h3>
                                        <span className='weapon-type'>{selectedWantedCitizen.danger_level}</span>
                                    </div>
                                    <div className='partone'>
                                        <h3>{lang.addedby}</h3>
                                        <span className='weapon-type'>{selectedWantedCitizen.added_by}</span>
                                    </div>
                                </div>
                                <div className='fotolar'>
                                    <span>{lang.media}</span>
                                    <div className='photos'>
                                        {selectedWantedCitizen.medias.map((element, index) => (
                                            <img key={element.id} src={element.url} />
                                        ))}
                                    </div>
                                </div>
                            </div>
                        </div>
                    )}

                    <AnimatePresence>
                    {isVehicleCriminalModal && (
                        <motion.div
                            initial={{ opacity: 0, scale: 0.95, zIndex: 9999 }}
                            animate={{ opacity: 1, scale: 1, zIndex: 9999 }}
                            exit={{ opacity: 0, scale: 0.95, zIndex: 9999 }}
                            transition={{ duration: 0.2 }}
                            style={{
                            position: 'fixed',
                            top: 0,
                            left: 0,
                            width: '100%',
                            height: '100%',
                            zIndex: 9999, // garantiye alalım
                            display: 'flex',
                            justifyContent: 'center',
                            alignItems: 'center',
                            pointerEvents: 'auto',
                            }}
                        >

                        <CreateVehicleCrime
                            isOpen={isVehicleCriminalModal}
                            onClose={() => setVehicleCriminalRecordAdd(false)}
                            lang={lang}
                            NotificationX={NotificationX}
                            vehCrimes={mdtData.vehcrimes}
                            dataLand={vehProfileData}
                            location={padres}
                            theme={theme}
                            players={mdtData.players}
                            openApp={openApp}
                            vehicles={mdtData.vehicles}
                        />
                        </motion.div>
                        
                    )}

                    {IscriminalRecordAdd && (
                         <motion.div
                         initial={{ opacity: 0, scale: 0.95, zIndex: 9999 }}
                         animate={{ opacity: 1, scale: 1, zIndex: 9999 }}
                         exit={{ opacity: 0, scale: 0.95, zIndex: 9999 }}
                         transition={{ duration: 0.2 }}
                         style={{
                           position: 'fixed',
                           top: 0,
                           left: 0,
                           width: '100%',
                           height: '100%',
                           zIndex: 9999, // garantiye alalım
                           display: 'flex',
                           justifyContent: 'center',
                           alignItems: 'center',
                           pointerEvents: 'auto',
                         }}
                       >
                        <CriminalRecord
                            isOpen={IscriminalRecordAdd}
                            onClose={() => setCriminalRecordAdd(false)}
                            lang={lang}
                            NotificationX={NotificationX}
                            setColdModal2={setColdModal2}
                            judMode={judMode}
                            dataLand={cidProfileData}
                            cidCrimes={mdtData.cidcrimes}
                            location={padres}
                            openApp={openApp}
                            theme={theme}
                            players={mdtData.players}
                        />
                        </motion.div>
                    )}
                    </AnimatePresence>

                    <ColdModal
                        appName="MDT"
                        title={lang.success}
                        message={lang.dojwax}
                        isOpen={openedColdModal}
                        onClose={() => setColdModal(null)}
                        buttons={[
                            { label: lang.ok, onClick: () => setColdModal(null) }
                        ]}
                    />

                    <ColdModal
                        appName="MDT"
                        title={lang.success}
                        message={lang.awaintcrime}
                        isOpen={openedColdModal2}
                        onClose={() => setColdModal2(null)}
                        buttons={[
                            { label: lang.ok, onClick: () => setColdModal2(null) }
                        ]}
                    />

                    <AnimatePresence>
                    {isModalCreateWantedRecord && (
                        <motion.div
                        initial={{ opacity: 0, scale: 0.95 }}
                        animate={{ opacity: 1, scale: 1 }}
                        exit={{ opacity: 0, scale: 0.95 }}
                        transition={{ duration: 0.25 }}
                        style={{
                            position: 'fixed',
                            top: 0,
                            left: 0,
                            width: '100%',
                            height: '100%',
                            zIndex: 9999, // garantiye alalım
                            display: 'flex',
                            justifyContent: 'center',
                            alignItems: 'center',
                            pointerEvents: 'auto',
                          }}
                        >
                        <CreateWanted
                            isOpen={isModalCreateWantedRecord}
                            onClose={() => setModalCreateWantedRecord(false)}
                            NotificationX={NotificationX}
                            padres={padres}
                            judMode={judMode}
                            setColdModal={setColdModal}
                            openedColdModal={openedColdModal}
                            lang={lang}
                            openApp={openApp}
                            theme={theme}
                            players={mdtData.players}
                            vehicles={mdtData.vehicles}
                        />
                        </motion.div>
                    )}
                    </AnimatePresence>

                    <AnimatePresence>
                    {addAnnounceModal && (
                        <motion.div
                        initial={{ opacity: 0, scale: 0.95 }}
                        animate={{ opacity: 1, scale: 1 }}
                        exit={{ opacity: 0, scale: 0.95 }}
                        transition={{ duration: 0.25 }}
                        style={{
                            position: 'fixed',
                            top: 0,
                            left: 0,
                            width: '100%',
                            height: '100%',
                            zIndex: 9999, // garantiye alalım
                            display: 'flex',
                            justifyContent: 'center',
                            alignItems: 'center',
                            pointerEvents: 'auto',
                          }}
                        >
                        <AddAnnounceModal
                            isOpen={addAnnounceModal}
                            onClose={() => setAnnounceModal(false)}
                            NotificationX={NotificationX}
                            theme={theme}
                            lang={lang}
                        />
                        </motion.div>
                    )}
                    </AnimatePresence>

                    <AnimatePresence>
                    {weaponModal && (
                        <motion.div
                        initial={{ opacity: 0, scale: 0.95 }}
                        animate={{ opacity: 1, scale: 1 }}
                        exit={{ opacity: 0, scale: 0.95 }}
                        transition={{ duration: 0.25 }}
                        style={{
                            position: 'fixed',
                            top: 0,
                            left: 0,
                            width: '100%',
                            height: '100%',
                            zIndex: 9999, // garantiye alalım
                            display: 'flex',
                            justifyContent: 'center',
                            alignItems: 'center',
                            pointerEvents: 'auto',
                          }}
                        >
                        <WeaponLicenseModal
                            onClose={() => setWeaponModal(false)}
                            players={mdtData.players}
                            weapons={mdtData.weapons}
                            lang={lang}
                            theme={theme}
                            NotificationX={NotificationX}
                        />
                        </motion.div>
                    )}
                    </AnimatePresence>

                    
                </div>
            </>)}

        </div>
    </>)
}

export default MdtApp;