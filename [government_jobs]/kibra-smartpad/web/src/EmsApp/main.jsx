import React, { useEffect, useState, useMemo } from "react";
import './main.css';
import emsLogo from '/public/appicons/ems.png'
import Avatar from '/public/avatar.png'
import Paramedics from "./Paramedics/main";
import AllCitizens from "./AllCitizens"
import PatientProfile from "./PatientProfile/main";
import { callNui, useNui } from "@/nui";
import EMSChat from "./Chat/main";

const EmsApp = ({lang, emsData, emsDispatch, tabOwnerName, allMessages}) => {
    const [loginPart, setLoginPart] = useState(false);
    const [passValue, setValuePass] = useState('');
    const [dashboard, setDashboard] = useState(true);
    const [mapUrl, setMapUrl] = useState("https://map.0resmon.org/");
    const [overview, setOverview] = useState(true);
    const [paramedics, setParamedics] = useState(false);
    const [allpatients, setAllPatients] = useState(false);
    const [paramedicsList, setParamedicsList] = useState([]);
    const [patientProfile, setPatientProfile] = useState(null);
    const [selectedMenu, setAddX] = useState('overview');
    const [allPlayers, setPlayers] = useState([]);
    const [q, setQ] = useState('');
    const [f, setF] = useState([]);
    const [emsChat, setEmsChat] = useState(false);
    const [o, setO] = useState(false);
    const [patientData, setPatientData] = useState([]);
    const [treatments, setTreatments] = useState([]);
    const [docnotes, setNotes] = useState([]);

    const OpenProfilePatient = (data) => {
        hideAll();
        setPatientProfile(data);
    }

    const CloseProfilePatient = () => {
        setPatientProfile(null);
    }

    const backListBro = () => {
        setPatientProfile(null);
        setAllPatients(true);
    }

    useEffect(() => {
        const onlineOfficers = emsData?.officers?.filter(officer => officer.online);
                
        if (onlineOfficers?.length > 0) {
            const coordsParam = onlineOfficers
            .map(officer => `${officer.coords.x},${officer.coords.y},${encodeURIComponent(officer.name)}`)
            .join("|");
        
            setMapUrl(`https://map.0resmon.org/?coords=${coordsParam}`);
        }
        
        // setVehCrimeList(mdtData.vehcrimes);
        // setCidCrimeList(mdtData.cidcrimes);
        setParamedicsList(emsData.officers);
        setTreatments(emsData.mdtDatabase.emsData_treatments);
        setNotes(emsData.mdtDatabase.emsData_notes);
        // setVehicleCrimes(mdtData.mdtDatabase.mdtData_vehicleCrimes);
        // setAllCrimes(mdtData.mdtDatabase.mdtData_crimeRecords);
        // setAnnouncements(mdtData.mdtDatabase.mdtData_announcements);
        // setHistory([...mdtData.mdtDatabase.mdtData_history].reverse());
    }, [emsData]);

    useEffect(() => {
        useNui("updateEmsData", (data) => {
            if(data.type == 'treatments'){
                setTreatments(data.data);
            } else if(data.type == 'docnotes'){
                setNotes(data.data);
            }
        })
    }, []);

    const returnPlayerPhoto = (cid) => {
            const path = `/web/pimg/${cid}.png`;
            const img = new Image();
            img.src = path;
          
            return new Promise((resolve) => {
              img.onload = () => resolve(path);
              img.onerror = () => resolve(Avatar);
            });
        }


    const hideAll = () => {
        setOverview(false);
        setPatientProfile(null);
        setParamedics(false);
        setEmsChat(false);
        setAllPatients(false);
    }

    const openProfile = (data) => {
        hideAll();
        setO(false);
        setQ('');
        setPatientProfile(data);
    }

    const setAdd = (page) => {
        setAddX(page);
        if(page === 'overview'){
            hideAll();
            setOverview(true);
        } else if(page === 'paramedics'){
            hideAll();
            setParamedics(true);
        } else if(page === 'allpatients'){
            hideAll();
            setAllPatients(true);
        } else if(page === 'emschat'){
            hideAll();
            setEmsChat(true);
        }
    }


    useEffect(() => {
        const container = document.querySelector('.paramedics-team');
        if (!container) return;

        const handleWheel = (e) => {
            if (e.deltaY !== 0) {
            container.scrollLeft += e.deltaY;
            e.preventDefault();
            }
        };

        container.addEventListener('wheel', handleWheel, { passive: false });

        return () => {
            container.removeEventListener('wheel', handleWheel);
        };
    }, []);

    useEffect(() => {
        const loadPhotos = async () => {
            const updatedList = await Promise.all(
                [...emsData.officers].reverse().map(async (item) => {
                    const url = await returnPlayerPhoto(item.cid);
                    return { ...item, photoUrl: url };
                })
            );

            setParamedicsList(updatedList);
        };
    
        loadPhotos();
    }, [emsData.officers]);

    useEffect(() => {
        const loadPhotos = async () => {
            const updatedList = await Promise.all(
                [...emsData.players].reverse().map(async (item) => {
                    const url = await returnPlayerPhoto(item.cid);
                    return { ...item, photoUrl: url };
                })
            );

            setPlayers(updatedList);
        };
    
        loadPhotos();
    }, [emsData.players]);

    useEffect(() => {
        if (!q.trim()) {
            setF([])
            setO(false)
            return
        }
        const r = allPlayers.filter(x =>
            x.pName.toLowerCase().includes(q.toLowerCase()) ||
            x.cid.toLowerCase().includes(q.toLowerCase())
        ) 
        setF(r)
        setO(r.length > 0)
    }, [q, allPlayers])

    return (
        <>
            <div className='EmsApp-Container'>
                <div className='header-icon-part'>
                    <div className='header-icons'>
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="12" viewBox="0 0 16 12" fill="none">
                            <path d="M0 3.31091L1.45455 4.76545C5.06909 1.15091 10.9309 1.15091 14.5455 4.76545L16 3.31091C11.5855 -1.10364 4.42182 -1.10364 0 3.31091ZM5.81818 9.12909L8 11.3109L10.1818 9.12909C9.89557 8.84208 9.55551 8.61437 9.18112 8.459C8.80672 8.30363 8.40535 8.22365 8 8.22365C7.59465 8.22365 7.19328 8.30363 6.81888 8.459C6.44449 8.61437 6.10443 8.84208 5.81818 9.12909ZM2.90909 6.22L4.36364 7.67454C5.32834 6.71064 6.63627 6.1692 8 6.1692C9.36373 6.1692 10.6717 6.71064 11.6364 7.67454L13.0909 6.22C10.2836 3.41273 5.72364 3.41273 2.90909 6.22Z" fill="white"/>
                        </svg>
                    </div>
                    <div className='header-icons'>
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="12" viewBox="0 0 20 12" fill="none">
                            <path d="M14.375 0C15.2038 0 15.9987 0.316071 16.5847 0.87868C17.1708 1.44129 17.5 2.20435 17.5 3V3.9996L18.9587 4.0032C19.2349 4.0032 19.4998 4.10851 19.695 4.29598C19.8903 4.48344 20 4.73769 20 5.0028V7.0032C20 7.26831 19.8903 7.52256 19.695 7.71002C19.4998 7.89749 19.2349 8.0028 18.9587 8.0028L17.5 8.0004V9C17.5 9.79565 17.1708 10.5587 16.5847 11.1213C15.9987 11.6839 15.2038 12 14.375 12H3.125C2.2962 12 1.50134 11.6839 0.915291 11.1213C0.32924 10.5587 0 9.79565 0 9V3C0 2.20435 0.32924 1.44129 0.915291 0.87868C1.50134 0.316071 2.2962 0 3.125 0H14.375ZM14.6875 1.1352H3.125C2.3125 1.1352 1.36875 1.7304 1.26 2.4912L1.25 2.6352V9.2292C1.25 10.0056 1.865 10.6452 2.6525 10.722L2.8125 10.7292H14.6875C15.0741 10.7291 15.4469 10.5914 15.7339 10.3427C16.0209 10.094 16.2017 9.75199 16.2412 9.3828L16.25 9.2292V2.6352C16.2499 2.26406 16.1064 1.90614 15.8474 1.63064C15.5883 1.35513 15.2321 1.18161 14.8475 1.1436L14.6875 1.1352ZM3.5425 2.3388H12.705C13.2387 2.3388 13.6775 2.7204 13.7425 3.2148L13.75 3.3408V8.5332C13.7502 8.77726 13.6576 9.01299 13.4896 9.19615C13.3216 9.37931 13.0897 9.49731 12.8375 9.528L12.7063 9.5352H3.54375C3.28931 9.53568 3.04345 9.44691 2.8524 9.2856C2.66134 9.12428 2.53824 8.90152 2.50625 8.6592L2.5 8.532V3.3408C2.5 2.8296 2.89875 2.4084 3.4125 2.346L3.5425 2.3388Z" fill="white"/>
                        </svg>
                    </div>
                </div>
                <svg xmlns="http://www.w3.org/2000/svg" width="1069" height="894" viewBox="0 0 1069 894" fill="none">
                    <path d="M783.646 -46.5C969.676 -46.4998 1067.88 115.377 1067.88 265.022C1067.88 339.907 1061.01 388.245 1052.28 418.002C1047.92 432.881 1043.11 443.092 1038.47 449.65C1033.96 456.021 1029.69 458.869 1026.23 459.31L1025.9 459.345C1018.37 459.978 1001.47 462.308 987.062 458.513C979.87 456.619 973.35 453.211 968.931 447.348C964.654 441.674 962.295 433.637 963.276 422.29L963.382 421.182C965.872 397.148 969.619 376.886 972.749 356.502C975.878 336.124 978.386 315.651 978.386 291.25C978.386 266.839 973.068 212.278 948.59 163.8C924.097 115.294 880.397 72.8477 803.68 72.8477C726.916 72.8477 680.585 125.973 650.663 181.984C635.699 209.996 624.819 238.765 616.279 262.032C612.007 273.672 608.324 283.923 605.006 292.029C601.782 299.904 598.933 305.672 596.266 308.722L596.008 309.009C593.192 312.054 590.758 314.768 588.595 317.184C586.431 319.601 584.541 321.716 582.808 323.57C579.34 327.281 576.528 329.915 573.467 331.793C567.361 335.538 560.171 336.334 544.549 336.334C536.878 336.334 527.332 332.758 516.851 326.953C506.384 321.157 495.049 313.175 483.816 304.441C462.75 288.062 442.106 269.09 428.268 256.999L425.592 254.676C398.166 231.016 353.053 171.516 249.802 171.516C198.106 171.516 163.617 195.808 142.069 226.129C120.537 256.429 111.921 292.753 111.921 316.897C111.921 364.958 147.279 566.634 383.497 717.671L386.285 719.445C505.559 795.017 602.101 847.226 668.828 880.544C702.191 897.203 728.101 909.139 745.671 916.911C754.456 920.797 761.157 923.642 765.662 925.516C767.914 926.452 769.618 927.147 770.759 927.607C771.329 927.837 771.759 928.009 772.046 928.123C772.19 928.18 772.298 928.223 772.37 928.251C772.406 928.265 772.434 928.276 772.452 928.283C772.461 928.287 772.468 928.289 772.473 928.291C772.475 928.292 772.476 928.293 772.478 928.293C772.478 928.293 772.477 928.293 772.511 928.208L772.512 928.209L772.479 928.294L773.161 928.561V928.445C773.403 928.535 773.708 928.648 774.067 928.787C775.066 929.174 776.486 929.748 778.171 930.496C781.543 931.993 785.963 934.182 790.176 936.956C794.394 939.734 798.37 943.078 800.887 946.871C803.315 950.531 804.372 954.587 803.008 958.982L802.868 959.409C801.239 964.14 799.57 967.853 797.237 970.561C794.923 973.247 791.932 974.971 787.589 975.671C783.224 976.374 777.494 976.042 769.729 974.589C762.453 973.228 753.422 970.888 742.099 967.522L739.804 966.836C690.34 951.891 409.629 884.498 170.561 641.55L167.75 638.684C47.9224 516.051 6.78888 411.73 1.18555 328.525C-4.33047 246.616 24.579 185.089 46.9023 146.598L47.96 144.782C92.7695 68.2346 189.923 49.5069 261.076 49.5068C296.653 49.5068 320.953 51.3818 344.769 57.9209C367.844 64.2568 390.493 74.9786 422.522 92.665L425.651 94.3984H425.652C442.504 103.755 455.551 111.885 465.933 118.403C476.302 124.913 484.045 129.838 490.253 132.752C496.463 135.667 501.252 136.627 505.673 135.059C510.067 133.499 513.973 129.482 518.54 122.794C536.838 96.0026 597.564 -46.5 783.646 -46.5Z" stroke="#121212"/>
                </svg>

                {loginPart && (
                    <div className='EmsApp-LoginPart'>
                        <div style={{display: 'flex',alignItems: 'center',flexDirection: 'column'}}>
                            <img src={emsLogo}></img>
                            <span className='welcome-text'>
                                You are connecting to 
                                Pill Box Hill Medical Center 
                                Database
                            </span>
                            <span className='info-text'>Please enter password to identify you</span>
                            <div className='password-box'>
                                <input type="password" placeholder="Enter password" value={passValue} onChange={(e) => setValuePass(e.target.value)}></input>
                                <i style={{color: '#d5d5d5',float: 'right',cursor: 'pointer',marginRight: '1.5rem',marginTop: '1.2rem'}} className="fa-solid fa-arrow-right"></i>
                            </div>
                        </div>
                    </div>
                )}

                {dashboard && (
                    <div className='EmsApp-Dashboard'>
                        <div className='EmsApp-LeftBar'>
                            <div className='EmsApp-LeftBar-Header'>
                                <img src={emsLogo}></img>
                                <div style={{display: 'flex',flexDirection: 'column', marginLeft: '1rem'}}>
                                    <span className='title-ems'>{lang.pillboks}</span>
                                    <span className='desc-ems'>{lang.medbase}</span>
                                </div>
                            </div>
                            <div className='EmsApp-LeftBar-MainPanel'>
                                <div className='EmsApp-PartOne'>
                                    <div className='EmsApp-PartOne-Header'>
                                        <div className='EmsApp-SubBox'>
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="14" viewBox="0 0 16 14" fill="none">
                                                <path d="M13.6 4V8.8C14.96 8.8 16 7.76 16 6.4C16 5.04 14.96 4 13.6 4ZM7.2 3.2H1.6C0.72 3.2 0 3.92 0 4.8V8C0 8.88 0.72 9.6 1.6 9.6H2.4V12C2.4 12.88 3.12 13.6 4 13.6H5.6V9.6H7.2L10.4 12.8H12V0H10.4L7.2 3.2Z" fill="#64666F"/>
                                            </svg>
                                        </div> 
                                        <span className='part-x'>{lang.dispatcher}</span>
                                    </div>
                                    <div className='EmsApp-List'>
                                        {emsDispatch.map((element, index) => {
                                            return (
                                                <div className='EmsApp-List-Item'>
                                                    <span className='time-clause'>{element.timestring}</span>
                                                    <span className='alert-title'>{element.title}</span>
                                                    <div className='alert-detail-box'>
                                                        <span className='alert-detail-str'>{lang.reqid}: <span style={{color: 'white'}}>{element.code}</span></span>
                                                        <span className='alert-detail-str'>{lang.gender} <span style={{color: 'white'}}>{element.gender}</span></span>
                                                        <span className='alert-detail-str'>{lang.location} <span style={{color: 'white'}}>{element.address}</span></span>   
                                                    </div>
                                                </div>
                                            )
                                        })}
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div className='EmsApp-MiddleDashboard'>
                            <div className='EmsApp-MiddleHeader'>
                                <span onClick={() => setAdd('overview')} className={`menu-title ${selectedMenu == 'overview' ? 'selected': ''}`}>{lang.overview}</span>
                                <span onClick={() => setAdd('paramedics')} className={`menu-title ${selectedMenu == 'paramedics' ? 'selected': ''}`}>{lang.paramedics}</span>
                                <span onClick={() => setAdd('allpatients')} className={`menu-title ${selectedMenu == 'allpatients' ? 'selected': ''}`}>{lang.citizens}</span>
                                <span onClick={() => setAdd('emschat')} className={`menu-title ${selectedMenu == 'emschat' ? 'selected': ''}`}>{lang.chat}</span>
                                <div className='search-player'>
                                <i className="fa-solid fa-magnifying-glass" style={{ color:'#818181', marginLeft:'1rem' }}></i>
                                <input
                                    value={q}
                                    onChange={e => setQ(e.target.value)}
                                    placeholder="Search Patient"
                                    style={{ width: '100%', padding: '0.5rem 1rem' }}
                                />
                                {o && (
                                <ul className='dropdown open'>
                                    {f.map(p => (
                                    <li onClick={() => openProfile(p)} key={p.cid} style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                                        <img
                                            src={p.photoUrl || '/public/avatar.png'} // avatarı yoksa default
                                            alt={p.pName}
                                            style={{
                                                width: 32,
                                                height: 32,
                                                borderRadius: '50%',
                                                objectFit: 'cover',
                                                marginRight: 8
                                            }}
                                        />
                                        <span>{p.pName}</span>
                                    </li>
                                    ))}
                                </ul>
                                )}

                                </div>
                            </div>
                            {overview && (
                                <div className='manisalar' style={{ position: 'relative' }}>
                                    <span className='map-title' style={{ fontFamily: 'SF Pro Text', fontSize: '1.2rem', color: '#fff' }}>
                                    {lang.overview}
                                    </span>
                                    <iframe
                                    src={mapUrl}
                                    loading="lazy"
                                    style={{
                                        border: 0,
                                        borderRadius: '4px',
                                        width: '100%',
                                        height: '611px',
                                        marginTop: '0.4rem',
                                        willChange: 'transform'
                                    }}
                                    />
                                  <div style={{
marginBottom: '0.3rem',
padding: '0.5rem 1.5rem',
borderRadius: '33px',
position: 'absolute',
top: '3.7rem',
zIndex: '100',
right: '1rem',
background: 'transparent'
}}>
  {paramedicsList.map((p, i) => (
    <div key={i} style={{
    display: 'flex',
    alignItems: 'center',
    marginBottom: '0.3rem',
    paddingBottom: '.5rem',
    paddingTop: '.5rem',
    borderRadius: '31px',
    paddingLeft: '1rem',
    paddingRight: '1rem',
    background: '#0000003b',
    fontFamily: '"SF Pro Display"',
    color: 'rgb(255, 255, 255)',
    fontSize: '13px'
    }}>
      <img
        src={p.photoUrl}
        alt={p.name}
        style={{
          width: '20px',
          height: '20px',
          borderRadius: '50%',
          marginRight: '0.5rem'
        }}
      />
      {p.name}
    </div>
  ))}
</div>

                                </div>
                                )}


                            {allpatients && <AllCitizens lang={lang} players={emsData.players} onClose={CloseProfilePatient} openProfileX={OpenProfilePatient}> </AllCitizens>}
                            {paramedics && <Paramedics lang={lang} officers={emsData.officers} grades={emsData.allgrades}></Paramedics>}
                            {patientProfile && <PatientProfile backList={backListBro} tabOwnerName={tabOwnerName} drugs={emsData.druglist} lang={lang} patientData={patientProfile} allergies={emsData.mdtDatabase.emsData_allergies} docnotes={docnotes} allTedaviler={treatments}></PatientProfile>}
                            {emsChat && <EMSChat lang={lang} playerName={tabOwnerName} allMessages={allMessages}></EMSChat>}
                        </div>
                    </div>
                )}
            </div>
        </>
    )
}

export default EmsApp;