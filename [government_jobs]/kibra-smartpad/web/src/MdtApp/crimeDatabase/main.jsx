import React, { useState, useEffect, useRef } from "react";
import "./main.css";
import Avatar from '/public/avatar.png';
import CrimeDetailsModal from "../crimeModal/main";
import { callNui } from "@/nui";

const  CrimeList = ({ lang, cidCrimes, vehCrimes, wantedList, wantedVehicles, theme}) => {
    const [query, setQuery] = useState("");
      const [photoMap, setPhotoMap] = useState({});
      const [selectedCrime, setSelectedCrime] = useState(null);
      const [isPersonalCrimes, setType] = useState('cid');
      const [modalOpen, setModalOpen] = useState(null)
      const [isModalFor, setModalForWanted] = useState(null);
      const [isModalForVeh, setModalForWantedVeh] = useState(null);
    
      const parseIfNeeded = (data, fallback = []) => {
        if (Array.isArray(data)) return data;
        if (typeof data === "string") {
          try {
            return JSON.parse(data);
          } catch {
            return fallback;
          }
        }
        return fallback;
      };
    
      const closeLicenseModal = () => {
        setModalForWanted(null);
        setModalForWantedVeh(null);
      }
    
      const openWantedModal = (data) => {
        setModalForWanted(data);
      }
    
      const openWantedModalVeh = (data) => {
        setModalForWantedVeh(data);
      }

      const deleteData = (type, data) => {
        // console.log(type, data);
        callNui('deleteDataFromMdt', {
            type: type,
            deletedData: data
        })
      }
    
      const filtered = cidCrimes.filter((c) => {
        const offenders = parseIfNeeded(c.offenders);
        return (
          offenders.some((off) =>
            `${off.name} ${off.cid}`.toLowerCase().includes(query.toLowerCase())
          ) || c.crime_id.toLowerCase().includes(query.toLowerCase())
        );
      });
    
      const filteredVeh = vehCrimes.filter((c) => {
        const cars = parseIfNeeded(c.cars);
        return (
          cars.some((off) =>
            `${off.plate} ${off.model}`.toLowerCase().includes(query.toLowerCase())
          ) || c.case_id.toLowerCase().includes(query.toLowerCase())
        );
      });
    
      const returnPlayerPhoto = async (cid) => {
        const path = `/web/pimg/${cid}.png`;
        try {
          const res = await fetch(path);
          if (res.ok) return path;
          else throw new Error();
        } catch {
          return Avatar;
        }
      };
    
      useEffect(() => {
        const load = async () => {
          const map = {};
          for (const row of filtered) {
            const offenders = parseIfNeeded(row.offenders);
            for (const o of offenders) {
              if (!map[o.cid]) map[o.cid] = await returnPlayerPhoto(o.cid);
            }
          }
          setPhotoMap(map);
        };
        load();
      }, [filtered]);
    
    return (
        <>
            <div className='vehicle-query-main-frame'>
                <div className='cquery-head'>
                    <div className={`cquery-put ${theme !== 'dark' ? 'white-bold':''}`}>
                        <svg style={{marginLeft: '1rem'}} xmlns="http://www.w3.org/2000/svg" width="17" height="18" viewBox="0 0 17 18" fill="none">
                            <path d="M16.8042 8.31747L15.2908 6.86681L13.9482 4.09644C13.8329 3.90301 13.6713 3.74347 13.4789 3.63319C13.2865 3.52291 13.0698 3.46561 12.8497 3.46682H5.28256C5.06247 3.46561 4.84579 3.52291 4.6534 3.63319C4.461 3.74347 4.29938 3.90301 4.18409 4.09644L2.84153 6.86681L1.32809 8.31747C1.26644 8.37647 1.21727 8.44797 1.18366 8.5275C1.15006 8.60703 1.13275 8.69286 1.13281 8.77962V14.1705C1.13281 14.3375 1.19711 14.4976 1.31155 14.6157C1.426 14.7338 1.58122 14.8001 1.74307 14.8001H4.18409C4.4282 14.8001 4.79435 14.5483 4.79435 14.2964V13.5409H13.3379V14.1705C13.3379 14.4224 13.582 14.8001 13.8261 14.8001H16.3892C16.5511 14.8001 16.7063 14.7338 16.8207 14.6157C16.9352 14.4976 16.9995 14.3375 16.9995 14.1705V8.77962C16.9995 8.69286 16.9822 8.60703 16.9486 8.5275C16.915 8.44797 16.8659 8.37647 16.8042 8.31747ZM5.40461 4.72607H12.7277L13.9482 7.24459H4.18409L5.40461 4.72607ZM6.01486 10.5187C6.01486 10.7705 5.64871 11.0224 5.40461 11.0224H2.84153C2.59743 11.0224 2.35333 10.6446 2.35333 10.3927V9.00755C2.47538 8.62977 2.71948 8.37792 3.08563 8.50384L5.52666 9.00755C5.77076 9.00755 6.01486 9.38532 6.01486 9.63718V10.5187ZM15.779 10.3927C15.779 10.6446 15.5349 11.0224 15.2908 11.0224H12.7277C12.4836 11.0224 12.1174 10.7705 12.1174 10.5187V9.63718C12.1174 9.38532 12.3615 9.00755 12.6056 9.00755L15.0467 8.50384C15.4128 8.37792 15.6569 8.62977 15.779 9.00755V10.3927Z" fill="white"/>
                        </svg>
                        <input placeholder={lang.searchcrime} value={query} onChange={(e) => setQuery(e.target.value)}></input>
                    </div>
                </div>
                <div className={`cquery-box ${theme !== 'dark' ? 'cqbox':''}`}>
                <div className={`cquery-header ${theme !== 'dark' ? 'white-bold' : ''}`}>
                        <span onClick={() => setType('cid')} className={`part-title2 ${theme !== 'dark' ? 'partdark' : ''}`}>{lang.ccrimes}</span>
                        <span onClick={() => setType('veh')} className={`part-title2 ${theme !== 'dark' ? 'partdark' : ''}`}>{lang.vehcrimes}</span>
                        <span onClick={() => setType('wlist')} className={`part-title2 ${theme !== 'dark' ? 'partdark' : ''}`}>{lang.wlist}</span>
                        <span onClick={() => setType('wlistveh')} className={`part-title2 ${theme !== 'dark' ? 'partdark' : ''}`}>{lang.wvehicles}</span>
                    </div>

                    {isPersonalCrimes == 'cid' && (
                        <>
                <div className={`cquery-mini-header ${theme !== 'dark' ? 'cquery-white':''}`}>
                <div style={{width: '9rem', marginLeft: '1.3rem'}}>
                                {lang.suspect}
                            </div>
                            <div style={{width: '22rem'}}>
                                {lang.caseid}
                            </div>
                            <div style={{width: '23rem'}}>
                                {lang.articles}
                            </div>
                            <div style={{width: '23rem'}}>
                                {lang.date}
                            </div>
                            <div style={{width: '5rem'}}>
                                {lang.view}
                            </div>
                        </div>
                        <div className='citizen-list'>
                            {filtered.map((crime, index) => {
                                const offenders = parseIfNeeded(crime.offenders);
                                const articles = parseIfNeeded(crime.articles);
                                return (
                                <div onClick={() => setModalOpen(crime)} className={`citizen-list-item ${theme !== 'dark' ? 'c-list-white' : ''}`}>
                                    <div style={{width: '9rem',marginLeft: '1.3rem',alignItems: 'center',display: 'flex'}}>
                                        <img src={Avatar}></img>
                                    </div>
                                    <div style={{width: '22rem',color: '#FFF',fontFamily: '"SF Pro Display"',fontSize: '16px',fontStyle: 'normal',alignItems: 'center',fontWeight: '700',lineHeight: '14.461px',display: 'flex'}}>
                                        {crime.crime_id}
                                    </div>
                                    <div style={{width: '23rem',display: 'flex',color: '#64666E',fontFamily: '"SF Pro Display"',fontSize: '16px',fontStyle: 'normal',fontWeight: '700',lineHeight: '14.461px',alignItems: 'center'}}>
                                        {articles.slice(0, 2).map((a, i) => (
                                            <span key={i}>
                                                {a.name}
                                                {i < Math.min(1, articles.length - 1) ? ", " : ""}
                                            </span>
                                            ))}
                                        {articles.length > 2 && "..."}
                                    </div>
                                    <div style={{width: '23rem',display: 'flex',color: '#64666E',fontFamily: '"SF Pro Display"',fontSize: '16px',fontStyle: 'normal',fontWeight: '700',lineHeight: '14.461px',alignItems: 'center'}}>
                                        {crime.date}
                                    </div>
                                    <div style={{width: '5rem',display: 'flex',alignItems: 'center'}}>
                                        <div onClick={(e) => { e.stopPropagation(); deleteData('crimepersonal', crime.crime_id); }} className='button-rev'>
                                            <i class="fa-solid fa-trash"></i>
                                        </div>
                                    </div>
                                </div>
                                );
                            })}
                        </div>
                        </>
                    )}


                    {isPersonalCrimes == 'veh' && (
                        <>
                <div className={`cquery-mini-header ${theme !== 'dark' ? 'cquery-white':''}`}>
                <div style={{width: '9rem', marginLeft: '1.3rem'}}>
                                {lang.suspect}
                            </div>
                            <div style={{width: '22rem'}}>
                                {lang.caseid}
                            </div>
                            <div style={{width: '23rem'}}>
                                {lang.articles}
                            </div>
                            <div style={{width: '23rem'}}>
                                {lang.date}
                            </div>
                            <div style={{width: '5rem'}}>
                                {lang.view}
                            </div>
                        </div>
                        <div className='citizen-list'>
                            {filteredVeh.map((crime, index) => {
                                const cars = parseIfNeeded(crime.cars);
                                return (
                                <div className={`citizen-list-item ${theme !== 'dark' ? 'c-list-white' : ''}`}>
                                    <div onClick={() => setModalOpen(crime)} style={{width: '9rem',marginLeft: '1.3rem',alignItems: 'center',display: 'flex'}}>
                                        <img src={Avatar}></img>
                                    </div>
                                    <div style={{width: '22rem',color: '#FFF',fontFamily: '"SF Pro Display"',fontSize: '16px',fontStyle: 'normal',alignItems: 'center',fontWeight: '700',lineHeight: '14.461px',display: 'flex'}}>
                                        {crime.case_id}
                                    </div>
                                    <div style={{width: '23rem',display: 'flex',color: '#64666E',fontFamily: '"SF Pro Display"',fontSize: '16px',fontStyle: 'normal',fontWeight: '700',lineHeight: '14.461px',alignItems: 'center'}}>
                                        {cars.slice(0, 2).map((a, i) => (
                                            <span key={i}>
                                                {a.plate}
                                                {i < Math.min(1, cars.length - 1) ? ", " : ""}
                                            </span>
                                            ))}
                                        {cars.length > 2 && "..."}
                                    </div>
                                    <div style={{width: '23rem',display: 'flex',color: '#64666E',fontFamily: '"SF Pro Display"',fontSize: '16px',fontStyle: 'normal',fontWeight: '700',lineHeight: '14.461px',alignItems: 'center'}}>
                                        {crime.date}
                                    </div>
                                    <div style={{width: '5rem',display: 'flex',alignItems: 'center'}}>
                                        <div onClick={(e) => { e.stopPropagation(); deleteData('crimevehicle', crime.case_id); }} className='button-rev'>
                                            <i class="fa-solid fa-trash"></i>
                                        </div>
                                    </div>
                                </div>
                                );
                            })}
                        </div>
                        </>
                    )}


                    {isPersonalCrimes == 'wlist' && (
                        <>
                <div className={`cquery-mini-header ${theme !== 'dark' ? 'cquery-white':''}`}>
                <div style={{width: '9rem', marginLeft: '1.3rem'}}>
                                {lang.citizenid}
                            </div>
                            <div style={{width: '22rem'}}>
                                {lang.citizenname}
                            </div>
                            <div style={{width: '23rem'}}>
                                {lang.wlevel}
                            </div>
                            <div style={{width: '23rem'}}>
                                {lang.wsince}
                            </div>
                            <div style={{width: '5rem'}}>
                                {lang.view}
                            </div>
                        </div>
                        <div className='citizen-list'>
                            {wantedList.map((crime, index) => {
                                const cars = parseIfNeeded(crime.cars);
                                return (
                                <div onClick={() => openWantedModal(crime)} className={`citizen-list-item ${theme !== 'dark' ? 'c-list-white' : ''}`}>
                                    <div style={{width: '9rem',marginLeft: '1.3rem',alignItems: 'center',display: 'flex'}}>
                                        {crime.cid}
                                    </div>
                                    <div style={{width: '22rem',color: '#FFF',fontFamily: '"SF Pro Display"',fontSize: '16px',fontStyle: 'normal',alignItems: 'center',fontWeight: '700',lineHeight: '14.461px',display: 'flex'}}>
                                        {crime.first_name} {crime.last_name}
                                    </div>
                                    <div style={{width: '23rem',display: 'flex',color: '#64666E',fontFamily: '"SF Pro Display"',fontSize: '16px',fontStyle: 'normal',fontWeight: '700',lineHeight: '14.461px',alignItems: 'center'}}>
                                        {crime.danger_level}
                                    </div>
                                    <div style={{width: '23rem',display: 'flex',color: '#64666E',fontFamily: '"SF Pro Display"',fontSize: '16px',fontStyle: 'normal',fontWeight: '700',lineHeight: '14.461px',alignItems: 'center'}}>
                                        {crime.wanted_since}
                                    </div>
                                    <div style={{width: '5rem',display: 'flex',alignItems: 'center'}}>
                                        <div onClick={(e) => { e.stopPropagation(); deleteData('wantedlist', crime.cid); }} className='button-rev'>
                                            <i class="fa-solid fa-trash"></i>
                                        </div>
                                    </div>
                                </div>
                                );
                            })}
                        </div>
                        </>
                    )}

                    {isPersonalCrimes == 'wlistveh' && (
                        <>
                <div className={`cquery-mini-header ${theme !== 'dark' ? 'cquery-white':''}`}>
                <div style={{width: '9rem', marginLeft: '1.3rem'}}>
                                {lang.plate}
                            </div>
                            <div style={{width: '22rem'}}>
                                {lang.model}
                            </div>
                            <div style={{width: '23rem'}}>
                                {lang.wlevel}
                            </div>
                            <div style={{width: '23rem'}}>
                                {lang.wsince}
                            </div>
                            <div style={{width: '5rem'}}>
                                {lang.view}
                            </div>
                        </div>
                        <div className='citizen-list'>
                            {wantedVehicles.map((crime, index) => {
                                const cars = parseIfNeeded(crime.cars);
                                return (
                                <div onClick={() => openWantedModalVeh(crime)} className={`citizen-list-item ${theme !== 'dark' ? 'c-list-white' : ''}`}>
                                    <div style={{width: '9rem',marginLeft: '1.3rem',alignItems: 'center',display: 'flex'}}>
                                        {crime.plate}
                                    </div>
                                    <div style={{width: '22rem',color: '#FFF',fontFamily: '"SF Pro Display"',fontSize: '16px',fontStyle: 'normal',alignItems: 'center',fontWeight: '700',lineHeight: '14.461px',display: 'flex'}}>
                                        {crime.modellabel}
                                    </div>
                                    <div style={{width: '23rem',display: 'flex',color: '#64666E',fontFamily: '"SF Pro Display"',fontSize: '16px',fontStyle: 'normal',fontWeight: '700',lineHeight: '14.461px',alignItems: 'center'}}>
                                        {crime.danger_level}
                                    </div>
                                    <div style={{width: '23rem',display: 'flex',color: '#64666E',fontFamily: '"SF Pro Display"',fontSize: '16px',fontStyle: 'normal',fontWeight: '700',lineHeight: '14.461px',alignItems: 'center'}}>
                                        {crime.wanted_since}
                                    </div>
                                    <div style={{width: '5rem',display: 'flex',alignItems: 'center'}}>
                                        <div onClick={(e) => { e.stopPropagation(); deleteData('wantedlistveh', crime.plate); }} className='button-rev'>
                                            <i class="fa-solid fa-trash"></i>
                                        </div>
                                    </div>
                                </div>
                                );
                            })}
                        </div>
                        </>
                    )}
                </div>
            </div>

            {isModalFor !== null && (
                    <div className="license-modal-overlay" onClick={closeLicenseModal}>
                        <div className="license-modal-content" onClick={(e) => e.stopPropagation()}>
                            <div onClick={closeLicenseModal} className="close-btn-5" style={{float: 'right', cursor: 'pointer'}}><i class="fa-solid fa-xmark"></i></div>
                            <img
                                src={isModalFor.photoUrl || Avatar}
                                alt="Profile"
                                className="license-modal-photo"
                            />
                            <h2>{isModalFor.first_name} {isModalFor.last_name}</h2>
                            <p>{isModalFor.cid}</p>
                            <div className='ayir'></div>
                            <div className='parts'>
                                <div className='partone'>
                                    <h3>{lang.wsince}</h3>
                                    <span className='weapon-type'>{isModalFor.wanted_since}</span>
                                </div>
                                <div className='partone'>
                                    <h3>{lang.identitynum}</h3>
                                    <span className='weapon-type'>{isModalFor.cid}</span>
                                </div> 
                                <div className='partone'>
                                    <h3>{lang.llocation}</h3>
                                    <span className='weapon-type'>{isModalFor.last_seen_location}</span>
                                </div>
                                <div className='partone'>
                                    <h3>{lang.wlevel}</h3>
                                    <span className='weapon-type'>{isModalFor.danger_level}</span>
                                </div>
                                <div className='partone'>
                                    <h3>{lang.addedby}</h3>
                                    <span className='weapon-type'>{isModalFor.added_by}</span>
                                </div>
                            </div>
                            <div className='fotolar'>
                                <span>{lang.media}</span>
                                <div className='photos'>
                                    {isModalFor.medias.map((element, index) => (
                                        <img key={element.id} src={element.url} />
                                    ))}
                                </div>
                            </div>
                        </div>
                    </div>
                  )}
            
                  {isModalForVeh !== null && (
                      <div className="license-modal-overlay" onClick={closeLicenseModal}>
                          <div className="license-modal-content" onClick={(e) => e.stopPropagation()}>
                          <div onClick={closeLicenseModal} className="close-btn-5" style={{float: 'right', cursor: 'pointer'}}><i class="fa-solid fa-xmark"></i></div>
                          <img
                              src={isModalForVeh.photoUrl || Avatar}
                              alt="Profile"
                              className="license-modal-photo"
                          />
                          <h2>{isModalForVeh.modellabel}</h2>
                          <p>Created by {isModalForVeh.added_by}</p>
                          <div className='ayir'></div>
                          <div className='parts'>
                              <div className='partone'>
                                  <h3>{lang.plate}</h3>
                                  <span className='weapon-type'>{isModalForVeh.plate}</span>
                              </div>
                              <div className='partone'>
                                  <h3>{lang.color}</h3>
                                  <span className='weapon-type'>{isModalForVeh.color}</span>
                              </div> 
                              <div className='partone'>
                                  <h3>{lang.llocation}</h3>
                                  <span className='weapon-type'>{isModalForVeh.last_seen_location}</span>
                              </div>
                              <div className='partone'>
                                  <h3>{lang.wsince}</h3>
                                  <span className='weapon-type'>{isModalForVeh.wanted_since}</span>
                              </div>
                              <div className='partone'>
                                  <h3>{lang.wlevel}</h3>
                                  <span className='weapon-type'>{isModalForVeh.danger_level}</span>
                              </div>
                              <div className='partone'>
                                  <h3>{lang.reason}</h3>
                                  <span className='weapon-type'>{isModalForVeh.reason}</span>
                              </div>
                              <div className='fotolar'>
                              <span>{lang.media}</span>
                                  <div className='photos'>
                                      {isModalForVeh.medias.map((element, index) => (
                                          <img key={element.id} src={element.url} />
                                      ))}
                                  </div>
                              </div>
                          </div>
                          </div>
                      </div>
                  )}
            
                  <CrimeDetailsModal
                    lang={lang}
                    isOpen={!!modalOpen} 
                    crimeData={modalOpen}
                    theme={theme}
                    onClose={() => setModalOpen(null)}
                    manageCrime={true}
                    typeland={isPersonalCrimes}
                  />
        </>
    )
}

export default  CrimeList;