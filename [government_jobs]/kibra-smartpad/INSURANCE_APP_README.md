# Enhanced Insurance App Setup Instructions

## 🚀 Overview
A comprehensive health insurance management app for the Kibra SmartPad system with modern interface design matching the news app style. Features include policy management, claims processing, plan comparison, and automatic renewals.

## 📋 Features Implemented

### ✅ Core Features
- **Policy Management**: Create, view, and manage insurance policies
- **Claims Processing**: Submit and track insurance claims
- **Medical History**: View medical records (ready for integration)
- **Database Integration**: Full MySQL database with proper indexing
- **Real-time Updates**: Automatic data refresh after operations

### 🆕 Enhanced Features
- **Insurance Plans**: Predefined plans for each category (Basic, Premium, Family, Emergency)
- **Plan Comparison**: Compare up to 3 insurance plans side-by-side
- **Policy Renewals**: Automatic renewal system with notifications
- **Search & Filter**: Advanced search and category filtering
- **Modern UI**: News app-style interface with dark/light themes
- **Provider Management**: Multiple insurance provider support

## 🗄️ Database Setup

### Automatic Setup
The database tables and sample data are automatically created when the resource starts via `resource/smartpad/auto.lua`. No manual setup required!

**Tables Created:**
- `kibra_smartpad_health_insurance` - Policy storage
- `kibra_smartpad_insurance_claims` - Claim storage  
- `kibra_smartpad_medical_history` - Medical records
- `kibra_smartpad_insurance_plans` - Available plans (12 predefined plans)
- `kibra_smartpad_insurance_providers` - Provider info (3 sample providers)
- `kibra_smartpad_policy_renewals` - Renewal tracking

**Sample Data Included:**
- 12 insurance plans across 4 categories
- 3 insurance providers
- All tables with proper indexing and foreign keys

## 📊 Insurance Plans Available

### Basic Plans
- **Basic Health Plus**: $150/month - $50,000 coverage
- **Basic Family Care**: $250/month - $75,000 coverage  
- **Basic Emergency**: $100/month - $25,000 coverage

### Premium Plans
- **Premium Health Elite**: $350/month - $150,000 coverage
- **Premium Family Gold**: $500/month - $200,000 coverage
- **Premium Executive**: $750/month - $500,000 coverage

### Family Plans
- **Family Health Plus**: $400/month - $100,000 coverage
- **Family Wellness**: $600/month - $150,000 coverage
- **Family Protection**: $800/month - $250,000 coverage

### Emergency Plans
- **Emergency Response**: $75/month - $50,000 coverage
- **Emergency Plus**: $120/month - $100,000 coverage
- **Emergency Premium**: $200/month - $200,000 coverage

## 🎨 Interface Features

### Modern Design
- **News App Style**: Matches the WeazelNews app interface
- **Responsive Layout**: Works on all screen sizes
- **Dark/Light Themes**: Automatic theme switching
- **Smooth Animations**: Hover effects and transitions
- **Search & Filter**: Real-time search and category filtering

### User Experience
- **Intuitive Navigation**: Clear tabs and categories
- **Visual Feedback**: Status indicators and progress tracking
- **Modal Interfaces**: Clean, modern modal forms
- **Empty States**: Helpful guidance when no data exists

## 🔧 Technical Implementation

### Frontend (React.js)
- **Component Structure**: Modular, reusable components
- **State Management**: React hooks for local state
- **Event Handling**: Proper event propagation control
- **Form Validation**: Client-side validation with error handling

### Backend (FiveM Lua)
- **Server Callbacks**: 8 new server-side callbacks
- **Client Callbacks**: 8 new client-side NUI callbacks
- **Database Operations**: Full CRUD operations with proper error handling
- **Data Validation**: Server-side validation and sanitization

### Database (MySQL)
- **6 Tables**: Complete insurance management system
- **Proper Indexing**: Optimized for performance
- **Foreign Keys**: Data integrity constraints
- **Audit Trail**: Creation and update timestamps

## 📱 Usage Guide

### For Players

1. **Open Insurance App**
   - Access from tablet menu
   - App icon: Blue shield with medical cross

2. **Create a Policy**
   - Click "New Policy" → "View Plans"
   - Select from available plans
   - Fill in dates and emergency contacts
   - Submit to create policy

3. **Submit Claims**
   - Click "New Claim"
   - Select existing policy
   - Enter claim details and amount
   - Submit for processing

4. **Compare Plans**
   - Click "Compare" button
   - Select up to 3 plans
   - View side-by-side comparison
   - Choose best option

5. **Manage Renewals**
   - Click "Renewals" tab
   - Set up automatic renewals
   - Track renewal history

