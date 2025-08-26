import React from 'react'

export default function ClaimItem({ claim, darkMode, onApprove }) {
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

  return (
    <div className="claim-item">
      <div className="claim-header">
        <h4>Claim #{claim.claim_number}</h4>
        <div className="claim-status" style={{ backgroundColor: getStatusColor(claim.status) }}>
          {claim.status}
        </div>
      </div>
      <div className="claim-details">
        <p><strong>Date:</strong> {formatDate(claim.date)}</p>
        <p><strong>Amount:</strong> {formatCurrency(claim.amount)}</p>
        <p><strong>Description:</strong> {claim.description}</p>
        {claim.notes && <p><strong>Notes:</strong> {claim.notes}</p>}
      </div>
      {claim.status === 'Pending' && onApprove && (
        <div style={{ marginTop: 12, textAlign: 'right' }}>
          <button
            onClick={() => onApprove(claim)}
            style={{
              background: '#10B981',
              color: '#fff',
              border: 'none',
              padding: '8px 16px',
              borderRadius: 6,
              fontSize: 12,
              fontWeight: 500,
              cursor: 'pointer',
              transition: 'all 0.2s ease'
            }}
          >
            <i className="fa-solid fa-check" style={{ marginRight: 6 }}></i>
            Process Claim
          </button>
        </div>
      )}
    </div>
  )
}
