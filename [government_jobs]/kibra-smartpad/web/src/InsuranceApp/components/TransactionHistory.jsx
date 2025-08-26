import React, { useState, useEffect } from 'react'
import { callNui } from '@/nui'

const TransactionHistory = ({ darkMode }) => {
  const [transactions, setTransactions] = useState([])
  const [filteredTransactions, setFilteredTransactions] = useState([])
  const [searchQuery, setSearchQuery] = useState('')
  const [filterType, setFilterType] = useState('all')
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    loadTransactions()
  }, [])

  useEffect(() => {
    filterTransactions()
  }, [transactions, searchQuery, filterType])

  const loadTransactions = () => {
    setLoading(true)
    callNui('getInsuranceTransactions', {}, (result) => {
      setLoading(false)
      if (result && result.transactions) {
        setTransactions(result.transactions || [])
      } else {
        // Fallback sample data
        setTransactions([
          {
            id: 1,
            transaction_id: 'TXN-001',
            policy_number: 'POL-ABC123',
            type: 'Premium Payment',
            amount: -150.00,
            description: 'Monthly premium payment for Basic Health Plus',
            date: new Date(Date.now() - 86400000).toISOString(),
            status: 'Completed'
          },
          {
            id: 2,
            transaction_id: 'TXN-002',
            policy_number: 'POL-ABC123',
            type: 'Claim Payout',
            amount: 2500.00,
            description: 'Claim payout for medical expenses',
            date: new Date(Date.now() - 172800000).toISOString(),
            status: 'Completed'
          },
          {
            id: 3,
            transaction_id: 'TXN-003',
            policy_number: 'POL-DEF456',
            type: 'Premium Payment',
            amount: -350.00,
            description: 'Monthly premium payment for Premium Health Elite',
            date: new Date(Date.now() - 259200000).toISOString(),
            status: 'Completed'
          }
        ])
      }
    })
  }

  const filterTransactions = () => {
    let filtered = transactions

    // Filter by type
    if (filterType !== 'all') {
      filtered = filtered.filter(t => t.type === filterType)
    }

    // Filter by search query
    if (searchQuery) {
      filtered = filtered.filter(t => 
        t.transaction_id.toLowerCase().includes(searchQuery.toLowerCase()) ||
        t.policy_number.toLowerCase().includes(searchQuery.toLowerCase()) ||
        t.description.toLowerCase().includes(searchQuery.toLowerCase())
      )
    }

    setFilteredTransactions(filtered)
  }

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(Math.abs(amount))
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

  const getTransactionIcon = (type) => {
    switch (type) {
      case 'Premium Payment':
        return 'fa-solid fa-credit-card'
      case 'Claim Payout':
        return 'fa-solid fa-hand-holding-dollar'
      case 'Policy Refund':
        return 'fa-solid fa-arrow-left'
      case 'Late Fee':
        return 'fa-solid fa-exclamation-triangle'
      default:
        return 'fa-solid fa-exchange-alt'
    }
  }

  const getTransactionColor = (type, amount) => {
    if (amount > 0) return '#10B981' // Green for incoming
    if (amount < 0) return '#EF4444' // Red for outgoing
    return '#6B7280' // Gray for neutral
  }

  const getStatusColor = (status) => {
    switch (status) {
      case 'Completed':
        return '#10B981'
      case 'Pending':
        return '#F59E0B'
      case 'Failed':
        return '#EF4444'
      default:
        return '#6B7280'
    }
  }

  if (loading) {
    return (
      <div style={{
        display: 'flex', justifyContent: 'center', alignItems: 'center',
        height: 200, color: darkMode ? '#888' : '#666'
      }}>
        <i className="fa-solid fa-spinner fa-spin" style={{ fontSize: 24, marginRight: 12 }}></i>
        Loading transactions...
      </div>
    )
  }

  return (
    <div style={{ padding: 20 }}>
      {/* Header */}
      <div style={{ marginBottom: 24 }}>
        <h3 style={{ 
          fontSize: 24, fontWeight: 600, margin: '0 0 8px 0',
          color: darkMode ? '#fff' : '#1e293b'
        }}>
          Transaction History
        </h3>
        <p style={{ 
          fontSize: 16, margin: 0,
          color: darkMode ? 'rgba(255, 255, 255, 0.7)' : 'rgba(0, 0, 0, 0.7)'
        }}>
          View all insurance-related transactions
        </p>
      </div>

      {/* Search and Filters */}
      <div style={{ 
        display: 'flex', gap: 16, marginBottom: 24,
        flexWrap: 'wrap'
      }}>
        <div style={{ flex: 1, minWidth: 300 }}>
          <input
            type="text"
            placeholder="Search by transaction ID, policy number, or description..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            style={{
              width: '100%', padding: '12px 16px', borderRadius: 10,
              border: darkMode ? '1px solid #28282c' : '1px solid #ddd',
              background: darkMode ? '#202024' : '#fff',
              color: darkMode ? '#fff' : '#222', fontSize: 15,
              outline: 'none', transition: 'border 0.18s'
            }}
          />
        </div>
        <select
          value={filterType}
          onChange={(e) => setFilterType(e.target.value)}
          style={{
            padding: '12px 16px', borderRadius: 10,
            border: darkMode ? '1px solid #28282c' : '1px solid #ddd',
            background: darkMode ? '#202024' : '#fff',
            color: darkMode ? '#fff' : '#222', fontSize: 15,
            outline: 'none', transition: 'border 0.18s',
            minWidth: 150
          }}
        >
          <option value="all">All Transactions</option>
          <option value="Premium Payment">Premium Payments</option>
          <option value="Claim Payout">Claim Payouts</option>
          <option value="Policy Refund">Policy Refunds</option>
          <option value="Late Fee">Late Fees</option>
        </select>
        <button
          onClick={loadTransactions}
          style={{
            padding: '12px 16px', borderRadius: 10,
            background: '#007AFF', color: '#fff', border: 'none',
            fontSize: 15, fontWeight: 500, cursor: 'pointer',
            transition: 'all 0.2s ease'
          }}
        >
          <i className="fa-solid fa-rotate" style={{ marginRight: 8 }}></i>
          Refresh
        </button>
      </div>

      {/* Transactions List */}
      <div style={{ 
        background: darkMode ? 'rgba(255, 255, 255, 0.05)' : 'rgba(255, 255, 255, 0.8)',
        borderRadius: 12, border: darkMode ? '1px solid rgba(255, 255, 255, 0.1)' : '1px solid rgba(0, 0, 0, 0.1)',
        overflow: 'hidden'
      }}>
        {filteredTransactions.length === 0 ? (
          <div style={{
            padding: 40, textAlign: 'center',
            color: darkMode ? 'rgba(255, 255, 255, 0.6)' : 'rgba(0, 0, 0, 0.6)'
          }}>
            <i className="fa-solid fa-receipt" style={{ fontSize: 48, marginBottom: 16, opacity: 0.5 }}></i>
            <div style={{ fontSize: 18, fontWeight: 600, marginBottom: 8 }}>
              No transactions found
            </div>
            <div style={{ fontSize: 14 }}>
              {searchQuery || filterType !== 'all' 
                ? 'Try adjusting your search or filters'
                : 'Transactions will appear here once you have insurance activity'
              }
            </div>
          </div>
        ) : (
          filteredTransactions.map((transaction) => (
            <div
              key={transaction.id}
              style={{
                padding: 20, borderBottom: darkMode ? '1px solid rgba(255, 255, 255, 0.1)' : '1px solid rgba(0, 0, 0, 0.1)',
                display: 'flex', alignItems: 'center', gap: 16,
                transition: 'background 0.2s ease'
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.background = darkMode ? 'rgba(255, 255, 255, 0.05)' : 'rgba(0, 0, 0, 0.02)'
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.background = 'transparent'
              }}
            >
              {/* Icon */}
              <div style={{
                width: 48, height: 48, borderRadius: 12,
                background: darkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                color: getTransactionColor(transaction.type, transaction.amount)
              }}>
                <i className={getTransactionIcon(transaction.type)} style={{ fontSize: 20 }}></i>
              </div>

              {/* Transaction Details */}
              <div style={{ flex: 1 }}>
                <div style={{ 
                  display: 'flex', justifyContent: 'space-between', 
                  alignItems: 'flex-start', marginBottom: 8
                }}>
                  <div>
                    <div style={{ 
                      fontSize: 16, fontWeight: 600, marginBottom: 4,
                      color: darkMode ? '#fff' : '#1e293b'
                    }}>
                      {transaction.type}
                    </div>
                    <div style={{ 
                      fontSize: 14, marginBottom: 4,
                      color: darkMode ? 'rgba(255, 255, 255, 0.7)' : 'rgba(0, 0, 0, 0.7)'
                    }}>
                      {transaction.description}
                    </div>
                    <div style={{ 
                      fontSize: 12,
                      color: darkMode ? 'rgba(255, 255, 255, 0.5)' : 'rgba(0, 0, 0, 0.5)'
                    }}>
                      Policy: {transaction.policy_number} • {transaction.transaction_id}
                    </div>
                  </div>
                  <div style={{ textAlign: 'right' }}>
                    <div style={{ 
                      fontSize: 18, fontWeight: 700, marginBottom: 4,
                      color: getTransactionColor(transaction.type, transaction.amount)
                    }}>
                      {transaction.amount > 0 ? '+' : ''}{formatCurrency(transaction.amount)}
                    </div>
                    <div style={{ 
                      fontSize: 12,
                      color: getStatusColor(transaction.status)
                    }}>
                      {transaction.status}
                    </div>
                  </div>
                </div>
                <div style={{ 
                  fontSize: 12,
                  color: darkMode ? 'rgba(255, 255, 255, 0.5)' : 'rgba(0, 0, 0, 0.5)'
                }}>
                  {formatDate(transaction.date)}
                </div>
              </div>
            </div>
          ))
        )}
      </div>

      {/* Summary */}
      {filteredTransactions.length > 0 && (
        <div style={{ 
          marginTop: 20, padding: 16, borderRadius: 10,
          background: darkMode ? 'rgba(0, 122, 255, 0.1)' : 'rgba(0, 122, 255, 0.05)',
          border: '1px solid #007AFF'
        }}>
          <div style={{ 
            fontSize: 14, fontWeight: 600, marginBottom: 8,
            color: darkMode ? '#fff' : '#1e293b'
          }}>
            Summary
          </div>
          <div style={{ 
            display: 'flex', gap: 24,
            fontSize: 12, color: darkMode ? 'rgba(255, 255, 255, 0.7)' : 'rgba(0, 0, 0, 0.7)'
          }}>
            <span>Total Transactions: {filteredTransactions.length}</span>
            <span>
              Total Incoming: {formatCurrency(
                filteredTransactions
                  .filter(t => t.amount > 0)
                  .reduce((sum, t) => sum + t.amount, 0)
              )}
            </span>
            <span>
              Total Outgoing: {formatCurrency(
                Math.abs(filteredTransactions
                  .filter(t => t.amount < 0)
                  .reduce((sum, t) => sum + t.amount, 0))
              )}
            </span>
          </div>
        </div>
      )}
    </div>
  )
}

export default TransactionHistory
