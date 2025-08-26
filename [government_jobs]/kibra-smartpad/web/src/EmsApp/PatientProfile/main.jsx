import React, { useEffect, useState } from "react";
import './main.css';
import emsLogo from '/public/appicons/ems.png'
import Avatar from '/public/avatar.png'
import TreatmentModal from "./TreatmentModal";
import DoctorNoteModal from "./DoctorNoteModal";

const PatientProfile = ({lang, patientData, allTedaviler, allergies, docnotes, drugs, tabOwnerName, backList}) => {
    const [modalOpen, setModalOpen] = useState(false);
    const [modalOpen2, setModalOpen2] = useState(false);

    const PlayerAlergies = () => {
        const list = allergies
            .filter(x => x.citizen_id === patientData.cid)
            .map(x => x.drug_name)

        return list.length > 0 ? list.join(", ") : lang.none
    }

    const getDoctorNotes = () => {
        const list = [...docnotes]
            .filter(x => x.citizen_id === patientData.cid)
            .reverse()
        return list
    }

    const getTreatments = () => {
    const list = [...allTedaviler]
        .filter(x => x.patient_id === patientData.cid)
        .reverse()
    return list
}


    // useEffect(() => {
    //     console.log("Tedaviler:", allTedaviler);
    //     console.log("Hasta CID:", patientData.cid);
    //     console.log("Filtreli:", getTreatments());

    // }, [])
    return (
        <div className='patient-profile-container'>
            <span className='title-patient'>About Patient</span>
            <div onClick={() => backList(null)} className='add-note'>{lang.back}</div>
            <div onClick={() => setModalOpen(true)} className='add-note'>{lang.addtreatment}</div>
            <div onClick={() => setModalOpen2(true)} className='add-note'>{lang.addnote}</div>
            <div className='bosanmis'>
                <div className='patient-profile-part'>
                    <img
  src={`/web/pimg/${patientData.cid}.png`}
  onError={e=>e.currentTarget.src='/web/pimg/avatar.png'}
/>


                    <span className='patient-name'>{patientData.pName}</span>
                    {patientData.nationality ? 
                        <div className='player-info-item'>
                            <span className='player-item-info-name'>{lang.nationality}</span>
                            <span className='player-item-info-data'>{patientData.nationality}</span>
                        </div> : ''
                    }
                    <div className='patient-box'>
                        <span className='patient-data-label'>{lang.citizenid}</span>
                        <span className='patient-data-string'>{patientData.cid}</span>
                    </div>
                    <div className='patient-box'>
                        <span className='patient-data-label'>{lang.birthday}</span>
                        <span className='patient-data-string'>{patientData.birthday}</span>
                    </div>
                    <div className='patient-box'>
                        <span className='patient-data-label'>{lang.allergies}</span>
                        <span className='patient-data-string'>{PlayerAlergies()}</span>
                    </div>
                </div>
                <div className="patient-history">
                    <div className="patient-history-part">
                        <div className='patient-history-part-header'>
                            <span className='h-title'>{lang.doctorNotes}</span>
                        </div>
                        <div className='patient-content'>
                           {getDoctorNotes().map((element, index) => (
                                <div key={index} className='patient-content-item'>
                                    <div style={{ display: 'flex', justifyContent: 'flex-start' }}>
                                        <div className='patient-content-info-part'>
                                            {element.created_at}
                                        </div>
                                        <div className='patient-content-info-part'>
                                            {element.doctor_name} note:
                                        </div>
                                    </div>
                                    <span className='doctor-note'>
                                        {element.note}
                                    </span>
                                </div>
                            ))}
                        </div>
                    </div>

                    <div style={{height: '377px',marginTop: '1rem',overflow: 'auto'}} className="patient-history-part">
                        <div className='patient-history-part-header'>
                            <span className='h-title'>{lang.treath}</span>
                        </div>
                        <div style={{justifyContent: 'flex-start',
height: '33rem',
maxHeight: '58rem'}} className='patient-content'>
                            <div className='patient-content-table-item'>
                                <div style={{display: 'flex', alignItems: 'center', width: '12rem', height: '100%'}}>
                                    <span className='th-table'>{lang.date}</span>
                                </div>
                                <div style={{display: 'flex', alignItems: 'center', width: '20rem', height: '100%'}}>
                                    <span className='th-table'>{lang.drugUsed}</span>
                                </div>
                                <div style={{display: 'flex', alignItems: 'center', width: '12rem', height: '100%'}}>
                                    <span className='th-table' style={{textAlign: 'right',float: 'right',marginLeft: '3rem',marginRight: '0rem'}}>{lang.responper}</span>
                                </div>
                            </div>
                            {getTreatments().map((element, index) => (
                                <div
                                    key={index}
                                    className='patient-content-table-item'
                                    style={{ backgroundColor: index % 2 === 0 ? 'transparent' : '#101010' }}
                                >
                                    <div style={{display: 'flex', alignItems: 'center', width: '12rem', height: '100%'}}>
                                        <span className='th-table'>{element.date}</span>
                                    </div>
                                    <div style={{display: 'flex', alignItems: 'center', width: '20rem', height: '100%'}}>
                                        <span className='th-table' style={{color: '#fff'}}>{element.drug}</span>
                                    </div>
                                    <div style={{display: 'flex', alignItems: 'center', width: '12rem', height: '100%'}}>
                                        <span className='th-table' style={{color: '#FFF177', textAlign: 'right',float: 'right',marginLeft: '3rem',marginRight: '0rem'}}>{element.responsible}</span>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            </div>
            <TreatmentModal
                isOpen={modalOpen}
                lang={lang}
                tabOwnerName={tabOwnerName}
                onClose={() => setModalOpen(false)}
                drugs={drugs}
                pcid={patientData.cid}
            />

            <DoctorNoteModal
                isOpen={modalOpen2}
                lang={lang}
                tabOwnerName={tabOwnerName}
                onClose={() => setModalOpen2(false)}
                drugs={drugs}
                pcid={patientData.cid}
            />
        </div>
    )
}

export default PatientProfile;