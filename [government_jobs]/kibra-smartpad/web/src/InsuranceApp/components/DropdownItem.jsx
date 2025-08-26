import React from 'react'

export default function DropdownItem({ icon, text, onClick, darkMode }) {
  return (
    <div className="dropdown-item" onClick={onClick}>
      <i className={icon}></i>
      <span>{text}</span>
    </div>
  )
}
