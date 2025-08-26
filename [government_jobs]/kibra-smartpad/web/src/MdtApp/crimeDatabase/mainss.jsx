import React, { useState, useEffect } from "react";
import Avatar from "/public/avatar.png";
import './main.css';
import CrimeDetailsModal from "../crimeModal/main";

const CrimeList = ({ lang, cidCrimes, vehCrimes, wantedList, wantedVehicles, theme}) => {
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
      <div style={{
        display: "flex",
        flexDirection: "column",
        height: "100%",
        maxHeight: "100vh",
        overflow: "hidden",
        padding: "1rem"
      }}>
      <div className='select-crime-type'>
        <div onClick={() => setType('cid')} className='sub-div'>{lang.ccrimes}</div>
        <div onClick={() => setType('veh')} className='sub-div'>{lang.vehcrimes}</div>
        <div onClick={() => setType('wlist')} className='sub-div'>{lang.wlist}</div>
        <div onClick={() => setType('wlistveh')} className='sub-div'>{lang.wvehicles}</div>
      </div>
      <input
        type="text"
        placeholder={lang.searchcrime}
        value={query}
        className='ss'
        onChange={(e) => setQuery(e.target.value)}
        style={{
          padding: '11px 12px',
          borderRadius: '4px',
          border: 'none',
          backgroundColor: 'rgb(21 22 26)',
          color: 'rgb(255, 255, 255)',
          width: '283px',
          fontFamily: '"SF Pro"',
          marginBottom: '1rem'
        }}
      />
  
    <div className={`crime-list ${theme !== 'dark' ? 'crime-list-white' : ''}`} style={{maxHeight: '44vh',
        background: 'transparent',
        marginTop: '-0.5rem',
        display: 'table-cell'}}>
                <table style={{
        width: '100%',
        minWidth: '100%',
        borderCollapse: 'collapse',
        marginLeft: '-1.2rem',
        fontFamily: '"SF Pro"',
        color: 'rgb(187, 187, 187)'}}>
          {isPersonalCrimes == 'cid' && (
            <>
              <thead>
                <tr style={{ backgroundColor: "rgb(21 22 26)", color: "#fff" }}>
                  <th style={{ padding: "10px", textAlign: "left" }}>{lang.suspect}</th>
                  <th style={{ padding: "10px", textAlign: "left" }}>{lang.caseid} #</th>
                  <th style={{ padding: "10px", textAlign: "left" }}>{lang.articles}</th>
                  <th style={{ padding: "10px", textAlign: "left" }}></th>
                </tr>
              </thead>
              
              <tbody>
                {filtered.map((crime, index) => {
                  const offenders = parseIfNeeded(crime.offenders);
                  const articles = parseIfNeeded(crime.articles);
                  return (
                    <tr key={index} style={{ borderBottom: "1px solid rgb(36 36 36)", backgroundColor: 'rgb(14 16 20)' }}>
                      <td style={{ padding: "10px" }}>{offenders.map(o => o.name).join(", ")}</td>
                      <td style={{ padding: "10px" }}>{crime.crime_id}</td>
                      <td style={{ padding: "10px" }}>{articles.map((a, i) => (
                        <span key={i}>{a.name}{i < articles.length - 1 ? ", " : ""}</span>
                      ))}</td>
                      <td style={{ padding: "10px" }}>
                        <button
                          onClick={() => setModalOpen(crime)}
                          style={{
                            background: "none",
                            border: "none",
                            color: "#fff",
                            cursor: "pointer",
                            fontSize: "18px"
                          }}
                        >
                          <i className="fa-solid fa-eye"></i>
                        </button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
              </>
            )}

          {isPersonalCrimes == 'veh' && (
            <>
              <thead>
                <tr style={{ backgroundColor: "rgb(21 22 26)", color: "#fff" }}>
                <th style={{ padding: "10px", textAlign: "left" }}>{lang.suspect}</th>
                  <th style={{ padding: "10px", textAlign: "left" }}>{lang.caseid} #</th>
                  <th style={{ padding: "10px", textAlign: "left" }}>{lang.articles}</th>
                  <th style={{ padding: "10px", textAlign: "left" }}></th>
                </tr>
              </thead>
              <tbody>
                {filteredVeh.map((crime, index) => {
                  const cars = parseIfNeeded(crime.cars);
                  const articles = parseIfNeeded(crime.crimes);
      
                  return (
                    <tr key={index} style={{ borderBottom: "1px solid rgb(36 36 36)", backgroundColor: 'rgb(14 16 20)' }}>
                      <td style={{ padding: "10px" }}>{cars.map(o => o.plate).join(", ")}</td>
                      <td style={{ padding: "10px" }}>{crime.case_id}</td>
                      <td style={{ padding: "10px" }}>{articles.map((a, i) => (
                        <span key={i}>{a.name}{i < articles.length - 1 ? ", " : ""}</span>
                      ))}</td>
                      <td style={{ padding: "10px" }}>
                        <button
                          onClick={() => setModalOpen(crime)}
                          style={{
                            background: "none",
                            border: "none",
                            color: "#fff",
                            cursor: "pointer",
                            fontSize: "18px"
                          }}
                        >
                          <i className="fa-solid fa-eye"></i>
                        </button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
              </>
            )}


          {isPersonalCrimes == 'wlist' && (
            <>
              <thead>
                <tr style={{ backgroundColor: "rgb(21 22 26)", color: "#fff" }}>
                <th style={{ padding: "10px", textAlign: "left" }}>{lang.citizenid}</th>
                  <th style={{ padding: "10px", textAlign: "left" }}>{lang.citizenname} #</th>
                  <th style={{ padding: "10px", textAlign: "left" }}>{lang.wlevel}</th>
                  <th style={{ padding: "10px", textAlign: "left" }}></th>
                </tr>
              </thead>
              <tbody>
                {wantedList.map((crime, index) => {      
                  return (
                    <tr className={`${crime.danger_level == lang.low}`} key={index} style={{ borderBottom: "1px solid rgb(36 36 36)", backgroundColor: 'rgb(14 16 20)' }}>
                      <td style={{ padding: "10px" }}>{crime.cid}</td>
                      <td style={{ padding: "10px" }}>{crime.first_name} {crime.last_name}</td>
                      <td style={{ padding: "10px" }}>{crime.danger_level}</td>
                      <td style={{ padding: "10px" }}>
                        <button
                          onClick={() => openWantedModal(crime)}
                          style={{
                            background: "none",
                            border: "none",
                            color: "#fff",
                            cursor: "pointer",
                            fontSize: "18px"
                          }}
                        >
                          <i className="fa-solid fa-eye"></i>
                        </button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
              </>
            )}

        {isPersonalCrimes == 'wlistveh' && (
            <>
              <thead>
                <tr style={{ backgroundColor: "rgb(21 22 26)", color: "#fff" }}>
                <th style={{ padding: "10px", textAlign: "left" }}>{lang.plate}</th>
                  <th style={{ padding: "10px", textAlign: "left" }}>{lang.model} #</th>
                  <th style={{ padding: "10px", textAlign: "left" }}>{lang.wlevel}</th>
                  <th style={{ padding: "10px", textAlign: "left" }}></th>
                </tr>
              </thead>
              <tbody>
                {wantedVehicles.map((crime, index) => {      
                  return (
                    <tr className={`${crime.danger_level == lang.low}`} key={index} style={{ borderBottom: "1px solid rgb(36 36 36)", backgroundColor: 'rgb(14 16 20)' }}>
                      <td style={{ padding: "10px" }}>{crime.plate}</td>
                      <td style={{ padding: "10px" }}>{crime.modellabel}</td>
                      <td style={{ padding: "10px" }}>{crime.danger_level}</td>
                      <td style={{ padding: "10px" }}>
                        <button
                          onClick={() => openWantedModalVeh(crime)}
                          style={{
                            background: "none",
                            border: "none",
                            color: "#fff",
                            cursor: "pointer",
                            fontSize: "18px"
                          }}
                        >
                          <i className="fa-solid fa-eye"></i>
                        </button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
              </>
            )}
        </table>
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
  );
};

export default CrimeList;
