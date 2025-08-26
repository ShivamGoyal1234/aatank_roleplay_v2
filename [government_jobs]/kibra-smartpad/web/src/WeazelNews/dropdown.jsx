import React, {useState, useEffect, useMemo, useRef} from 'react';
import { ChevronDown, Search, Sun, Moon, Bell, User, Calendar, Clock, MessageSquare, TrendingUp, Shield, DollarSign, Trophy, Newspaper, X, Check, Trash2, Menu, ChevronRight, AlertCircle } from 'lucide-react';

const CustomDropdown = ({ value, onChange, options, placeholder = "Select...", isDarkMode = true, style = {} }) => {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef(null);

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setIsOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const selectedOption = options.find(opt => opt.value === value);

  const dropdownStyles = {
    container: {
      position: 'relative',
      width: '100%',
      ...style
    },
    trigger: {
      width: '100%',
      padding: '12px 16px',
      backgroundColor: isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)',
      border: 'none',
      borderRadius: '10px',
      fontSize: '15px',
      color: isDarkMode ? '#FFFFFF' : '#000000',
      cursor: 'pointer',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      transition: 'all 0.2s ease',
      outline: 'none',
      ...(isOpen && {
        backgroundColor: isDarkMode ? 'rgba(255, 255, 255, 0.15)' : 'rgba(0, 0, 0, 0.08)',
      })
    },
    dropdown: {
      position: 'absolute',
      top: 'calc(100% + 4px)',
      left: 0,
      right: 0,
      backgroundColor: isDarkMode ? '#2C2C2E' : '#FFFFFF',
      borderRadius: '10px',
      boxShadow: '0 10px 40px rgba(0, 0, 0, 0.3)',
      overflow: 'hidden',
      opacity: isOpen ? 1 : 0,
      transform: isOpen ? 'translateY(0)' : 'translateY(-10px)',
      visibility: isOpen ? 'visible' : 'hidden',
      transition: 'all 0.2s ease',
      zIndex: 1000,
      maxHeight: '240px',
      overflowY: 'auto'
    },
    option: {
      padding: '12px 16px',
      fontSize: '15px',
      color: isDarkMode ? '#FFFFFF' : '#000000',
      cursor: 'pointer',
      transition: 'all 0.15s ease',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      backgroundColor: 'transparent'
    },
    chevron: {
      transition: 'transform 0.2s ease',
      transform: isOpen ? 'rotate(180deg)' : 'rotate(0deg)',
      color: isDarkMode ? 'rgba(255, 255, 255, 0.6)' : 'rgba(0, 0, 0, 0.6)'
    }
  };

  return (
    <div ref={dropdownRef} style={dropdownStyles.container}>
      <button
        type="button"
        style={dropdownStyles.trigger}
        onClick={() => setIsOpen(!isOpen)}
      >
        <span>{selectedOption ? selectedOption.label : placeholder}</span>
        <ChevronDown size={18} style={dropdownStyles.chevron} />
      </button>

      <div style={dropdownStyles.dropdown}>
        {options.map((option) => (
          <div
            key={option.value}
            style={{
              ...dropdownStyles.option,
              ...(value === option.value ? {
                backgroundColor: isDarkMode ? 'rgba(0, 122, 255, 0.3)' : 'rgba(0, 122, 255, 0.1)',
                color: '#007AFF'
              } : {})
            }}
            onClick={() => {
              onChange(option.value);
              setIsOpen(false);
            }}
            onMouseEnter={(e) => {
              if (value !== option.value) {
                e.currentTarget.style.backgroundColor = isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)';
              }
            }}
            onMouseLeave={(e) => {
              if (value !== option.value) {
                e.currentTarget.style.backgroundColor = 'transparent';
              }
            }}
          >
            <span>{option.label}</span>
            {value === option.value && <Check size={16} />}
          </div>
        ))}
      </div>
    </div>
  );
};

export default CustomDropdown;