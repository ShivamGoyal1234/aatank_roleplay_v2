import React, {useState, useEffect} from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import './main.css'
import ColdModal from '@/SettingsApp/coldModal/main'
import { callNui } from '@/nui'

const MailComposerModal = ({ isOpen, onClose, myMail, allMails, lang, tabOwner}) => {
    const [receiver, setReceiver] = useState('');
    const [fromMail, setFromMail] = useState('');
    const [subject, setSubject] = useState('');
    const [message, setMessage] = useState('');
    const [suggestions, setSuggestions] = useState([])
    const [alert, setAlerto] = useState(false);
    const handleReceiverChange = e => {
      const v = e.target.value
      setReceiver(v)
      if (v) {
        const filtered = allMails.filter(m => m.toLowerCase().includes(v.toLowerCase()))
        setSuggestions(filtered.slice(0, 5))
      } else {
        setSuggestions([])
      }
    }

    useEffect(() => {
      if(myMail){
        setFromMail(myMail);
      }
    }, [myMail]);

    const selectSuggestion = suggestion => {
      setReceiver(suggestion)
      setSuggestions([])
    }

    const handleSend = () => {
      if (!receiver || !fromMail || !subject || !message) {
        setAlerto(lang.fillAllFields);
        return
      }

      if(receiver === tabOwner){
        setAlerto(lang.cannothim);
        return 
      }

      callNui('SendMail', {
        receiver,
        fromMail,
        subject,
        message,
        type: 0
      })
      onClose()
    }

    return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          className="mail-overlay"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
        >
          <motion.div
            className="mail-modal"
            initial={{ scale: 0.95, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0.95, opacity: 0 }}
            transition={{ duration: 0.25, ease: 'easeInOut' }}
          >
            <h2 className="modal-title2x">{lang.newmail}</h2>
            <div className="yanyana-wrapper">
                <div className="yanyana">
                    <div onClick={onClose} className='sendor'><i style={{color: '#008bff'}}className="fa-solid fa-xmark"></i></div>
                    <div onClick={handleSend} className='sendor'><i className="fa-solid fa-arrow-up"></i></div>
                </div>
            </div>

            <div className='rowan'>
                <div style={{display: 'flex', flexDirection: 'column', marginTop: '15rem'}}>
                    <div className='roxa'>
                        <span className='totxo'>{lang.tox} <input onChange={handleReceiverChange} className='to-kim' value={receiver}></input></span>
                        <div className='bottom-bar'></div>
                        {suggestions.length > 0 && (
                            <ul style={{ listStyle: 'none',
                              margin: '0px',
                              fontFamily: '\'SF Pro Text\'',
                              padding: '0.5rem',
                              fontSize: '12px',
                              zIndex: '1000',
                              background: 'rgb(16, 16, 16)',
                              border: '1px solid rgb(36, 36, 36)',
                              borderRadius: '4px',
                              position: 'absolute',
                              top: '3rem',
                              width: '100%',
                              boxShadow: 'rgb(0 0 0 / 10%) 0px 2px 8px'}}
                            >
                            {suggestions.map((s, i) => (
                              <li
                                key={i}
                                onClick={() => selectSuggestion(s)}
                                style={{ padding: '0.5rem 0', cursor: 'pointer', borderBottom: i < suggestions.length - 1 ? '1px solid rgb(52 52 52)' : 'none' }}
                              >{s}</li>
                            ))}
                          </ul>
                        )}
                    </div>
                     <div className='roxa'>
                        <span className='totxo'>{lang.fromx} <input onChange={(e) => setFromMail(e.target.value)} className='to-kim' value={fromMail}></input></span>
                        <div className='bottom-bar'></div>
                    </div>
                    <div className='roxa'>
                        <span className='totxo'>{lang.subject} <input onChange={(e) => setSubject(e.target.value)} className='to-kim' value={subject}></input></span>
                        <div className='bottom-bar'></div>
                    </div>
                    <div className='roxa'>
                        <textarea onChange={(e) => setMessage(e.target.value)} value={message}></textarea>
                    </div>
                </div>
            </div>
            {/* <input type="text" placeholder="To (e.g. john.doe)" className="mail-input" />
            <input type="text" placeholder="Subject" className="mail-input" />
            <textarea placeholder="Your message..." className="mail-textarea" />

            <div className="modal-actions">
              <button className="modal-button send">Send</button>
              <button className="modal-button cancel" onClick={onClose}>Cancel</button>
            </div> */}
          </motion.div>
          <ColdModal
              appName="Mail"
              title={lang.error}
              message={alert}
              isOpen={alert}
              onClose={() => setAlerto(false)}
              buttons={[
                  { label: lang.ok, onClick: () => {
                      setAlerto(false);
                  }}
              ]}
          />
        </motion.div>
      )}
    </AnimatePresence>
  )
}

export default MailComposerModal
