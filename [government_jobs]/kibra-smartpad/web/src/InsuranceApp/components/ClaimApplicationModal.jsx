import React, { useState, useEffect } from 'react'
import { callNui } from '@/nui'

const ClaimApplicationModal = ({ open, onClose, onSuccess, darkMode, policies }) => {
  const [formData, setFormData] = useState({
    policy_id: '',
    amount: '',
    description: '',
    notes: ''
  })
  const [submitting, setSubmitting] = useState(false)
  const [showPolicyDropdown, setShowPolicyDropdown] = useState(false)
  const [policySearchQuery, setPolicySearchQuery] = useState('')

  useEffect(() => {
    if (open) {
      // Reset form when modal opens
      setFormData({
        policy_id: '',
        amount: '',
        description: '',
        notes: ''
      })
      setPolicySearchQuery('')
      setShowPolicyDropdown(false)
    }
  }, [open])

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (!event.target.closest('[data-modal-dropdown]')) {
        setShowPolicyDropdown(false)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  // Filter policies based on search query
  const filteredPolicies = policies.filter(policy => 
    policy.policy_number.toLowerCase().includes(policySearchQuery.toLowerCase()) ||
    policy.insurance_type.toLowerCase().includes(policySearchQuery.toLowerCase()) ||
    policy.citizen_name.toLowerCase().includes(policySearchQuery.toLowerCase())
  )

  const handlePolicySelect = (policy) => {
    setFormData({
      ...formData,
      policy_id: policy.id
    })
    setShowPolicyDropdown(false)
    setPolicySearchQuery('')
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (!formData.policy_id || !formData.amount || !formData.description) {
      alert('Please fill in all required fields')
      return
    }
    
    setSubmitting(true)

    const selectedPolicy = policies.find(p => p.id == formData.policy_id)
    const newClaim = {
      claim_number: 'CLM-' + Math.random().toString(36).substr(2, 9).toUpperCase(),
      policy_number: selectedPolicy?.policy_number,
      date: new Date().toISOString(),
      status: 'Pending',
      ...formData
    }

    callNui('createInsuranceClaim', newClaim, (result) => {
      setSubmitting(false)
      if (result) {
        onSuccess(result)
        onClose()
      } else {
        alert('Failed to create claim. Please try again.')
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

  if (!open) return null

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
              color: darkMode ? '#EF4444' : '#DC2626', borderRadius: 12,
              width: 32, height: 32, alignItems: 'center',
              justifyContent: 'center', marginRight: 10, fontSize: 18
            }}
          >
            <i className="fa-solid fa-file-medical"></i>
          </span>
          <span style={{ fontSize: 21, fontWeight: 700 }}>New Insurance Claim</span>
        </div>

        <form style={{ display: 'flex', flexDirection: 'column', gap: 17 }}>
          {/* Policy Selection Dropdown */}
          <div style={{ position: 'relative' }} data-modal-dropdown>
            <label style={{ fontWeight: 600, fontSize: 14 }}>Select Policy *</label>
            <div style={{ position: 'relative', marginTop: 5 }}>
              <input
                type="text"
                placeholder="Search and select a policy..."
                value={policySearchQuery}
                onChange={(e) => {
                  setPolicySearchQuery(e.target.value)
                  setShowPolicyDropdown(true)
                }}
                onFocus={() => setShowPolicyDropdown(true)}
                style={{
                  width: '100%', padding: '12px 14px', borderRadius: 10,
                  border: darkMode ? '1px solid #28282c' : '1px solid #ddd',
                  background: darkMode ? '#202024' : '#fff',
                  color: darkMode ? '#fff' : '#222', fontSize: 15,
                  outline: 'none', transition: 'border 0.18s',
                  paddingRight: '40px'
                }}
              />
              <div
                style={{
                  position: 'absolute', right: 12, top: '50%', transform: 'translateY(-50%)',
                  color: darkMode ? '#888' : '#666', cursor: 'pointer',
                  transition: 'transform 0.2s ease',
                  transform: showPolicyDropdown ? 'translateY(-50%) rotate(180deg)' : 'translateY(-50%) rotate(0deg)'
                }}
                onClick={() => setShowPolicyDropdown(!showPolicyDropdown)}
              >
                <i className="fa-solid fa-chevron-down"></i>
              </div>
            </div>

            {/* Dropdown Menu */}
            {showPolicyDropdown && (
              <div
                style={{
                  position: 'absolute', top: '100%', left: 0, right: 0,
                  background: darkMode ? '#2C2C2E' : '#FFFFFF',
                  borderRadius: 10, boxShadow: '0 10px 40px rgba(0, 0, 0, 0.3)',
                  overflow: 'hidden', zIndex: 1000, maxHeight: '200px', overflowY: 'auto',
                  border: darkMode ? '1px solid #28282c' : '1px solid #ddd'
                }}
              >
                {filteredPolicies.length === 0 ? (
                  <div style={{
                    padding: '12px 16px', fontSize: 15,
                    color: darkMode ? '#888' : '#666', textAlign: 'center'
                  }}>
                    {policies.length === 0 ? 'No policies available' : 'No policies found'}
                  </div>
                ) : (
                  filteredPolicies.map((policy) => (
                    <div
                      key={policy.id}
                      onClick={() => handlePolicySelect(policy)}
                      style={{
                        padding: '12px 16px', fontSize: 15,
                        color: darkMode ? '#FFFFFF' : '#000000',
                        cursor: 'pointer', transition: 'all 0.15s ease',
                        borderBottom: darkMode ? '1px solid #28282c' : '1px solid #f0f0f0',
                        background: formData.policy_id == policy.id
                          ? darkMode ? 'rgba(0, 122, 255, 0.3)' : 'rgba(0, 122, 255, 0.1)'
                          : 'transparent'
                      }}
                      onMouseEnter={(e) => {
                        if (formData.policy_id != policy.id) {
                          e.currentTarget.style.background = darkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)'
                        }
                      }}
                      onMouseLeave={(e) => {
                        if (formData.policy_id != policy.id) {
                          e.currentTarget.style.background = 'transparent'
                        }
                      }}
                    >
                      <div style={{ fontWeight: 600, marginBottom: 4 }}>{policy.policy_number}</div>
                      <div style={{ fontSize: 12, color: darkMode ? '#888' : '#666', marginBottom: 4 }}>
                        {policy.insurance_type} • {policy.citizen_name}
                      </div>
                      <div style={{ fontSize: 12, color: darkMode ? '#888' : '#666' }}>
                        Valid until: {formatDate(policy.end_date)}
                      </div>
                    </div>
                  ))
                )}
              </div>
            )}
          </div>

          {/* Selected Policy Display */}
          {formData.policy_id && (
            (() => {
              const selectedPolicy = policies.find(p => p.id == formData.policy_id)
              return selectedPolicy ? (
                <div style={{
                  padding: 12, borderRadius: 8, background: darkMode ? 'rgba(0, 122, 255, 0.1)' : 'rgba(0, 122, 255, 0.05)',
                  border: '1px solid #007AFF', marginBottom: 8
                }}>
                  <div style={{ fontWeight: 600, fontSize: 14, marginBottom: 4 }}>
                    Selected: {selectedPolicy.policy_number}
                  </div>
                  <div style={{ fontSize: 12, color: darkMode ? '#888' : '#666' }}>
                    {selectedPolicy.insurance_type} • {selectedPolicy.citizen_name} • 
                    Valid until: {formatDate(selectedPolicy.end_date)}
                  </div>
                </div>
              ) : null
            })()
          )}

          <div>
            <label style={{ fontWeight: 600, fontSize: 14 }}>Claim Amount ($) *</label>
            <input
              type="number"
              placeholder="Enter amount"
              value={formData.amount}
              onChange={(e) => setFormData({...formData, amount: e.target.value})}
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
            <label style={{ fontWeight: 600, fontSize: 14 }}>Description *</label>
            <textarea
              placeholder="Describe your claim..."
              value={formData.description}
              onChange={(e) => setFormData({...formData, description: e.target.value})}
              required
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

          <div>
            <label style={{ fontWeight: 600, fontSize: 14 }}>Additional Notes</label>
            <textarea
              placeholder="Any additional information..."
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
            disabled={submitting || !formData.policy_id || !formData.amount || !formData.description}
            onClick={handleSubmit}
            style={{
              marginTop: 15, background: (formData.policy_id && formData.amount && formData.description) ? '#007AFF' : '#666',
              color: '#fff', border: 'none', borderRadius: 12, fontWeight: 700,
              fontSize: 16, padding: '13px 0', boxShadow: '0 3px 9px 0 rgba(0,99,255,0.05)',
              cursor: (submitting || !formData.policy_id || !formData.amount || !formData.description) ? 'not-allowed' : 'pointer',
              opacity: (submitting || !formData.policy_id || !formData.amount || !formData.description) ? 0.7 : 1, 
              transition: 'all .17s'
            }}
          >
            {submitting ? 'Submitting Claim...' : 'Submit Claim'}
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

export default ClaimApplicationModal
