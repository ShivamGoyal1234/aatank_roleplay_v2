import React, { useState } from "react";
import "./main.css";
import { callNui } from "../../nui";

const TabletNameModal = ({isModalOpen, closeModal, lang, setTabName, Notification}) => {

  const [tabletName, setTabletName] = useState("My Tablet");
  const [newName, setNewName] = useState("");

  const handleNameChange = () => {
    if (!newName.trim()) {
      Notification(lang.invalid, lang.enterTabletName);
    } else {
      setTabletName(newName || tabletName); 
      setTabName(newName);
      closeModal();
      callNui('UpdateTabletData', {
        datatype: 'deviceName',
        result: newName
      })
    }
  };

  return (
    <div>
      {isModalOpen && (
        <div className="modal-backdrop" onClick={closeModal}>
          <div className="modal" onClick={(e) => e.stopPropagation()} >
            <h2>{lang.changeTabletName}</h2>
            <input
              type="text"
              placeholder={lang.entername}
              value={newName}
              onChange={(e) => setNewName(e.target.value)}
            />
            <div className="modal-actions">
              <button onClick={handleNameChange}>{lang.save}</button>
              <button onClick={closeModal}>{lang.cancel}</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default TabletNameModal;
