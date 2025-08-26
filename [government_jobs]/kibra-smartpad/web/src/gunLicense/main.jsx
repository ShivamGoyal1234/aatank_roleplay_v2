import React from 'react'
import './main.css'
import Avatar from '/public/avatar.png'

const GunLicenseCard = ({lang, data, isOpen}) => (
  <div className="guncard">
    <div className="guncard-header">
      <div className="header-small">{lang.GOVERNMENTOFLOSSANTOS}</div>
      <div className="header-large">LOS SANTOS <span className="accent">{lang.WEAPONLICENSE}</span></div>
    </div>
    <div className="guncard-body">
    <img
        src={`/web/pimg/${data.OwnerCid}.png`}
        alt="Avatar"
        className="avatar"
        onError={e=>{e.target.onerror=null; e.target.src=Avatar}}
    />      
    <div className="info">
        <div className="name">{data.Owner}</div>
        <div className="divider" />
        <div className="details-grid">
          <div className="detail-block">
            <span className="detail-label">{lang.DateofBirth}:</span>
            <span className="detail-value">{data.PrintingDate}</span>
          </div>
          <div className="detail-block">
            <span className="detail-label">{lang.gender}:</span>
            <span className="detail-value">{data.Gender == 0 ? lang.male : lang.female}</span>
          </div>
          <div className="detail-block">
            <span className="detail-label">{lang.type}:</span>
            <span className="detail-value">{data.Type}</span>
          </div>
          <div className="detail-block">
            <span className="detail-label">{lang.serialNo}:</span>
            <span className="detail-value">{data.License}</span>
          </div>
          <div className="detail-block">
            <span className="detail-label">{lang.signature}:</span>
            <span className="detail-value signature">{data.Owner}</span>
          </div>
          <div className="detail-block">
            <span className="detail-label">{lang.expirationdate}:</span>
            <span className="detail-value">02-2030</span>
          </div>
        </div>
      </div>
    </div>
  </div>
)

export default GunLicenseCard
