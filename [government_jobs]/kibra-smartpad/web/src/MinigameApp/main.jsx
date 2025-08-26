import React, { useState, useEffect, useRef } from 'react';
import './main.css';
import { callNui } from '@/nui';

const HackerMinigame = ({batteryLevel, lang, openApp}) => {
  const [timeRemaining, setTimeRemaining] = useState(300);
  const [grid, setGrid] = useState([]);
  const [selectedRow, setSelectedRow] = useState(10);
  const [selectedCol, setSelectedCol] = useState(10);
  const [targetWord, setTargetWord] = useState('JNH');
  const [gameStatus, setGameStatus] = useState('playing');
  const [currentTargetRow, setCurrentTargetRow] = useState(-1);
  const [currentTargetStartCol, setCurrentTargetStartCol] = useState(-1);
  const [attemptsLeft, setAttemptsLeft] = useState(3);
  const inputRef = useRef(null);
  const [time, setTime] = useState(new Date());

  // Ses referansları
  const moveSound = useRef(null);
  const successSound = useRef(null);
  const failSound = useRef(null);

  // Rastgele 3 harflik kelime oluştur
  const generateRandomWord = () => {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    let word = '';
    for (let i = 0; i < 3; i++) {
      word += letters[Math.floor(Math.random() * letters.length)];
    }
    return word;
  };

  // Oyunu sıfırla
  const resetGame = () => {
    setTargetWord(generateRandomWord());
    setAttemptsLeft(3);
    setSelectedRow(10);
    setSelectedCol(10);
    setGameStatus('playing');
    setTimeRemaining(300);
  };

  useEffect(() => {
    if (inputRef.current) {
      inputRef.current.focus();
    }
  }, []);

  const formattedTime = `${time.getHours().toString().padStart(2, "0")}:${time
    .getMinutes()
    .toString()
    .padStart(2, "0")}`;

  useEffect(() => {
    const generateGrid = () => {
      const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      const newGrid = [];
      let targetRowIndex = -1;
      let targetStartCol = -1;
      
      // Her 2-3 frame'de bir hedef kelime göster
      const shouldShowTarget = Math.random() < 0.4; // %40 ihtimal
      
      if (shouldShowTarget) {
        // Rastgele bir satıra hedef kelimeyi yerleştir
        targetRowIndex = Math.floor(Math.random() * 20);
        targetStartCol = Math.floor(Math.random() * (20 - 3));
      }
      
      for (let i = 0; i < 20; i++) {
        const row = [];
        
        // Bu satırda hedef kelime gösterilecek mi?
        const showTargetInThisRow = i === targetRowIndex;
        
        for (let j = 0; j < 20; j++) {
          const isTargetPosition = showTargetInThisRow && j >= targetStartCol && j < targetStartCol + 3;
          const letter = isTargetPosition ? targetWord[j - targetStartCol] : letters[Math.floor(Math.random() * letters.length)];
          const isRandomGreen = !isTargetPosition && Math.random() < 0.05;
          row.push({ 
            letter, 
            isRandomGreen, 
            isTargetLetter: isTargetPosition 
          });
        }
        newGrid.push(row);
      }
      
      setCurrentTargetRow(targetRowIndex);
      setCurrentTargetStartCol(targetStartCol);
      return newGrid;
    };

    // İlk grid'i oluştur
    const initialGrid = generateGrid();
    setGrid(initialGrid);

    const interval = setInterval(() => {
      if (gameStatus === 'playing') {
        const newGrid = generateGrid();
        setGrid(newGrid);
      }
    }, 3000); // 3 saniye

    return () => clearInterval(interval);
  }, [targetWord, gameStatus]);

  useEffect(() => {
    const timer = setInterval(() => {
      if (gameStatus === 'playing') {
        setTimeRemaining(prev => {
          if (prev <= 1) {
            // Süre bittiğinde oyunu sıfırla
            setTimeout(() => {
              resetGame();
            }, 1500);
            return 0;
          }
          return prev - 1;
        });
      }
    }, 1000);

    return () => clearInterval(timer);
  }, [gameStatus]);

  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  // Ses çalma fonksiyonu
  const playSound = (soundRef) => {
    if (soundRef.current) {
      soundRef.current.currentTime = 0;
      soundRef.current.play().catch(e => console.log('Ses çalma hatası:', e));
    }
  };

  const handleKeyDown = (e) => {
    if (gameStatus !== 'playing') return;

    if (e.key === 'Enter') {
      // Oyuncunun seçtiği pozisyonda hedef kelimenin başlangıcı var mı?
    if (selectedRow === currentTargetRow && 
        selectedCol === currentTargetStartCol && 
        currentTargetRow !== -1) {
        playSound(successSound);
        setGameStatus('granted');
        callNui('getMiniGameResult', {result: true}, (res) => {if(res){openApp('mainsc')}});
      } else {
        playSound(failSound);
        const newAttemptsLeft = attemptsLeft - 1;
        setAttemptsLeft(newAttemptsLeft);

        if (newAttemptsLeft === 0) { // 5. denemede de yanlışsa aq
          setGameStatus('denied');
          callNui('getMiniGameResult', {result: false});
          setTimeout(() => {
            resetGame();
          }, 1500);
        }
      }
    } else if (e.key === 'ArrowUp' || e.key === 'w' || e.key === 'W') {
      e.preventDefault();
      playSound(moveSound);
      setSelectedRow(prev => (prev - 1 + 20) % 20);
    } else if (e.key === 'ArrowDown' || e.key === 's' || e.key === 'S') {
      e.preventDefault();
      playSound(moveSound);
      setSelectedRow(prev => (prev + 1) % 20);
    } else if (e.key === 'ArrowLeft' || e.key === 'a' || e.key === 'A') {
      e.preventDefault();
      playSound(moveSound);
      setSelectedCol(prev => (prev - 1 + 20) % 20);
    } else if (e.key === 'ArrowRight' || e.key === 'd' || e.key === 'D') {
      e.preventDefault();
      playSound(moveSound);
      setSelectedCol(prev => (prev + 1) % 20);
    }
  };

  useEffect(() => {
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [selectedRow, selectedCol, gameStatus, currentTargetRow, currentTargetStartCol, attemptsLeft]);

  return (
    <div className="hacker-container">
        <div style={{marginBottom: '1rem'}} className="tablet-frame-homescreen-header">
          <div className='header-icon-time-part'>
              <span className='time-string'>{formattedTime}</span>
          </div>
          <div className='header-icon-part'>
              <div className='header-icons'>
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="10" viewBox="0 0 18 10" fill="none">
                  <path d="M14.5227 0.617317C14.4465 0.801088 14.4465 1.03406 14.4465 1.5V8.5C14.4465 8.96594 14.4465 9.19891 14.5227 9.38268C14.6241 9.62771 14.8188 9.82239 15.0638 9.92388C15.2476 10 15.4806 10 15.9465 10C16.4125 10 16.6454 10 16.8292 9.92388C17.0742 9.82239 17.2689 9.62771 17.3704 9.38268C17.4465 9.19891 17.4465 8.96594 17.4465 8.5V1.5C17.4465 1.03406 17.4465 0.801088 17.3704 0.617317C17.2689 0.372288 17.0742 0.177614 16.8292 0.0761205C16.6454 0 16.4125 0 15.9465 0C15.4806 0 15.2476 0 15.0638 0.0761205C14.8188 0.177614 14.6241 0.372288 14.5227 0.617317Z" fill="white"/>
                  <path d="M9.94653 3.5C9.94653 3.03406 9.94653 2.80109 10.0227 2.61732C10.1241 2.37229 10.3188 2.17761 10.5638 2.07612C10.7476 2 10.9806 2 11.4465 2C11.9125 2 12.1454 2 12.3292 2.07612C12.5742 2.17761 12.7689 2.37229 12.8704 2.61732C12.9465 2.80109 12.9465 3.03406 12.9465 3.5V8.5C12.9465 8.96594 12.9465 9.19891 12.8704 9.38268C12.7689 9.62771 12.5742 9.82239 12.3292 9.92388C12.1454 10 11.9125 10 11.4465 10C10.9806 10 10.7476 10 10.5638 9.92388C10.3188 9.82239 10.1241 9.62771 10.0227 9.38268C9.94653 9.19891 9.94653 8.96594 9.94653 8.5V3.5Z" fill="white"/>
                  <path d="M5.52265 4.61732C5.44653 4.80109 5.44653 5.03406 5.44653 5.5V8.5C5.44653 8.96594 5.44653 9.19891 5.52265 9.38268C5.62415 9.62771 5.81882 9.82239 6.06385 9.92388C6.24762 10 6.48059 10 6.94653 10C7.41247 10 7.64545 10 7.82922 9.92388C8.07424 9.82239 8.26892 9.62771 8.37041 9.38268C8.44653 9.19891 8.44653 8.96594 8.44653 8.5V5.5C8.44653 5.03406 8.44653 4.80109 8.37041 4.61732C8.26892 4.37229 8.07424 4.17761 7.82922 4.07612C7.64545 4 7.41247 4 6.94653 4C6.48059 4 6.24762 4 6.06385 4.07612C5.81882 4.17761 5.62415 4.37229 5.52265 4.61732Z" fill="white"/>
                  <path d="M1.02265 6.11732C0.946533 6.30109 0.946533 6.53406 0.946533 7V8.5C0.946533 8.96594 0.946533 9.19891 1.02265 9.38268C1.12415 9.62771 1.31882 9.82239 1.56385 9.92388C1.74762 10 1.98059 10 2.44653 10C2.91247 10 3.14545 10 3.32922 9.92388C3.57424 9.82239 3.76892 9.62771 3.87041 9.38268C3.94653 9.19891 3.94653 8.96594 3.94653 8.5V7C3.94653 6.53406 3.94653 6.30109 3.87041 6.11732C3.76892 5.87229 3.57424 5.67761 3.32922 5.57612C3.14545 5.5 2.91247 5.5 2.44653 5.5C1.98059 5.5 1.74762 5.5 1.56385 5.57612C1.31882 5.67761 1.12415 5.87229 1.02265 6.11732Z" fill="white"/>
              </svg>
              </div>
              <div className="header-icons battery">
                  <div className="battery-shell">
                      <div
                      className="battery-level"
                      style={{
                          width: `${batteryLevel}%`,
                          backgroundColor: batteryLevel < 20 ? 'red' : 'rgb(227 227 227)',
                      }}
                      ></div>
                  </div>
                  <span className="battery-percent">{batteryLevel}%</span>
              </div>
              <div className='header-icons'>
                    <svg xmlns="http://www.w3.org/2000/svg" width="15" height="10" viewBox="0 0 15 10" fill="none">
                      <path d="M12.9512 4.246C13.0647 4.3525 13.2397 4.353 13.3502 4.243L14.4142 3.179C14.5287 3.064 14.5292 2.8745 14.4112 2.763C12.6022 1.0505 10.1607 0 7.47322 0C4.78572 0 2.34422 1.0505 0.535223 2.763C0.417223 2.8745 0.417723 3.064 0.532223 3.179L1.59622 4.243C1.70672 4.353 1.88172 4.3525 1.99522 4.246C3.42972 2.9015 5.35672 2.077 7.47322 2.077C9.58972 2.077 11.5167 2.9015 12.9512 4.246Z" fill="white"/>
                      <path d="M10.5043 6.69645C10.6198 6.79945 10.7923 6.80045 10.9018 6.69095L11.9643 5.62845C12.0798 5.51295 12.0803 5.32045 11.9603 5.20995C10.7793 4.12445 9.20385 3.46145 7.47334 3.46145C5.74285 3.46145 4.16735 4.12445 2.98635 5.20995C2.86635 5.32045 2.86685 5.51295 2.98235 5.62845L4.04485 6.69095C4.15435 6.80045 4.32685 6.79945 4.44235 6.69645C5.24835 5.97695 6.31035 5.53845 7.47334 5.53845C8.63634 5.53845 9.69835 5.97695 10.5043 6.69645Z" fill="white"/>
                      <path d="M9.5082 7.6611C9.6337 7.7661 9.6327 7.9616 9.5167 8.0776L7.6787 9.9156C7.5662 10.0281 7.3832 10.0281 7.2707 9.9156L5.4327 8.0776C5.3167 7.9616 5.3152 7.7661 5.4412 7.6611C5.9917 7.2006 6.7007 6.9231 7.4747 6.9231C8.2487 6.9231 8.9572 7.2006 9.5082 7.6611Z" fill="white"/>
                  </svg>
              </div>
          </div>
      </div>
      <div className="header">
        <div className="command-prompt">/Command Prompt</div>
        <div className="tagline">BUSTING THROUGH BACKDOOR SINCE 2024</div>
      </div>
      
      <div className="target-info" style={{
        textAlign: 'center',
        color: '#00ff00',
        fontSize: '1.2rem',
        marginBottom: '10px',
        fontFamily: 'monospace',
        textShadow: '0 0 10px #00ff00'
      }}>
        TARGET: {targetWord}
      </div>
      
      <div className="grid-container">
        <div className="letter-grid">
          {grid.map((row, i) => (
            <div key={i} className={`grid-row ${i === selectedRow ? 'selected-row' : ''}`}>
              {row.map((cell, j) => {
                const isSelected = i === selectedRow && j >= selectedCol && j < selectedCol + 3;
                return (
                  <span 
                    key={j} 
                    className={`grid-letter ${cell.isRandomGreen ? 'random-green' : ''} ${cell.isTargetLetter ? 'target-letter-visible' : ''} ${isSelected ? 'selected-letter' : ''}`}
                  >
                    {cell.letter}
                  </span>
                );
              })}
            </div>
          ))}
        </div>
      </div>
      
      <div className="footer">
        <div className="timer-container">
          <div className="timer-label">Time remaining</div>
          <div className="timer">{formatTime(timeRemaining)}</div>
        </div>
        {gameStatus === 'playing' && (
          <div className="attempts-container">
            <div className="attempts-label">Attempts left</div>
            <div className="attempts">{attemptsLeft}</div>
          </div>
        )}
      </div>
      
      {gameStatus !== 'playing' && (
        <div className="overlay">
          <div className={`result ${gameStatus}`}>
            {gameStatus === 'granted' ? 'ACCESS GRANTED' : 'ACCESS DENIED'}
          </div>
        </div>
      )}
      
      <input
        ref={inputRef}
        type="text"
        className="hidden-input"
        value=""
        onChange={() => {}}
      />
      
      {/* Ses dosyaları */}
      <audio ref={moveSound} preload="auto">
        <source src="data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdJivrJBhNjVgodDbq2EcBj+a2/LDciUFLIHO8tiJNwgZaLvt559NEAxQp+PwtmMcBjiR1/LMeSwFJHfH8N2QQAoUXrTp66hVFApGn+DyvmwhBTGH0fPTgjMGHm7A7+OZURE" />
      </audio>
      
      <audio ref={successSound} preload="auto">
        <source src="data:audio/wav;base64,UklGRoAHAABXQVZFZm10IBAAAAABAAEAIlYAAESsAAACABAAZGF0YVwHAAAAAAC7/7sA//+7ALv/uwC7/7v/u/+7/7v/u/+7/7v/AAC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7/7v/u/+7/7v/u/+7/7v/AAC7ALsAuwC7ALsAuwC7ALsAuwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC7/7v/u/+7/7v/u/+7/7v/u/+7/7v/AAC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC7/7v/u/+7/7v/u/+7/7v/AAC7ALsAuwC7ALsAuwC7ALsAuwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC7/7v/u/+7/7v/u/+7/7v/u/+7/7v/AAC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC7/7v/u/+7/7v/u/+7/7v/AAC7ALsAuwC7ALsAuwC7ALsAuwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC7/7v/u/+7/7v/u/+7/7v/u/+7/7v/AAC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC7/7v/u/+7/7v/u/+7/7v/AAC7ALsAuwC7ALsAuwC7ALsAuwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC7/7v/u/+7/7v/u/+7/7v/u/+7/7v/AAC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC7/7v/u/+7/7v/u/+7/7v/AAC7ALsAuwC7ALsAuwC7ALsAuwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC7/7v/u/+7/7v/u/+7/7v/u/+7/7v/AAC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwC7ALsAuwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" />
      </audio>
      
      <audio ref={failSound} preload="auto">
        <source src="data:audio/wav;base64,UklGRqwCAABXQVZFZm10IBAAAAABAAEARKwAAIhYAQACABAAZGF0YYgCAAAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAC7/wAAAAA=" />
      </audio>
    </div>
  );
};

export default HackerMinigame;