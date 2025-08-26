import React, { useState, useEffect, useRef } from 'react';
import './main.css';
import { callNui } from '@/nui';

function WeaponLicenseModal({lang, onClose, players, weapons, NotificationX}) {
  const [visible, setVisible] = useState(false);
  const [inputValue, setInputValue] = useState('');
  const [search, setSearch] = useState("");
  const [filteredPlayers, setFilteredPlayers] = useState([]);
  const inputRef = useRef(null);
  const modalRef = useRef(null);
  const dropdownRef = useRef(null);
  const [licenseCode, setLicenseCode] = useState('');
  const [weaponName, setWeaponName] = useState('');
  const [expirationDate, setExpirationDate] = useState("");
  const [licenseType, setWeaponLicenseType] = useState("");
  const [allweapons, setWeapons] = useState([]);
  const [filteredWeapons, setFilteredWeapons] = useState([]);
  const [showWeaponDropdown, setShowWeaponDropdown] = useState(false);
  const [selectedCid, setCid] = useState('');

  useEffect(() => {
    const today = new Date().toISOString().split("T")[0]; // YYYY-MM-DD formatında bugünün tarihi
    setExpirationDate(today);
    setWeapons(weapons);
  }, []);
  
  const handleDateChange = (e) => {
    setExpirationDate(e.target.value);
  };

  const generateLicenseCode = () => {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    let code = 'WL-'
    for (let i = 0; i < 5; i++) {
      code += chars.charAt(Math.floor(Math.random() * chars.length))
    }
    return code
  }

  
  useEffect(() => {
    setTimeout(() => setVisible(true), 10);
  }, []);

  const handleClose = () => {
    setVisible(false);
    setTimeout(() => onClose(), 300);
  };

  const handleWeaponSearch = (e) => {
    const value = e.target.value;
    setWeaponName(value);
  
    if (value.length > 0) {
      const filtered = allweapons.filter(w =>
        w.name.toLowerCase().includes(value.toLowerCase())
      );
      setFilteredWeapons(filtered);
    } else {
      setFilteredWeapons([]);
    }
  };
  
  const handleWeaponSelect = (weapon) => {
    setWeaponName(weapon.name);
    setLicenseCode(generateLicenseCode())
    setWeaponLicenseType(weapon.licenseType);
    setFilteredWeapons([]);
  };

  const handleSearch = (e) => {
    const value = e.target.value;
    setSearch(value);

    if (value.length > 0) {
      const filtered = players.filter((player) =>
        player.pName.toLowerCase().includes(value.toLowerCase())
      );
      setFilteredPlayers(filtered);
    } else {
      setFilteredPlayers([]);
    }
  };

  const handleSelect = (player) => {
    setSearch(player.pName);
    setCid(player.cid);
    setFilteredPlayers([]);
  };

  const CreateNewWeaponLicense = () => {
    if(search?.trim() && licenseCode?.trim() && weaponName?.trim() && licenseType?.trim() && expirationDate?.trim()){
        callNui('CreateNewLicense', {
          selectedCid,
          search,
          licenseCode,
          licenseType,
          expirationDate,
          status: 1,
        }, function(){
          onClose();
        });
        onClose();
    } else {
      NotificationX(lang.invalid, lang.emptyFields);
    }
  }

  return (
    <div className={`modal-overlay-wpn ${visible ? 'fade-in' : 'fade-out'}`} onClick={handleClose}>
      <div className={`modal-container-wpn ${visible ? 'fade-in' : 'fade-out'}`} onClick={e => e.stopPropagation()} ref={modalRef}>
        <h2>{lang.rweaponlicense}</h2>     
        <div onClick={() => onClose()} className='modal-cnt-closend'><i className='fa-regular fa-xmark'></i></div>
        <div className='bolburalari'></div>
        <div className='bimbox'>
            <span className='bimbox-label'>{lang.scitizen}</span>
            <input
              className="bimbox-input"
              placeholder="Search Player"
              value={search}
              onChange={handleSearch}
            />   
            {filteredPlayers.length > 0 && (
                <ul className="player-list">
                  {filteredPlayers.map((player) => (
                    <li key={player.id} onClick={() => handleSelect(player)}>
                      {player.pName}
                    </li>
                  ))}
                </ul>
              )}     
        </div>
        <div className='bimbox'>
          <span className='bimbox-label'>{lang.weapon}</span>
          <input
            className="bimbox-input"
            placeholder="Weapon Name"
            value={weaponName}
            onChange={handleWeaponSearch}
            onFocus={() => setShowWeaponDropdown(true)}
            onBlur={() => {
              setTimeout(() => setShowWeaponDropdown(false), 150);
            }}
          />
          <ul className={`weapon-dropdown ${showWeaponDropdown ? 'open' : ''}`}>
            {filteredWeapons.map((w, i) => (
              <li key={i} onClick={() => handleWeaponSelect(w)}>
                {w.name}
              </li>
            ))}
          </ul>
        </div>

        <div className='bimbox'>
            <span className='bimbox-label'>{lang.licenseCode}</span>
            <input
              className="bimbox-input"
              placeholder="License Code"
              value={licenseCode}
              onChange={(e) => setLicenseCode(e.target.value)}
            />   
        </div>

        <div className='bimbox'>
            <span className='bimbox-label'>{lang.ltype}</span>
            <input
              className="bimbox-input"
              placeholder="License Type"
              value={licenseType}
              onChange={(e) => setWeaponLicenseType(e.target.value)}
            />   
        </div>
        <div className='bimbox'>
            <span className='bimbox-label'>{lang.expirationdate}</span>
            <input
              className="bimbox-input"
              type="date"
              value={expirationDate}
              onChange={handleDateChange}
            /> 
        </div>
        <div onClick={() => CreateNewWeaponLicense()} className='button-create-license'>
            {lang.register}
        </div>
      </div>
    </div>
  );
}

export default WeaponLicenseModal;
