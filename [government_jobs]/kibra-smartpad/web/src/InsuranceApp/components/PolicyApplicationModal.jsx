import React, { useState, useEffect } from 'react'
import { callNui } from '@/nui'

const PolicyApplicationModal = ({ open, onClose, onSuccess, darkMode, plans }) => {
  const [formData, setFormData] = useState({
    insurance_type: '',
    start_date: '',
    end_date: '',
    monthly_premium: '',
    coverage_amount: '',
    emergency_contact: '',
    emergency_phone: '',
    selected_plan: null
  })
  const [submitting, setSubmitting] = useState(false)
  const [showPlanDropdown, setShowPlanDropdown] = useState(false)
  const [planSearchQuery, setPlanSearchQuery] = useState('')

  useEffect(() => {
    if (open) {
      // Reset form when modal opens
      setFormData({
        insurance_type: '',
        start_date: '',
        end_date: '',
        monthly_premium: '',
        coverage_amount: '',
        emergency_contact: '',
        emergency_phone: '',
        selected_plan: null
      })
      setPlanSearchQuery('')
      setShowPlanDropdown(false)
    }
  }, [open])

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (!event.target.closest('[data-modal-dropdown]')) {
        setShowPlanDropdown(false)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  // Filter plans based on search query
  const filteredPlans = plans.filter(plan => 
    plan.plan_name.toLowerCase().includes(planSearchQuery.toLowerCase()) ||
    plan.category.toLowerCase().includes(planSearchQuery.toLowerCase())
  )

  const handlePlanSelect = (plan) => {
    setFormData({
      ...formData,
      insurance_type: plan.category,
      monthly_premium: plan.monthly_premium,
      coverage_amount: plan.coverage_amount,
      selected_plan: plan
    })
    setShowPlanDropdown(false)
    setPlanSearchQuery('')
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (!formData.selected_plan || !formData.start_date || !formData.end_date) {
      alert('Please fill in all required fields')
      return
    }
    
    setSubmitting(true)

    const newPolicy = {
      policy_number: 'POL-' + Math.random().toString(36).substr(2, 9).toUpperCase(),
      citizen_id: 'CIT-' + Math.random().toString(36).substr(2, 9).toUpperCase(),
      citizen_name: 'John Doe', // This would come from player data
      status: 'Active',
      created_at: new Date().toISOString(),
      ...formData
    }

    callNui('createInsurancePolicy', newPolicy, (result) => {
      setSubmitting(false)
      if (result) {
        onSuccess(result)
        onClose()
      } else {
        alert('Failed to create policy. Please try again.')
      }
    })
  }

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(amount)
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
          color: darkMode ? '#fff' : '#19191b', position: 'relative',
          maxHeight: '90vh', overflow: 'auto'
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', marginBottom: 20 }}>
          <span
            style={{
              display: 'inline-flex', background: darkMode ? '#222' : '#e4e8ef',
              color: darkMode ? '#fdc70a' : '#9b8800', borderRadius: 12,
              width: 32, height: 32, alignItems: 'center',
              justifyContent: 'center', marginRight: 10, fontSize: 18
            }}
          >
            <i className="fa-solid fa-shield-halved"></i>
          </span>
          <span style={{ fontSize: 21, fontWeight: 700 }}>New Insurance Policy</span>
        </div>

        <form style={{ display: 'flex', flexDirection: 'column', gap: 17 }}>
          {/* Plan Selection Dropdown */}
          <div style={{ position: 'relative' }} data-modal-dropdown>
            <label style={{ fontWeight: 600, fontSize: 14 }}>Choose Insurance Plan *</label>
            <div style={{ position: 'relative', marginTop: 5 }}>
              <input
                type="text"
                placeholder="Search and select a plan..."
                value={planSearchQuery}
                onChange={(e) => {
                  setPlanSearchQuery(e.target.value)
                  setShowPlanDropdown(true)
                }}
                onFocus={() => setShowPlanDropdown(true)}
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
                  transform: showPlanDropdown ? 'translateY(-50%) rotate(180deg)' : 'translateY(-50%) rotate(0deg)'
                }}
                onClick={() => setShowPlanDropdown(!showPlanDropdown)}
              >
                <i className="fa-solid fa-chevron-down"></i>
              </div>
            </div>

            {/* Dropdown Menu */}
            {showPlanDropdown && (
              <div
                style={{
                  position: 'absolute', top: '100%', left: 0, right: 0,
                  background: darkMode ? '#2C2C2E' : '#FFFFFF',
                  borderRadius: 10, boxShadow: '0 10px 40px rgba(0, 0, 0, 0.3)',
                  overflow: 'hidden', zIndex: 1000, maxHeight: '200px', overflowY: 'auto',
                  border: darkMode ? '1px solid #28282c' : '1px solid #ddd'
                }}
              >
                {filteredPlans.length === 0 ? (
                  <div style={{
                    padding: '12px 16px', fontSize: 15,
                    color: darkMode ? '#888' : '#666', textAlign: 'center'
                  }}>
                    No plans found
                  </div>
                ) : (
                  filteredPlans.map((plan) => (
                    <div
                      key={plan.id}
                      onClick={() => handlePlanSelect(plan)}
                      style={{
                        padding: '12px 16px', fontSize: 15,
                        color: darkMode ? '#FFFFFF' : '#000000',
                        cursor: 'pointer', transition: 'all 0.15s ease',
                        borderBottom: darkMode ? '1px solid #28282c' : '1px solid #f0f0f0',
                        background: formData.selected_plan?.id === plan.id
                          ? darkMode ? 'rgba(0, 122, 255, 0.3)' : 'rgba(0, 122, 255, 0.1)'
                          : 'transparent'
                      }}
                      onMouseEnter={(e) => {
                        if (formData.selected_plan?.id !== plan.id) {
                          e.currentTarget.style.background = darkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)'
                        }
                      }}
                      onMouseLeave={(e) => {
                        if (formData.selected_plan?.id !== plan.id) {
                          e.currentTarget.style.background = 'transparent'
                        }
                      }}
                    >
                      <div style={{ fontWeight: 600, marginBottom: 4 }}>{plan.plan_name}</div>
                      <div style={{ fontSize: 12, color: darkMode ? '#888' : '#666', marginBottom: 4 }}>
                        {plan.category} • {formatCurrency(plan.monthly_premium)}/month
                      </div>
                      <div style={{ fontSize: 12, color: darkMode ? '#888' : '#666' }}>
                        Coverage: {formatCurrency(plan.coverage_amount)}
                      </div>
                    </div>
                  ))
                )}
              </div>
            )}
          </div>

          {/* Selected Plan Display */}
          {formData.selected_plan && (
            <div style={{
              padding: 12, borderRadius: 8, background: darkMode ? 'rgba(0, 122, 255, 0.1)' : 'rgba(0, 122, 255, 0.05)',
              border: '1px solid #007AFF', marginBottom: 8
            }}>
              <div style={{ fontWeight: 600, fontSize: 14, marginBottom: 4 }}>
                Selected: {formData.selected_plan.plan_name}
              </div>
              <div style={{ fontSize: 12, color: darkMode ? '#888' : '#666' }}>
                {formatCurrency(formData.selected_plan.monthly_premium)}/month • 
                Coverage: {formatCurrency(formData.selected_plan.coverage_amount)}
              </div>
            </div>
          )}

          <div style={{ display: 'flex', gap: 10 }}>
            <div style={{ flex: 1 }}>
              <label style={{ fontWeight: 600, fontSize: 14 }}>Start Date *</label>
              <input
                type="date"
                value={formData.start_date}
                onChange={(e) => setFormData({...formData, start_date: e.target.value})}
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
            <div style={{ flex: 1 }}>
              <label style={{ fontWeight: 600, fontSize: 14 }}>End Date *</label>
              <input
                type="date"
                value={formData.end_date}
                onChange={(e) => setFormData({...formData, end_date: e.target.value})}
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
          </div>

          <div style={{ display: 'flex', gap: 10 }}>
            <div style={{ flex: 1 }}>
              <label style={{ fontWeight: 600, fontSize: 14 }}>Emergency Contact</label>
              <input
                type="text"
                placeholder="Contact name"
                value={formData.emergency_contact}
                onChange={(e) => setFormData({...formData, emergency_contact: e.target.value})}
                style={{
                  width: '100%', padding: '12px 14px', borderRadius: 10,
                  border: darkMode ? '1px solid #28282c' : '1px solid #ddd',
                  background: darkMode ? '#202024' : '#fff',
                  color: darkMode ? '#fff' : '#222', fontSize: 15,
                  marginTop: 5, outline: 'none', transition: 'border 0.18s'
                }}
              />
            </div>
            <div style={{ flex: 1 }}>
              <label style={{ fontWeight: 600, fontSize: 14 }}>Emergency Phone</label>
              <input
                type="tel"
                placeholder="Phone number"
                value={formData.emergency_phone}
                onChange={(e) => setFormData({...formData, emergency_phone: e.target.value})}
                style={{
                  width: '100%', padding: '12px 14px', borderRadius: 10,
                  border: darkMode ? '1px solid #28282c' : '1px solid #ddd',
                  background: darkMode ? '#202024' : '#fff',
                  color: darkMode ? '#fff' : '#222', fontSize: 15,
                  marginTop: 5, outline: 'none', transition: 'border 0.18s'
                }}
              />
            </div>
          </div>

          <button 
            type="button"
            disabled={submitting || !formData.selected_plan || !formData.start_date || !formData.end_date}
            onClick={handleSubmit}
            style={{
              marginTop: 15, background: (formData.selected_plan && formData.start_date && formData.end_date) ? '#007AFF' : '#666',
              color: '#fff', border: 'none', borderRadius: 12, fontWeight: 700,
              fontSize: 16, padding: '13px 0', boxShadow: '0 3px 9px 0 rgba(0,99,255,0.05)',
              cursor: (submitting || !formData.selected_plan || !formData.start_date || !formData.end_date) ? 'not-allowed' : 'pointer',
              opacity: (submitting || !formData.selected_plan || !formData.start_date || !formData.end_date) ? 0.7 : 1, 
              transition: 'all .17s'
            }}
          >
            {submitting ? 'Creating Policy...' : 'Create Policy'}
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

export default PolicyApplicationModal
