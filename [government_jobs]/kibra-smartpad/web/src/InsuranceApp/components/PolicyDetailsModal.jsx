import React from 'react'

export default function PolicyDetailsModal({ policy, onClose, darkMode }) {
  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString()
  }

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(amount)
  }

  return (
    <div className={`modal-overlay ${darkMode ? 'dark' : 'light'}`}>
      <div className="modal-content large">
        <div className="modal-header">
          <h2>Policy Details</h2>
          <button className="close-btn" onClick={onClose}>×</button>
        </div>
        <div className="policy-details-content">
          <div className="policy-info">
            <h3>Policy Information</h3>
            <div className="info-grid">
              <div className="info-item">
                <span className="label">Policy Number:</span>
                <span className="value">{policy.policy_number}</span>
              </div>
              <div className="info-item">
                <span className="label">Type:</span>
                <span className="value">{policy.insurance_type}</span>
              </div>
              <div className="info-item">
                <span className="label">Status:</span>
                <span className="value">{policy.status}</span>
              </div>
              <div className="info-item">
                <span className="label">Start Date:</span>
                <span className="value">{formatDate(policy.start_date)}</span>
              </div>
              <div className="info-item">
                <span className="label">End Date:</span>
                <span className="value">{formatDate(policy.end_date)}</span>
              </div>
              <div className="info-item">
                <span className="label">Monthly Premium:</span>
                <span className="value">{formatCurrency(policy.monthly_premium)}</span>
              </div>
              <div className="info-item">
                <span className="label">Coverage Amount:</span>
                <span className="value">{formatCurrency(policy.coverage_amount)}</span>
              </div>
            </div>
          </div>
          
          {policy.emergency_contact && (
            <div className="emergency-info">
              <h3>Emergency Contact</h3>
              <div className="info-grid">
                <div className="info-item">
                  <span className="label">Contact:</span>
                  <span className="value">{policy.emergency_contact}</span>
                </div>
                <div className="info-item">
                  <span className="label">Phone:</span>
                  <span className="value">{policy.emergency_phone}</span>
                </div>
              </div>
            </div>
          )}
        </div>
        <div className="modal-actions">
          <button className="btn-primary" onClick={onClose}>
            Close
          </button>
        </div>
      </div>
    </div>
  )
}
