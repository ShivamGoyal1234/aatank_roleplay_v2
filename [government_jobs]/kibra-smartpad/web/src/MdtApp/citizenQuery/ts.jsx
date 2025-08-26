import React, { useState, useEffect, useRef } from "react";
import "./main.css";
import Avatar from '/public/avatar.png';

const CitizenQueryPage = ({onClose, isOpened, players, lang, setCitizenProfile, isCitizenProfile, setProfileData}) => {
    const [citizenName, setCitizenName] = useState('');
    const [citizenList, setCitizenList] = useState([]);

    const VehiclePlateEvent = (e) => {
        setCitizenName(e);
    }

    useEffect(() => {
        const prepareInitialList = async () => {
            if (!players || !players.length) return
    
            const enriched = await Promise.all(players.map(async (p) => {
                const photo = await returnPlayerPhoto(p.cid)
                return { ...p, photoUrl: photo }
            }))
    
            setCitizenList(enriched)
        }
    
        prepareInitialList()
    }, [players]);

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
        const handleSearch = async () => {
            if (!players || !players.length) return
    
            if (citizenName.trim() === '') {
                const all = await Promise.all(players.map(async (p) => {
                    const photo = await returnPlayerPhoto(p.cid)
                    return { ...p, photoUrl: photo }
                }))
                setCitizenList(all)
                return
            }
    
            const search = citizenName.toLowerCase()
            const filtered = players.filter((v) =>
                v.pName.toLowerCase().includes(search) ||
                v.cid.toLowerCase().includes(search)
            )
    
            const enriched = await Promise.all(filtered.map(async (element) => {
                const photo = await returnPlayerPhoto(element.cid)
                return { ...element, photoUrl: photo }
            }))
    
            setCitizenList(enriched.reverse())
        }
    
        handleSearch()
    }, [citizenName, players]);

    const handleSett = (data) => {
        setCitizenProfile(true);
        setProfileData(data);
        onClose();
    }
    
    return (
        <div className='vehicle-query-main-frame'>
            <div className='vehicle-query-header'>
                <div className='vehicle-query-header-box'>
                    <div>
                        <i style={{color: '#ddd'}} class="fa-solid fa-user"></i>
                    </div>
                    <div className='vehicle-query-box-inp'>
                        <input placeholder={lang.citizenqueryplc} value={citizenName} onChange={(e) => VehiclePlateEvent(e.target.value)}></input>
                    </div>
                </div>
               
            </div>
            <div className="vehicles-container">
                <h1>{lang.citizens}</h1>
                <div className="table-wrapper">
                    <table className="vehicles-table">
                        <thead>
                        <tr>
                            <th>{lang.photo}</th>
                            <th>{lang.Citizenname}</th>
                            <th>{lang.job}</th>
                            <th>{lang.birthdate}</th>
                            <th>{lang.view}</th>
                        </tr>
                        </thead>
                        <tbody>
                            {citizenList.map((citizen, index) => (
                                <tr key={index}>
                                <td>
                                    <img src={citizen.photoUrl} alt="owner" className="vehicle-photo" />
                                </td>
                                <td>{citizen.pName}</td>
                                <td>{citizen.job}</td>
                                <td>{citizen.birthdate}</td>
                                <td><div onClick={() => handleSett(citizen)} className='view-button'><i className="fa-solid fa-eye"></i></div></td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    )
}

export default CitizenQueryPage;