### For Administrators

1. **Database Management**
   - Monitor policy creation and claims
   - Review renewal requests
   - Manage insurance providers

2. **Plan Management**
   - Add new insurance plans
   - Modify existing plan details
   - Set plan availability

3. **Provider Management**
   - Add new insurance providers
   - Update provider information
   - Manage provider relationships

## 🔄 API Endpoints

### Server Callbacks
- `Kibra:SmartPad:CreateInsurancePolicy` - Create new policy
- `Kibra:SmartPad:CreateInsuranceClaim` - Submit new claim
- `Kibra:SmartPad:GetInsuranceData` - Retrieve all data
- `Kibra:SmartPad:GetInsurancePlans` - Get available plans
- `Kibra:SmartPad:GetInsuranceProviders` - Get providers
- `Kibra:SmartPad:RenewInsurancePolicy` - Renew policy
- `Kibra:SmartPad:GetPolicyRenewals` - Get renewal history

### Client Callbacks
- `createInsurancePolicy` - Frontend policy creation
- `createInsuranceClaim` - Frontend claim submission
- `getInsuranceData` - Frontend data retrieval
- `getInsurancePlans` - Frontend plan loading
- `getInsuranceProviders` - Frontend provider loading
- `renewInsurancePolicy` - Frontend policy renewal
- `getPolicyRenewals` - Frontend renewal history

## 🛠️ Troubleshooting

### Common Issues

1. **App Not Loading**
   - Check if database tables exist
   - Verify server callbacks are registered
   - Check browser console for errors

2. **Buttons Not Working**
   - Ensure insurance app is properly loaded
   - Check for JavaScript errors in console
   - Verify NUI callbacks are registered

3. **Data Not Saving**
   - Check MySQL connection
   - Verify table structure matches schema
   - Check server logs for database errors

4. **Icon Not Showing**
   - Ensure `insurance.png` exists in appicons folder
   - Check file permissions
   - Verify app configuration in `shared/apps.lua`

### Debug Steps

1. **Check Console Logs**
   ```javascript
   // Open browser console (F12)
   // Look for JavaScript errors
   ```

2. **Verify Database**
   ```sql
   -- Check if tables exist
   SHOW TABLES LIKE 'kibra_smartpad%';
   
   -- Check if plans are loaded
   SELECT * FROM kibra_smartpad_insurance_plans;
   ```

3. **Test Callbacks**
   ```lua
   -- In server console
   -- Check if callbacks are registered
   ```

## 🎯 Future Enhancements

### Planned Features
1. **Automatic Premium Deduction**: Monthly payment processing
2. **Medical Integration**: Hospital/EMS system integration
3. **Family Management**: Add family members to policies
4. **Claim Processing**: Admin interface for claim approval
5. **Notifications**: Email/SMS notifications for renewals
6. **Analytics**: Policy and claim statistics
7. **Mobile App**: Standalone mobile application

### Integration Opportunities
- **Hospital Systems**: Automatic medical record updates
- **Banking Systems**: Automatic premium payments
- **Government Systems**: Policy registration and verification
- **Emergency Services**: Real-time coverage verification

## 📞 Support

For technical support or questions:
1. Check this README for troubleshooting steps
2. Review server logs for error messages
3. Verify database connectivity and table structure
4. Test individual components for functionality

## 📄 Files Modified/Created

### New Files
- `web/src/InsuranceApp/main.jsx` - Enhanced main component
- `web/src/InsuranceApp/main.css` - Modern styling
- `create_insurance_icon.html` - Icon generator
- `web/public/appicons/insurance.svg` - SVG insurance icon

### Modified Files
- `resource/smartpad/auto.lua` - Added insurance tables and sample data
- `resource/callbacks/server.lua` - Added 8 new callbacks
- `resource/callbacks/client.lua` - Added 8 new callbacks
- `shared/apps.lua` - Insurance app configuration

### Database Tables (Auto-Created)
- `kibra_smartpad_health_insurance` - Policy storage
- `kibra_smartpad_insurance_claims` - Claim storage
- `kibra_smartpad_medical_history` - Medical records
- `kibra_smartpad_insurance_plans` - Available plans
- `kibra_smartpad_insurance_providers` - Provider info
- `kibra_smartpad_policy_renewals` - Renewal tracking

---

**🎉 The Enhanced Insurance App is now ready for use!**

### Quick Setup:
1. **Restart the resource** - Tables and data will be auto-created
2. **Create insurance icon** - Use the provided HTML generator
3. **Test the app** - All features are ready to use!

The database setup is now fully automated through `auto.lua` - no manual SQL commands needed!
