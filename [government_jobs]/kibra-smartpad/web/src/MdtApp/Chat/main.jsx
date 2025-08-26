import React, { useState, useEffect, useRef } from 'react'
import './main.css'
import { callNui } from '@/nui'
import { v4 as uuidv4 } from 'uuid';

export default function MDTChat({ lang, allMessages, playerName }) {
  const [text, setText] = useState('')
  const [messages, setMessages] = useState([])

  useEffect(() => {
    setMessages(allMessages)
  }, [allMessages]);

  const messagesRef = useRef(null)
  useEffect(() => {
    const el = messagesRef.current;
    if (el) {
      el.scrollTop = el.scrollHeight;
    }
  }, [messages])

  const send = () => {
    if (!text) return;
    const newMsg = {
      id: uuidv4(),
      sender: playerName,
      message: text,
      type: 'mdt',
      time: new Date().toLocaleTimeString()
    };
    callNui('sendMessage', newMsg);
    setText('');
  };

  return (
    <div className="ems-chat">
      <div className="ems-chat-header">
        <span className="ems-heax">{lang.mdtchat}</span>
      </div>
     <div className="ems-messages" ref={messagesRef}>
        {messages.map((m, i) => (
          <div key={i} className={m.sender === playerName ? 'msg minex' : 'msg'}>
            <div className="sender">{m.sender}</div>
            <div className="text">{m.message}</div>
            <div className="timestamp">{m.time}</div>
          </div>
        ))}
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
