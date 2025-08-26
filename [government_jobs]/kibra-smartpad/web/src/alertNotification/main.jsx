import React, { useEffect, useState } from "react";
import "./AlertModal.css";

const AlertModal = ({ title, message, okay, onCancel, onConfirm }) => {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    setTimeout(() => setVisible(true), 10);
  }, []);

  const handleClose = () => {
    setVisible(false);
    setTimeout(onCancel, 300);
  };

  return (
    <div className={`n-modal-overlay ${visible ? 'show' : 'hide'}`}>
      <div className={`n-modal-box ${visible ? 'fade-in' : 'fade-out'}`}>
        <h2 className="n-modal-title">{title}</h2>
        <p className="n-modal-message">{message}</p>
        <div className="n-modal-buttons">
          <button className="n-cancel-btn2" onClick={handleClose}>
            {okay}
          </button>
          {/* <button className="confirm-btn" onClick={onConfirm}>
            Do something
          </button> */}
        </div>
      </div>
    </div>
  );
};

export default AlertModal;
