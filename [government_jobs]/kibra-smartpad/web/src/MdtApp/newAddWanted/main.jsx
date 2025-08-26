import React, {useEffect, useState, useRef, useCallback} from 'react';
import './main.css';
import Avatar from '/public/avatar.png';
import { useNui, callNui } from '@/nui';
import CameraModal from '@/CameraModal/main';
import { color } from 'framer-motion';

const NewCreateWanted = ({isOpen, onClose, padres, lang, openApp, NotificationX, players, vehicles, judMode, setColdModal, openedColdModal}) => {
     const [offenceValue, setOffences] = useState('');
    const [crimeLocation, UpdateCrimeLocation] = useState('');
    const [data, setData] = useState("");
    const [currentDate, setCurrentDate] = useState('');
    const [currentTime, setCurrentTime] = useState('');
    const [wantedType, setWantedType] = useState('person');
    const [adress, setAddress] = useState('');
    const [photoLink, setFoto] = useState('');
    const [filteredPlayers, setFilteredPlayers] = useState([]);
    const [showPlayerDropdown, setShowPlayerDropdown] = useState(false);
    const [firstname, setFirstname] = useState('');
    const [curCid, setIdentifier] = useState('unkown');
    const [lastname, setLastname] = useState('');
    const [isLoading, setIsLoading] = useState(false)
    const [details, setDetails] = useState('');
    const [plate, setPlate] = useState('');
    const [vehicleModel, setModel] = useState('');
    const [location, setLocation] = useState('');
    const [dangerLevel, setLevel] = useState(1);
    const [filteredPlates, setFilteredPlates] = useState([]);
    const [orgModel, setOrgModel] = useState('');
    const [showPlateDropdown, setShowPlateDropdown] = useState(false);
    
    useEffect(() => {
        if (firstname.trim() !== '') {
            const results = players.filter(p =>
                p.pName.toLowerCase().includes(firstname.toLowerCase())
            );
            setFilteredPlayers(results);
            setShowPlayerDropdown(true);
        } else {
            setShowPlayerDropdown(false);
        }
    }, [firstname]);
    
    useEffect(() => {
        if (plate.trim() !== '') {
            const results = vehicles.filter(v =>
                v.plate.toLowerCase().includes(plate.toLowerCase())
            );
            setFilteredPlates(results);
            setShowPlateDropdown(true);
        } else {
            setShowPlateDropdown(false);
        }
    }, [plate]);

    
    const selectPlayer = (player, identifier) => {
        const [first, ...last] = player.pName.split(' ');
        setFirstname(first);
        setIdentifier(identifier);
        setLastname(last.join(' '));
        setShowPlayerDropdown(false);
    }

    const selectPlate = (vehicle) => {
        setPlate(vehicle.plate);
        setModel(vehicle.model);
        setOrgModel(vehicle.orgmodel);
        setShowPlateDropdown(false);
    };
    
    const setPhotoLink = (newLink) => {
        addPhoto(newLink);
        setFoto(newLink);
    }

    const [addedPhotos, setAddedPhotos] = useState([]);
    const [checked, setChecked] = useState({ citizen: false, vehicle: false });

    const addPhoto = (dataurl) => {
        const newPhoto = {
          id: addedPhotos.length + 1,
          url: dataurl
        };
    
        setAddedPhotos(prevPhotos => [...prevPhotos, newPhoto]);
      };

    const [selected, setSelected] = useState('citizen');

    useEffect(() => {
        const now = new Date();
        const formattedDate = now.toISOString().slice(0, 10); 
        const formattedTime = now.toTimeString().slice(0, 5);
        setCurrentDate(formattedDate);
        setCurrentTime(formattedTime);
        setAddress(padres);
    }, []); 

    useEffect(() => {
        useNui("openApp", (data) => {
            openApp('mdt', 'openmdtforcamera')
            addPhoto(data.url);
        });
    })

    const colors = ['Red', 'Green', 'Blue', 'Yellow', 'Orange', 'Purple', 'Black', 'White']
    const [showList, setShowList] = useState(false)
    const [selectedColor, setSelectedColor] = useState('');
    const listRef = useRef(null)
    const handleClickOutside = e => {
      if(listRef.current && !listRef.current.contains(e.target)) setShowList(false)
    }

    useEffect(() => {
        setLocation(padres);
        document.addEventListener('mousedown', handleClickOutside)
        return () => document.removeEventListener('mousedown', handleClickOutside)
    }, []);

    const [openedCameraModal, setCameraModal] = useState(false);

    const toggleCameraApp = useCallback(() => {
        callNui('ToggleCameraAppModule', {});
        setCameraModal(prevState => !prevState);
    }, []);

    const CreateWanted = () => {
        if (selected == 'citizen') {
            if (firstname?.trim() && lastname?.trim() && details?.trim() && location?.trim()) {
                if ((dangerLevel >= 1) && (dangerLevel <= 5)) {  // <-- Burada String'e çevrildi
                    callNui('CreateNewWanted', {
                        type: selected,
                        cid: curCid,
                        firstname,
                        lastname,
                        details,
                        location,
                        dangerlevel: dangerLevel,
                        medias: addedPhotos
                    });
                    callNui('CloseCameraApp', {});
                    onClose();
                } else {
                    NotificationX(lang.invalid, lang.wantedLevelReq);
                }
            } else {
                NotificationX(lang.invalid, lang.emptyFields);
            }
        } else {
            if(plate?.trim() && vehicleModel?.trim() && details?.trim() && location?.trim() && selectedColor?.trim()) {
                if ((dangerLevel >= 1) && (dangerLevel <= 5)) {  // <-- Burada String'e çevrildi
                    callNui('CreateNewWanted', {
                        type: selected,
                        cid: curCid,
                        plate,
                        vehicleModel,
                        selectedColor,
                        orgModel,
                        details,
                        location,
                        dangerlevel: dangerLevel,
                        medias: addedPhotos
                    });
                    callNui('CloseCameraApp', {});
                    onClose();
                } else {
                    NotificationX(lang.invalid, lang.wantedLevelReq);
                }
            } else {
                NotificationX(lang.invalid, lang.emptyFields);
            }
        }

        if(judMode !== 'POLICE'){
            setColdModal(true);
        }
    };
    
    return (
        <>
            <div className={`createwanted-container ${isOpen ? "show" : ""}`}>
                <div className='create-wanted-box'>
                    <div className='criminal-record-title'>
                        Add New Wanted
                        <i onClick={() => onClose()}style={{float: 'right', color: '#757575', cursor: 'pointer'}} className="fa-solid fa-xmark"></i>
                    </div>
                    <div className='wanted-type-box'>
                        <span>Wanted Type</span>
                        <div className="checkbox-container">
                            {[
                                { label: "Citizen", type: "citizen" },
                                { label: "Vehicle", type: "vehicle" },
                            ].map(({ label, type }) => (
                                <label key={type} className="checkbox-label">
                                <input
                                    type="radio"
                                    name="selection"
                                    className="hidden-checkbox"
                                    value={type}
                                    checked={selected === type}
                                    onChange={() => setSelected(type)}
                                />
                                <div className={`custom-checkbox ${selected === type ? "checked" : ""}`}>
                                    {selected === type && <div className="checkbox-indicator"></div>}
                                </div>
                                <span className="checkbox-text">{label}</span>
                                </label>
                            ))}
                        </div>
                    </div>
                    <div className='criminal-record-content'>
                        {selected == 'citizen' ? 
                            <>
                                <div className='record-box' style={{ position: 'relative' }}>
                                    <span className=''>Firstname</span>
                                    <input
                                        placeholder='Firstname'
                                        onChange={(e) => setFirstname(e.target.value)}
                                        value={firstname}
                                        onFocus={() => firstname.trim() && setShowPlayerDropdown(true)}
                                    />
                                    {showPlayerDropdown && (
                                        <ul className='dropdown-listx'>
                                            {filteredPlayers.map((player, index) => (
                                                <li
                                                    key={index}
                                                    onClick={() => selectPlayer(player, player.cid)}
                                                    className='dropdown-item'
                                                >
                                                        {player.pName}

                                                </li>
                                            ))}
                                        </ul>
                                    )}
                                </div>

                                <div className='record-box'>
                                    <span className=''>Lastname</span>
                                    <input placeholder='Lastname' onChange={(e) => setLastname(e.target.value)} value={lastname}></input>
                                </div>
                                <div className='descriptionpart'>
                                <span>Details</span>
                                <input placeholder='Add Details' onChange={(e) => setDetails(e.target.value)} value={details}></input>
                            </div>
                            </>
                        : 
                        
                        <>
                            <div className='record-box' style={{ position: 'relative' }}>
                                <span className=''>Plate</span>
                                <input
                                    placeholder='Vehicle Plate'
                                    onChange={(e) => setPlate(e.target.value)}
                                    value={plate}
                                    onFocus={() => plate.trim() && setShowPlateDropdown(true)}
                                />
                                {showPlateDropdown && (
                                    <ul className='dropdown-listx'>
                                        {filteredPlates.map((vehicle, index) => (
                                            <li
                                                key={index}
                                                onClick={() => selectPlate(vehicle)}
                                                className='dropdown-item'
                                            >
                                                {vehicle.plate} - {vehicle.modelname}
                                            </li>
                                        ))}
                                    </ul>
                                )}
                            </div>
                    

                            <div className='record-box'>
                                <span className=''>Model</span>
                                <input placeholder='Vehicle Model' onChange={(e) => setModel(e.target.value)} value={vehicleModel}></input>
                            </div>
                            <div className='record-box' style={{ position: 'relative' }}>
                                <span>Color</span>
                                <input
                                    placeholder='Vehicle Color'
                                    value={selectedColor}
                                    onChange={e => setSelectedColor(e.target.value)}
                                    onFocus={() => setShowList(true)}
                                />
                                {showList && (
                                    <ul
                                    ref={listRef}
                                    className='listref'>
                                    {colors.filter(c => c.toLowerCase().includes(selectedColor.toLowerCase())).map((c, i) => (
                                        <li key={i} onClick={() => { setSelectedColor(c); setShowList(false) }}>
                                        {c}
                                        </li>
                                    ))}
                                    </ul>
                                )}
                            </div>
                            <div className='descriptionpart'>
                                <span>Details</span>
                                <input placeholder='Add Details' onChange={(e) => setDetails(e.target.value)} value={details}></input>
                            </div>
                        </>}
                        
                        <div className='descriptionpart'>
                            <span>Wanted Level</span>
                            <input type='number' placeholder='Wanted Level' onChange={(e) => setLevel(e.target.value)} value={dangerLevel}></input>
                        </div>
                        <div className='record-box'>
                            <span className=''>Location</span>
                            <input placeholder='Location' onChange={(e) => setLocation(e.target.value)} value={location}></input>
                        </div>
                        <div className='record-box'>
                            <span className=''>Add Media</span>
                            <div className='listed-details'>
                                <div onClick={toggleCameraApp} className='listed-detail-takePhoto'>
                                    <i class="fa-solid fa-camera"></i>
                                </div>
                                {/* <div className='listed-detail-takePhoto'>
                                    <i class="fa-solid fa-image"></i>
                                </div> */}
                                {addedPhotos.map((element, index) => 
                                    <div className='listed-detail-takePhoto'>
                                        <img src={element.url}></img>
                                    </div>
                                )}
                            </div>
                        </div>
                        {judMode == 'POLICE' ? 
                            <div onClick={() => CreateWanted()} className='create-new-wanted-person'>
                                {lang.cwanted}
                            </div>
                        : 
                            <div onClick={() => CreateWanted()} className='create-new-wanted-person'>
                                {isLoading ? <div className="spinner" /> : lang.csendreq}
                            </div>
                        }
                    </div>
                </div>
            </div>

            {openedCameraModal && <CameraModal onCloseV2={toggleCameraApp} setPhotoLink={setPhotoLink}/>}
        </>
    )
}

export default NewCreateWanted;