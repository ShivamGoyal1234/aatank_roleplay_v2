# Insurance System Setup Guide

## Overview
The Insurance System for Kibra SmartPad provides comprehensive health insurance management functionality including:
- Policy creation and management
- Insurance claims processing
- Medical records management
- Insurance plans management
- Transaction history
- Policy renewals

## Database Setup

### 1. Run the SQL Setup
Execute the `insurance_database_setup.sql` file in your MySQL database to create all necessary tables:

```sql
-- Run this in your MySQL database
source insurance_database_setup.sql;
```

This will create the following tables:
- `kibra_smartpad_health_insurance` - Insurance policies
- `kibra_smartpad_insurance_claims` - Insurance claims
- `kibra_smartpad_medical_records` - Medical records
- `kibra_smartpad_insurance_plans` - Available insurance plans
- `kibra_smartpad_insurance_providers` - Insurance providers
- `kibra_smartpad_insurance_transactions` - Transaction history
- `kibra_smartpad_policy_renewals` - Policy renewal records
- `kibra_smartpad_medical_history` - Patient medical history

### 2. Sample Data
The setup script includes sample insurance plans and providers to get you started.

## Features

### 1. Add Medical Records
**How to use:**
1. Navigate to the "Medical Records" tab in the Insurance App
2. Enter a player ID or name in the search field
3. Click "Search" to find the player's medical records
4. Click "Add Record" to create a new medical record
5. Fill in the required fields:
   - Medical Condition
   - Diagnosis
   - Treatment
   - Doctor Name
   - Severity (Low/Medium/High/Critical)
   - Additional Notes (optional)
6. Click "Create Medical Record"

**Fixed Issues:**
- ✅ Add Record button now works properly
- ✅ Button is enabled when a player is selected
- ✅ Proper form validation
- ✅ Database storage and retrieval
- ✅ Success/error notifications

### 2. Add Insurance Plans
**How to use:**
1. Navigate to the "View Plans" tab in the Insurance App
2. Click the "Add Plan" button
3. Fill in the required fields:
   - Plan Name
   - Category (Basic/Premium/Family/Emergency)
   - Monthly Premium
   - Coverage Amount
   - Description (optional)
   - Features (comma-separated)
   - Deductible (optional)
   - Max Claims per Year (optional)
4. Click "Create Plan"

**Fixed Issues:**
- ✅ Add Plan button now works properly
- ✅ Complete form interface for creating new plans
- ✅ Database storage and retrieval
- ✅ Plan listing and management
- ✅ Success/error notifications

### 3. Policy Management
- Create new insurance policies
- View existing policies
- Process policy renewals
- Track policy status

### 4. Claims Processing
- File new insurance claims
- Approve/reject claims
- Track claim status
- Process claim payouts

### 5. Medical Records Management
- Search patient medical records
- Add new medical records
- View medical history
- Track treatment progress

## Technical Implementation

### Frontend Components
- `InsuranceApp/main.jsx` - Main insurance application
- `InsuranceApp/components/MedicalRecordsModal.jsx` - Medical record creation modal
- `InsuranceApp/components/InsurancePlansModal.jsx` - Insurance plan management modal
- `InsuranceApp/components/MedicalRecordsViewer.jsx` - Medical records viewer

### Backend Callbacks
- `Kibra:SmartPad:CreateMedicalRecord` - Create medical records
- `Kibra:SmartPad:CreateInsurancePlan` - Create insurance plans
- `Kibra:SmartPad:GetMedicalRecords` - Retrieve medical records
- `Kibra:SmartPad:GetInsurancePlans` - Retrieve insurance plans
- `Kibra:SmartPad:GetInsuranceData` - Get all insurance data

### Database Tables
All tables use proper indexing and foreign key relationships for optimal performance.

## Usage Examples

### Creating a Medical Record
```javascript
// Frontend call
callNui('createMedicalRecord', {
  player_id: '12345',
  player_name: 'John Doe',
  condition: 'Hypertension',
  diagnosis: 'High blood pressure detected during routine checkup',
  treatment: 'Prescribed Lisinopril 10mg daily',
  doctor: 'Dr. Smith',
  notes: 'Patient advised to monitor blood pressure regularly',
  severity: 'Medium'
}, (result) => {
  if (result.success) {
    console.log('Medical record created successfully');
  }
});
```

### Creating an Insurance Plan
```javascript
// Frontend call
callNui('createInsurancePlan', {
  plan_name: 'Premium Health Elite',
  category: 'Premium',
  monthly_premium: 350.00,
  coverage_amount: 150000.00,
  description: 'Comprehensive health coverage',
  features: 'All doctor visits, Specialist consultations, Surgery coverage, Mental health',
  deductible: 250.00,
  max_claims_per_year: 25
}, (result) => {
  if (result.success) {
    console.log('Insurance plan created successfully');
  }
});
```

## Permissions
Currently, all users have full access to create medical records and insurance plans. You can modify the permission checks in the server callbacks to restrict access based on job roles or other criteria.

## Troubleshooting

### Common Issues
1. **"Add Record" button not working**
   - Make sure you've searched for a player first
   - Check that the player ID is valid
   - Ensure the database tables are created

2. **"Add Plan" button not working**
   - Check that the InsurancePlansModal is properly imported
   - Verify the database connection
   - Check server logs for errors

3. **Database errors**
   - Run the SQL setup script
   - Check MySQL connection settings
   - Verify table permissions

### Debug Mode
Enable debug logging by checking the server console for callback errors and the browser console for frontend errors.

## Future Enhancements
- Role-based permissions for medical staff
- Advanced search and filtering
- Medical record templates
- Insurance plan comparison tools
- Automated claim processing
- Integration with hospital systems

## Support
For issues or questions, check the server logs and browser console for error messages. The system includes comprehensive error handling and user feedback.
