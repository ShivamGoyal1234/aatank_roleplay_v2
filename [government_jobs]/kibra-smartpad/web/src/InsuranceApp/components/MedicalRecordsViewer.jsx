import React, { useState, useEffect } from 'react'
import { callNui } from '@/nui'

const MedicalRecordsViewer = ({ darkMode, onAddMedicalRecord }) => {
  const [searchQuery, setSearchQuery] = useState('')
  const [selectedPlayerId, setSelectedPlayerId] = useState('')
  const [selectedPlayerName, setSelectedPlayerName] = useState('')
  const [medicalRecords, setMedicalRecords] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [searchResults, setSearchResults] = useState([])
  const [showSearchResults, setShowSearchResults] = useState(false)

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (showSearchResults && !event.target.closest('.search-container')) {
        setShowSearchResults(false)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => {
      document.removeEventListener('mousedown', handleClickOutside)
    }
  }, [showSearchResults])

  const handleSearchPlayer = async () => {
    if (!searchQuery.trim()) {
      setError('Please enter a player ID or name')
      return
    }

    setLoading(true)
    setError('')

    // First search for players by name or citizen ID
    callNui('searchPlayer', { searchQuery: searchQuery.trim() }, (searchResult) => {
      setLoading(false)
      if (searchResult && searchResult.success && searchResult.players.length > 0) {
        setSearchResults(searchResult.players)
        setShowSearchResults(true)
        setError('')
      } else {
        setError('No players found with that name or ID')
        setSearchResults([])
        setShowSearchResults(false)
        setMedicalRecords([])
        setSelectedPlayerId('')
        setSelectedPlayerName('')
      }
    })
  }

  const handleSelectPlayer = (player) => {
    setSelectedPlayerId(player.citizen_id)
    setSelectedPlayerName(player.name)
    setSearchQuery(player.name)
    setShowSearchResults(false)
    
    // Clear any previous errors
    setError('')
    
    // If this is a new player that can have a record created
    if (player.canCreateRecord) {
      setMedicalRecords([])
      setError('This player has no medical records yet. You can create a new record.')
      return
    }
    
    // Now fetch medical records for the selected player
    callNui('getMedicalRecords', { targetPlayerId: player.citizen_id }, (result) => {
      if (result && result.success) {
        setMedicalRecords(result.records || [])
        if (result.records.length === 0) {
          setError('No medical records found for this player. You can create a new record.')
        }
      } else {
        setError('No medical records found for this player. You can create a new record.')
        setMedicalRecords([])
      }
    })
  }

  const handleAddRecord = () => {
    if (selectedPlayerId && onAddMedicalRecord) {
      onAddMedicalRecord(selectedPlayerId, selectedPlayerName || selectedPlayerId)
    }
  }

  const getSeverityColor = (severity) => {
    switch (severity) {
      case 'Low': return '#10B981'
      case 'Medium': return '#F59E0B'
      case 'High': return '#EF4444'
      case 'Critical': return '#DC2626'
      default: return '#6B7280'
    }
  }

  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })
  }

  if (loading) {
    return (
      <div style={{ 
        display: 'flex', 
        justifyContent: 'center', 
        alignItems: 'center', 
        height: 200,
        color: darkMode ? '#fff' : '#333'
      }}>
        <div style={{ textAlign: 'center' }}>
          <div style={{ fontSize: 24, marginBottom: 10 }}>⏳</div>
          <div>Loading medical records...</div>
        </div>
      </div>
    )
  }

  return (
    <div style={{ padding: 20 }}>
      {/* Search Section */}
      <div style={{ 
        background: darkMode ? '#1f1f23' : '#fff',
        borderRadius: 12,
        padding: 20,
        marginBottom: 20,
        border: darkMode ? '1px solid #2a2a2e' : '1px solid #e5e7eb'
      }}>
        <div style={{ 
          display: 'flex', 
          alignItems: 'center', 
          marginBottom: 15,
          gap: 10
        }}>
          <span style={{
            display: 'inline-flex',
            background: darkMode ? '#222' : '#e4e8ef',
            color: darkMode ? '#10B981' : '#059669',
            borderRadius: 8,
            width: 28,
            height: 28,
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: 14
          }}>
            <i className="fa-solid fa-search"></i>
          </span>
          <span style={{ fontSize: 18, fontWeight: 600 }}>
            Search Medical Records
          </span>
        </div>

        <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap', position: 'relative' }} className="search-container">
          <div style={{ flex: 1, minWidth: 200, position: 'relative' }}>
            <input
              type="text"
              placeholder="Enter Player Name"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && handleSearchPlayer()}
              onFocus={() => searchResults.length > 0 && setShowSearchResults(true)}
              style={{
                width: '100%',
                padding: '12px 14px',
                borderRadius: 8,
                border: darkMode ? '1px solid #2a2a2e' : '1px solid #d1d5db',
                background: darkMode ? '#2a2a2e' : '#fff',
                color: darkMode ? '#fff' : '#333',
                fontSize: 14,
                outline: 'none'
              }}
            />
            
            {/* Search Results Dropdown */}
            {showSearchResults && searchResults.length > 0 && (
              <div style={{
                position: 'absolute',
                top: '100%',
                left: 0,
                right: 0,
                background: darkMode ? '#2a2a2e' : '#fff',
                border: darkMode ? '1px solid #3a3a3e' : '1px solid #d1d5db',
                borderRadius: 8,
                maxHeight: 200,
                overflowY: 'auto',
                zIndex: 1000,
                marginTop: 4
              }}>
                {searchResults.map((player, index) => (
                  <div
                    key={index}
                    onClick={() => handleSelectPlayer(player)}
                    style={{
                      padding: '12px 14px',
                      cursor: 'pointer',
                      borderBottom: index < searchResults.length - 1 ? 
                        (darkMode ? '1px solid #3a3a3e' : '1px solid #f3f4f6') : 'none',
                      color: darkMode ? '#fff' : '#333',
                      fontSize: 14,
                      display: 'flex',
                      justifyContent: 'space-between',
                      alignItems: 'center'
                    }}
                    onMouseEnter={(e) => {
                      e.target.style.background = darkMode ? '#3a3a3e' : '#f9fafb'
                    }}
                    onMouseLeave={(e) => {
                      e.target.style.background = 'transparent'
                    }}
                  >
                    <div>
                      <div style={{ fontWeight: 600 }}>{player.name}</div>
                      <div style={{ 
                        fontSize: 12, 
                        color: darkMode ? '#9ca3af' : '#6b7280',
                        marginTop: 2
                      }}>
                        ID: {player.citizen_id}
                      </div>
                    </div>
                    <div style={{
                      padding: '4px 8px',
                      borderRadius: 4,
                      fontSize: 11,
                      fontWeight: 600,
                      background: player.online ? '#10B981' : 
                                 player.canCreateRecord ? '#F59E0B' : '#6B7280',
                      color: '#fff'
                    }}>
                      {player.online ? 'ONLINE' : 
                       player.canCreateRecord ? 'NEW PLAYER' : 'OFFLINE'}
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
          
          <button
            onClick={handleSearchPlayer}
            disabled={!searchQuery.trim()}
            style={{
              padding: '12px 20px',
              background: searchQuery.trim() ? '#10B981' : '#6B7280',
              color: '#fff',
              border: 'none',
              borderRadius: 8,
              fontWeight: 600,
              cursor: searchQuery.trim() ? 'pointer' : 'not-allowed',
              opacity: searchQuery.trim() ? 1 : 0.6,
              whiteSpace: 'nowrap'
            }}
          >
            Search
          </button>
          {onAddMedicalRecord && (
            <button
              onClick={handleAddRecord}
              disabled={!selectedPlayerId}
              style={{
                padding: '12px 20px',
                background: !selectedPlayerId ? '#6B7280' : '#3B82F6',
                color: '#fff',
                border: 'none',
                borderRadius: 8,
                fontWeight: 600,
                cursor: !selectedPlayerId ? 'not-allowed' : 'pointer',
                opacity: !selectedPlayerId ? 0.6 : 1,
                whiteSpace: 'nowrap',
                display: 'flex',
                alignItems: 'center',
                gap: 6
              }}
            >
              <i className="fa-solid fa-plus"></i>
              {selectedPlayerId && searchResults.find(p => p.citizen_id === selectedPlayerId)?.canCreateRecord ? 
                'Create Record' : 'Add Record'}
            </button>
          )}
        </div>

        {error && (
          <div style={{
            marginTop: 10,
            padding: 10,
            background: error.includes('create a new record') ? 
              'rgba(59, 130, 246, 0.1)' : 'rgba(239, 68, 68, 0.1)',
            border: error.includes('create a new record') ? 
              '1px solid #3B82F6' : '1px solid #EF4444',
            borderRadius: 6,
            color: error.includes('create a new record') ? '#3B82F6' : '#EF4444',
            fontSize: 14
          }}>
            {error}
          </div>
        )}

        {selectedPlayerId && (
          <div style={{
            marginTop: 10,
            padding: 10,
            background: 'rgba(16, 185, 129, 0.1)',
            border: '1px solid #10B981',
            borderRadius: 6,
            color: '#10B981',
            fontSize: 14
          }}>
            <strong>Selected Patient:</strong> {selectedPlayerName || selectedPlayerId} (ID: {selectedPlayerId})
          </div>
        )}
      </div>

      {/* Results Section */}
      {selectedPlayerId && (
        <div style={{ 
          background: darkMode ? '#1f1f23' : '#fff',
          borderRadius: 12,
          padding: 20,
          border: darkMode ? '1px solid #2a2a2e' : '1px solid #e5e7eb'
        }}>
          <div style={{ 
            display: 'flex', 
            alignItems: 'center', 
            justifyContent: 'space-between',
            marginBottom: 20,
            gap: 10
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
              <span style={{
                display: 'inline-flex',
                background: darkMode ? '#222' : '#e4e8ef',
                color: darkMode ? '#10B981' : '#059669',
                borderRadius: 8,
                width: 28,
                height: 28,
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: 14
              }}>
                <i className="fa-solid fa-user-md"></i>
              </span>
              <span style={{ fontSize: 18, fontWeight: 600 }}>
                Medical Records for: {selectedPlayerName || selectedPlayerId}
              </span>
            </div>
            
            <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
              <span style={{ fontSize: 14, color: darkMode ? '#888' : '#666' }}>
                {medicalRecords.length} record{medicalRecords.length !== 1 ? 's' : ''}
              </span>
              {onAddMedicalRecord && (
                <button
                  onClick={handleAddRecord}
                  style={{
                    padding: '8px 16px',
                    background: '#3B82F6',
                    color: '#fff',
                    border: 'none',
                    borderRadius: 6,
                    fontWeight: 600,
                    cursor: 'pointer',
                    fontSize: 12,
                    display: 'flex',
                    alignItems: 'center',
                    gap: 4
                  }}
                >
                  <i className="fa-solid fa-plus"></i>
                  Add New
                </button>
              )}
            </div>
          </div>

          {medicalRecords.length === 0 ? (
            <div style={{ 
              textAlign: 'center', 
              padding: 40,
              color: darkMode ? '#888' : '#666'
            }}>
              <div style={{ fontSize: 24, marginBottom: 10 }}>📋</div>
              <div>No medical records found for this player.</div>
              {onAddMedicalRecord && (
                <button
                  onClick={handleAddRecord}
                  style={{
                    marginTop: 16,
                    padding: '12px 24px',
                    background: '#3B82F6',
                    color: '#fff',
                    border: 'none',
                    borderRadius: 8,
                    fontWeight: 600,
                    cursor: 'pointer',
                    display: 'flex',
                    alignItems: 'center',
                    gap: 8,
                    margin: '16px auto 0'
                  }}
                >
                  <i className="fa-solid fa-plus"></i>
                  Add First Record
                </button>
              )}
            </div>
          ) : (
            <div style={{ display: 'flex', flexDirection: 'column', gap: 15 }}>
              {medicalRecords.map((record, index) => (
                <div
                  key={record.id || index}
                  style={{
                    background: darkMode ? '#2a2a2e' : '#f9fafb',
                    borderRadius: 10,
                    padding: 16,
                    border: `1px solid ${darkMode ? '#3a3a3e' : '#e5e7eb'}`
                  }}
                >
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 12 }}>
                    <div>
                      <div style={{ 
                        fontSize: 16, 
                        fontWeight: 600, 
                        marginBottom: 4,
                        color: darkMode ? '#fff' : '#111'
                      }}>
                        {record.condition}
                      </div>
                      <div style={{ 
                        fontSize: 12, 
                        color: darkMode ? '#888' : '#666',
                        marginBottom: 8
                      }}>
                        Doctor: {record.doctor} • {formatDate(record.date)}
                      </div>
                    </div>
                    <span style={{
                      padding: '4px 8px',
                      borderRadius: 6,
                      fontSize: 11,
                      fontWeight: 600,
                      background: `${getSeverityColor(record.severity)}20`,
                      color: getSeverityColor(record.severity),
                      border: `1px solid ${getSeverityColor(record.severity)}40`
                    }}>
                      {record.severity}
                    </span>
                  </div>

                  <div style={{ marginBottom: 10 }}>
                    <div style={{ 
                      fontSize: 13, 
                      fontWeight: 600, 
                      marginBottom: 4,
                      color: darkMode ? '#ccc' : '#555'
                    }}>
                      Diagnosis:
                    </div>
                    <div style={{ 
                      fontSize: 14, 
                      color: darkMode ? '#ddd' : '#333',
                      lineHeight: 1.4
                    }}>
                      {record.diagnosis}
                    </div>
                  </div>

                  <div style={{ marginBottom: 10 }}>
                    <div style={{ 
                      fontSize: 13, 
                      fontWeight: 600, 
                      marginBottom: 4,
                      color: darkMode ? '#ccc' : '#555'
                    }}>
                      Treatment:
                    </div>
                    <div style={{ 
                      fontSize: 14, 
                      color: darkMode ? '#ddd' : '#333',
                      lineHeight: 1.4
                    }}>
                      {record.treatment}
                    </div>
                  </div>

                  {record.notes && (
                    <div>
                      <div style={{ 
                        fontSize: 13, 
                        fontWeight: 600, 
                        marginBottom: 4,
                        color: darkMode ? '#ccc' : '#555'
                      }}>
                        Notes:
                      </div>
                      <div style={{ 
                        fontSize: 14, 
                        color: darkMode ? '#ddd' : '#333',
                        lineHeight: 1.4,
                        fontStyle: 'italic'
                      }}>
                        {record.notes}
                      </div>
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  )
}

export default MedicalRecordsViewer
