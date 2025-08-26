import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import './main.css';

const CourtDateModal = ({ isOpen, onClose, onSubmit, caseId }) => {
  const [date, setDate] = useState('');
  const [time, setTime] = useState('');
  const [type, setType] = useState('Hearing');
  const [prosecutor, setProsecutor] = useState('');
  const [defense, setDefense] = useState('');

  const handleSubmit = () => {
    if (!date || !time || !prosecutor || !defense) return;
    onSubmit({
      caseId,
      dateTime: `${date}T${time}`,
      type,
      prosecutor,
      defense
    });
    onClose();
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div className="court-modal-backdrop" initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}>
          <motion.div className="court-modal-content" initial={{ scale: 0.95 }} animate={{ scale: 1 }} exit={{ scale: 0.95 }} transition={{ duration: 0.2 }}>
            <h2>Plan Court Date</h2>
            <input type="date" value={date} onChange={(e) => setDate(e.target.value)} />
            <input type="time" value={time} onChange={(e) => setTime(e.target.value)} />
            <select value={type} onChange={(e) => setType(e.target.value)}>
              <option value="Hearing">Hearing</option>
              <option value="Sentencing">Sentencing</option>
              <option value="Review">Review</option>
            </select>
            <input type="text" placeholder="Prosecutor" value={prosecutor} onChange={(e) => setProsecutor(e.target.value)} />
            <input type="text" placeholder="Defense Lawyer" value={defense} onChange={(e) => setDefense(e.target.value)} />
            <div className="court-modal-actions">
              <button onClick={onClose}>Cancel</button>
              <button onClick={handleSubmit}>Create</button>
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default CourtDateModal;
