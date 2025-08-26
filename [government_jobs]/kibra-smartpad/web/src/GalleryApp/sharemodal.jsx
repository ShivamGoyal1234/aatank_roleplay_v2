import React, { useEffect, useState } from "react";

const ShareModal = ({ show, onClose, people, devices, theme}) => {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    if (show) {
      setVisible(true);
      setTimeout(() => {
        document.querySelector(".share-modal-overlay").classList.add("show");
        document.querySelector(".share-modal").classList.add("show");
      }, 10);
    } else {
      document.querySelector(".share-modal-overlay")?.classList.remove("show");
      document.querySelector(".share-modal")?.classList.remove("show");
      setTimeout(() => setVisible(false), 300);
    }
  }, [show]);

  if (!visible) return null;

  return (
    <div className="share-modal-overlay" onClick={onClose}>
      <div className={`share-modal ${theme == 'dark' ? 'dark' : ''}`} onClick={(e) => e.stopPropagation()}>
        <div className="share-modal-header">
          <span>AirDrop a Copy</span>
          <button onClick={onClose} className="share-done-btn">Done</button>
        </div>

        <div className="share-section">
          <h3>People</h3>
          <div className="share-grid">
            {people.map((person, index) => (
              <div key={index} className="share-item">
                <img src={person.avatar} alt={person.name} className="share-avatar" />
                <span>{person.name}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default ShareModal;
