import React, { useEffect } from 'react'
import './main.css'

const ColdModal = ({ appName, title, message, buttons, isOpen, onClose }) => {
  useEffect(() => {
    document.body.style.overflow = isOpen ? 'hidden' : ''
  }, [isOpen])

  if (!isOpen) return null

  return (
    <div className="nm-overlay" onClick={onClose}>
      <div className="nm-modal" onClick={e => e.stopPropagation()}>
        <div className="nm-header">“{appName}” {title}</div>
        <div className="nm-message">{message}</div>
        <div className="nm-buttons">
          {buttons.map((btn, idx) => (
            <button key={idx} className="nm-button" onClick={btn.onClick}>
              {btn.label}
            </button>
          ))}
        </div>
      </div>
    </div>
  )
}

export default ColdModal;
