import React, { useState, useEffect } from "react"
import "./TreatmentModal.css"
import { callNui } from "@/nui"

export default function DoctorNoteModal({ lang, isOpen, onClose, pcid, tabOwnerName }) {
  const [responsible, setResponsible] = useState("")
  const [noteText, setNoteText] = useState("")

  useEffect(() => {
    setResponsible(tabOwnerName)
  }, [tabOwnerName])

  if (!isOpen) return null

  return (
    <div className="modal-overlay2">
      <div className="modal-content2">
        <div className="modal-header2">
          <h2 className="modal-header-title">{lang.addnote}</h2>
          <div className="close-button2" onClick={onClose}>×</div>
        </div>
        <div className="modal-body2">
          <label>{lang.resperson}</label>
          <input
            type="text"
            value={responsible}
            onChange={e => setResponsible(e.target.value)}
            placeholder="Dr. House"
          />
          <label>{lang.doctornote}</label>
          <textarea
            value={noteText}
            onChange={e => setNoteText(e.target.value)}
            placeholder={lang.enterNote}
            rows={4}
            style={{width: '91%',
resize: 'none',
background: '#0a0a0a',
padding: '17px',
borderRadius: '7px',
border: '1px solid rgb(18, 18, 18)'
            }}
          />
          <button
            className="submit-button2"
            onClick={() => {
              if (noteText && responsible) {
                callNui("addDoctorNote", {
                  note: noteText,
                  responsible,
                  selectedPerson: pcid
                })
                setNoteText("")
                setResponsible("")
                onClose()
              }
            }}
          >
              {lang.addnote}
          </button>
        </div>
      </div>
    </div>
  )
}
