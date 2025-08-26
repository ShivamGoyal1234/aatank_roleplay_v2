import React, { useState, useEffect } from 'react';
import { Battery, Zap } from 'lucide-react';
import { callNui } from '@/nui';
import './main.css';

const BatteryDeadScreen = ({lang, onChargerConnect }) => {
  const [showChargingHint, setShowChargingHint] = useState(false);
  const [isCharging, setIsCharging] = useState(false);
  const [chargeProgress, setChargeProgress] = useState(0);

  useEffect(() => {
    const hintTimer = setTimeout(() => {
      setShowChargingHint(true);
    }, 2000);

    return () => clearTimeout(hintTimer);
  }, []);

  const usePowerBank = () => {
  callNui('usePowerBank', {}, (res) => {
    if (res) {
      setIsCharging(true);
      let current = 0;
      const interval = setInterval(() => {
        current += 5;
        setChargeProgress(current);
        if (current >= 100) {
          clearInterval(interval);
          callNui('updateChargeWait', {value: res})
          setTimeout(() => {
            if (onChargerConnect) onChargerConnect();
          }, 500);
        }
      }, 100);
    }
  });
};



  return (
    <>
      <div className="battery-dead-container">
        <div className="battery-dead-gradient"></div>
        
        <div className="battery-dead-content">
          <div className="battery-wrapper">
            <Battery 
              size={120} 
              className="battery-icon"
              strokeWidth={1.5}
            />
            <div className="battery-fill"></div>
            
            <div className="warning-badge">
              <span>!</span>
            </div>
          </div>

          <h1 className="battery-dead-title">{lang.batterovered}</h1>
          
          <p className="battery-dead-subtitle">
            {lang.batterydesc}
          </p>

          <div className={`charging-hint ${showChargingHint ? 'show' : ''}`}>
            <div onClick={usePowerBank} className="hint-container">
              <Zap className="zap-icon" size={24} />
              <span className="hint-text">{lang.usePowerBank}</span>
            </div>
          </div>

          {isCharging && (
              <div className="charge-progress-bar">
                <div
                  className="charge-progress-fill"
                  style={{ width: `${chargeProgress}%` }}
                />
                <span className="charge-progress-text">{chargeProgress}%</span>
              </div>
            )}



          {onChargerConnect && (
            <button
              onClick={onChargerConnect}
              className="test-button"
            >
              {lang.usePowerBank}
            </button>
          )}
        </div>

        <div className="corner-glow-top"></div>
        <div className="corner-glow-bottom"></div>
      </div>
    </>
  );
};

export default BatteryDeadScreen;