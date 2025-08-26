import React, { useState, useEffect, useRef } from "react";
import "./main.css"
import Avatar from '/public/unkown.png';
import CrimeDetailsModal from "../crimeModal/main";

const VehicleProfileScreen = ({lang, data, onClose, crimes, onOpen, theme}) => {
    const [playerPhoto, setPhoto] = useState('');
    const [vehicleCrimes, setVehicleCrimes] = useState([]);
    const [modalOpen, setModalOpen] = useState(null)
    const [isSet, izzet] = useState('veh');


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

    const getCrimeData = (data, veh) => {
        data.typeland = veh;
        setModalOpen(data);
    }

    const parseArticles = (articles) => {
        if (!articles) return [];
      
        try {
          const parsed = typeof articles === 'string' ? JSON.parse(articles) : articles;
          return Array.isArray(parsed) ? parsed : [];
        } catch (err) {
          console.warn("Article parse error:", articles);
          return [];
        }
    };
    
      
    useEffect(() => {
        if (!crimes?.length || !data?.plate) return;
    
        const filtered = crimes.filter(crime => {
            let parsedCars = [];
    
            try {
                parsedCars = typeof crime.cars === 'string'
                    ? JSON.parse(crime.cars)
                    : crime.cars;
            } catch (err) {
                console.warn("Araç listesi JSON parse edilemedi:", crime.cars);
                return false;
            }
    
            return Array.isArray(parsedCars) && parsedCars.some(car => {
                return car.plate?.toUpperCase() === data.plate.toUpperCase();
            });
        });
    
        setVehicleCrimes(filtered);
    }, [crimes, data]);
    

    useEffect(() => {
        const prepareData = async () => {
            const photo = await returnPlayerPhoto(data.model);
            setPhoto(photo);
        };
    
        prepareData();
    }, [data]);
    
    return (
        <>
            <div className='mdt-citizenprofile-page2'>
                <div style={{width: '33%',
float: 'left',
marginLeft: '1rem',
marginTop: '1rem',
height: '22rem'}}>
                    <img src={playerPhoto}></img>
                </div>
                <div className='mdt-citizenprofile-page-left'>
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.plate}</span>
                        <span className='player-item-info-data'>{data.plate}</span>
                    </div>
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.oname}</span>
                        <span className='player-item-info-data'>{data.ownerName}</span>
                    </div>
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.model}</span>
                        <span className='player-item-info-data'>{data.modelname}</span>
                    </div>
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.vehicleColor}</span>
                        <span className='player-item-info-data'>{data.vehicleColor}</span>
                    </div>
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.wlevel}</span>
                        <span className='player-item-info-data'>{data.wantedlevel ? data.wantedlevel : lang.notwanted}</span>
                    </div>
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.class}</span>
                        <span className='player-item-info-data'>{data.class}</span>
                    </div>
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.public}</span>
                        <span className='player-item-info-data'>{data.type}</span>
                    </div>
                </div>
                <div className='mdt-citizenprofile-page-bottom'>
                <div className="container">
                        <div className="header">
                            <h1>{lang.history}</h1>
                            <button onClick={onClose} className='back-button'><i class="fa-solid fa-arrow-turn-down-left"></i></button>
                            <button onClick={onOpen} className="add-button">{lang.addrecord}</button>
                        </div>
                        <div className="table-container">
                            <table className="table">
                                <thead>
                                    <tr>
                                        <th>{lang.date}</th>
                                        <th>{lang.articles}</th>
                                        <th>{lang.cars}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                {vehicleCrimes.map((record, i) => (
                                    <tr onClick={() => getCrimeData(record, 'veh')} key={i}>
                                        <td>{record.date}</td>
                                        <td>
                                            {(() => {
                                                const crimes = parseArticles(record.crimes);
                                                const shown = crimes.slice(0, 3).map((a) => a.name).join(', ');
                                                return crimes.length > 2 ? `${shown}, ...` : shown;
                                            })()}
                                        </td>
                                        <td>{parseArticles(record.cars).map((a) => a.plate).join(', ')}</td>
                                    </tr>
                                ))}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <CrimeDetailsModal
                lang={lang}
                isOpen={!!modalOpen} 
                crimeData={modalOpen}
                theme={theme}
                onClose={() => setModalOpen(null)}
                manageCrime={false}
                typeland={isSet}
            />
        </>
    )
}

export default VehicleProfileScreen;