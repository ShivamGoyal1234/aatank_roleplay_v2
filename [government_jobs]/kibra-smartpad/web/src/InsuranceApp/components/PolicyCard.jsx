import React from 'react'

export default function PolicyCard({ policy, onClick, onRenew, darkMode }) {
  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString()
  }

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(amount)
  }

  const getStatusColor = (status) => {
    switch (status) {
      case 'Active': return '#10B981'
      case 'Expired': return '#EF4444'
      case 'Cancelled': return '#F59E0B'
      case 'Pending': return '#3B82F6'
      default: return '#6B7280'
    }
  }

  const getInsuranceTypeColor = (type) => {
    switch (type) {
      case 'Basic': return '#6B7280'
      case 'Premium': return '#10B981'
      case 'Family': return '#3B82F6'
      case 'Emergency': return '#EF4444'
      default: return '#6B7280'
    }
  }

  return (
    <div 
      className="policy-card"
      onClick={onClick}
    >
      <div className="policy-header">
        <div className="policy-type" style={{ backgroundColor: getInsuranceTypeColor(policy.insurance_type) }}>
          {policy.insurance_type}
        </div>
        <div className="policy-status" style={{ backgroundColor: getStatusColor(policy.status) }}>
          {policy.status}
        </div>
      </div>
      <div className="policy-body">
        <h3>Policy #{policy.policy_number}</h3>
        <p className="policy-name">{policy.citizen_name}</p>
        <div className="policy-details">
          <div className="detail">
            <span>Premium:</span>
            <span>{formatCurrency(policy.monthly_premium)}/month</span>
          </div>
          <div className="detail">
            <span>Coverage:</span>
            <span>{formatCurrency(policy.coverage_amount)}</span>
          </div>
          <div className="detail">
            <span>Valid Until:</span>
            <span>{formatDate(policy.end_date)}</span>
          </div>
        </div>
      </div>
      <div className="policy-actions">
        <button className="btn-small" onClick={(e) => {
          e.stopPropagation()
          onRenew(policy)
        }}>
          Renew
        </button>
      </div>
    </div>
  )
}
