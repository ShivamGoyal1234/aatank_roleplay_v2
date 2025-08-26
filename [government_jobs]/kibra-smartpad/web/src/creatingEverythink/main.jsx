import React, { useEffect, useState } from 'react';
import '../App.css';

const CreatingHersey = ({ isVisible }) => {
  const [visibleClass, setVisibleClass] = useState('');

  useEffect(() => {
    if (isVisible) {
      setTimeout(() => setVisibleClass('show'), 10); // Animasyon tetikleme
    } else {
      setVisibleClass('');
    }
  }, [isVisible]);

  return (
    <div className={`creating-frame ${visibleClass}`}>
      <div className="loading-container">
        <div className="loading-text">We are setting things up for you...</div>
        <div className="loading-bar">
          <div className="loading-bar-progress"></div>
        </div>
      </div>
    </div>
  );
};

export default CreatingHersey;
