import React from 'react'

export default function DropdownButton({ 
  icon, 
  text, 
  isOpen, 
  onClick, 
  children, 
  darkMode 
}) {
  return (
    <div className="dropdown-container">
      <button className="dropdown-button" onClick={onClick}>
        <i className={icon}></i>
        <span>{text}</span>
        <i className={`fa-solid fa-chevron-down ${isOpen ? 'rotated' : ''}`}></i>
      </button>
      {isOpen && (
        <div className="dropdown-menu">
          {children}
        </div>
      )}
    </div>
  )
}
