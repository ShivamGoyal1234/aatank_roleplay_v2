import React, { useState, useEffect } from 'react'
import { callNui } from '@/nui'

const InsurancePlansModal = ({ open, onClose, onSuccess, darkMode, plans = [] }) => {
  const [isCreating, setIsCreating] = useState(false)
  const [formData, setFormData] = useState({
    plan_name: '',
    category: 'Basic',
    monthly_premium: '',
    coverage_amount: '',
    description: '',
    features: '',
    deductible: '',
    max_claims_per_year: ''
  })
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    if (open) {
      setFormData({
        plan_name: '',
        category: 'Basic',
        monthly_premium: '',
        coverage_amount: '',
        description: '',
        features: '',
        deductible: '',
        max_claims_per_year: ''
      })
    }
  }, [open])

  const handleSubmit = async (e) => {
    e.preventDefault()
    
    if (!formData.plan_name || !formData.monthly_premium || !formData.coverage_amount) {
      alert('Please fill in all required fields')
      return
    }
    
    setSubmitting(true)

    const newPlan = {
      plan_name: formData.plan_name,
      category: formData.category,
      monthly_premium: parseFloat(formData.monthly_premium),
      coverage_amount: parseFloat(formData.coverage_amount),
      description: formData.description,
      features: formData.features,
      deductible: parseFloat(formData.deductible) || 0,
      max_claims_per_year: parseInt(formData.max_claims_per_year) || 10,
      is_active: 1
    }

    callNui('createInsurancePlan', newPlan, (result) => {
      setSubmitting(false)
      if (result && result.success) {
        onSuccess(result)
        onClose()
        setIsCreating(false)
      } else {
        alert('Failed to create insurance plan. Please try again.')
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
        background: 'rgba(0,0,0,0.5)',
        zIndex: 99999, display: 'flex',
        alignItems: 'center', justifyContent: 'center',
        transition: 'background 0.2s ease'
      }}
      onClick={onClose}
    >
      <div
        onClick={e => e.stopPropagation()}
        style={{
          width: '90%', maxWidth: 800, maxHeight: '90vh',
          background: darkMode ? '#1f1f23' : '#fff',
          borderRadius: 20, boxShadow: '0 8px 36px rgba(0,0,0,0.16)',
          padding: 32, transform: 'translateY(24px) scale(0.98)',
          opacity: 0, animation: 'smoothModalIn 0.35s cubic-bezier(.58,1.7,.38,.92) forwards',
          border: darkMode ? '1px solid #2a2a2e' : '1px solid #e5e7eb',
          color: darkMode ? '#fff' : '#1e293b',
          position: 'relative',
          overflow: 'auto'
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 24 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <span
              style={{
                display: 'inline-flex', background: darkMode ? '#222' : '#e4e8ef',
                color: darkMode ? '#10B981' : '#059669', borderRadius: 12,
                width: 40, height: 40, alignItems: 'center',
                justifyContent: 'center', fontSize: 18
              }}
            >
              <i className="fa-solid fa-shield-halved"></i>
            </span>
            <span style={{ fontSize: 24, fontWeight: 700 }}>
              {isCreating ? 'Create New Insurance Plan' : 'Insurance Plans'}
            </span>
          </div>
          
          <div style={{ display: 'flex', gap: 8 }}>
            {!isCreating && (
              <button
                onClick={() => setIsCreating(true)}
                style={{
                  background: '#10B981',
                  color: '#fff',
                  border: 'none',
                  padding: '10px 16px',
                  borderRadius: 8,
                  fontWeight: 600,
                  cursor: 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  gap: 6
                }}
              >
                <i className="fa-solid fa-plus"></i>
                Add Plan
              </button>
            )}
            <button
              style={{
                position: 'absolute', top: 18, right: 22,
                background: 'transparent', border: 'none',
                color: darkMode ? '#888' : '#666', fontSize: 24,
                cursor: 'pointer', width: 32, height: 32,
                display: 'flex', alignItems: 'center', justifyContent: 'center'
              }}
              onClick={onClose}
            >
              ×
            </button>
          </div>
        </div>

        {isCreating ? (
          <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 20 }}>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>
              <div>
                <label style={{ fontWeight: 600, fontSize: 14, marginBottom: 6, display: 'block' }}>
                  Plan Name *
                </label>
                <input
                  type="text"
                  placeholder="e.g., Premium Health Elite"
                  value={formData.plan_name}
                  onChange={(e) => setFormData({...formData, plan_name: e.target.value})}
                  required
                  style={{
                    width: '100%', padding: '12px 14px', borderRadius: 10,
                    border: darkMode ? '1px solid #2a2a2e' : '1px solid #d1d5db',
                    background: darkMode ? '#2a2a2e' : '#fff',
                    color: darkMode ? '#fff' : '#1e293b', fontSize: 15,
                    outline: 'none', transition: 'border 0.18s'
                  }}
                />
              </div>

              <div>
                <label style={{ fontWeight: 600, fontSize: 14, marginBottom: 6, display: 'block' }}>
                  Category *
                </label>
                <select
                  value={formData.category}
                  onChange={(e) => setFormData({...formData, category: e.target.value})}
                  required
                  style={{
                    width: '100%', padding: '12px 14px', borderRadius: 10,
                    border: darkMode ? '1px solid #2a2a2e' : '1px solid #d1d5db',
                    background: darkMode ? '#2a2a2e' : '#fff',
                    color: darkMode ? '#fff' : '#1e293b', fontSize: 15,
                    outline: 'none', transition: 'border 0.18s'
                  }}
                >
                  <option value="Basic">Basic</option>
                  <option value="Premium">Premium</option>
                  <option value="Family">Family</option>
                  <option value="Emergency">Emergency</option>
                </select>
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>
              <div>
                <label style={{ fontWeight: 600, fontSize: 14, marginBottom: 6, display: 'block' }}>
                  Monthly Premium ($) *
                </label>
                <input
                  type="number"
                  placeholder="150.00"
                  value={formData.monthly_premium}
                  onChange={(e) => setFormData({...formData, monthly_premium: e.target.value})}
                  required
                  min="0"
                  step="0.01"
                  style={{
                    width: '100%', padding: '12px 14px', borderRadius: 10,
                    border: darkMode ? '1px solid #2a2a2e' : '1px solid #d1d5db',
                    background: darkMode ? '#2a2a2e' : '#fff',
                    color: darkMode ? '#fff' : '#1e293b', fontSize: 15,
                    outline: 'none', transition: 'border 0.18s'
                  }}
                />
              </div>

              <div>
                <label style={{ fontWeight: 600, fontSize: 14, marginBottom: 6, display: 'block' }}>
                  Coverage Amount ($) *
                </label>
                <input
                  type="number"
                  placeholder="50000.00"
                  value={formData.coverage_amount}
                  onChange={(e) => setFormData({...formData, coverage_amount: e.target.value})}
                  required
                  min="0"
                  step="0.01"
                  style={{
                    width: '100%', padding: '12px 14px', borderRadius: 10,
                    border: darkMode ? '1px solid #2a2a2e' : '1px solid #d1d5db',
                    background: darkMode ? '#2a2a2e' : '#fff',
                    color: darkMode ? '#fff' : '#1e293b', fontSize: 15,
                    outline: 'none', transition: 'border 0.18s'
                  }}
                />
              </div>
            </div>

            <div>
              <label style={{ fontWeight: 600, fontSize: 14, marginBottom: 6, display: 'block' }}>
                Description
              </label>
              <textarea
                placeholder="Brief description of the plan..."
                value={formData.description}
                onChange={(e) => setFormData({...formData, description: e.target.value})}
                rows={3}
                style={{
                  width: '100%', padding: '12px 14px', borderRadius: 10,
                  border: darkMode ? '1px solid #2a2a2e' : '1px solid #d1d5db',
                  background: darkMode ? '#2a2a2e' : '#fff',
                  color: darkMode ? '#fff' : '#1e293b', fontSize: 15,
                  outline: 'none', resize: 'vertical', fontFamily: 'inherit'
                }}
              />
            </div>

            <div>
              <label style={{ fontWeight: 600, fontSize: 14, marginBottom: 6, display: 'block' }}>
                Features (comma-separated)
              </label>
              <textarea
                placeholder="Emergency room visits, Basic doctor visits, Prescription drugs"
                value={formData.features}
                onChange={(e) => setFormData({...formData, features: e.target.value})}
                rows={3}
                style={{
                  width: '100%', padding: '12px 14px', borderRadius: 10,
                  border: darkMode ? '1px solid #2a2a2e' : '1px solid #d1d5db',
                  background: darkMode ? '#2a2a2e' : '#fff',
                  color: darkMode ? '#fff' : '#1e293b', fontSize: 15,
                  outline: 'none', resize: 'vertical', fontFamily: 'inherit'
                }}
              />
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>
              <div>
                <label style={{ fontWeight: 600, fontSize: 14, marginBottom: 6, display: 'block' }}>
                  Deductible ($)
                </label>
                <input
                  type="number"
                  placeholder="500.00"
                  value={formData.deductible}
                  onChange={(e) => setFormData({...formData, deductible: e.target.value})}
                  min="0"
                  step="0.01"
                  style={{
                    width: '100%', padding: '12px 14px', borderRadius: 10,
                    border: darkMode ? '1px solid #2a2a2e' : '1px solid #d1d5db',
                    background: darkMode ? '#2a2a2e' : '#fff',
                    color: darkMode ? '#fff' : '#1e293b', fontSize: 15,
                    outline: 'none', transition: 'border 0.18s'
                  }}
                />
              </div>

              <div>
                <label style={{ fontWeight: 600, fontSize: 14, marginBottom: 6, display: 'block' }}>
                  Max Claims per Year
                </label>
                <input
                  type="number"
                  placeholder="10"
                  value={formData.max_claims_per_year}
                  onChange={(e) => setFormData({...formData, max_claims_per_year: e.target.value})}
                  min="1"
                  style={{
                    width: '100%', padding: '12px 14px', borderRadius: 10,
                    border: darkMode ? '1px solid #2a2a2e' : '1px solid #d1d5db',
                    background: darkMode ? '#2a2a2e' : '#fff',
                    color: darkMode ? '#fff' : '#1e293b', fontSize: 15,
                    outline: 'none', transition: 'border 0.18s'
                  }}
                />
              </div>
            </div>

            <div style={{ display: 'flex', gap: 12, marginTop: 20 }}>
              <button
                type="button"
                onClick={() => setIsCreating(false)}
                style={{
                  flex: 1,
                  padding: '12px 20px',
                  background: 'transparent',
                  color: darkMode ? '#fff' : '#1e293b',
                  border: `1px solid ${darkMode ? '#2a2a2e' : '#d1d5db'}`,
                  borderRadius: 10,
                  fontWeight: 600,
                  cursor: 'pointer',
                  transition: 'all 0.2s'
                }}
              >
                Cancel
              </button>
              <button
                type="submit"
                disabled={submitting || !formData.plan_name || !formData.monthly_premium || !formData.coverage_amount}
                style={{
                  flex: 1,
                  padding: '12px 20px',
                  background: (formData.plan_name && formData.monthly_premium && formData.coverage_amount) ? '#10B981' : '#6B7280',
                  color: '#fff',
                  border: 'none',
                  borderRadius: 10,
                  fontWeight: 600,
                  cursor: (submitting || !formData.plan_name || !formData.monthly_premium || !formData.coverage_amount) ? 'not-allowed' : 'pointer',
                  opacity: (submitting || !formData.plan_name || !formData.monthly_premium || !formData.coverage_amount) ? 0.7 : 1,
                  transition: 'all 0.2s'
                }}
              >
                {submitting ? 'Creating Plan...' : 'Create Plan'}
              </button>
            </div>
          </form>
        ) : (
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(300px, 1fr))', gap: 20 }}>
            {plans.map((plan) => (
              <div
                key={plan.id}
                style={{
                  background: darkMode ? '#2a2a2e' : '#f8fafc',
                  borderRadius: 12,
                  padding: 20,
                  border: `1px solid ${darkMode ? '#3a3a3e' : '#e5e7eb'}`,
                  cursor: 'pointer',
                  transition: 'all 0.2s'
                }}
                onMouseEnter={(e) => {
                  e.target.style.transform = 'translateY(-2px)'
                  e.target.style.boxShadow = '0 8px 25px rgba(0,0,0,0.1)'
                }}
                onMouseLeave={(e) => {
                  e.target.style.transform = 'translateY(0)'
                  e.target.style.boxShadow = 'none'
                }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 12 }}>
                  <div>
                    <h4 style={{ fontSize: 18, fontWeight: 600, margin: '0 0 4px 0', color: darkMode ? '#fff' : '#1e293b' }}>
                      {plan.plan_name}
                    </h4>
                    <span style={{
                      padding: '4px 8px',
                      borderRadius: 6,
                      fontSize: 12,
                      fontWeight: 600,
                      background: '#10B98120',
                      color: '#10B981',
                      border: '1px solid #10B98140'
                    }}>
                      {plan.category}
                    </span>
                  </div>
                  <div style={{ textAlign: 'right' }}>
                    <div style={{ fontSize: 20, fontWeight: 700, color: '#10B981' }}>
                      {formatCurrency(plan.monthly_premium)}
                    </div>
                    <div style={{ fontSize: 12, color: darkMode ? '#888' : '#666' }}>/month</div>
                  </div>
                </div>

                <div style={{ marginBottom: 12 }}>
                  <div style={{ fontSize: 14, color: darkMode ? '#ccc' : '#555', marginBottom: 4 }}>
                    Coverage: {formatCurrency(plan.coverage_amount)}
                  </div>
                  <div style={{ fontSize: 14, color: darkMode ? '#ccc' : '#555' }}>
                    Deductible: {formatCurrency(plan.deductible)}
                  </div>
                </div>

                {plan.description && (
                  <p style={{ fontSize: 14, color: darkMode ? '#ddd' : '#333', marginBottom: 12, lineHeight: 1.4 }}>
                    {plan.description}
                  </p>
                )}

                {plan.features && (
                  <div>
                    <div style={{ fontSize: 12, fontWeight: 600, color: darkMode ? '#ccc' : '#555', marginBottom: 6 }}>
                      Features:
                    </div>
                    <ul style={{ fontSize: 12, color: darkMode ? '#ddd' : '#333', margin: 0, paddingLeft: 16 }}>
                      {plan.features.split(', ').slice(0, 3).map((feature, index) => (
                        <li key={index}>{feature}</li>
                      ))}
                      {plan.features.split(', ').length > 3 && (
                        <li>+{plan.features.split(', ').length - 3} more</li>
                      )}
                    </ul>
                  </div>
                )}
              </div>
            ))}
          </div>
        )}

        <style>
          {`@keyframes smoothModalIn {
            from { opacity: 0; transform: translateY(60px) scale(.92); }
            to { opacity: 1; transform: translateY(0) scale(1); }
          }`}
        </style>
      </div>
    </div>
  )
}

export default InsurancePlansModal
