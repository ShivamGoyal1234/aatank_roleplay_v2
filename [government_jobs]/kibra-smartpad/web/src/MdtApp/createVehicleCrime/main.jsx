import React, {useState, useEffect, useRef, createContext, useCallback} from "react"
import './main.css';
import Avatar from '/public/avatar.png';
import CameraModal from "@/CameraModal/main";
import { motion, AnimatePresence } from 'framer-motion';
import { callNui } from "@/nui";

const CreateVehicleCrime = ({isOpen, onClose, dataLand, location, lang, vehicles, NotificationX, players, vehCrimes}) => {
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
    const [vehiclePlate, setVehiclePlate] = useState('');
    const [driverName, setDriverName] = useState('');
    
    const toggleOffender = (player) => {
        const exists = offenders.some(o => o.plate === player.plate);
        if (exists) {
            setOffenders(prev => prev.filter(o => o.plate !== player.plate));
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
            !witnesses || 
            !driverName
        ) {
            NotificationX(lang.invalid, lang.emptyFields);
            return;
        }
    
        callNui('CreateVehicleCrime', {
            offenders: offenders.map(o => ({ plate: o.plate, model: o.model, owner: o.owner})),
            caseNumber: caseNumber,
            crimes: selectedCrimes,
            money: getTotalFine(),
            date: currentDate,
            time: currentTime,
            location: crimeLocation,
            medias: addedMedias,
            reason: crimeReason,
            witnesses: witnesses,
            driverName: driverName,
        });

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
    
    const returnPlayerPhoto = (model) => {
        const pathorg = `https://docs.fivem.net/vehicles/${model}.webp`;
        const path = `/web/modvehicles/${model}.png`;
        const img = new Image();
    
        return new Promise((resolve) => {
            img.onload = () => resolve(pathorg);
            img.onerror = () => {
                const img2 = new Image();
                img2.src = path;
    
                img2.onload = () => resolve(path);
                img2.onerror = () => resolve(Avatar);
            };
    
            img.src = pathorg;
        });
    };

    useEffect(() => {
        const prepareData = async () => {
            const photo = await returnPlayerPhoto(dataLand.model);
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
                const photo = await returnPlayerPhoto(off.model);
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

    const filteredCrimes = vehCrimes.filter(crime =>
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
                    <span className='crbh-text'>Add Criminal Record</span>
                    <span className='crbh-desc'>Create a new offence record</span>
                    <i onClick={() => onClose()}style={{float: 'right',
                        color: 'rgb(117, 117, 117)',
                        position: 'absolute',
                        right: '1.5rem',
                        top: '1rem',
                        cursor: 'pointer'}} className="fa-solid fa-xmark">
                    </i>
                </div>
                <div className='seperate-box'>
                    <span className='box-title'>{lang.vehicles}</span>
                    <div className='offender-multi-box'>
                        {offendersWithPhoto.map((off, i) => (
                            <div key={i} className='offender-box'>
                                <img src={off.photoUrl} />
                                <div style={{ display: 'flex', flexDirection: 'column' }}>
                                    <span className='player-name'>{off.plate} - {off.ownerName}</span>
                                    <span className='player-cid'>{off.modelname}</span>
                                </div>
                                <span className='offender-remove' onClick={() => toggleOffender(off)}>✖</span>
                            </div>
                        ))}
                        <div
                            className='offender-add-btn'
                            onClick={() => setOffenderDropdownOpen(!offenderDropdownOpen)}
                        >+ Add Car</div>
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
                                {vehicles.map((p, index) => {
                                    const selected = offenders.some(o => o.plate === p.plate);
                                    return (
                                        <div
                                            key={index}
                                            className={`offender-dropdown-item ${selected ? 'selected' : ''}`}
                                            onClick={() => toggleOffender(p)}
                                        >
                                            <span>{p.plate}</span>
                                            <span className='cid-label'>{p.modelname}</span>
                                        </div>
                                    );
                                })}
                            </motion.div>
                        )}
                    </AnimatePresence>
                </div>

                <div className='offender-box-level' ref={dropdownRef}>
                    <span className='box-title'>Crime List</span>
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
                <div className='part-linesx'>
                    <div className='part-line'>
                        <span className='box-title'>{lang.date}</span>
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
                                placeholder={lang.clocation}
                                onChange={(e) => UpdateInputLocation(e)}
                            />
                    </div>
                    <div className='part-line'>
                        <span className='box-title'>{lang.note}</span>
                            <input
                                type="text"
                                className='part-lineinput'
                                value={crimeReason}
                                placeholder={lang.note}
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
                        <span className='box-title'>{lang.driver}</span>
                        <div className='prison-dropdown-wrapper'>
                            <input
                                type="text"
                                className='part-lineinput'
                                value={driverName}
                                placeholder="John Wack"
                                onChange={(e) => setDriverName(e.target.value)}
                                onClick={() => setPrisonDropdownOpen(!prisonDropdownOpen)}
                            />

                            <AnimatePresence>
                            {prisonDropdownOpen && (
                                <motion.div
                                    initial={{ opacity: 0, height: 0 }}
                                    animate={{ opacity: 1, height: 'auto' }}
                                    exit={{ opacity: 0, height: 0 }}
                                    transition={{ duration: 0.2 }}
                                    className='prison-dropdown-list'
                                >
                                    
                                {players.map((time, index) => (
                                    <div
                                        key={index}
                                        className={`prison-dropdown-item ${prisonTime === time ? 'selected' : ''}`}
                                        onClick={() => {
                                            setDriverName(time.pName)
                                            setPrisonDropdownOpen(false)
                                        }}
                                        >
                                        {time.pName} - {time.cid}
                                    </div>
                                ))}
                                </motion.div>
                            )}
                            </AnimatePresence>
                        </div>
                    </div>
                    <div className='part-line'>
                        <span className='box-title'>Case Number</span>
                            <input
                                type="text"
                                className='part-lineinput'
                                value={caseNumber}
                                readOnly
                            />
                    </div>

                    <div className='part-line'>
                        <span className='box-title'>Media</span>
                        <div className='media-list'>
                            <div onClick={toggleCameraApp} className='add-media'>
                                Add Evidence 
                            </div>
                            {addedMedias.map((element, index) => 
                                <img src={element.url} className='evidence-img'></img>
                            )}
                        </div>
                    </div>
                    <div onClick={createNewCriminalRecord} className='create-new-crime'>
                        Create
                    </div>
                </div>
            </div>
        </div>
        {openedCameraModal && <CameraModal onCloseV2={() => setShowCamera(false)} setPhotoLink={setMedia}/>}
        </>
    )
}

export default CreateVehicleCrime;