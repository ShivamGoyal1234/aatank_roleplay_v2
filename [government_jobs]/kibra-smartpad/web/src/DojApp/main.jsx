import React, { useState, useEffect} from 'react';
import './main.css';
import { callNui, useNui } from '@/nui';
import { act } from 'react';
import ColdModal from '@/SettingsApp/coldModal/main';
import EnterVerdictModal from "./verdict";

const DOJApp = ({lang, batteryLevel, allPersonelCrimes, pname, tabJob, courtRooms, allDataCourts, allCrimes}) => {
    const [isDarkMode, setIsDarkMode] = useState(true);
    const [activeTab, setActiveTab] = useState('dashboard');
    const [userRole, setUserRole] = useState('judge');
    const [showModal, setShowModal] = useState(false);
    const [selectedCase, setSelectedCase] = useState(null);
    const [warrantTab, setWarrantTab] = useState('person');
    const [showRejectModal, setShowRejectModal] = useState(false);
    const [rejectReason, setRejectReason] = useState('');
    const [rejectingItem, setRejectingItem] = useState(null);
    const [modalClosing, setModalClosing] = useState(false);
    const [time, setTime] = useState(new Date());
    const [dataPersonal, setDataPersonal] = useState([]);
    const [courtTime, setCourtTime] = useState(null);
    const [courtDate, setCourtDate] = useState(null);
    const [modalOpen, setModalOpen] = useState(false);
    const [allCourts, setAllCourts] = useState([]);
    const [courtData, setCourtData] = useState([]);
    const [judges, setJudges] = useState([]);
    const [selectedJudge, setSelectedJudge] = useState([]);
    const [notes, setNotes] = useState('');
    const [al, setal] = useState(false);
    const formattedTime = `${time.getHours().toString().padStart(2, '0')}:${time
    .getMinutes()
    .toString()
    .padStart(2, '0')}`;

    useEffect(() => {
        if (activeTab === 'pending') setSelectedCase(null);
    }, [activeTab]);


    const handleVerdictSubmit = (verdict) => {
        // console.log(verdict);
    }

    const approveCase = () => {
        callNui('approveCase', {
            id: selectedCase.crime_id
        })
        setSelectedCase(null);
    }

    useEffect(() => {
        setAllCourts(allDataCourts);
    }, [allDataCourts]);

    const closeModal = (modalType) => {
        setModalClosing(true);
        setTimeout(() => {
            if (modalType === 'reject') {
                setShowRejectModal(false);
                setRejectReason('');
                setRejectingItem(null);
            } else {
                setShowModal(false);
            }
            setModalClosing(false);
        }, 300);
    };

    const openHodal = (casex) => {
        setSelectedCase(casex);
        setModalOpen(true);
    }

    const createNewCourt = () => {
        if (!selectedCase || !courtDate || !courtTime || !selectedJudge || !courtData) {
            setal(true);
            return;
        }
        callNui('createNewCourt', {
            caseid: selectedCase.crime_id,
            courtDate,
            courtTime,
            judge: selectedJudge,
            courtData,
            notes,
            type: 'citizen'
        });
        closeModal('schedule');
    }


    const ConfirmRejectX = () => {
        callNui('RejectCrime', {
            id: selectedCase.crime_id,
            reason: rejectReason
        })
        closeModal('reject');
    }

    useEffect(() => {
        if (courtRooms && courtRooms.length > 0) {
            setCourtData(JSON.stringify({
                id: 1,
                name: courtRooms[0].RoomName,
                location: courtRooms[0].location
            }));
        }
    }, [courtRooms]);

    useEffect(() => {
        setDataPersonal(allPersonelCrimes);
        callNui('getDojUsers', {type: 'judges'}, (data) => {
            setJudges(data);
            if (data && data.length > 0) {
                setSelectedJudge(JSON.stringify({ cid: data[0].cid, name: data[0].name }));
            }
        })
    }, [allPersonelCrimes]);

    const justPendingData = Array.isArray(dataPersonal) ? dataPersonal.filter(item => item.status === 0) : [];
    const justActiveData = Array.isArray(dataPersonal) ? dataPersonal.filter(item => item.status === 1) : [];
    const justVerdictedData = Array.isArray(dataPersonal) ? dataPersonal.filter(item => item.status === 4) : [];

    const mockWarrants = {
        person: [
            { id: 'PWR-001', name: 'James Miller', requester: 'Det. Wilson', date: '2024-03-15', reason: 'Armed Robbery Suspect' },
            { id: 'PWR-002', name: 'Lisa Brown', requester: 'Det. Garcia', date: '2024-03-14', reason: 'Fraud Investigation' }
        ],
        vehicle: [
            { id: 'VWR-001', plate: 'ABC-1234', requester: 'Officer Smith', date: '2024-03-15', reason: 'Vehicle used in robbery' },
            { id: 'VWR-002', plate: 'XYZ-5678', requester: 'Officer Davis', date: '2024-03-14', reason: 'Suspected drug transport' }
        ]
    };

    const renderDashboard = () => (
        <>
            
            <div className="stats-grid">
                <div className="stat-card">
                    <div className="stat-label">{lang.pendikcases}</div>
                    <div className="stat-value">{justPendingData.length}</div>
                    <div className="stat-change positive">+12% from last week</div>
                </div>
                <div className="stat-card">
                    <div className="stat-label">{lang.activecas}</div>
                    <div className="stat-value">{justActiveData.length}</div>
                    <div className="stat-change negative">-5% from last week</div>
                </div>
                <div className="stat-card">
                    <div className="stat-label">{lang.caseclo}</div>
                    <div className="stat-value">{justVerdictedData.length}</div>
                    <div className="stat-change positive">+18% this month</div>
                </div>
                {/* <div className="stat-card">
                    <div className="stat-label">Pending Warrants</div>
                    <div className="stat-value">12</div>
                    <div className="stat-change positive">+3 new today</div>
                </div> */}
            </div>

            <div className="card">
                <div className="card-header">
                    <h2 className="card-title">{lang.todaycourttitle}</h2>
                    <button className="btn btn-primary" onClick={() => setShowModal(true)}>
                        {lang.schedulehearing}
                    </button>
                </div>
                
                {allCourts.map((hearing, idx) => (
                    <div key={idx} className="hearing-card">
                        <div className="hearing-header">
                            <div>
                                <div className="hearing-time">{hearing.time}</div>
                                <div className="hearing-details">
                                    <div className="hearing-detail">
                                         {hearing.case_id} - {hearing.type}
                                    </div>
                                    <div className="hearing-detail">
                                         {hearing.assigned_judge.name}
                                    </div>
                                    <div className="hearing-detail">
                                         {hearing.courtroom.salonName} - {hearing.courtroom.location}
                                    </div>
                                </div>
                            </div>
                            {/* <button className="btn btn-secondary btn-sm">{lang.viewdetails}</button> */}
                        </div>
                    </div>
                ))}
            </div>
        </>
    );

    const renderPendingCases = () => {
            return (
            <div className="card">
                <div className="card-header">
                    <h2 className="card-title">{lang.pendikcases}</h2>
                    <span className="text-secondary">{lang.waitingcasepending.replace("%s", justPendingData.length)}</span>
                </div>
                <div className="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>{lang.casenumber}</th>
                                <th>{lang.suspect}</th>
                                <th>{lang.charge}</th>
                                <th>{lang.date}</th>
                                <th>{lang.officer}</th>
                                <th>{lang.status}</th>
                                <th>{lang.actions}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {justPendingData.map((case_) => (
                                <tr key={case_.crime_id}>
                                    <td>{case_.crime_id}</td>
                                    <td>{
                                    (
                                        () => {
                                        const names = (case_.offenders || []).map(s => s.name);
                                        const joined = names.join(', ');
                                        return joined.length > 40 ? joined.slice(0, 40) + '...' : joined;
                                        })()
                                    }
                                    </td>
                                    <td>{
                                    (
                                        () => {
                                        const names = (case_.offenders || []).map(s => s.name);
                                        const joined = names.join(', ');
                                        return joined.length > 40 ? joined.slice(0, 40) + '...' : joined;
                                        })()
                                    }</td>
                                    <td>{case_.date}</td>
                                    <td>{case_.officer_name}</td>
                                    <td><span className="status-badge status-pending">{case_.status === 0 ? lang.pending : lang.approved}</span></td>
                                    <td>
                                        <button 
                                            className="btn btn-primary btn-sm"
                                            onClick={() => setSelectedCase(case_)}
                                        >
                                            {lang.viewcase}
                                        </button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
                
                {selectedCase && (
                    <div className="case-details" key={selectedCase.crime_id}>
                        <h3 style={{ marginBottom: '20px' }}>{lang.casedetails}: {selectedCase.crime_id}</h3>
                        <div className="detail-row">
                            <span className="detail-label">{lang.suspect}:</span>
                            <span style={{marginTop: '.5rem'}}>{
                            (
                                () => {
                                const names = (selectedCase?.offenders || []).map(s => s.name);
                                const joined = names.join(', ');
                                return joined.length > 40 ? joined.slice(0, 40) + '...' : joined;
                                })()
                            }</span>
                        </div>
                        <div className="detail-row">
                            <span className="detail-label">{lang.charge}:</span>
                            <span style={{marginTop: '.5rem'}}>{
                            (
                                () => {
                                const names = (selectedCase?.articles || []).map(s => s.name);
                                const joined = names.join(', ');
                                return joined.length > 40 ? joined.slice(0, 40) + '...' : joined;
                                })()
                            }</span>
                        </div>
                        <div className="detail-row">
                            <span className="detail-label">{lang.arofficer}:</span>
                            <span>{selectedCase.officer_name}</span>
                        </div>
                        <div className="detail-row">
                            <span className="detail-label">{lang.date}:</span>
                            <span>{selectedCase.date}</span>
                        </div>
                        
                        {(userRole === 'judge' || userRole === 'prosecutor') && (
                            <div className="action-buttons">
                                <button onClick={approveCase} className="btn btn-success">{lang.approvecase}</button>
                                <button 
                                    className="btn btn-danger"
                                    onClick={() => {
                                        setRejectingItem({ type: 'case', item: selectedCase });
                                        setShowRejectModal(true);
                                    }}
                                >
                                    {lang.rejcase}
                                </button>
                                {userRole === 'judge' && (
                                    <button className="btn btn-secondary">{lang.aspersonel}</button>
                                )}
                            </div>
                        )}
                    </div>
                )}
            </div>
    );
}

    const renderActiveCases = () => (
        <div className="card">
            <div className="card-header">
                <h2 className="card-title">{lang.accases}</h2>
            </div>
            {justActiveData.map((case_) => (
                <div key={case_.crime_id} className="card" style={{ background: 'var(--bg-primary)' }}>
                    <h3>
                        {case_.crime_id} - {
                            (() => {
                                const names = (case_.offenders || []).map(s => s.name);
                                const joined = names.join(', ');
                                return joined.length > 40 ? joined.slice(0, 40) + '...' : joined;
                            })()
                        }
                    </h3>
                    <div style={{ marginTop: '16px' }}>
                        <span className="status-badge status-active">{case_.status === 1 ? lang.approved : lang.rejected}</span>
                    </div>

                    <div className="grid-2" style={{ marginTop: '20px' }}>
                        <div>
                            <div className="detail-label">{lang.prosecutor}</div>
                            <div>{case_.approved_by}</div>
                        </div>
                        <div>
                            <div className="detail-label">{lang.defense}</div>
                            <div>{case_.lawyer ? case_.lawyer : lang.lawnotyet}</div>
                        </div>
                    </div>
                    

                    <div style={{ marginTop: '24px' }}>
                        <h4 style={{ marginBottom: '16px' }}>{lang.casetimeline}</h4>
                        <div className="timeline">
                            {(case_.timeline || []).map((element, index) => {
                                let label = '';
                                if (element.type === 'created') label = lang.offencecreated.replace("%s", case_.officer_name);
                                else if (element.type === 'approved') label = lang.caseapprovedfrom.replace("%s", case_.approved_by);
                                else if (element.type === 'rejected') label = lang.rejectedmsg.replace("%s%s", case_.crime_id, case_.approved_by);
                                else if (element.type === 'hourtcreated') label = lang.hourtcreated.replace("%s", element.created).replace("%d", element.date);
                                else label = element.label;

                                return (
                                    <div className="timeline-item" key={index}>
                                        <div className="timeline-dot"></div>
                                        <div className="timeline-content">
                                            <div className="timeline-date">{element.date}</div>
                                            <div>{label}</div>
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    </div>


                    {userRole === 'judge' && (
                        <div className="action-buttons">
                            <button onClick={() => openHodal(case_)} className="btn btn-primary">{lang.enterverdict}</button>
                        </div>
                    )}
                </div>
            ))}
        </div>
    );


    const renderWarrants = () => (
        <div className="card">
            <div className="card-header">
                <h2 className="card-title">{lang.warreqs}</h2>
            </div>
            <div className="tabs">
                <button 
                    className={`tab ${warrantTab === 'person' ? 'active' : ''}`}
                    onClick={() => setWarrantTab('person')}
                >
                    {lang.personwarrants}
                </button>
                <button 
                    className={`tab ${warrantTab === 'vehicle' ? 'active' : ''}`}
                    onClick={() => setWarrantTab('vehicle')}
                >
                    {lang.vehwarrants}
                </button>
            </div>
            
            <div className="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>{lang.id}</th>
                            <th>{warrantTab === 'person' ? 'Name' : 'License Plate'}</th>
                            <th>{lang.requester}</th>
                            <th>{lang.date}</th>
                            <th>{lang.reason}</th>
                            {(userRole === 'judge' || userRole === 'prosecutor') && <th>{lang.actions}</th>}
                        </tr>
                    </thead>
                    <tbody>
                        {mockWarrants[warrantTab].map((warrant) => (
                            <tr key={warrant.id}>
                                <td>{warrant.id}</td>
                                <td>{warrant.name || warrant.plate}</td>
                                <td>{warrant.requester}</td>
                                <td>{warrant.date}</td>
                                <td>{warrant.reason}</td>
                                {(userRole === 'judge' || userRole === 'prosecutor') && (
                                    <td>
                                        <div style={{ display: 'flex', gap: '8px' }}>
                                            <button className="btn btn-success btn-sm">{lang.approve}</button>
                                            <button 
                                                className="btn btn-danger btn-sm"
                                                onClick={() => {
                                                    setRejectingItem({ type: 'warrant', item: warrant });
                                                    setShowRejectModal(true);
                                                }}
                                            >
                                                {lang.reject}
                                            </button>
                                        </div>
                                    </td>
                                )}
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );

    const renderRejectModal = () => (
        <div className={`modal-overlayra ${modalClosing ? 'modal-closing' : ''}`} onClick={() => closeModal('reject')}>
            <div className="modalar" onClick={(e) => e.stopPropagation()}>
                <div className="modal-header">
                    <h2 className="modal-title">{lang.rejectreason}</h2>
                    <button className="close-btn" onClick={() => closeModal('reject')}>×</button>
                </div>
                
                <form>
                    <div className="form-group">
                        <label className="form-label">{lang.whyreject} {rejectingItem?.type}?</label>
                        <textarea 
                            className="form-textarea" 
                            rows="5"
                            value={rejectReason}
                            onChange={(e) => setRejectReason(e.target.value)}
                            placeholder="Please provide a detailed reason for rejection..."
                        ></textarea>
                    </div>
                    
                    <div className="form-group">
                        <label className="form-label">{lang.commonreasons}</label>
                        <div style={{display: 'flex',flexDirection: 'column',gap: '8px',width: '27.5rem'}}>
                            <button 
                                type="button" 
                                className="btn btn-secondary"
                                onClick={() => setRejectReason(lang.reason1)}
                            >
                                {lang.reason1}
                            </button>
                            <button 
                                type="button" 
                                className="btn btn-secondary"
                                onClick={() => setRejectReason(lang.reason2)}
                            >
                               {lang.reason2}
                            </button>
                            <button 
                                type="button" 
                                className="btn btn-secondary"
                                onClick={() => setRejectReason(lang.reason3)}
                            >
                                {lang.reason3}
                            </button>
                        </div>
                    </div>
                    
                    <div style={{ display: 'flex', gap: '12px', marginTop: '24px' }}>
                        <button 
                            type="button" 
                            className="btn btn-danger" 
                            style={{ flex: 1 }}
                            disabled={!rejectReason.trim()}
                            onClick={() => {
                                ConfirmRejectX()
                            }}
                        >
                            {lang.confirmreject}
                        </button>
                        <button 
                            type="button" 
                            className="btn btn-secondary" 
                            style={{ flex: 1 }} 
                            onClick={() => closeModal('reject')}
                        >
                            {lang.cancel}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    );
    
    const renderModal = () => (
        <>
            <div className={`modal-overlayra ${modalClosing ? 'modal-closing' : ''}`} onClick={() => closeModal('schedule')}>
                <div className="modalt" onClick={(e) => e.stopPropagation()}>
                    <div className="modal-header">
                        <h2 className="modal-title">{lang.schcourt}</h2>
                        <button className="close-btn" onClick={() => closeModal('schedule')}>×</button>
                    </div>
                    
                    <form>
                        <div className="form-groupa">
                            <label className="form-label">{lang.casenumber}</label>
                            <select onChange={e => {
  const found = justActiveData.find(x => x.crime_id === e.target.value);
  setSelectedCase(found);
}}
 className="form-select">
                                <option>{lang.selectcase}</option>
                                    {justActiveData.map(c => (
                                        <option 
  key={c.crime_id} 
  value={c.crime_id}
>
  {c.crime_id} - {
    (() => {
      const names = c.offenders.map(s => s.name);
      const joined = names.join(', ');
      return joined.length > 40 ? joined.slice(0, 40) + '...' : joined;
    })()
  }
</option>

                                ))}
                            </select>
                        </div>
                        
                        <div className="grid-2">
                            <div className="form-group" style={{marginBottom: '20px', width: '16.5rem'}}>
                                <label className="form-label">{lang.date}</label>
                                <input value={courtDate} onChange={(e) => setCourtDate(e.target.value)} type="date" className="form-input" />
                            </div>
                            <div className="form-group" style={{marginBottom: '20px', width: '16.5rem'}}>
                                <label className="form-label">{lang.time}</label>
                                <input value={courtTime} onChange={(e) => setCourtTime(e.target.value)} type="time" className="form-input" />
                            </div>
                        </div>
                        
                        <div className="form-group">
                            <label className="form-label">{lang.assignjudges}</label>
                            <select onChange={(e) => setSelectedJudge(e.target.value)}className="form-select">
                                {judges.map((element, index) => {
                                    return <option key={element.cid} value={JSON.stringify({ cid: element.cid, name: element.name })}>{element.name}</option>
                                })}

                            </select>
                        </div>
                        
                        <div className="form-group">
                            <label className="form-label">{lang.courtrooms}</label>
                            <select
                                onChange={e => setCourtData(e.target.value)}
                                className="form-select"
                                value={courtData}
                            >
                                {courtRooms.map((element, idx) => (
                                    <option
                                        key={idx}
                                        value={JSON.stringify({id: idx + 1, name: element.RoomName, location: element.location})}
                                    >
                                        {element.RoomName} - {element.location}
                                    </option>
                                ))}
                            </select>
                        </div>
                        
                        <div className="form-group" style={{width: '34rem'}}>
                            <label className="form-label">{lang.addnotes}</label>
                            <textarea onChange={(e) => setNotes(e.target.value)} value={notes} className="form-textarea" rows="3"></textarea>
                        </div>
                        
                        <div style={{ display: 'flex', gap: '12px', marginTop: '24px' }}>
                            <button onClick={createNewCourt} type="button" className="btn btn-primary" style={{ flex: 1 }}>
                                {lang.schcourt}
                            </button>
                            <button type="button" className="btn btn-secondary" style={{ flex: 1 }} onClick={() => closeModal('schedule')}>
                                {lang.cancel}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </>
    );

    const renderContent = () => {
        switch(activeTab) {
            case 'dashboard':
                return renderDashboard();
            case 'pending':
                return renderPendingCases();
            case 'active':
                return renderActiveCases();
            case 'warrants':
                return renderWarrants();
            case 'history':
                return (
                    <>
                        <div className="card">
                            <h2 className="card-title">{lang.verhistory}</h2>
                            <div style={{ marginTop: '20px' }}>
                                <p style={{ color: 'var(--text-secondary)' }}>{lang.closedhisto}</p>
                            </div>
                        </div>


                    </>
                );
            case 'calendar':
                return (
                    <div className="card">
                        <div className="card-header">
                            <h2 className="card-title">{lang.courtcalendar}</h2>
                            <button className="btn btn-primary" onClick={() => setShowModal(true)}>
                                {lang.schedulehearing}
                            </button>
                        </div>
                        <div style={{ marginTop: '20px' }}>
                            <p style={{ color: 'var(--text-secondary)' }}>{lang.displayedcourts}</p>
                        </div>
                    </div>
                );
            default:
                return renderDashboard();
        }
    };

    return (
        <>
            <div className={`app-container ${isDarkMode ? '' : 'light-mode'}`}>
                <div style={{margin: '0',height: '0',width: '1rem',top: '.8rem',position: 'absolute'}} className='header-icon-time-part'>
                    <span className='time-string'>{formattedTime}</span>
                </div>
                <div className='header-icon-part'>
                    <div className='header-icons'>
                      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="10" viewBox="0 0 18 10" fill="none">
                        <path d="M14.5227 0.617317C14.4465 0.801088 14.4465 1.03406 14.4465 1.5V8.5C14.4465 8.96594 14.4465 9.19891 14.5227 9.38268C14.6241 9.62771 14.8188 9.82239 15.0638 9.92388C15.2476 10 15.4806 10 15.9465 10C16.4125 10 16.6454 10 16.8292 9.92388C17.0742 9.82239 17.2689 9.62771 17.3704 9.38268C17.4465 9.19891 17.4465 8.96594 17.4465 8.5V1.5C17.4465 1.03406 17.4465 0.801088 17.3704 0.617317C17.2689 0.372288 17.0742 0.177614 16.8292 0.0761205C16.6454 0 16.4125 0 15.9465 0C15.4806 0 15.2476 0 15.0638 0.0761205C14.8188 0.177614 14.6241 0.372288 14.5227 0.617317Z" fill="white"/>
                        <path d="M9.94653 3.5C9.94653 3.03406 9.94653 2.80109 10.0227 2.61732C10.1241 2.37229 10.3188 2.17761 10.5638 2.07612C10.7476 2 10.9806 2 11.4465 2C11.9125 2 12.1454 2 12.3292 2.07612C12.5742 2.17761 12.7689 2.37229 12.8704 2.61732C12.9465 2.80109 12.9465 3.03406 12.9465 3.5V8.5C12.9465 8.96594 12.9465 9.19891 12.8704 9.38268C12.7689 9.62771 12.5742 9.82239 12.3292 9.92388C12.1454 10 11.9125 10 11.4465 10C10.9806 10 10.7476 10 10.5638 9.92388C10.3188 9.82239 10.1241 9.62771 10.0227 9.38268C9.94653 9.19891 9.94653 8.96594 9.94653 8.5V3.5Z" fill="white"/>
                        <path d="M5.52265 4.61732C5.44653 4.80109 5.44653 5.03406 5.44653 5.5V8.5C5.44653 8.96594 5.44653 9.19891 5.52265 9.38268C5.62415 9.62771 5.81882 9.82239 6.06385 9.92388C6.24762 10 6.48059 10 6.94653 10C7.41247 10 7.64545 10 7.82922 9.92388C8.07424 9.82239 8.26892 9.62771 8.37041 9.38268C8.44653 9.19891 8.44653 8.96594 8.44653 8.5V5.5C8.44653 5.03406 8.44653 4.80109 8.37041 4.61732C8.26892 4.37229 8.07424 4.17761 7.82922 4.07612C7.64545 4 7.41247 4 6.94653 4C6.48059 4 6.24762 4 6.06385 4.07612C5.81882 4.17761 5.62415 4.37229 5.52265 4.61732Z" fill="white"/>
                        <path d="M1.02265 6.11732C0.946533 6.30109 0.946533 6.53406 0.946533 7V8.5C0.946533 8.96594 0.946533 9.19891 1.02265 9.38268C1.12415 9.62771 1.31882 9.82239 1.56385 9.92388C1.74762 10 1.98059 10 2.44653 10C2.91247 10 3.14545 10 3.32922 9.92388C3.57424 9.82239 3.76892 9.62771 3.87041 9.38268C3.94653 9.19891 3.94653 8.96594 3.94653 8.5V7C3.94653 6.53406 3.94653 6.30109 3.87041 6.11732C3.76892 5.87229 3.57424 5.67761 3.32922 5.57612C3.14545 5.5 2.91247 5.5 2.44653 5.5C1.98059 5.5 1.74762 5.5 1.56385 5.57612C1.31882 5.67761 1.12415 5.87229 1.02265 6.11732Z" fill="white"/>
                    </svg>
                    </div>
                    <div className="header-icons battery">
                        <div className="battery-shell">
                            <div
                            className="battery-level"
                            style={{
                                width: `${batteryLevel}%`,
                                backgroundColor: batteryLevel < 20 ? 'red' : 'rgb(227 227 227)',
                            }}
                            ></div>
                        </div>
                        <span className="battery-percent">{batteryLevel}%</span>
                    </div>
                    <div className='header-icons'>
                         <svg xmlns="http://www.w3.org/2000/svg" width="15" height="10" viewBox="0 0 15 10" fill="none">
                            <path d="M12.9512 4.246C13.0647 4.3525 13.2397 4.353 13.3502 4.243L14.4142 3.179C14.5287 3.064 14.5292 2.8745 14.4112 2.763C12.6022 1.0505 10.1607 0 7.47322 0C4.78572 0 2.34422 1.0505 0.535223 2.763C0.417223 2.8745 0.417723 3.064 0.532223 3.179L1.59622 4.243C1.70672 4.353 1.88172 4.3525 1.99522 4.246C3.42972 2.9015 5.35672 2.077 7.47322 2.077C9.58972 2.077 11.5167 2.9015 12.9512 4.246Z" fill="white"/>
                            <path d="M10.5043 6.69645C10.6198 6.79945 10.7923 6.80045 10.9018 6.69095L11.9643 5.62845C12.0798 5.51295 12.0803 5.32045 11.9603 5.20995C10.7793 4.12445 9.20385 3.46145 7.47334 3.46145C5.74285 3.46145 4.16735 4.12445 2.98635 5.20995C2.86635 5.32045 2.86685 5.51295 2.98235 5.62845L4.04485 6.69095C4.15435 6.80045 4.32685 6.79945 4.44235 6.69645C5.24835 5.97695 6.31035 5.53845 7.47334 5.53845C8.63634 5.53845 9.69835 5.97695 10.5043 6.69645Z" fill="white"/>
                            <path d="M9.5082 7.6611C9.6337 7.7661 9.6327 7.9616 9.5167 8.0776L7.6787 9.9156C7.5662 10.0281 7.3832 10.0281 7.2707 9.9156L5.4327 8.0776C5.3167 7.9616 5.3152 7.7661 5.4412 7.6611C5.9917 7.2006 6.7007 6.9231 7.4747 6.9231C8.2487 6.9231 8.9572 7.2006 9.5082 7.6611Z" fill="white"/>
                        </svg>
                    </div>
            </div>
                <aside className="sidebar">
                    <div className="logox">
                        <div className="logo-icon"><i className="fa-solid fa-gavel"></i></div>
                        <span>{lang.dojsystem}</span>
                    </div>
                    
                    <ul className="nav-menu">
                        <li className="nav-item">
                            <button 
                                className={`nav-link ${activeTab === 'dashboard' ? 'active' : ''}`}
                                onClick={() => setActiveTab('dashboard')}
                            >
                                <i className="fa-solid fa-chart-simple"></i> &nbsp; {lang.dashboard}
                            </button>
                        </li>
                        <li className="nav-item">
                            <button 
                                className={`nav-link ${activeTab === 'pending' ? 'active' : ''}`}
                                onClick={() => setActiveTab('pending')}
                            >
                                <i className="fa-solid fa-gavel"></i> &nbsp; {lang.pendikcases}
                            </button>
                        </li>
                        <li className="nav-item">
                            <button 
                                className={`nav-link ${activeTab === 'active' ? 'active' : ''}`}
                                onClick={() => setActiveTab('active')}
                            >
                                <i className="fa-solid fa-square-check"></i> &nbsp; {lang.accases}
                            </button>
                        </li>
                        {/* <li className="nav-item">
                            <button 
                                className={`nav-link ${activeTab === 'warrants' ? 'active' : ''}`}
                                onClick={() => setActiveTab('warrants')}
                            >
                                <i className="fa-regular fa-bell"></i> &nbsp; {lang.warrants}
                            </button>
                        </li> */}
                        <li className="nav-item">
                            <button 
                                className={`nav-link ${activeTab === 'history' ? 'active' : ''}`}
                                onClick={() => setActiveTab('history')}
                            >
                                <i className="fa-regular fa-folder-open"></i> &nbsp; {lang.verdicthis}
                            </button>
                        </li>
                        <li className="nav-item">
                            <button 
                                className={`nav-link ${activeTab === 'calendar' ? 'active' : ''}`}
                                onClick={() => setActiveTab('calendar')}
                            >
                                <i className="fa-regular fa-calendar"></i> &nbsp; {lang.courtcalendar}
                            </button>
                        </li>
                    </ul>
                    
                    <div style={{ marginTop: 'auto' }}>
                        <select 
                            className="form-select" 
                            value={userRole} 
                            onChange={(e) => setUserRole(e.target.value)}
                            style={{ marginBottom: '20px' }}
                        >
                            <option value="judge">Judge</option>
                            <option value="prosecutor">Prosecutor</option>
                            <option value="lawyer">Lawyer</option>
                        </select>
                    </div>
                </aside>
                
                <main className="main-content">
                    <header className="header">
                        <div className="header-left">
                            <h1 className="page-title">
                                {activeTab === 'dashboard' && lang.dashboard}
                                {activeTab === 'pending' && lang.pendikcases}
                                {activeTab === 'active' && lang.accases}
                                {activeTab === 'warrants' && lang.warreqs}
                                {activeTab === 'history' && lang.verdicthis}
                                {activeTab === 'calendar' && lang.courtcalendar}
                            </h1>
                        </div>
                        
                        <div className="header-rightx">
                            {/* <button 
                                className="theme-toggle"
                                onClick={() => setIsDarkMode(!isDarkMode)}
                            >
                                {isDarkMode ? '☀️' : '🌙'} {isDarkMode ? 'Light' : 'Dark'} Mode
                            </button> */}
                            
                            <div className="user-infox">
                                <div className="user-avatarx">
                                    {userRole === 'judge' ? 'J' : userRole === 'prosecutor' ? 'P' : 'L'}
                                </div>
                                <div className="user-detailsx">
                                    <div className="user-namex">{pname}</div>
                                    <div className="user-rolex">{userRole.charAt(0).toUpperCase() + userRole.slice(1)}</div>
                                </div>
                            </div>
                        </div>
                    </header>
                    
                    <div className="content-area">
                        {renderContent()}
                    </div>

                     {showModal && renderModal()}
                    {showRejectModal && renderRejectModal()}
                </main>
            </div>
            <ColdModal
                appName="DojApp"
                title={lang.error}
                message={lang.emptyFields}
                isOpen={al}
                onClose={() => setal(false)}
                buttons={[
                    { label: lang.ok, onClick: () => setal(false) }
                ]}
            />

            <EnterVerdictModal
                open={modalOpen}
                onClose={() => setModalOpen(false)}
                data={selectedCase}
                lang={lang}
                allCrimes={allCrimes}
                onSubmit={handleVerdictSubmit}
            />
        </>
    );
};

export default DOJApp;