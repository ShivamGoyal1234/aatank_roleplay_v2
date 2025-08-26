import React, { useState, useRef, useEffect } from "react"
import "./TreatmentModal.css"
import { callNui } from "@/nui"

export default function TreatmentModal({ lang, isOpen, onClose, onSubmit, drugs, tabOwnerName, pcid}) {
  const [selectedDrug, setSelectedDrug] = useState("Select Drug")
  const [responsible, setResponsible] = useState("")
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const [secData, setSecData] = useState("");
  const dropdownRef = useRef(null);

    useEffect(() => {
      if (drugs.length > 0) {
          setSecData(drugs[0])
          setSelectedDrug(drugs[0].drug)
      }
    }, [drugs]);

    useEffect(() => {
        setResponsible(tabOwnerName);
        function handleClickOutside(e) {
          if (dropdownRef.current && !dropdownRef.current.contains(e.target)) {
            setDropdownOpen(false)
          }
        }

        if (dropdownOpen) {
          document.addEventListener("mousedown", handleClickOutside)
        } else {
          document.removeEventListener("mousedown", handleClickOutside)
        }
        return () => {
          document.removeEventListener("mousedown", handleClickOutside)
        }
    }, [dropdownOpen]);

    if (!isOpen) return null;

    return (
      <div className="modal-overlay2">
        <div className="modal-content2">
          <div className="modal-header2">
            <h2 className='modal-header-title'>{lang.addtreatment}</h2>
            <div className="close-button2" onClick={onClose}>×</div>
          </div>
          <div className="modal-body2">
            <label>{lang.drug}</label>
            <div className="custom-dropdown" ref={dropdownRef}>
              <div
                className={`dropdown-selected ${dropdownOpen ? "open" : ""}`}
                onClick={() => setDropdownOpen(!dropdownOpen)}
              >
                {secData
                  ? `${secData.drug} - ${secData.brand} - ${secData.type}`
                  : lang.selectDrug}


                <span className={`arrow ${dropdownOpen ? "up" : "down"}`}></span>
              </div>
              <div className={`dropdown-list ${dropdownOpen ? "show" : ""}`}>
                {drugs.map((d, i) => (
                  <div
                    key={i}
                    className="dropdown-item"
                    onClick={() => {
                      setSecData(d);
                      setSelectedDrug(d.drug)
                      setDropdownOpen(false)
                    }}
                  >
                    {d.drug} - {d.brand} - {d.type}
                  </div>
                ))}
              </div>
            </div>
            <label>{lang.resperson}</label>
            <input
              type="text"
              value={responsible}
              onChange={e => setResponsible(e.target.value)}
              placeholder="Johnny Sins"
            />
            <button
              className="submit-button2"
              onClick={() => {
                if (selectedDrug && responsible) {
                  setSelectedDrug("")
                  setResponsible("")
                  onClose()
                  callNui('addDrugList', {
                    selectedDrug,
                    responsible,
                    selectedPerson: pcid
                  })
                }
              }}
            >
              {lang.addtreatment}
            </button>
          </div>
        </div>
      </div>
    )
}
