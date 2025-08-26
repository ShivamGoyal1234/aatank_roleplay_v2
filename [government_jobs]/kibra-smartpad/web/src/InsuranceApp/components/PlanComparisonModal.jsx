import React from 'react'

export default function PlanComparisonModal({ plans, selectedPlans, onClose, onSelectPlan, darkMode }) {
  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(amount)
  }

  return (
    <div className={`modal-overlay ${darkMode ? 'dark' : 'light'}`}>
      <div className="modal-content large">
        <div className="modal-header">
          <h2>Compare Insurance Plans</h2>
          <button className="close-btn" onClick={onClose}>×</button>
        </div>
        <div className="comparison-container">
          <div className="plan-selection">
            <h3>Select Plans to Compare (Max 3)</h3>
            <div className="plans-grid">
              {plans.map((plan) => (
                <div 
                  key={plan.id} 
                  className={`plan-card ${selectedPlans.find(p => p.id === plan.id) ? 'selected' : ''}`}
                  onClick={() => onSelectPlan(plan)}
                >
                  <h4>{plan.plan_name}</h4>
                  <div className="plan-category">{plan.category}</div>
                  <div className="plan-price">{formatCurrency(plan.monthly_premium)}/month</div>
                </div>
              ))}
            </div>
          </div>
          
          {selectedPlans.length > 0 && (
            <div className="comparison-table">
              <h3>Comparison</h3>
              <table>
                <thead>
                  <tr>
                    <th>Feature</th>
                    {selectedPlans.map(plan => (
                      <th key={plan.id}>{plan.plan_name}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>Monthly Premium</td>
                    {selectedPlans.map(plan => (
                      <td key={plan.id}>{formatCurrency(plan.monthly_premium)}</td>
                    ))}
                  </tr>
                  <tr>
                    <td>Coverage Amount</td>
                    {selectedPlans.map(plan => (
                      <td key={plan.id}>{formatCurrency(plan.coverage_amount)}</td>
                    ))}
                  </tr>
                  <tr>
                    <td>Deductible</td>
                    {selectedPlans.map(plan => (
                      <td key={plan.id}>{formatCurrency(plan.deductible)}</td>
                    ))}
                  </tr>
                  <tr>
                    <td>Max Claims/Year</td>
                    {selectedPlans.map(plan => (
                      <td key={plan.id}>{plan.max_claims_per_year}</td>
                    ))}
                  </tr>
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
