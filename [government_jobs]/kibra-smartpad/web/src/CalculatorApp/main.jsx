import React,{ useState } from 'react'
import Display from './Display.jsx'
import ButtonPanel from './ButtonPanel.jsx'
import calculate from '../logic/calculate.js'
import './main.css'

export default function CalculatorApp(){
  const [s,setS]=useState({ total:null,next:null,operation:null })
  const handleClick = buttonName => {
    setS(prev => ({
        ...prev,
        ...calculate(prev, buttonName)
    }))
    }

  return (
    <div className="calculator-component">
      <Display value={s.next||s.total||'0'}/>
      <ButtonPanel clickHandler={handleClick}/>
    </div>
  )
}
