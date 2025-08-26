import React, { useState, useEffect } from 'react'
import './clockWidget.css';

const ClockWidget = () => {
  const [t, setT] = useState(new Date())
  useEffect(() => {
    const i = setInterval(() => setT(new Date()), 1000)
    return () => clearInterval(i)
  }, [])
  const s = t.getSeconds()
  const m = t.getMinutes()
  const h = t.getHours() % 12
  const sd = s * 6
  const md = m * 6 + s * 0.1
  const hd = h * 30 + m * 0.5
  return (
    <div className="clock-widget">
      <svg viewBox="0 0 100 100">
        <circle cx="50" cy="50" r="48" className="clock-face"/>
        {Array.from({ length: 12 }).map((_, i) => {
          const a = i * 30 * (Math.PI / 180)
          const x1 = 50 + 40 * Math.sin(a)
          const y1 = 50 - 40 * Math.cos(a)
          const x2 = 50 + 45 * Math.sin(a)
          const y2 = 50 - 45 * Math.cos(a)
          return <line key={i} x1={x1} y1={y1} x2={x2} y2={y2} className="tick"/>
        })}
        <line x1="50" y1="50" x2="50" y2="20" className="hour-hand" style={{ transform: `rotate(${hd}deg)`, transformOrigin: '50% 50%' }}/>
        <line x1="50" y1="50" x2="50" y2="15" className="minute-hand" style={{ transform: `rotate(${md}deg)`, transformOrigin: '50% 50%' }}/>
        <line x1="50" y1="50" x2="50" y2="10" className="second-hand" style={{ transform: `rotate(${sd}deg)`, transformOrigin: '50% 50%' }}/>
        <circle cx="50" cy="50" r="2" className="center-dot"/>
      </svg>
    </div>
  )
}

export default ClockWidget
