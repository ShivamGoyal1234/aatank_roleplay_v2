import React, { useState } from 'react'

export default function PolicyRenewalModal({ policy, onClose, onRenew, darkMode }) {
  const [renewalData, setRenewalData] = useState({
    new_end_date: '',
    renewal_amount: policy.monthly_premium,
    auto_renewal: false
  })

  const handleSubmit = (e) => {
    e.preventDefault()
    onRenew(renewalData)
  }

  return (
    <div className={`modal-overlay ${darkMode ? 'dark' : 'light'}`}>
      <div className="modal-content">
        <div className="modal-header">
          <h2>Renew Policy</h2>
          <button className="close-btn" onClick={onClose}>×</button>
        </div>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label>Policy Number</label>
            <input type="text" value={policy.policy_number} disabled />
          </div>
          <div className="form-group">
            <label>New End Date</label>
            <input 
              type="date" 
              value={renewalData.new_end_date}
              onChange={(e) => setRenewalData({...renewalData, new_end_date: e.target.value})}
              required
            />
          </div>
          <div className="form-group">
            <label>Renewal Amount</label>
            <input 
              type="number" 
              value={renewalData.renewal_amount}
              onChange={(e) => setRenewalData({...renewalData, renewal_amount: e.target.value})}
              required
            />
          </div>
          <div className="form-group">
            <label>
              <input 
                type="checkbox" 
                checked={renewalData.auto_renewal}
                onChange={(e) => setRenewalData({...renewalData, auto_renewal: e.target.checked})}
              />
              Enable Auto-Renewal
            </label>
          </div>
          <div className="modal-actions">
            <button type="button" className="btn-secondary" onClick={onClose}>
              Cancel
            </button>
            <button type="submit" className="btn-primary">
              Renew Policy
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
