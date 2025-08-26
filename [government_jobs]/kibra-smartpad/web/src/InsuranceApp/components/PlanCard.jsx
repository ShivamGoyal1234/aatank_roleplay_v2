import React from 'react'

export default function PlanCard({ plan, onClick, isSelected, darkMode }) {
  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(amount)
  }

  return (
    <div 
      className={`plan-card ${isSelected ? 'selected' : ''}`}
      onClick={onClick}
    >
      <div className="plan-header">
        <h4>{plan.plan_name}</h4>
        <div className="plan-category">{plan.category}</div>
      </div>
      <div className="plan-price">
        <span className="price">{formatCurrency(plan.monthly_premium)}</span>
        <span className="period">/month</span>
      </div>
      <div className="plan-coverage">
        Coverage: {formatCurrency(plan.coverage_amount)}
      </div>
      <div className="plan-features">
        <p>{plan.description}</p>
        <ul>
          {plan.features.split(', ').map((feature, index) => (
            <li key={index}>{feature}</li>
          ))}
        </ul>
      </div>
      <div className="plan-details">
        <p><strong>Deductible:</strong> {formatCurrency(plan.deductible)}</p>
        <p><strong>Max Claims:</strong> {plan.max_claims_per_year}/year</p>
      </div>
      {onClick && (
        <button className="btn-primary" style={{ marginTop: '16px', width: '100%' }}>
          Select This Plan
        </button>
      )}
      {isSelected && (
        <div className="selected-indicator">✓ Selected</div>
      )}
    </div>
  )
}
