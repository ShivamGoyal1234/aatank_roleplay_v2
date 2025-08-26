import React, { useState, useEffect } from 'react'
import { callNui } from '@/nui'

const ClaimApprovalModal = ({ open, onClose, onSuccess, darkMode, claim }) => {
  const [formData, setFormData] = useState({
    status: 'Approved',
    approved_amount: '',
    notes: '',
    approved_by: ''
  })
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    if (open && claim) {
      // Pre-fill with claim amount
      setFormData({
        status: 'Approved',
        approved_amount: claim.amount || '',
        notes: '',
        approved_by: ''
      })
    }
  }, [open, claim])

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (!formData.approved_by) {
      alert('Please enter your name as the approver')
      return
    }
    
    setSubmitting(true)

    const approvalData = {
      claim_id: claim.id,
      claim_number: claim.claim_number,
      status: formData.status,
      approved_amount: formData.status === 'Approved' ? parseFloat(formData.approved_amount) : 0,
      notes: formData.notes,
      approved_by: formData.approved_by,
      approved_date: new Date().toISOString()
    }

    callNui('approveInsuranceClaim', approvalData, (result) => {
      setSubmitting(false)
      if (result) {
        onSuccess(result)
        onClose()
      } else {
        alert('Failed to process claim. Please try again.')
      }
    })
  }

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(amount)
  }

  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString()
  }

  if (!open || !claim) return null

  return (
    <div
      style={{
        position: 'fixed', top: 0, left: 0,
        width: '100%', height: '100%',
        background: 'rgba(0,0,0,0.38)',
        zIndex: 99999, display: 'flex',
        alignItems: 'center', justifyContent: 'center',
        transition: 'background 0.2s ease'
      }}
      onClick={onClose}
    >
      <div
        onClick={e => e.stopPropagation()}
        style={{
          minWidth: 400, width: '100%', maxWidth: 500,
          background: darkMode ? '#19191b' : '#f7f7f9',
          borderRadius: 20, boxShadow: '0 8px 36px rgba(0,0,0,0.16)',
          padding: 32, transform: 'translateY(24px) scale(0.98)',
          opacity: 0, animation: 'smoothModalIn 0.35s cubic-bezier(.58,1.7,.38,.92) forwards',
          border: darkMode ? '1px solid #222226' : '1px solid #ebebee',
          color: darkMode ? '#fff' : '#19191b', position: 'relative'
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', marginBottom: 20 }}>
          <span
            style={{
              display: 'inline-flex', background: darkMode ? '#222' : '#e4e8ef',
              color: darkMode ? '#3B82F6' : '#2563EB', borderRadius: 12,
              width: 32, height: 32, alignItems: 'center',
              justifyContent: 'center', marginRight: 10, fontSize: 18
            }}
          >
            <i className="fa-solid fa-check-circle"></i>
          </span>
          <span style={{ fontSize: 21, fontWeight: 700 }}>Process Insurance Claim</span>
        </div>

        {/* Claim Details */}
        <div style={{
          padding: 16, borderRadius: 12, background: darkMode ? 'rgba(59, 130, 246, 0.1)' : 'rgba(37, 99, 235, 0.05)',
          border: '1px solid #3B82F6', marginBottom: 20
        }}>
          <div style={{ fontWeight: 600, fontSize: 16, marginBottom: 8 }}>
            Claim: {claim.claim_number}
          </div>
          <div style={{ fontSize: 14, color: darkMode ? '#888' : '#666', marginBottom: 4 }}>
            Policy: {claim.policy_number}
          </div>
          <div style={{ fontSize: 14, color: darkMode ? '#888' : '#666', marginBottom: 4 }}>
            Amount: {formatCurrency(claim.amount)}
          </div>
          <div style={{ fontSize: 14, color: darkMode ? '#888' : '#666', marginBottom: 4 }}>
            Date: {formatDate(claim.date)}
          </div>
          <div style={{ fontSize: 14, color: darkMode ? '#888' : '#666' }}>
            Description: {claim.description}
          </div>
        </div>

        <form style={{ display: 'flex', flexDirection: 'column', gap: 17 }}>
          <div>
            <label style={{ fontWeight: 600, fontSize: 14 }}>Decision *</label>
            <select
              value={formData.status}
              onChange={(e) => setFormData({...formData, status: e.target.value})}
              style={{
                width: '100%', padding: '12px 14px', borderRadius: 10,
                border: darkMode ? '1px solid #28282c' : '1px solid #ddd',
                background: darkMode ? '#202024' : '#fff',
                color: darkMode ? '#fff' : '#222', fontSize: 15,
                marginTop: 5, outline: 'none', transition: 'border 0.18s'
              }}
            >
              <option value="Approved">Approve</option>
              <option value="Rejected">Reject</option>
              <option value="Under Review">Under Review</option>
            </select>
          </div>

          {formData.status === 'Approved' && (
            <div>
              <label style={{ fontWeight: 600, fontSize: 14 }}>Approved Amount *</label>
              <input
                type="number"
                placeholder="Enter approved amount"
                value={formData.approved_amount}
                onChange={(e) => setFormData({...formData, approved_amount: e.target.value})}
                required
                style={{
                  width: '100%', padding: '12px 14px', borderRadius: 10,
                  border: darkMode ? '1px solid #28282c' : '1px solid #ddd',
                  background: darkMode ? '#202024' : '#fff',
                  color: darkMode ? '#fff' : '#222', fontSize: 15,
                  marginTop: 5, outline: 'none', transition: 'border 0.18s'
                }}
              />
            </div>
          )}

          <div>
            <label style={{ fontWeight: 600, fontSize: 14 }}>Approver Name *</label>
            <input
              type="text"
              placeholder="Your name"
              value={formData.approved_by}
              onChange={(e) => setFormData({...formData, approved_by: e.target.value})}
              required
              style={{
                width: '100%', padding: '12px 14px', borderRadius: 10,
                border: darkMode ? '1px solid #28282c' : '1px solid #ddd',
                background: darkMode ? '#202024' : '#fff',
                color: darkMode ? '#fff' : '#222', fontSize: 15,
                marginTop: 5, outline: 'none', transition: 'border 0.18s'
              }}
            />
          </div>

          <div>
            <label style={{ fontWeight: 600, fontSize: 14 }}>Notes</label>
            <textarea
              placeholder="Additional notes or comments..."
              value={formData.notes}
              onChange={(e) => setFormData({...formData, notes: e.target.value})}
              rows={3}
              style={{
                width: '100%', padding: '12px 14px', borderRadius: 10,
                border: darkMode ? '1px solid #28282c' : '1px solid #ddd',
                background: darkMode ? '#202024' : '#fff',
                color: darkMode ? '#fff' : '#222', fontSize: 15,
                marginTop: 5, outline: 'none', resize: 'vertical',
                fontFamily: 'inherit'
              }}
            />
          </div>

          <button 
            type="button"
            disabled={submitting || !formData.approved_by || (formData.status === 'Approved' && !formData.approved_amount)}
            onClick={handleSubmit}
            style={{
              marginTop: 15, 
              background: formData.status === 'Approved' ? '#10B981' : formData.status === 'Rejected' ? '#EF4444' : '#3B82F6',
              color: '#fff', border: 'none', borderRadius: 12, fontWeight: 700,
              fontSize: 16, padding: '13px 0', boxShadow: '0 3px 9px 0 rgba(0,0,0,0.1)',
              cursor: (submitting || !formData.approved_by || (formData.status === 'Approved' && !formData.approved_amount)) ? 'not-allowed' : 'pointer',
              opacity: (submitting || !formData.approved_by || (formData.status === 'Approved' && !formData.approved_amount)) ? 0.7 : 1, 
              transition: 'all .17s'
            }}
          >
            {submitting ? 'Processing...' : `Process Claim as ${formData.status}`}
          </button>
        </form>

        <button
          style={{
            position: 'absolute', top: 18, right: 22,
            background: 'transparent', border: 'none',
            color: darkMode ? '#888' : '#222', fontSize: 22,
            cursor: 'pointer'
          }}
          onClick={onClose}
        >
          ×
        </button>
      </div>
      <style>
        {`@keyframes smoothModalIn {
            from { opacity: 0; transform: translateY(60px) scale(.92); }
            to { opacity: 1; transform: translateY(0) scale(1); }
          }`}
      </style>
    </div>
  )
}

export default ClaimApprovalModal
