import React, {useState, useEffect, useRef, createContext, useCallback} from "react"
import './main.css';
import Avatar from '/public/avatar.png';
import CameraModal from "@/CameraModal/main";
import { callNui } from "@/nui";

const NewAddCriminalRecordModal = ({isOpen, onClose, dataLand, location, lang}) => {
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

    const crimeList = [
        { name: "Car Theft", fine: 5000 },
        { name: "Armed Robbery", fine: 8000 },
        { name: "Assault", fine: 3000 },
        { name: "Drug Possession", fine: 4500 },
        { name: "Murder", fine: 20000 },
        { name: "Speeding", fine: 1500 },
    ]

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

    const createNewCriminalRecord = () => {
        callNui('CreateNewCriminalRecord', {
            offender: data.cid,
            crimes: selectedCrimes,
            money: getTotalFine(),
            date: currentDate,
            time: currentTime,
            location: crimeLocation,
            medias: addedMedias
        })
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
        const now = new Date();
        const formattedDate = now.toISOString().slice(0, 10); 
        const formattedTime = now.toTimeString().slice(0, 5);
        setCurrentDate(formattedDate);
        setCurrentTime(formattedTime);
        UpdateCrimeLocation(location);
    }, []); 

    const filteredCrimes = crimeList.filter(crime =>
        crime.name.toLowerCase().includes(offenceValue.toLowerCase())
    );

    return (
        <>
        <div className={`criminalrecord-container ${isOpen ? "show" : ""}`}>
            <div className="criminal-record-box">
                <div className='criminal-record-title'>
                    {lang.addrecord}
                    <i onClick={() => onClose()}style={{float: 'right', color: '#757575', cursor: 'pointer'}} className="fa-solid fa-xmark"></i>
                </div>
                <div className='criminal-details'>
                    <div className='criminal-data-part'>
                        <div className='criminal-data-part-label'>Offender</div>
                        <div className='criminal-data-part-offender'>
                            <img src={playerPhoto}></img>
                            <div className='criminal-detail-part'>
                                <span className='criminal-offender-name'>{dataLand.pName}</span>
                                <span className='criminal-offender-cid'>{dataLand.cid}</span>
                            </div>
                        </div>
                    </div>
                    <div style={{ marginTop: '.6rem' }} className='criminal-data-part'>
                        <div className='criminal-data-part-label'>Offence Type</div>
                        <div className='search-offence'>
                            <i className="fa-regular fa-magnifying-glass"></i>
                            <input placeholder='Offence Name' onChange={(e) => setOffenceValue(e.target.value)} value={offenceValue}></input>
                        </div>
                        <div className='newcrime-list'>
                            {filteredCrimes.map((crime, index) => (
                                <div
                                    key={index}
                                    className='newcrime-list-item'
                                    style={{
                                        border: selectedCrimes.find(c => c.name === crime.name) ? '2px solid red' : '1px solid #ccc',
                                        cursor: 'pointer'
                                    }}
                                    
                                    onClick={() => toggleCrime(crime)}
                                >
                                    <i className="fa-solid fa-gavel"></i>
                                    <div className='crime-name'>{crime.name}</div>
                                    <div className='crime-bedel'>${crime.fine}</div>
                                </div>
                            ))}
                        </div>
                        <div className="total-fine">
                            Total Fine: <strong>${getTotalFine()}</strong>
                        </div>
                    </div>
                    <div style={{marginTop: '.6rem'}} className='criminal-data-part'>
                        <div className='criminal-data-part-label'>Date and Time</div>
                        <div className="datetime-container">
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
                    <div style={{marginTop: '1rem'}} className='criminal-data-part'>
                        <div className='criminal-data-part-label'>Location</div>
                        <div className='search-offence'>
                            <i className="fa-solid fa-map"></i>
                            <input placeholder='Location' onChange={(e) => UpdateInputLocation(e)} value={crimeLocation}></input>
                        </div>
                    </div>
                    <div style={{marginTop: '1rem'}} className='criminal-data-part'>
                        <div className='criminal-data-part-label'>Note</div>
                        <div className='search-offence'>
                            <i className="fa-solid fa-map"></i>
                            <input placeholder='Note' onChange={(e) => setCrimeReason(e.target.value)} value={crimeReason}></input>
                        </div>
                    </div>
                    <div style={{marginTop: '1rem'}} className='criminal-data-part'>
                        <div className='criminal-data-part-label'>Witnesses</div>
                        <div className='search-offence'>
                            <i className="fa-solid fa-map"></i>
                            <input placeholder='John Wack' onChange={(e) => setWitnesses(e.target.value)} value={witnesses}></input>
                        </div>
                    </div>
                    <div style={{marginTop: '.6rem'}} className='criminal-data-part'>
                        <div className='criminal-data-part-label'>Evidences</div>
                        <div className='evidences-list'>
                            <div onClick={toggleCameraApp} className='evidence-list-item'>
                                Add Evidence
                            </div>
                            {addedMedias.map((element, index) => 
                                <img src={element.url} className='evidence-img'></img>
                            )}
                        </div>
                    </div>
                    <div onClick={createNewCriminalRecord} className='create-criminalrecord'>
                        Add New Criminal Record
                    </div>
                </div>
            </div>
        </div>
        {openedCameraModal && <CameraModal onCloseV2={() => setShowCamera(false)} setPhotoLink={setMedia}/>}
        </>
    )
}

export default NewAddCriminalRecordModal;