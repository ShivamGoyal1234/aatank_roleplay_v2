import React, { useState, useEffect, useRef } from 'react';
import './main.css';

const SmartTabBrowser = () => {
    const [tabs, setTabs] = useState([
        { id: 1, url: '', title: 'New Tab', isPrivate: false, loading: false, error: null }
    ]);
    const [activeTabId, setActiveTabId] = useState(1);
    const [searchHistory, setSearchHistory] = useState([]);
    const [showHistory, setShowHistory] = useState(false);
    const [darkMode, setDarkMode] = useState(true);
    const [showBookmarks, setShowBookmarks] = useState(true);
    const [inputValue, setInputValue] = useState('');
    const inputRef = useRef(null);

    const bookmarks = [
        { name: 'Google', url: 'https://www.google.com', icon: '🔍' },
        { name: 'YouTube', url: 'https://www.youtube.com', icon: '📺' },
        { name: 'GitHub', url: 'https://github.com', icon: '💻' },
        { name: 'Twitter', url: 'https://twitter.com', icon: '🐦' },
        { name: 'Reddit', url: 'https://www.reddit.com', icon: '📱' },
        { name: 'Stack Overflow', url: 'https://stackoverflow.com', icon: '💡' }
    ];

    useEffect(() => {
        document.documentElement.className = darkMode ? 'dark-mode' : 'light-mode';
    }, [darkMode]);

    useEffect(() => {
        const saved = JSON.parse(localStorage.getItem('searchHistory') || '[]');
        setSearchHistory(saved);
    }, []);

    const activeTab = tabs.find(tab => tab.id === activeTabId);

    const formatUrl = (input) => {
        if (!input) return '';
        if (input.startsWith('http://') || input.startsWith('https://')) {
            return input;
        }
        if (input.includes('.') && !input.includes(' ')) {
            return `https://${input}`;
        }
        return `https://www.google.com/search?q=${encodeURIComponent(input)}`;
    };

    const navigate = (url) => {
        const formattedUrl = formatUrl(url);
        
        setTabs(tabs.map(tab => 
            tab.id === activeTabId 
                ? { ...tab, url: formattedUrl, loading: true, error: null, title: url || 'Loading...' }
                : tab
        ));

        const newHistory = [url, ...searchHistory.filter(item => item !== url)].slice(0, 10);
        setSearchHistory(newHistory);
        localStorage.setItem('searchHistory', JSON.stringify(newHistory));
        
        setTimeout(() => {
            setTabs(tabs.map(tab => 
                tab.id === activeTabId 
                    ? { ...tab, loading: false, title: url || 'New Tab' }
                    : tab
            ));
        }, 1500);

        setShowHistory(false);
        setShowBookmarks(false);
    };



    const addTab = (isPrivate = false) => {
        const newTab = {
            id: Date.now(),
            url: '',
            title: isPrivate ? 'Private Tab' : 'New Tab',
            isPrivate,
            loading: false,
            error: null
        };
        setTabs([...tabs, newTab]);
        setActiveTabId(newTab.id);
        setInputValue('');
        setShowBookmarks(true);
    };

    const closeTab = (tabId) => {
        if (tabs.length === 1) return;
        
        const newTabs = tabs.filter(tab => tab.id !== tabId);
        setTabs(newTabs);
        
        if (tabId === activeTabId) {
            setActiveTabId(newTabs[newTabs.length - 1].id);
        }
    };

    const handleBack = () => {
        setShowBookmarks(true);
        setTabs(tabs.map(tab => 
            tab.id === activeTabId 
                ? { ...tab, url: '', title: 'New Tab' }
                : tab
        ));
        setInputValue('');
    };

    const handleRefresh = () => {
        if (activeTab?.url) {
            setTabs(tabs.map(tab => 
                tab.id === activeTabId 
                    ? { ...tab, loading: true }
                    : tab
            ));
            
            setTimeout(() => {
                setTabs(tabs.map(tab => 
                    tab.id === activeTabId 
                        ? { ...tab, loading: false }
                        : tab
                ));
            }, 1000);
        }
    };

    const clearHistory = () => {
        setSearchHistory([]);
        localStorage.removeItem('searchHistory');
        setShowHistory(false);
    };

    return (
        <div className={`browser-container ${activeTab?.isPrivate ? 'private-mode' : ''}`}>
            <div className="browser-header">
                <div className="browser-title">
                    <span className="app-icon">🌐</span>
                    <span className="app-name">SmartTab Browser</span>
                    {activeTab?.isPrivate && <span className="private-badge">Private</span>}
                </div>
                
                <div className="tabs-container">
                    {tabs.map(tab => (
                        <div 
                            key={tab.id} 
                            className={`tab ${tab.id === activeTabId ? 'active' : ''} ${tab.isPrivate ? 'private' : ''}`}
                            onClick={() => setActiveTabId(tab.id)}
                        >
                            <span className="tab-title">
                                {tab.isPrivate && '🔒 '}
                                {tab.title}
                            </span>
                            {tabs.length > 1 && (
                                <button 
                                    className="tab-close" 
                                    onClick={(e) => {
                                        e.stopPropagation();
                                        closeTab(tab.id);
                                    }}
                                >
                                    ×
                                </button>
                            )}
                        </div>
                    ))}
                    <button className="new-tab-btn" onClick={() => addTab(false)}>+</button>
                </div>

                <div className="header-actions">
                    <button 
                        className="icon-btn private-btn" 
                        onClick={() => addTab(true)}
                        title="New Private Tab"
                    >
                        🔒
                    </button>
                    <button 
                        className="icon-btn theme-btn" 
                        onClick={() => setDarkMode(!darkMode)}
                        title="Toggle Theme"
                    >
                        {darkMode ? '☀️' : '🌙'}
                    </button>
                </div>
            </div>

            <div className="navigation-bar">
                <button 
                    className="nav-btn" 
                    onClick={handleBack}
                    disabled={!activeTab?.url}
                >
                    ←
                </button>
                <button 
                    className="nav-btn" 
                    onClick={handleRefresh}
                    disabled={!activeTab?.url}
                >
                    ↻
                </button>
                
                <div className="url-bar-container">
                    <input
                        ref={inputRef}
                        type="text"
                        className="url-input"
                        placeholder="Search or enter address"
                        value={inputValue}
                        onChange={(e) => setInputValue(e.target.value)}
                        onFocus={() => setShowHistory(true)}
                        onBlur={() => setTimeout(() => setShowHistory(false), 200)}
                        onKeyPress={(e) => {
                            if (e.key === 'Enter') {
                                e.preventDefault();
                                if (inputValue.trim()) {
                                    navigate(inputValue);
                                }
                            }
                        }}
                    />
                    {activeTab?.url && <span className="ssl-indicator">🔒</span>}
                </div>

                <button className="nav-btn menu-btn">⋮</button>
            </div>

            {activeTab?.loading && <div className="progress-bar"><div className="progress-fill"></div></div>}

            {showHistory && searchHistory.length > 0 && (
                <div className="history-dropdown">
                    <div className="history-header">
                        <span>Recent Searches</span>
                        <button onClick={clearHistory} className="clear-history">Clear</button>
                    </div>
                    {searchHistory.map((item, index) => (
                        <div 
                            key={index} 
                            className="history-item"
                            onClick={() => {
                                setInputValue(item);
                                navigate(item);
                            }}
                        >
                            🕐 {item}
                        </div>
                    ))}
                </div>
            )}

            <div className="browser-content">
                {showBookmarks && !activeTab?.url ? (
                    <div className="bookmarks-grid">
                        <h2 className="bookmarks-title">Quick Access</h2>
                        <div className="bookmarks-container">
                            {bookmarks.map((bookmark, index) => (
                                <div 
                                    key={index} 
                                    className="bookmark-item"
                                    onClick={() => {
                                        setInputValue(bookmark.url);
                                        navigate(bookmark.url);
                                    }}
                                >
                                    <div className="bookmark-icon">{bookmark.icon}</div>
                                    <div className="bookmark-name">{bookmark.name}</div>
                                </div>
                            ))}
                        </div>
                    </div>
                ) : activeTab?.error ? (
                    <div className="error-page">
                        <div className="error-icon">⚠️</div>
                        <h1 className="error-title">Unable to connect</h1>
                        <p className="error-message">
                            Check your connection and try again
                        </p>
                        <button className="error-btn" onClick={handleRefresh}>
                            Try Again
                        </button>
                    </div>
                ) : activeTab?.url ? (
                    <iframe 
                        src={activeTab.url}
                        className="browser-iframe"
                        title="Browser Content"
                        sandbox="allow-scripts allow-same-origin allow-forms"
                    />
                ) : null}
            </div>
        </div>
    );
};

export default SmartTabBrowser;