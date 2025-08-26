import { motion } from 'framer-motion'
import React, { useEffect } from 'react'
import './main.css'

const CrimeDetailsModal = ({ lang, isOpen, onClose, crimeData, typeland, theme}) => {
  if (!isOpen || !crimeData) return null

  // useEffect(() => {
  //   console.log(typeland);
  // }, [crimeData])

  const offenders = Array.isArray(crimeData.offenders) ? crimeData.offenders : []
  const articles = Array.isArray(crimeData.articles) ? crimeData.articles : []
  const media = Array.isArray(crimeData.media) ? crimeData.media : []
  const medias = Array.isArray(crimeData.media) ? crimeData.media : []
  const vehicles = typeof crimeData.vehicle_data === 'string'
    ? JSON.parse(crimeData.vehicle_data || '[]')
    : crimeData.vehicle_data || []

    const cars = typeof crimeData.cars === 'string'
    ? JSON.parse(crimeData.cars)
    : Array.isArray(crimeData.cars) ? crimeData.cars : []
  
  const articlesveh = typeof crimeData.crimes === 'string'
    ? JSON.parse(crimeData.crimes)
    : Array.isArray(crimeData.crimes) ? crimeData.crimes : []
  
  const vehicles5 = typeof crimeData.vehicle_data === 'string'
    ? JSON.parse(crimeData.vehicle_data)[0] || {}
    : Array.isArray(crimeData.vehicle_data) ? crimeData.vehicle_data[0] : {}
  

  return (
    <div className="crime-modal-overlay">
      <motion.div
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        exit={{ opacity: 0, scale: 0.95 }}
        transition={{ duration: 0.2 }}
        className={`crime-modal-container ${theme !== 'dark' ? 'crime-white' : ''}`}
      >
      {(crimeData.typeland == 'cid' || typeland == 'cid') && (
          <>
            <div className={`crime-modal-header ${theme !== 'dark' ? 'crime-white' : ''}`}>
              <h2 style={{ fontSize: '17px', margin: 0 }}>{lang.crimeDetails}</h2>
              <button onClick={onClose}>✕</button>
            </div>

            <div className="crime-modal-section">
              <div className={`crime-title ${theme !== 'dark' ? 'dark-text' : ''}`}>{lang.offenders}</div>
              <ul className={`crime-list ${theme !== 'dark' ? 'crime-list-white' : ''}`}>
                {offenders.map((off, i) => (
                  <li key={i}>{off.name} ({off.cid})</li>
                ))}
              </ul>
            </div>

          <div className="crime-modal-section">
            <div className={`crime-title ${theme !== 'dark' ? 'dark-text' : ''}`}>{lang.articles}</div>
            <ul className={`crime-list ${theme !== 'dark' ? 'crime-list-white' : ''}`}>
              {articles.map((a, i) => (
                <li key={i}>{a.name} - ${a.fine}</li>
              ))}
            </ul>
          </div>
          

        <div className="crime-modal-info">
          <div><span className="crime-label">{lang.date}:</span> {crimeData.date}</div>
          <div><span className="crime-label">{lang.location}:</span> {crimeData.location}</div>
          <div><span className="crime-label">{lang.note}:</span> {crimeData.description}</div>
          <div><span className="crime-label">{lang.enteredby}:</span> {crimeData.officer_name}</div>
          <div><span className="crime-label">{lang.witnesses}:</span> {crimeData.witnesses}</div>
          <div><span className="crime-label">{lang.prisontime}:</span> {crimeData.jail_time || 'N/A'}</div>
          <div><span className="crime-label">{lang.fine}:</span> ${crimeData.fine_amount}</div>
          <div><span className="crime-label">{lang.casenumber}:</span> {crimeData.crime_id}</div>
          <div><span className="crime-label">{lang.vehicleInfo}:</span>
            {vehicles && vehicles.modelName ? (
              <>
                {lang.model}: {vehicles.modelName || lang.unkown} - {lang.color}: {vehicles.color1 || lang.unkown}
              </>
            ) : (
              <div style={{ color: '#777' }}>{lang.noinformationveh}</div>
            )}
          </div>
        </div>

        </>
      )}

        {(crimeData.typeland == 'veh' || typeland == 'veh') && (
          <>
            <div className="crime-modal-header">
              <h2 style={{ fontSize: '17px', margin: 0 }}>{lang.crimeDetails}</h2>
              <button onClick={onClose}>✕</button>
            </div>

            <div className="crime-modal-section">
              <div className="crime-title">{lang.cars}</div>
              <ul className={`crime-list ${theme !== 'dark' ? 'crime-list-white' : ''}`}>
                {cars.map((off, i) => (
                  <li key={i}>{off.plate} ({off.model})</li>
                ))}
              </ul>
            </div>

          <div className="crime-modal-section">
            <div className="crime-title">{lang.articles}</div>
            <ul className={`crime-list ${theme !== 'dark' ? 'crime-list-white' : ''}`}>
              {articlesveh.map((a, i) => (
                <li key={i}>{a.name} - ${a.fine}</li>
              ))}
            </ul>
          </div>
          

        <div className="crime-modal-info">
          <div><span className="crime-label">{lang.date}:</span> {crimeData.date}</div>
          <div><span className="crime-label">{lang.location}:</span> {crimeData.location}</div>
          <div><span className="crime-label">{lang.note}:</span> {crimeData.notes}</div>
          <div><span className="crime-label">{lang.enteredby}:</span> {crimeData.officer_name}</div>
          <div><span className="crime-label">{lang.driver}:</span> {crimeData.dname || 'N/A'}</div>
          <div><span className="crime-label">{lang.fine}:</span> ${crimeData.fine_amount}</div>
          <div><span className="crime-label">{lang.casenumber}:</span> {crimeData.case_id}</div>
          {/* <div><span className="crime-label">{lang.vehicleInfo}:</span> 
            {vehicles5 && vehicles5.modelName ? (
              <>
                {lang.model}: {vehicles5.modelName || lang.unkown} - {lang.color}: {vehicles5.color1 || lang.unkown}
              </>
            ) : (
              <div style={{ color: '#777' }}>{lang.noinformationveh}</div>
            )}
          </div> */}
        </div>
          </>
      )}

        <div className="crime-modal-section">
          <div className="crime-title">{lang.media}</div>
          <div className="crime-media">
            {media.length > 0
              ? media.map((m, i) => (
                  <img key={i} src={m.url} alt={`evidence-${i}`} className="crime-media-img" />
                ))
              : <div style={{ color: '#777' }}>{lang.nomedia}</div>}
          </div>
        </div>
      </motion.div>
    </div>
  )
}

export default CrimeDetailsModal
