import React, { useState, useEffect, useMemo } from 'react'
import CustomDropdown from './dropdown'
import { callNui } from '@/nui'

const ApplicationModal = ({ lang, open, onClose, onSubmit, isDark, isDarkMode, setApplications}) => {
  const [role, setRole] = useState('Muhabir')
  const [name, setName] = useState('')
  const [age, setAge] = useState('')
  const [experience, setExperience] = useState('')
  const [grades, setGrades] = useState([])
  const [motivation, setMotivation] = useState('')
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    callNui('getJournalists', {}, data => {
      if (data.data?.length) setGrades(data.getGrades);
    })
  }, [])

  const roleOptions = useMemo(() =>
    grades.map(g => ({ value: g.gradelevel, label: g.label })), [grades]
  )

  if (!open) return null

  const handleSubmit = async e => {
    e.preventDefault()
    if (!name || !age || !experience || !motivation) return
    setSubmitting(true)
    await onSubmit({ name, age, experience, motivation, role })
    setSubmitting(false)
    onClose()
    setName(''); setAge(''); setExperience(''); setMotivation(''); setRole('Muhabir')
  }

  const sendReq = () => {
    callNui('createJobApplications', {
      role,
      name,
      age,
      experience,
      motivation,
    }, (res) => {
      
    })
  }

  return (
    <div
      style={{
        position: 'fixed', top: 0, left: 0,
        width: '100%', height: '100%',
        background: 'rgba(0,0,0,0.38)',
        zIndex: 9999, display: 'flex',
        alignItems: 'center', justifyContent: 'center',
        transition: 'background 0.2s ease'
      }}
      onClick={onClose}
    >
      <div
        onClick={e => e.stopPropagation()}
        style={{
          minWidth: 350, width: '100%', maxWidth: 420,
          background: isDark ? '#19191b' : '#f7f7f9',
          borderRadius: 20, boxShadow: '0 8px 36px rgba(0,0,0,0.16)',
          padding: 32, transform: 'translateY(24px) scale(0.98)',
          opacity: 0, animation: 'smoothModalIn 0.35s cubic-bezier(.58,1.7,.38,.92) forwards',
          border: isDark ? '1px solid #222226' : '1px solid #ebebee',
          color: isDark ? '#fff' : '#19191b', position: 'relative'
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', marginBottom: 20 }}>
          <span
            style={{
              display: 'inline-flex', background: isDark ? '#222' : '#e4e8ef',
              color: isDark ? '#fdc70a' : '#9b8800', borderRadius: 12,
              width: 32, height: 32, alignItems: 'center',
              justifyContent: 'center', marginRight: 10, fontSize: 18
            }}
          >
            <i className="fa-solid fa-user-plus"></i>
          </span>
          <span style={{ fontSize: 21, fontWeight: 700 }}>{lang.apply}</span>
        </div>
        <form style={{ display: 'flex', flexDirection: 'column', gap: 17 }}>
          <div>
            <label style={{ fontWeight: 600, fontSize: 14 }}>{lang.firstName} {lang.lastName}</label>
            <input
              type="text" placeholder={lang.ne} value={name}
              onChange={e => setName(e.target.value)}
              style={{
                width: '93%', padding: '12px 14px', borderRadius: 10,
                border: isDark ? '1px solid #28282c' : '1px solid #ddd',
                background: isDark ? '#202024' : '#fff',
                color: isDark ? '#fff' : '#222', fontSize: 15,
                marginTop: 5, outline: 'none', transition: 'border 0.18s'
              }}
            />
          </div>
          <div style={{ display: 'flex', gap: 10 }}>
            <div style={{ flex: 1 }}>
              <label style={{ fontWeight: 600, fontSize: 14 }}>{lang.age}</label>
              <input
                type="number" min={15} placeholder={lang.age} value={age}
                onChange={e => setAge(e.target.value)}
                style={{
                  width: '82%', padding: '12px 14px', borderRadius: 10,
                  border: isDark ? '1px solid #28282c' : '1px solid #ddd',
                  background: isDark ? '#202024' : '#fff',
                  color: isDark ? '#fff' : '#222', fontSize: 15,
                  marginTop: 5, outline: 'none'
                }}
              />
            </div>
            <div style={{ flex: 1 }}>
              <label style={{ fontWeight: 600, fontSize: 14 }}>{lang.role}</label>
              <div style={{marginTop: '.5rem'}}>
                <CustomDropdown
                  value={role} onChange={v => setRole(v)}
                  options={roleOptions} isDarkMode={isDarkMode}
                  placeholder={lang.selrole}
                />
              </div>
            </div>
          </div>
          <div>
            <label style={{ fontWeight: 600, fontSize: 14 }}>{lang.experience}</label>
            <input
              type="text" placeholder={lang.expp} value={experience}
              onChange={e => setExperience(e.target.value)}
              style={{
                width: '93%', padding: '12px 14px', borderRadius: 10,
                border: isDark ? '1px solid #28282c' : '1px solid #ddd',
                background: isDark ? '#202024' : '#fff',
                color: isDark ? '#fff' : '#222', fontSize: 15,
                marginTop: 5, outline: 'none'
              }}
            />
          </div>
          <div>
            <label style={{ fontWeight: 600, fontSize: 14 }}>{lang.motivation}</label>
            <textarea
              rows={2} placeholder={lang.whyy} value={motivation}
              onChange={e => setMotivation(e.target.value)}
              style={{
                width: '93%', padding: '12px 14px', borderRadius: 10,
                border: isDark ? '1px solid #28282c' : '1px solid #ddd',
                background: isDark ? '#202024' : '#fff',
                color: isDark ? '#fff' : '#222', fontSize: 15,
                marginTop: 5, outline: 'none', resize: 'vertical'
              }}
            />
          </div>
          <button 
            type="button"
            disabled={submitting}
            style={{
              marginTop: 15, background: '#007AFF', color: '#fff',
              border: 'none', borderRadius: 12, fontWeight: 700,
              fontSize: 16, padding: '13px 0',
              boxShadow: '0 3px 9px 0 rgba(0,99,255,0.05)',
              cursor: submitting ? 'not-allowed' : 'pointer',
              opacity: submitting ? 0.7 : 1, transition: 'all .17s'
            }}
            onClick={sendReq}
          >
            {submitting ? lang.sending : lang.senx}
          </button>
        </form>
        <button
          style={{
            position: 'absolute', top: 18, right: 22,
            background: 'transparent', border: 'none',
            color: isDark ? '#888' : '#222', fontSize: 22,
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

export default ApplicationModal
