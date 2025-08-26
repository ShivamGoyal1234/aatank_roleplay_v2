import React, {useState, useEffect, useRef, createContext, useCallback} from "react"
import './main.css';
import Avatar from '/public/avatar.png';
import CameraModal from "@/CameraModal/main";
import { motion, AnimatePresence } from 'framer-motion';
import { callNui } from "@/nui";

const NewAddCriminalRecordModal = ({isOpen, onClose, dataLand, location, lang, players, NotificationX, cidCrimes, judMode, setColdModal2}) => {
    const [crimeLocation, UpdateCrimeLocation] = useState('');
    const [data, setData] = useState("");
    const [currentDate, setCurrentDate] = useState('');
    const [currentTime, setCurrentTime] = useState('');
    const [selectedCrimes, setSelectedCrimes] = useState([]);
    const [offenceValue, setOffenceValue] = useState('');
    const [addedMedias, setAddMedia] = useState([]);
    const [openedCameraModal, setCameraModal] = useState(false);
    const [photoLink, setPhotoLink] = useState('');
    const [crimeReason, setCrimeReason] = useState('');
    const [witnesses, setWitnesses] = useState('');
    const [prisonTime, setPrisonTime] = useState(null);
    const [prisonDropdownOpen, setPrisonDropdownOpen] = useState(false);
    const [offenders, setOffenders] = useState([dataLand]);
    const [offenderDropdownOpen, setOffenderDropdownOpen] = useState(false);
    const [offendersWithPhoto, setOffendersWithPhoto] = useState([]);
    const [caseNumber, setCaseNumber] = useState('');
    const [vehicleInvolved, setVehicleInvolved] = useState(false);
    const [vehiclePlate, setVehiclePlate] = useState('');
    
    const toggleOffender = (player) => {
        const exists = offenders.some(o => o.cid === player.cid);
        if (exists) {
            setOffenders(prev => prev.filter(o => o.cid !== player.cid));
        } else {
            setOffenders(prev => [...prev, player]);
        }
    
        setOffenderDropdownOpen(false); 
    };
    
    const createNewCriminalRecord = () => {
        if (
            offenders.length === 0 ||
            !caseNumber ||
            selectedCrimes.length === 0 ||
            !currentDate ||
            !currentTime ||
            !crimeLocation ||
            !crimeReason ||
            !witnesses 
        ) {
            NotificationX(lang.invalid, lang.emptyFields);
            return;
        }
    
        callNui('CreateNewCriminalRecord', {
            offenders: offenders.map(o => ({ cid: o.cid, name: o.pName })),
            caseNumber: caseNumber,
            crimes: selectedCrimes,
            money: getTotalFine(),
            date: currentDate,
            time: currentTime,
            location: crimeLocation,
            medias: addedMedias,
            reason: crimeReason,
            witnesses: witnesses,
            prisonTime: prisonTime,
            plate: vehiclePlate
        });

        if(judMode !== 'POLICE'){
            setColdModal2(true);
        }

        onClose();
    }
    
    useEffect(() => {
        setCaseNumber(generateCaseNumber());
    }, []);
    

    const dropdownRef = useRef(null);
    const [dropdownOpen, setDropdownOpen] = useState(false);


    const addPhoto = (dataurl) => {
        const newPhoto = {
          id: addedMedias.length + 1,
          url: dataurl
        };
    
        setAddMedia(prevPhotos => [...prevPhotos, newPhoto]);
        callNui('CloseCameraApp', {});
        setCameraModal(false);
    };

    const toggleCameraApp = useCallback(() => {
        callNui('ToggleCameraAppModule', {});
        setCameraModal(prev => !prev);
    }, []);

    const [playerPhoto, setPhoto] = useState('');

    const setMedia = (url) => {
        setPhotoLink(url);
        addPhoto(url);
    }
    
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
        const prepareData = async () => {
            const photo = await returnPlayerPhoto(dataLand.cid);
            setPhoto(photo);
        };
    
        prepareData();
    }, [data]);

    const toggleCrime = (crime) => {
        const exists = selectedCrimes.find(c => c.name === crime.name);
        if (exists) {
            setSelectedCrimes(prev => prev.filter(c => c.name !== crime.name));
        } else {
            setSelectedCrimes(prev => [...prev, crime]);
        }
    }

    const getTotalFine = () => {
        return selectedCrimes.reduce((sum, c) => sum + c.fine, 0);
    }

    const generateCaseNumber = () => {
        const date = new Date();
        const yyyy = date.getFullYear();
        const mm = String(date.getMonth() + 1).padStart(2, '0');
        const dd = String(date.getDate()).padStart(2, '0');
    
        const random = Math.random().toString(36).substring(2, 5).toUpperCase(); // 3 karakter: A-Z, 0-9
        return `CR-${yyyy}${mm}${dd}-${random}`;
    };
    

    const UpdateList = (e) => {
        setOffences(e.target.value);
    }

    const UpdateInputLocation = (e) => {
        UpdateCrimeLocation(e.target.value);
    }

    const handleDateChange = (event) => {
        setCurrentDate(event.target.value)
      };
    
      const handleTimeChange = (event) => {
        setCurrentTime(event.target.value)
    };

    useEffect(() => {
        const fetchPhotos = async () => {
            const newData = await Promise.all(offenders.map(async (off) => {
                const photo = await returnPlayerPhoto(off.cid);
                return { ...off, photoUrl: photo };
            }));
            setOffendersWithPhoto(newData);
        };
    
        if (offenders.length > 0) fetchPhotos();
    }, [offenders]);
    

    useEffect(() => {
        const now = new Date();
        const formattedDate = now.toISOString().slice(0, 10); 
        const formattedTime = now.toTimeString().slice(0, 5);
        setCurrentDate(formattedDate);
        setCurrentTime(formattedTime);
        UpdateCrimeLocation(location);
    }, []); 

    const filteredCrimes = cidCrimes.filter(crime =>
        crime.name.toLowerCase().includes(offenceValue.toLowerCase())
    );

    useEffect(() => {
        const handleClickOutside = (event) => {
          if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
            setDropdownOpen(false);
          }
        };
      
        document.addEventListener('mousedown', handleClickOutside);
        return () => {
          document.removeEventListener('mousedown', handleClickOutside);
        };
      }, []);
      

    return (
        <>
        <div className={`criminalrecord-container ${isOpen ? "show" : ""}`}>
            <div className="criminal-record-box">
                <div className='criminal-record-box-header'>
                    <span className='crbh-text'>{lang.addrecord}</span>
                    <span className='crbh-desc'>{lang.addcrimedesc}</span>
                    <i onClick={() => onClose()}style={{float: 'right',
                        color: 'rgb(117, 117, 117)',
                        position: 'absolute',
                        right: '1.5rem',
                        top: '1rem',
                        cursor: 'pointer'}} className="fa-solid fa-xmark">
                    </i>
                </div>
                <div className='seperate-box'>
                    <span className='box-title'>{lang.offenders}</span>
                    <div className='offender-multi-box'>
                        {offendersWithPhoto.map((off, i) => (
                            <div key={i} className='offender-box'>
                                <img src={off.photoUrl} />
                                <div style={{ display: 'flex', flexDirection: 'column' }}>
                                    <span className='player-name'>{off.pName}</span>
                                    <span className='player-cid'>{off.cid}</span>
                                </div>
                                <span className='offender-remove' onClick={() => toggleOffender(off)}>✖</span>
                            </div>
                        ))}
                        <div
                            className='offender-add-btn'
                            onClick={() => setOffenderDropdownOpen(!offenderDropdownOpen)}
                        >+ {lang.addoffender}</div>
                    </div>

                    <AnimatePresence>
                        {offenderDropdownOpen && (
                            <motion.div
                                initial={{ opacity: 0, height: 0 }}
                                animate={{ opacity: 1, height: 'auto' }}
                                exit={{ opacity: 0, height: 0 }}
                                transition={{ duration: 0.2 }}
                                className='offender-dropdown-list'
                            >
                                {players.map((p, index) => {
                                    const selected = offenders.some(o => o.cid === p.cid);
                                    return (
                                        <div
                                            key={index}
                                            className={`offender-dropdown-item ${selected ? 'selected' : ''}`}
                                            onClick={() => toggleOffender(p)}
                                        >
                                            <span>{p.pName}</span>
                                            <span className='cid-label'>{p.cid}</span>
                                        </div>
                                    );
                                })}
                            </motion.div>
                        )}
                    </AnimatePresence>
                </div>

                <div className='offender-box-level' ref={dropdownRef}>
                    <span className='box-title'>{lang.crimeList}</span>
                    {/* <span className='box-cost'><strong>${getTotalFine()}</strong></span> */}
                    <input
                        type='text'
                        placeholder='Search crime...'
                        className='crime-search-input'
                        value={offenceValue}
                        onChange={(e) => setOffenceValue(e.target.value)}
                        onFocus={() => setDropdownOpen(true)}
                    />

                    <AnimatePresence>
                        {dropdownOpen && filteredCrimes.length > 0 && (
                        <motion.div
                            initial={{ opacity: 0, height: 0 }}
                            animate={{ opacity: 1, height: 'auto' }}
                            exit={{ opacity: 0, height: 0 }}
                            transition={{ duration: 0.2 }}
                            className='crime-dropdown-list'
                        >
                            {filteredCrimes.map((crime, index) => {
                            const selected = selectedCrimes.some((c) => c.name === crime.name);
                            return (
                                <div
                                key={index}
                                className={`crime-dropdown-item ${selected ? 'selected' : ''}`}
                                onClick={() => toggleCrime(crime)}
                                >
                                <span>{crime.name}</span>
                                <span>${crime.fine}</span>
                                </div>
                            );
                            })}
                        </motion.div>
                        )}
                    </AnimatePresence>
                </div>
                <div className='part-lines'>
                    <div className='part-line'>
                        <span className='box-title'>{lang.dateTime}</span>
                        <div className='dateler'>
                            <input
                                type="date"
                                className="datetime-input date-input"
                                value={currentDate}
                                onChange={handleDateChange}
                            />
                            <input
                                type="time"
                                className="datetime-input time-input"
                                value={currentTime}
                                onChange={handleTimeChange}
                            />
                        </div>
                    </div>
                    <div className='part-line'>
                        <span className='box-title'>{lang.location}</span>
                            <input
                                type="text"
                                className='part-lineinput'
                                value={crimeLocation}
                                placeholder="Crime Location"
                                onChange={(e) => UpdateInputLocation(e)}
                            />
                    </div>
                    <div className='part-line'>
                        <span className='box-title'>{lang.note}</span>
                            <input
                                type="text"
                                className='part-lineinput'
                                value={crimeReason}
                                placeholder="Note"
                                onChange={(e) => setCrimeReason(e.target.value)}
                            />
                    </div>
                    <div className='part-line'>
                        <span className='box-title'>{lang.witnesses}</span>
                            <input
                                type="text"
                                className='part-lineinput'
                                value={witnesses}
                                placeholder="John Wack, Serdar Başkan"
                                onChange={(e) => setWitnesses(e.target.value)}
                            />
                    </div>
                    <div style={{zIndex: 999}} className='part-line'>
                        <span className='box-title'>{lang.prisontime}</span>
                        <div className='prison-dropdown-wrapper'>
                            <div
                            className='prison-dropdown-toggle'
                            onClick={() => setPrisonDropdownOpen(!prisonDropdownOpen)}
                            >
                            {prisonTime ? `${prisonTime} Months` : 'Select Prison Time'}
                            </div>

                            <AnimatePresence>
                            {prisonDropdownOpen && (
                                <motion.div
                                initial={{ opacity: 0, height: 0 }}
                                animate={{ opacity: 1, height: 'auto' }}
                                exit={{ opacity: 0, height: 0 }}
                                transition={{ duration: 0.2 }}
                                className='prison-dropdown-list'
                                >
                                {[0, 15, 30, 45, 60, 999].map((time, index) => (
                                    <div
                                    key={index}
                                    className={`prison-dropdown-item ${prisonTime === time ? 'selected' : ''}`}
                                    onClick={() => {
                                        setPrisonTime(time)
                                        setPrisonDropdownOpen(false)
                                    }}
                                    >
                                    {time === 0 ? 'No Jail' : time === 999 ? 'Life Sentence' : `${time} Months`}
                                    </div>
                                ))}
                                </motion.div>
                            )}
                            </AnimatePresence>
                        </div>
                    </div>
                    <div className='part-line'>
                        <span className='box-title'>{lang.casenumber}</span>
                            <input
                                type="text"
                                className='part-lineinput'
                                value={caseNumber}
                                readOnly
                            />
                    </div>
    
                    <div className='part-line'>
                        <span className='box-title'>{lang.vehplate}</span>
                        <input
                        type='text'
                        className='part-lineinput'
                        placeholder='e.g. 34ABC123'
                        value={vehiclePlate}
                        onChange={(e) => setVehiclePlate(e.target.value)}
                        />
                    </div>
                    <div className='part-line'>
                        <span className='box-title'>{lang.media}</span>
                        <div className='media-list'>
                            <div onClick={toggleCameraApp} className='add-media'>
                                {lang.addevidence} 
                            </div>
                            {addedMedias.map((element, index) => 
                                <img src={element.url} className='evidence-img'></img>
                            )}
                        </div>
                    </div>
                    <div 
                        onClick={createNewCriminalRecord} 
                        className={`create-new-crime ${judMode === 'POLICE' ? 'police-style' : 'doj-style'}`}
                        >
                        {judMode === 'POLICE' ? lang.create : lang.sentCrimeRecord}
                    </div>
                </div>
            </div>
        </div>
        {openedCameraModal && <CameraModal onCloseV2={() => setShowCamera(false)} setPhotoLink={setMedia}/>}
        </>
    )
}

export default NewAddCriminalRecordModal;