import React, { useState, useEffect, useRef } from "react";
import "./main.css";
import "../App.css";
import "./citizenProfileScreen.css"
import Xitizen from '/public/player.png';
import Avatar from '/public/avatar.png';
import CrimeDetailsModal from "./crimeModal/main";
import { callNui } from "@/nui";

const CitizenProfileScreen = ({lang, onOpen, data, onClose, crimes, theme}) => {
    const [playerPhoto, setPhoto] = useState('');
    const [playerCrimes, setPlayerCrimes] = useState([]);
    const [modalOpen, setModalOpen] = useState(null)
    const [isSet, izzet] = useState('cid');

    const returnPlayerPhoto = (cid) => {
        const path = `/web/pimg/${cid}.png`;
        const img = new Image();
        img.src = path;
        
        return new Promise((resolve) => {
            img.onload = () => resolve(path);
            img.onerror = () => resolve(Avatar);
        });
    }

    const selectOnMap = (data) => {
        if(data.coords !== undefined || data.coords !== null){
            callNui('SelectOnMap', {
                coords: data.coords
            });
        } 
    }

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
        if (!crimes || !data?.cid) return;
    
        const filtered = crimes.filter(crime => {
            let parsedOffenders = [];
    
            try {
                parsedOffenders = typeof crime.offenders === 'string'
                    ? JSON.parse(crime.offenders)
                    : crime.offenders;
            } catch (err) {
                console.warn("JSON parse failed for crime.offenders:", crime.offenders);
            }
    
            return Array.isArray(parsedOffenders) && parsedOffenders.some(off => off.cid === data.cid);
        });
    
        setPlayerCrimes(filtered);
    }, [crimes, data]);

    useEffect(() => {
        const prepareData = async () => {
            const photo = await returnPlayerPhoto(data.cid);
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
                        <span className='player-item-info-name'>{lang.citizenname}</span>
                        <span className='player-item-info-data'>{data.pName}</span>
                    </div>
                    {data.nationality ? 
                        <div className='player-info-item'>
                            <span className='player-item-info-name'>{lang.nationality}</span>
                            <span className='player-item-info-data'>{data.nationality}</span>
                        </div> : ''
                    }
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.citizenid}</span>
                        <span className='player-item-info-data'>{data.cid}</span>
                    </div>
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.birthdate}</span>
                        <span className='player-item-info-data'>{data.birthdate}</span>
                    </div>
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.phoneNumber}</span>
                        <span className='player-item-info-data'>{data.phone}</span>
                    </div>
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.wlevel}</span>
                        <span className='player-item-info-data'>{data.wantedlevel ? data.wantedlevel : lang.notwanted}</span>
                    </div>
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.gunlevel}</span>
                        <span className='player-item-info-data wrong'>{data.wlicense ? data.wlicense : lang.nolicense}</span>
                    </div>
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.gender}</span>
                        <span className='player-item-info-data wrong'>{data.gender == 0 ? lang.male : lang.female}</span>
                    </div>
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.dlicense}</span>
                        <span className='player-item-info-data wrong'>{data.dlicense ? lang.yes : lang.no}</span>
                    </div>
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.job}</span>
                        <span className='player-item-info-data'>{data.job}</span>
                    </div>
                    <div onClick={() => selectOnMap(data.house)} className='player-info-item'>
                        <span className='player-item-info-name'>{lang.house}</span>
                        <span className='player-item-info-data'>{data.house.name}</span>
                    </div>
                    <div className='player-info-item'>
                        <span className='player-item-info-name'>{lang.apartment}</span>
                        <span className='player-item-info-data'>{data.apartment.name}</span>
                    </div>
                </div>
                <div className='mdt-citizenprofile-page-bottom'>
                <div className="container">
                        <div className="header">
                            <h1>{lang.history}</h1>
                            <button onClick={onClose} className='back-button'><i className="fa-solid fa-arrow-left"></i></button>
                            <button onClick={onOpen} className="add-button">{lang.addrecord}</button>
                        </div>
                        <div className="table-container">
                            <table className="table">
                                <thead>
                                    <tr>
                                        <th>{lang.date}</th>
                                        <th>{lang.articles}</th>
                                        <th>{lang.resperson}</th>
                                        <th>{lang.status}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                {playerCrimes.map((record, i) => (
                                    <tr onClick={() => getCrimeData(record, 'cid')} key={i}>
                                        <td>{record.date}</td>
                                        <td>{
                                            (
                                                () => {
                                                const names = record.articles.map(s => s.name);
                                                const joined = names.join(', ');
                                                return joined.length > 40 ? joined.slice(0, 40) + '...' : joined;
                                                })()
                                            }
                                        </td>
                                        {/* <td>{parseArticles(record.articles).map((a) => a.name).join(', ')}</td> */}
                                        <td>{record.officer_name}</td>
                                        <td className={record.status === 0 ? 'status-pending' : 'status-approved'}>
                                           {record.status === 0 
                                            ? lang.pending 
                                            : record.status === 3 
                                                ? lang.rejected 
                                                : lang.approved
                                            }

                                        </td>
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

export default CitizenProfileScreen;