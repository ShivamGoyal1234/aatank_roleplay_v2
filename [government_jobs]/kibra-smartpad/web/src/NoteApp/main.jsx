import React, { useState, useRef, useEffect } from 'react'
import { ReactSketchCanvas } from 'react-sketch-canvas'
import { callNui } from '@/nui'
import './main.css'
import ColdModal from '@/SettingsApp/coldModal/main'

export default function NotesApp({lang, allNotes, tabOwner, tabletTheme, myLimit}) {
  const [notes, setNotes] = useState([])
  const [selectedNoteId, setSelectedNoteId] = useState(null)
  const [mode, setMode] = useState('nonMode')
  const [text, setText] = useState('')
  const [drawData, setDrawData] = useState(null);
  const [selectad, setSelectad] = useState('');
  const [darkMode, setDarkMode] = useState(true)
  const canvasRef = useRef(null)
  const [verver, Verme] = useState(false);
  const [modTheme, setModTheme] = useState(false);

  useEffect(() => {
    setNotes(allNotes)
  }, [allNotes])

  useEffect(() => {
    if (mode === 'draw' && canvasRef.current) {
      canvasRef.current.clearCanvas()
      if (drawData) {
        canvasRef.current.loadPaths(drawData)
      }
    }
  }, [mode])


  useEffect(() => {
    setNotes(allNotes);
    if(tabletTheme == 'light'){
      setModTheme(true)
    } else {
      setModTheme(false);
    }
  }, [])

  // Kısa random id/hash üret
  const generateId = () => Math.random().toString(36).substr(2, 9)
  
  // Yeni not ekle
const handleNewNote = () => {
  if (notes.length < myLimit) {
    const newId = generateId()
    const newNote = {
      id: newId,
      label: lang.untitledNot,
      text: '',
      mode: 'nonMode',
      drawing: null,
      date: new Date().toLocaleString()
    }
    const updated = [...notes, newNote]
    setNotes(updated)
    setSelectedNoteId(newId)
    setText('')
    setDrawData(null)
    callNui('updateNote', { id: newId, note: newNote })
    openNote(newNote, false)
    setMode('nonMode')
  } else {
    Verme(true)
  }
}



  const openNote = (note, skipMode = true) => {
    setSelectedNoteId(note.id)
    setText(note.text)
    setSelectad(note.id)
    setDrawData(note.drawing)
    if (skipMode) {
        setMode(note.drawing && note.drawing.length > 0 ? 'draw' : 'text') 
    }
  }

  const handleSaveNote = async () => {
    if (!selectedNoteId) return
    const idx = notes.findIndex(n => n.id === selectedNoteId)
    if (idx === -1) return
    let paths = drawData || []
    if (canvasRef.current) paths = await canvasRef.current.exportPaths()
    const updatedNotes = [...notes]
    const old = updatedNotes[idx]
    const newNote = { id: old.id, label: old.label, text, drawing: paths, date: old.date }
    updatedNotes.splice(idx, 1)
    updatedNotes.unshift(newNote)
    setNotes(updatedNotes)
    callNui('updateNote', { id: selectedNoteId, note: newNote })
  }



  // Text değiştiğinde label’ı da güncelle (ilk satır başlık yap)
  const handleTextChange = (e) => {
    const val = e.target.value
    setText(val)
  }

  // Çizim data’sı değiştiğinde NUI’ye bildir
  const handleDrawingChange = (data) => {
    setDrawData(data)
  }

  // Silgi butonu: canvas temizle + NUI’den sil
  const handleClearDrawing = () => {
    if (canvasRef.current) {
      canvasRef.current.clearCanvas()
      setDrawData(null)
      callNui('changeNoteDrawing', { id: selectedNoteId, drawing: null })
    }
  }

  const handleDeleteNote = () => {
    if (!selectedNoteId) return
    const updated = notes.filter(n => n.id !== selectedNoteId)
    setNotes(updated)
    callNui('deleteSelectedNote', { id: selectedNoteId })
    const next = updated[0]
    setSelectedNoteId(next?.id || null)
    setText(next?.text || '')
    setDrawData(next?.drawing || null)
  }


  return (
    <div className={`notes-container ${darkMode ? 'dark' : 'light'}`}>

      {/* HEADER İKONLARI */}
      <div className='header-icon-part'>
        <div className='header-icons'>
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="12" viewBox="0 0 16 12" fill="none">
            <path d="M0 3.31091L1.45455 4.76545C5.06909 1.15091 10.9309 1.15091 14.5455 4.76545L16 3.31091C11.5855 -1.10364 4.42182 -1.10364 0 3.31091ZM5.81818 9.12909L8 11.3109L10.1818 9.12909C9.89557 8.84208 9.55551 8.61437 9.18112 8.459C8.80672 8.30363 8.40535 8.22365 8 8.22365C7.59465 8.22365 7.19328 8.30363 6.81888 8.459C6.44449 8.61437 6.10443 8.84208 5.81818 9.12909ZM2.90909 6.22L4.36364 7.67454C5.32834 6.71064 6.63627 6.1692 8 6.1692C9.36373 6.1692 10.6717 6.71064 11.6364 7.67454L13.0909 6.22C10.2836 3.41273 5.72364 3.41273 2.90909 6.22Z" fill="white"/>
          </svg>
        </div>
        <div className='header-icons'>
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="12" viewBox="0 0 20 12" fill="none">
            <path d="M14.375 0C15.2038 0 15.9987 0.316071 16.5847 0.87868C17.1708 1.44129 17.5 2.20435 17.5 3V3.9996L18.9587 4.0032C19.2349 4.0032 19.4998 4.10851 19.695 4.29598C19.8903 4.48344 20 4.73769 20 5.0028V7.0032C20 7.26831 19.8903 7.52256 19.695 7.71002C19.4998 7.89749 19.2349 8.0028 18.9587 8.0028L17.5 8.0004V9C17.5 9.79565 17.1708 10.5587 16.5847 11.1213C15.9987 11.6839 15.2038 12 14.375 12H3.125C2.2962 12 1.50134 11.6839 0.915291 11.1213C0.32924 10.5587 0 9.79565 0 9V3C0 2.20435 0.32924 1.44129 0.915291 0.87868C1.50134 0.316071 2.2962 0 3.125 0H14.375ZM14.6875 1.1352H3.125C2.3125 1.1352 1.36875 1.7304 1.26 2.4912L1.25 2.6352V9.2292C1.25 10.0056 1.865 10.6452 2.6525 10.722L2.8125 10.7292H14.6875C15.0741 10.7291 15.4469 10.5914 15.7339 10.3427C16.0209 10.094 16.2017 9.75199 16.2412 9.3828L16.25 9.2292V2.6352C16.2499 2.26406 16.1064 1.90614 15.8474 1.63064C15.5883 1.35513 15.2321 1.18161 14.8475 1.1436L14.6875 1.1352ZM3.5425 2.3388H12.705C13.2387 2.3388 13.6775 2.7204 13.7425 3.2148L13.75 3.3408V8.5332C13.7502 8.77726 13.6576 9.01299 13.4896 9.19615C13.3216 9.37931 13.0897 9.49731 12.8375 9.528L12.7063 9.5352H3.54375C3.28931 9.53568 3.04345 9.44691 2.8524 9.2856C2.66134 9.12428 2.53824 8.90152 2.50625 8.6592L2.5 8.532V3.3408C2.5 2.8296 2.89875 2.4084 3.4125 2.346L3.5425 2.3388Z" fill="white"/>
          </svg>
        </div>
      </div>

      <div className={`settings-app-left-bar ${modTheme ? 'light' : 'dark'}`} style={{zIndex: '100',marginTop: '5rem', height: '47rem'}}>
          <span className='appa-title'>{lang.notes}</span>
          <div className='logar-part'>
              <div className='settings' style={{top: '5rem'}}>
                  <div className={`settings-item ${modTheme ? 'light' : 'dark'}`} onClick={handleNewNote}
                    >
                      <div className='setting-item-logo gray'>
                          <i className="fa-solid fa-plus"></i>
                      </div> 
                      <span className='app-namex'>{lang.newnote}</span>
                  </div>
                {notes.map((note) => (
                    <div
                      className={`settings-item ${modTheme ? 'light' : 'dark'} ${selectedNoteId == note.id ? 'selectedt' : ''}`}
                      onClick={() => {
                        setSelectedNoteId(note.id)
                        setText(note.text)
                        setSelectad(note.id)
                        setDrawData(note.drawing)

                        const hasText = note.text?.trim() !== ''
                        const hasDraw = note.drawing && note.drawing.length > 0
                        const newMode = !hasText && !hasDraw
                          ? 'nonMode'
                          : hasDraw
                            ? 'draw'
                            : 'text'
                        setMode(newMode)
                      }}
                    >
                      <div className='setting-item-logo gray'>
                        <i className="fa-regular fa-folder"></i>
                      </div>
                      <span className='app-namex'>{note.label}</span>
                    </div>
                  ))}
              </div>
          </div>
      </div>

      {/* MAIN PANEL */}
      <div className={`notes-main ${darkMode ? 'dark' : 'light'}`}>
        {selectedNoteId && (
          <>
            <div className="notes-toolbar">
              <input
                className="note-title-input"
                value={notes.find((n) => n.id === selectedNoteId)?.label || ''}
                onChange={(e) => {
                  const val = e.target.value
                  const idx = notes.findIndex((n) => n.id === selectedNoteId)
                  if (idx === -1) return
                  const updated = [...notes]
                  updated[idx].label = val
                  setNotes(updated)
                }}
                placeholder={lang.notetitle}
              />
            </div>

            <div className={`notes-content ${darkMode ? 'dark' : 'light'}`}>
              <div className="floating-icons">
                {mode !== 'draw' && (
                  <button className="mode-toggle-icon" onClick={() => setMode('text')}>
                    <i className="fa-solid fa-keyboard" />
                  </button>
                )}
                {mode !== 'text' && (
                  <button className="mode-toggle-icon" onClick={() => setMode('draw')}>
                    <i className="fa-solid fa-pencil" />
                  </button>
                )}
                <button className="mode-toggle-icon" onClick={handleSaveNote}>
                  <i className="fa-solid fa-floppy-disk" />
                </button>
                {mode !== 'text' && (
                  <button className="mode-toggle-icon" onClick={handleClearDrawing}>
                    <i className="fa-solid fa-eraser" />
                  </button>
                )}
                  <button className="mode-toggle-icon" onClick={handleDeleteNote}>
                    <i className="fa-regular fa-trash-can"></i>
                  </button>
              </div>

              {mode === 'text' ? (
                <textarea
                  className={`notes-textarea ${darkMode ? 'dark' : 'light'}`}
                  value={text}
                  onChange={handleTextChange}
                />
              ) : ''}

              {mode === 'draw' ? (

                <div className="drawing-wrapper">
                  <ReactSketchCanvas
                    ref={canvasRef}
                    className="notes-canvas"
                    width="100%"
                    height="100%"
                    strokeWidth={1}
                    strokeColor="#dddddd"
                    onChange={handleDrawingChange}
                    canvasColor={darkMode ? '#111' : '#fff'}
                  />
                </div>
              ) : ''}
            </div>
          </>
        )}
      </div>

      <ColdModal
          appName="SmartPad"
          title={lang.limitfull}
          message={lang.limitmessage}
          isOpen={verver}
          onClose={() =>  Verme(false)}
          buttons={[
              { label: lang.ok, onClick: () => Verme(false) }
          ]}
      />
    </div>
  )
}
