import React, { useState, useEffect, useRef } from 'react'
import { callNui } from '@/nui'
import './main.css'

// Import components
import PolicyApplicationModal from './components/PolicyApplicationModal'
import ClaimApplicationModal from './components/ClaimApplicationModal'
import ClaimApprovalModal from './components/ClaimApprovalModal'
import MedicalRecordsModal from './components/MedicalRecordsModal'
import PolicyDetailsModal from './components/PolicyDetailsModal'
import PolicyRenewalModal from './components/PolicyRenewalModal'
import InsurancePlansModal from './components/InsurancePlansModal'
import PlanComparisonModal from './components/PlanComparisonModal'
import PolicyCard from './components/PolicyCard'
import ClaimItem from './components/ClaimItem'
import PlanCard from './components/PlanCard'
import DropdownButton from './components/DropdownButton'
import DropdownItem from './components/DropdownItem'
import EmptyState from './components/EmptyState'
import TransactionHistory from './components/TransactionHistory'
import MedicalRecordsViewer from './components/MedicalRecordsViewer'

export default function InsuranceApp({ lang, insuranceData, tabOwner, tabletTheme }) {
  const [activeTab, setActiveTab] = useState('policies')
  const [policies, setPolicies] = useState([])
  const [claims, setClaims] = useState([])
  const [medicalHistory, setMedicalHistory] = useState([])
  const [selectedPolicy, setSelectedPolicy] = useState(null)
  const [showPolicyApplicationModal, setShowPolicyApplicationModal] = useState(false)
  const [showClaimApplicationModal, setShowClaimApplicationModal] = useState(false)
  const [showClaimApprovalModal, setShowClaimApprovalModal] = useState(false)
  const [showMedicalRecordsModal, setShowMedicalRecordsModal] = useState(false)
  const [showPolicyDetails, setShowPolicyDetails] = useState(false)
  const [darkMode, setDarkMode] = useState(true)
  const [searchQuery, setSearchQuery] = useState('')
  const [activeCategory, setActiveCategory] = useState('all')
  const [showPlansModal, setShowPlansModal] = useState(false)
  const [showComparisonModal, setShowComparisonModal] = useState(false)
  const [selectedPlans, setSelectedPlans] = useState([])
  const [insurancePlans, setInsurancePlans] = useState([])
  const [showRenewalModal, setShowRenewalModal] = useState(false)
  const [showProviderModal, setShowProviderModal] = useState(false)
  const [providers, setProviders] = useState([])
  const [showPolicyDropdown, setShowPolicyDropdown] = useState(false)
  const [showClaimDropdown, setShowClaimDropdown] = useState(false)
  const [selectedClaim, setSelectedClaim] = useState(null)
  const [selectedPlayer, setSelectedPlayer] = useState(null)
  const [plansLoaded, setPlansLoaded] = useState(false)
  const [playerPermissions, setPlayerPermissions] = useState({
    canApproveClaims: false,
    canAccessMedicalRecords: false,
    canWriteMedicalRecords: false,
    canSeeMedicalRecordsTab: false,
    playerJob: ''
  })
  const [medicalHistoryStartDate, setMedicalHistoryStartDate] = useState('')
  const [medicalHistoryEndDate, setMedicalHistoryEndDate] = useState('')
  const [filteredMedicalHistory, setFilteredMedicalHistory] = useState([])
  const [showMedicalHistoryFilter, setShowMedicalHistoryFilter] = useState(false)

  useEffect(() => {
    if (insuranceData) {
      setPolicies(insuranceData.insuranceData_policies || insuranceData.policies || [])
      setClaims(insuranceData.insuranceData_claims || insuranceData.claims || [])
      setMedicalHistory(insuranceData.insuranceData_medicalHistory || insuranceData.medicalHistory || [])
      
      // Set player permissions
      const permissions = {
        canApproveClaims: insuranceData.canApproveClaims || false,
        canAccessMedicalRecords: insuranceData.canAccessMedicalRecords || false,
        canWriteMedicalRecords: insuranceData.canWriteMedicalRecords || false,
        canSeeMedicalRecordsTab: insuranceData.canSeeMedicalRecordsTab || false,
        playerJob: insuranceData.playerJob || ''
      }
      
      setPlayerPermissions(permissions)
    }
    
    if (tabletTheme === 'light') {
      setDarkMode(false)
    }
  }, [insuranceData, tabletTheme])

  // Update filtered medical history when medical history changes
  useEffect(() => {
    setFilteredMedicalHistory(medicalHistory)
  }, [medicalHistory])

  const applyMedicalHistoryDateFilter = () => {
    if (!medicalHistoryStartDate && !medicalHistoryEndDate) {
      setFilteredMedicalHistory(medicalHistory)
      return
    }

    const filtered = medicalHistory.filter(record => {
      const recordDate = new Date(record.date)
      const start = medicalHistoryStartDate ? new Date(medicalHistoryStartDate) : null
      const end = medicalHistoryEndDate ? new Date(medicalHistoryEndDate) : null

      if (start && end) {
        return recordDate >= start && recordDate <= end
      } else if (start) {
        return recordDate >= start
      } else if (end) {
        return recordDate <= end
      }
      return true
    })

    setFilteredMedicalHistory(filtered)
  }

  // const refreshInsuranceData = () => {
  //   callNui('getInsuranceData', {}, (result) => {
  //     if (result) {
  //       setInsuranceData(result)
  //     }
  //   })
  // }

  const clearMedicalHistoryDateFilter = () => {
    setMedicalHistoryStartDate('')
    setMedicalHistoryEndDate('')
    setFilteredMedicalHistory(medicalHistory)
  }

  const toggleMedicalHistoryFilter = () => {
    setShowMedicalHistoryFilter(!showMedicalHistoryFilter)
  }

  // Close dropdowns when clicking outside
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (!event.target.closest('.dropdown-container')) {
        setShowPolicyDropdown(false)
        setShowClaimDropdown(false)
      }
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  // Close dropdowns when clicking outside modal dropdowns
  useEffect(() => {
    const handleClickOutside = (event) => {
      // Close modal dropdowns if clicking outside
      const modalDropdowns = document.querySelectorAll('[data-modal-dropdown]')
      modalDropdowns.forEach(dropdown => {
        if (!dropdown.contains(event.target)) {
          // This will be handled by the individual modal components
        }
      })
    }

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  // Load insurance plans
  useEffect(() => {
    if (!plansLoaded) {
      callNui('getInsurancePlans', {}, (result) => {
        if (result && result.plans) {
          setInsurancePlans(result.plans || [])
        } else {
          // Fallback sample data if callback fails
          setInsurancePlans([
            {
              id: 1,
              plan_name: 'Basic Health Plus',
              category: 'Basic',
              monthly_premium: 150.00,
              coverage_amount: 50000.00,
              description: 'Essential health coverage for individuals',
              features: 'Emergency room visits, Basic doctor visits, Prescription drugs',
              deductible: 500.00,
              max_claims_per_year: 10
            },
            {
              id: 2,
              plan_name: 'Premium Health Elite',
              category: 'Premium',
              monthly_premium: 350.00,
              coverage_amount: 150000.00,
              description: 'Comprehensive health coverage',
              features: 'All doctor visits, Specialist consultations, Surgery coverage, Mental health',
              deductible: 250.00,
              max_claims_per_year: 25
            },
            {
              id: 3,
              plan_name: 'Family Health Plus',
              category: 'Family',
              monthly_premium: 400.00,
              coverage_amount: 100000.00,
              description: 'Complete family health coverage',
              features: 'Family doctor, Pediatric care, Maternity coverage, Dental',
              deductible: 400.00,
              max_claims_per_year: 20
            },
            {
              id: 4,
              plan_name: 'Emergency Response',
              category: 'Emergency',
              monthly_premium: 75.00,
              coverage_amount: 50000.00,
              description: 'Emergency medical coverage',
              features: 'Emergency room, Ambulance, Urgent care, Trauma care',
              deductible: 500.00,
              max_claims_per_year: 10
            }
          ])
        }
        setPlansLoaded(true)
      })
    }
  }, [plansLoaded])

  // Load providers
  useEffect(() => {
    callNui('getInsuranceProviders', {}, (result) => {
      if (result && result.providers) {
        setProviders(result.providers || [])
      } else {
        // Fallback sample data
        setProviders([
          {
            id: 1,
            provider_name: 'HealthFirst Insurance',
            provider_code: 'HFI001',
            contact_email: 'contact@healthfirst.com',
            contact_phone: '555-0100'
          },
          {
            id: 2,
            provider_name: 'MediCare Plus',
            provider_code: 'MCP002',
            contact_email: 'info@medicareplus.com',
            contact_phone: '555-0200'
          }
        ])
      }
    })
  }, [])



  const refreshInsuranceData = () => {
    callNui('getInsuranceData', {}, (result) => {
      if (result) {
        setPolicies(result.policies || result.insuranceData_policies || [])
        setClaims(result.claims || result.insuranceData_claims || [])
        setMedicalHistory(result.medicalHistory || result.insuranceData_medicalHistory || [])
      }
    })
  }

  const handlePolicyDetails = (policy) => {
    setSelectedPolicy(policy)
    setShowPolicyDetails(true)
  }

  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString()
  }

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(amount)
  }

  const getStatusColor = (status) => {
    switch (status) {
      case 'Active': return '#10B981'
      case 'Expired': return '#EF4444'
      case 'Cancelled': return '#F59E0B'
      case 'Pending': return '#3B82F6'
      default: return '#6B7280'
    }
  }

  const getInsuranceTypeColor = (type) => {
    switch (type) {
      case 'Basic': return '#6B7280'
      case 'Premium': return '#10B981'
      case 'Family': return '#3B82F6'
      case 'Emergency': return '#EF4444'
      default: return '#6B7280'
    }
  }

  const categories = [
    { id: 'all', name: 'All Policies', color: '#007AFF' },
    { id: 'Basic', name: 'Basic', color: '#6B7280' },
    { id: 'Premium', name: 'Premium', color: '#10B981' },
    { id: 'Family', name: 'Family', color: '#3B82F6' },
    { id: 'Emergency', name: 'Emergency', color: '#EF4444' }
  ]

  const filteredPolicies = policies.filter(policy => {
    const matchesCategory = activeCategory === 'all' || policy.insurance_type === activeCategory
    const matchesSearch = policy.policy_number.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         policy.citizen_name.toLowerCase().includes(searchQuery.toLowerCase())
    return matchesCategory && matchesSearch
  })

  const filteredClaims = claims.filter(claim => {
    const matchesSearch = claim.claim_number.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         claim.description.toLowerCase().includes(searchQuery.toLowerCase())
    return matchesSearch
  })

  return (
    <div className={`insurance-app ${darkMode ? 'dark' : 'light'}`}>
      {/* Header */}
      <div className="insurance-header">
        <div className="header-content">
          <div className="header-left">
            <h1>Health Insurance</h1>
            <div className="header-subtitle">Manage your health coverage</div>
          </div>
                     <div className="header-actions">
             <DropdownButton
               icon="fa-solid fa-shield-halved"
               text="New Policy"
               isOpen={showPolicyDropdown}
               onClick={() => setShowPolicyDropdown(!showPolicyDropdown)}
               darkMode={darkMode}
             >
                                    <DropdownItem
                       icon="fa-solid fa-plus"
                       text="Create New Policy"
                       onClick={() => {
                         setShowPolicyDropdown(false)
                         setShowPolicyApplicationModal(true)
                       }}
                       darkMode={darkMode}
                     />
               <DropdownItem
                 icon="fa-solid fa-list"
                 text="View All Plans"
                 onClick={() => {
                   setShowPolicyDropdown(false)
                   setActiveTab('plans')
                 }}
                 darkMode={darkMode}
               />
               <DropdownItem
                 icon="fa-solid fa-chart-line"
                 text="Compare Plans"
                 onClick={() => {
                   setShowPolicyDropdown(false)
                   setActiveTab('compare')
                 }}
                 darkMode={darkMode}
               />
             </DropdownButton>

             <DropdownButton
               icon="fa-solid fa-file-medical"
               text="New Claim"
               isOpen={showClaimDropdown}
               onClick={() => setShowClaimDropdown(!showClaimDropdown)}
               darkMode={darkMode}
             >
                                    <DropdownItem
                       icon="fa-solid fa-plus"
                       text="File New Claim"
                       onClick={() => {
                         setShowClaimDropdown(false)
                         setShowClaimApplicationModal(true)
                       }}
                       darkMode={darkMode}
                     />
               <DropdownItem
                 icon="fa-solid fa-history"
                 text="View Claims History"
                 onClick={() => {
                   setShowClaimDropdown(false)
                   setActiveTab('claims')
                 }}
                 darkMode={darkMode}
               />
               <DropdownItem
                 icon="fa-solid fa-user-md"
                 text="Medical Records"
                 onClick={() => {
                   setShowClaimDropdown(false)
                   setActiveTab('medical')
                 }}
                 darkMode={darkMode}
               />
             </DropdownButton>

             <button className="btn-secondary" onClick={refreshInsuranceData}>
               <i className="fa-solid fa-rotate"></i>
               <span>Refresh</span>
             </button>
           </div>
        </div>
      </div>

      {/* Search and Categories */}
      <div className="search-categories-section">
        <div className="search-bar">
          <input
            type="text"
            placeholder="Search policies, claims..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="search-input"
          />
        </div>
        <div className="categories-bar">
          {categories.map((category) => (
            <button
              key={category.id}
              className={`category-button ${activeCategory === category.id ? 'active' : ''}`}
              onClick={() => setActiveCategory(category.id)}
              style={{ '--category-color': category.color }}
            >
              {category.name}
            </button>
          ))}
        </div>
      </div>

             {/* Tabs */}
       <div className="insurance-tabs">
         <button 
           className={`tab ${activeTab === 'policies' ? 'active' : ''}`}
           onClick={() => setActiveTab('policies')}
         >
           My Policies ({policies.length})
         </button>
         <button 
           className={`tab ${activeTab === 'claims' ? 'active' : ''}`}
           onClick={() => setActiveTab('claims')}
         >
           Claims History ({claims.length})
         </button>
         <button 
           className={`tab ${activeTab === 'plans' ? 'active' : ''}`}
           onClick={() => setActiveTab('plans')}
         >
           View Plans ({insurancePlans.length})
         </button>
         <button 
           className={`tab ${activeTab === 'compare' ? 'active' : ''}`}
           onClick={() => setActiveTab('compare')}
         >
           Compare Plans
         </button>
         <button 
           className={`tab ${activeTab === 'medical' ? 'active' : ''}`}
           onClick={() => setActiveTab('medical')}
         >
           Medical Records History ({medicalHistory.length})
         </button>
         <button 
           className={`tab ${activeTab === 'renewals' ? 'active' : ''}`}
           onClick={() => setActiveTab('renewals')}
         >
           Renewals
         </button>
         <button 
           className={`tab ${activeTab === 'transactions' ? 'active' : ''}`}
           onClick={() => setActiveTab('transactions')}
         >
           Transactions
         </button>
         <button 
           className={`tab ${activeTab === 'medical-records' ? 'active' : ''}`}
           onClick={() => setActiveTab('medical-records')}
         >
           Medical Records
         </button>
       </div>

       {/* Content */}
       <div className="insurance-content">
         {activeTab === 'policies' && (
           <div className="policies-section">
             {filteredPolicies.length === 0 ? (
               <EmptyState
                 icon="🏥"
                 title="No Insurance Policies"
                 description="You don't have any active insurance policies. Create your first policy to get started."
                 buttonText="Get Insurance"
                 onButtonClick={() => setShowPolicyApplicationModal(true)}
                 darkMode={darkMode}
               />
             ) : (
               <div className="policies-grid">
                 {filteredPolicies.map((policy) => (
                   <PolicyCard
                     key={policy.id}
                     policy={policy}
                     onClick={() => handlePolicyDetails(policy)}
                     onRenew={(policy) => {
                       setShowRenewalModal(true)
                       setSelectedPolicy(policy)
                     }}
                     darkMode={darkMode}
                   />
                 ))}
               </div>
             )}
           </div>
         )}

         {activeTab === 'claims' && (
           <div className="claims-section">
             {filteredClaims.length === 0 ? (
               <EmptyState
                 icon="📋"
                 title="No Claims History"
                 description="You haven't filed any insurance claims yet."
                 buttonText="File a Claim"
                 onButtonClick={() => setShowClaimApplicationModal(true)}
                 darkMode={darkMode}
               />
             ) : (
               <div className="claims-list">
                 {filteredClaims.map((claim) => {
                   return (
                     <ClaimItem
                       key={claim.id}
                       claim={claim}
                       darkMode={darkMode}
                       onApprove={(claim) => {
                         setSelectedClaim(claim)
                         setShowClaimApprovalModal(true)
                       }}
                     />
                   )
                 })}
               </div>
             )}
           </div>
         )}

         {activeTab === 'medical' && (
           <div className="medical-section">
             {medicalHistory.length === 0 ? (
               <EmptyState
                 icon="📊"
                 title="No Medical Records"
                 description="Your medical records will appear here once you have medical records created."
                 darkMode={darkMode}
               />
             ) : (
               <>
                 {/* Medical Records Header */}
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
                     justifyContent: 'space-between',
                     marginBottom: 15
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
                         <i className="fa-solid fa-heartbeat"></i>
                       </span>
                       <span style={{ fontSize: 18, fontWeight: 600 }}>
                         Medical Records History
                       </span>
                     </div>
                     <button
                       onClick={refreshInsuranceData}
                       style={{
                         padding: '8px 12px',
                         background: darkMode ? '#2a2a2e' : '#f3f4f6',
                         color: darkMode ? '#fff' : '#333',
                         border: darkMode ? '1px solid #3a3a3e' : '1px solid #d1d5db',
                         borderRadius: 6,
                         cursor: 'pointer',
                         display: 'flex',
                         alignItems: 'center',
                         gap: 6,
                         fontSize: 12,
                         fontWeight: 500
                       }}
                     >
                       <i className="fa-solid fa-sync-alt"></i>
                       Refresh
                     </button>
                   </div>
                 </div>

                 {/* Date Range Filter */}
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
                     justifyContent: 'space-between',
                     marginBottom: 15
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
                         <i className="fa-solid fa-calendar"></i>
                       </span>
                       <span style={{ fontSize: 16, fontWeight: 600 }}>
                         Filter Medical Records
                       </span>
                     </div>
                     <button
                       onClick={toggleMedicalHistoryFilter}
                       style={{
                         padding: '8px 16px',
                         background: showMedicalHistoryFilter ? '#EF4444' : '#3B82F6',
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
                       <i className={`fa-solid ${showMedicalHistoryFilter ? 'fa-times' : 'fa-filter'}`}></i>
                       {showMedicalHistoryFilter ? 'Hide Filter' : 'Show Filter'}
                     </button>
                   </div>

                   {showMedicalHistoryFilter && (
                     <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'center' }}>
                       <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                         <label style={{ fontSize: 14, fontWeight: 500, color: darkMode ? '#ccc' : '#555' }}>
                           From:
                         </label>
                         <input
                           type="date"
                           value={medicalHistoryStartDate}
                           onChange={(e) => setMedicalHistoryStartDate(e.target.value)}
                           style={{
                             padding: '8px 12px',
                             borderRadius: 6,
                             border: darkMode ? '1px solid #2a2a2e' : '1px solid #d1d5db',
                             background: darkMode ? '#2a2a2e' : '#fff',
                             color: darkMode ? '#fff' : '#333',
                             fontSize: 14,
                             outline: 'none'
                           }}
                         />
                       </div>
                       <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                         <label style={{ fontSize: 14, fontWeight: 500, color: darkMode ? '#ccc' : '#555' }}>
                           To:
                         </label>
                         <input
                           type="date"
                           value={medicalHistoryEndDate}
                           onChange={(e) => setMedicalHistoryEndDate(e.target.value)}
                           style={{
                             padding: '8px 12px',
                             borderRadius: 6,
                             border: darkMode ? '1px solid #2a2a2e' : '1px solid #d1d5db',
                             background: darkMode ? '#2a2a2e' : '#fff',
                             color: darkMode ? '#fff' : '#333',
                             fontSize: 14,
                             outline: 'none'
                           }}
                         />
                       </div>
                       <button
                         onClick={applyMedicalHistoryDateFilter}
                         style={{
                           padding: '8px 16px',
                           background: '#10B981',
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
                         <i className="fa-solid fa-search"></i>
                         Apply Filter
                       </button>
                       <button
                         onClick={clearMedicalHistoryDateFilter}
                         style={{
                           padding: '8px 16px',
                           background: '#6B7280',
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
                         <i className="fa-solid fa-times"></i>
                         Clear Filter
                       </button>
                     </div>
                   )}

                   <div style={{ 
                     marginTop: 10,
                     padding: 8,
                     background: darkMode ? 'rgba(59, 130, 246, 0.1)' : 'rgba(59, 130, 246, 0.05)',
                     border: '1px solid #3B82F6',
                     borderRadius: 6,
                     fontSize: 12,
                     color: darkMode ? '#93C5FD' : '#1E40AF'
                   }}>
                     Showing {filteredMedicalHistory.length} of {medicalHistory.length} records
                     {(medicalHistoryStartDate || medicalHistoryEndDate) && (
                       <span style={{ marginLeft: 8 }}>
                         • Filtered by date range
                       </span>
                     )}
                   </div>
                 </div>

                 {/* Medical Records List */}
                 <div className="medical-list">
                   {filteredMedicalHistory.length === 0 ? (
                     <div style={{ 
                       textAlign: 'center', 
                       padding: 40,
                       color: darkMode ? '#888' : '#666'
                     }}>
                       <div style={{ fontSize: 24, marginBottom: 10 }}>📋</div>
                       <div>No medical records found for the selected date range.</div>
                       <button
                         onClick={clearMedicalHistoryDateFilter}
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
                         <i className="fa-solid fa-times"></i>
                         Clear Filter
                       </button>
                     </div>
                   ) : (
                     filteredMedicalHistory.map((record) => (
                       <div key={record.id} className="medical-item">
                         <div className="medical-header">
                           <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', width: '100%' }}>
                             <h4>{record.condition}</h4>
                             <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                               {record.severity && (
                                 <span style={{
                                   padding: '4px 8px',
                                   borderRadius: 6,
                                   fontSize: 11,
                                   fontWeight: 600,
                                   background: record.severity === 'Low' ? '#10B98120' : 
                                              record.severity === 'Medium' ? '#F59E0B20' : 
                                              record.severity === 'High' ? '#EF444420' : '#DC262620',
                                   color: record.severity === 'Low' ? '#10B981' : 
                                          record.severity === 'Medium' ? '#F59E0B' : 
                                          record.severity === 'High' ? '#EF4444' : '#DC2626',
                                   border: `1px solid ${record.severity === 'Low' ? '#10B98140' : 
                                                       record.severity === 'Medium' ? '#F59E0B40' : 
                                                       record.severity === 'High' ? '#EF444440' : '#DC262640'}`
                                 }}>
                                   {record.severity}
                                 </span>
                               )}
                               <span className="medical-date">{formatDate(record.date)}</span>
                             </div>
                           </div>
                         </div>
                         <div className="medical-details">
                           <p><strong>Diagnosis:</strong> {record.diagnosis}</p>
                           <p><strong>Treatment:</strong> {record.treatment}</p>
                           <p><strong>Doctor:</strong> {record.doctor}</p>
                           {record.notes && <p><strong>Notes:</strong> {record.notes}</p>}
                         </div>
                       </div>
                     ))
                   )}
                 </div>
               </>
             )}
           </div>
         )}

         {activeTab === 'transactions' && (
           <TransactionHistory darkMode={darkMode} />
         )}

         {activeTab === 'medical-records' && (
           <MedicalRecordsViewer 
             darkMode={darkMode} 
             onAddMedicalRecord={(playerId, playerName) => {
               setSelectedPlayer({ id: playerId, name: playerName })
               setShowMedicalRecordsModal(true)
             }}
           />
         )}

         {activeTab === 'plans' && (
           <div className="plans-section">
             <div className="plans-header">
               <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 }}>
                 <div>
                   <h3>Available Insurance Plans</h3>
                   <p>Choose from our comprehensive range of health insurance plans</p>
                 </div>
                 <button
                   onClick={() => setShowPlansModal(true)}
                   style={{
                     background: '#10B981',
                     color: '#fff',
                     border: 'none',
                     padding: '12px 20px',
                     borderRadius: 8,
                     fontWeight: 600,
                     cursor: 'pointer',
                     display: 'flex',
                     alignItems: 'center',
                     gap: 8
                   }}
                 >
                   <i className="fa-solid fa-plus"></i>
                   Add Plan
                 </button>
               </div>
             </div>
             <div className="plans-grid">
               {insurancePlans.map((plan) => (
                 <PlanCard
                   key={plan.id}
                   plan={plan}
                   onClick={() => {
                     setShowPolicyApplicationModal(true)
                     // Pre-select this plan
                   }}
                   darkMode={darkMode}
                 />
               ))}
             </div>
           </div>
         )}

         {activeTab === 'compare' && (
           <div className="compare-section">
             <div className="compare-header">
               <h3>Compare Insurance Plans</h3>
               <p>Select up to 3 plans to compare their features and benefits</p>
             </div>
             
             <div className="plan-selection">
               <h4>Select Plans to Compare (Max 3)</h4>
               <div className="plans-grid">
                 {insurancePlans.map((plan) => (
                   <PlanCard
                     key={plan.id}
                     plan={plan}
                     isSelected={selectedPlans.find(p => p.id === plan.id)}
                     onClick={() => {
                       if (selectedPlans.find(p => p.id === plan.id)) {
                         setSelectedPlans(selectedPlans.filter(p => p.id !== plan.id))
                       } else if (selectedPlans.length < 3) {
                         setSelectedPlans([...selectedPlans, plan])
                       }
                     }}
                     darkMode={darkMode}
                   />
                 ))}
               </div>
             </div>
             
             {selectedPlans.length > 0 && (
               <div className="comparison-table">
                 <h4>Comparison</h4>
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
                     <tr>
                       <td>Features</td>
                       {selectedPlans.map(plan => (
                         <td key={plan.id}>
                           <ul>
                             {plan.features.split(', ').map((feature, index) => (
                               <li key={index}>{feature}</li>
                             ))}
                           </ul>
                         </td>
                       ))}
                     </tr>
                   </tbody>
                 </table>
               </div>
             )}
           </div>
         )}

         {activeTab === 'renewals' && (
           <div className="renewals-section">
             <EmptyState
               icon="🔄"
               title="Policy Renewals"
               description="Manage your policy renewals and automatic payments here."
               buttonText="Set Up Renewals"
               onButtonClick={() => setShowRenewalModal(true)}
               darkMode={darkMode}
             />
           </div>
         )}
       </div>

       {/* Application Modals */}
       <PolicyApplicationModal
         open={showPolicyApplicationModal}
         onClose={() => setShowPolicyApplicationModal(false)}
         onSuccess={refreshInsuranceData}
         darkMode={darkMode}
         plans={insurancePlans}
       />

       <ClaimApplicationModal
         open={showClaimApplicationModal}
         onClose={() => setShowClaimApplicationModal(false)}
         onSuccess={refreshInsuranceData}
         darkMode={darkMode}
         policies={policies}
       />

       <ClaimApprovalModal
         open={showClaimApprovalModal}
         onClose={() => setShowClaimApprovalModal(false)}
         onSuccess={refreshInsuranceData}
         darkMode={darkMode}
         claim={selectedClaim}
       />

       <MedicalRecordsModal
         open={showMedicalRecordsModal}
         onClose={() => setShowMedicalRecordsModal(false)}
         onSuccess={refreshInsuranceData}
         darkMode={darkMode}
         playerId={selectedPlayer?.id}
         playerName={selectedPlayer?.name}
       />

       <InsurancePlansModal
         open={showPlansModal}
         onClose={() => setShowPlansModal(false)}
         onSuccess={(result) => {
           // Refresh plans after creating a new one
           callNui('getInsurancePlans', {}, (result) => {
             if (result && result.plans) {
               setInsurancePlans(result.plans || [])
             }
           })
         }}
         darkMode={darkMode}
         plans={insurancePlans}
       />

       {showPolicyDetails && selectedPolicy && (
         <PolicyDetailsModal 
           policy={selectedPolicy}
           onClose={() => {
             setShowPolicyDetails(false)
             setSelectedPolicy(null)
           }}
           darkMode={darkMode}
         />
       )}

       {showRenewalModal && selectedPolicy && (
         <PolicyRenewalModal
           policy={selectedPolicy}
           onClose={() => {
             setShowRenewalModal(false)
             setSelectedPolicy(null)
           }}
           onRenew={(renewalData) => {
             // Handle renewal
             setShowRenewalModal(false)
             setSelectedPolicy(null)
           }}
           darkMode={darkMode}
         />
       )}
     </div>
   )
 }

 // Helper function for currency formatting
 function formatCurrency(amount) {
   return new Intl.NumberFormat('en-US', {
     style: 'currency',
     currency: 'USD'
   }).format(amount)
 }