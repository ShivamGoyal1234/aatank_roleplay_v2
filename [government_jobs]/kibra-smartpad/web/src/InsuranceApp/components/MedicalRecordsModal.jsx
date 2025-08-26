import React, { useState, useEffect } from 'react'
import { callNui } from '@/nui'

const MedicalRecordsModal = ({ open, onClose, onSuccess, darkMode, playerId, playerName }) => {
  const [formData, setFormData] = useState({
    condition: '',
    diagnosis: '',
    treatment: '',
    doctor: '',
    notes: '',
    severity: 'Low'
  })
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    if (open) {
      // Reset form when modal opens
      setFormData({
        condition: '',
        diagnosis: '',
        treatment: '',
        doctor: '',
        notes: '',
        severity: 'Low'
      })
    }
  }, [open])

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (!formData.condition || !formData.diagnosis || !formData.treatment || !formData.doctor) {
      alert('Please fill in all required fields')
      return
    }
    
    setSubmitting(true)

    const medicalRecord = {
      player_id: playerId,
      player_name: playerName,
      condition: formData.condition,
      diagnosis: formData.diagnosis,
      treatment: formData.treatment,
      doctor: formData.doctor,
      notes: formData.notes,
      severity: formData.severity,
      date: new Date().toISOString(),
      status: 'Active'
    }

    callNui('createMedicalRecord', medicalRecord, (result) => {
      setSubmitting(false)
      if (result) {
        onSuccess(result)
        onClose()
      } else {
        alert('Failed to create medical record. Please try again.')
      }
    })
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
              color: darkMode ? '#10B981' : '#059669', borderRadius: 12,
              width: 32, height: 32, alignItems: 'center',
              justifyContent: 'center', marginRight: 10, fontSize: 18
            }}
          >
            <i className="fa-solid fa-user-md"></i>
          </span>
          <span style={{ fontSize: 21, fontWeight: 700 }}>Add Medical Record</span>
        </div>

        {playerName && (
          <div style={{
            padding: 12, borderRadius: 8, background: darkMode ? 'rgba(16, 185, 129, 0.1)' : 'rgba(5, 150, 105, 0.05)',
            border: '1px solid #10B981', marginBottom: 16
          }}>
            <div style={{ fontWeight: 600, fontSize: 14, marginBottom: 4 }}>
              Patient: {playerName}
            </div>
            <div style={{ fontSize: 12, color: darkMode ? '#888' : '#666' }}>
              ID: {playerId}
            </div>
          </div>
        )}

        <form style={{ display: 'flex', flexDirection: 'column', gap: 17 }}>
          <div>
            <label style={{ fontWeight: 600, fontSize: 14 }}>Medical Condition *</label>
            <input
              type="text"
              placeholder="e.g., Hypertension, Diabetes, etc."
              value={formData.condition}
              onChange={(e) => setFormData({...formData, condition: e.target.value})}
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
            <label style={{ fontWeight: 600, fontSize: 14 }}>Diagnosis *</label>
            <textarea
              placeholder="Detailed diagnosis..."
              value={formData.diagnosis}
              onChange={(e) => setFormData({...formData, diagnosis: e.target.value})}
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
            <label style={{ fontWeight: 600, fontSize: 14 }}>Treatment *</label>
            <textarea
              placeholder="Treatment plan and medications..."
              value={formData.treatment}
              onChange={(e) => setFormData({...formData, treatment: e.target.value})}
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

          <div style={{ display: 'flex', gap: 10 }}>
            <div style={{ flex: 1 }}>
              <label style={{ fontWeight: 600, fontSize: 14 }}>Doctor Name *</label>
              <input
                type="text"
                placeholder="Doctor's name"
                value={formData.doctor}
                onChange={(e) => setFormData({...formData, doctor: e.target.value})}
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
              <label style={{ fontWeight: 600, fontSize: 14 }}>Severity</label>
              <select
                value={formData.severity}
                onChange={(e) => setFormData({...formData, severity: e.target.value})}
                style={{
                  width: '100%', padding: '12px 14px', borderRadius: 10,
                  border: darkMode ? '1px solid #28282c' : '1px solid #ddd',
                  background: darkMode ? '#202024' : '#fff',
                  color: darkMode ? '#fff' : '#222', fontSize: 15,
                  marginTop: 5, outline: 'none', transition: 'border 0.18s'
                }}
              >
                <option value="Low">Low</option>
                <option value="Medium">Medium</option>
                <option value="High">High</option>
                <option value="Critical">Critical</option>
              </select>
            </div>
          </div>

          <div>
            <label style={{ fontWeight: 600, fontSize: 14 }}>Additional Notes</label>
            <textarea
              placeholder="Any additional notes or observations..."
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
            disabled={submitting || !formData.condition || !formData.diagnosis || !formData.treatment || !formData.doctor}
            onClick={handleSubmit}
            style={{
              marginTop: 15, background: (formData.condition && formData.diagnosis && formData.treatment && formData.doctor) ? '#10B981' : '#666',
              color: '#fff', border: 'none', borderRadius: 12, fontWeight: 700,
              fontSize: 16, padding: '13px 0', boxShadow: '0 3px 9px 0 rgba(16,185,129,0.05)',
              cursor: (submitting || !formData.condition || !formData.diagnosis || !formData.treatment || !formData.doctor) ? 'not-allowed' : 'pointer',
              opacity: (submitting || !formData.condition || !formData.diagnosis || !formData.treatment || !formData.doctor) ? 0.7 : 1, 
              transition: 'all .17s'
            }}
          >
            {submitting ? 'Creating Record...' : 'Create Medical Record'}
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

export default MedicalRecordsModal
