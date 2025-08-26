import React, { useState, useEffect, useRef } from 'react'
import './main.css'
import { callNui } from '@/nui'

export default function EMSChat({ lang, allMessages, playerName }) {
  const [text, setText] = useState('')
  const [messages, setMessages] = useState(allMessages)
  const messagesEndRef = useRef(null)

  useEffect(() => {
    setMessages(allMessages)
  }, [allMessages])

  const send = () => {
    if (!text) return
    const newMsg = { sender: playerName, message: text, type: 'ems' }
    setMessages(prev => [...prev, newMsg])
    callNui('sendMessage', newMsg)
    setText('')
  }

  return (
    <div className="ems-chat">
      <div className="ems-chat-header">
        <span className="ems-heax">{lang.emschat}</span>
      </div>
      <div className="ems-messages">
        {messages.map((m, i) => (
          <div key={i} className={m.sender === playerName ? 'msg mine' : 'msg'}>
            <div className="sender">{m.sender}</div>
            <div className="text">{m.message}</div>
            <div className="timestamp">{m.time}</div>
          </div>
        ))}
        <div ref={messagesEndRef} />
      </div>
      <div className="ems-input">
        <input
          value={text}
          onChange={e => setText(e.target.value)}
          onKeyDown={e => e.key === 'Enter' && send()}
          placeholder={lang.writesmt}
        />
        <button onClick={send}>
          <svg xmlns="http://www.w3.org/2000/svg" width="19" height="16" viewBox="0 0 19 16" fill="none">
            <path d="M0 0V6.18182L10.9091 8L0 9.81818V16L18.9091 8L0 0Z" fill="#9B9B9B" />
          </svg>
        </button>
      </div>
    </div>
  )
}
