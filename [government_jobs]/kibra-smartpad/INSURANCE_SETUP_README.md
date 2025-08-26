# Insurance App Setup Guide

## Overview
The Health Insurance app in Kibra SmartPad allows players to manage their health insurance policies, file claims, and view medical history.

## Database Setup

### 1. Create Required Tables
Run the following SQL commands in your database to create the necessary tables:

```sql
-- Health Insurance Policies Table
CREATE TABLE IF NOT EXISTS `kibra_smartpad_health_insurance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizen_id` varchar(50) NOT NULL,
  `citizen_name` varchar(100) NOT NULL,
  `insurance_type` varchar(50) NOT NULL,
  `policy_number` varchar(50) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `monthly_premium` decimal(10,2) NOT NULL,
  `coverage_amount` decimal(10,2) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'Active',
  `emergency_contact` varchar(100) DEFAULT NULL,
  `emergency_phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `citizen_id` (`citizen_id`),
  KEY `policy_number` (`policy_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insurance Claims Table
CREATE TABLE IF NOT EXISTS `kibra_smartpad_insurance_claims` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizen_id` varchar(50) NOT NULL,
  `policy_number` varchar(50) NOT NULL,
  `claim_number` varchar(50) NOT NULL,
  `date` date NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` text NOT NULL,
  `notes` text DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `citizen_id` (`citizen_id`),
  KEY `policy_number` (`policy_number`),
  KEY `claim_number` (`claim_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Medical History Table
CREATE TABLE IF NOT EXISTS `kibra_smartpad_medical_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizen_id` varchar(50) NOT NULL,
  `condition` varchar(100) NOT NULL,
  `diagnosis` text NOT NULL,
  `treatment` text NOT NULL,
  `doctor` varchar(100) NOT NULL,
  `date` date NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `citizen_id` (`citizen_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 2. Import SQL File
Alternatively, you can import the `insurance_tables.sql` file directly into your database.

## Features

### Insurance Policies
- Create new insurance policies with different types (Basic, Premium, Family, Emergency)
- Set coverage amounts and monthly premiums
- Add emergency contact information
- View policy status and expiration dates

### Insurance Claims
- File claims against existing policies
- Track claim status (Pending, Approved, Rejected)
- Add detailed descriptions and notes
- View claim history

### Medical History
- View medical records and treatment history
- Track conditions, diagnoses, and treatments
- See doctor information and dates

## Troubleshooting

### Buttons Not Working
If the buttons in the Insurance app are not working:

1. **Check Database Tables**: Ensure all three tables are created in your database
2. **Check Console**: Open browser console (F12) and look for any JavaScript errors
3. **Refresh Data**: Use the "Refresh" button in the app to reload insurance data
4. **Check Server Logs**: Look for any server-side errors in your FiveM console

### Data Not Loading
If insurance data is not loading:

1. **Verify Database Connection**: Ensure your database connection is working
2. **Check Player Data**: Make sure the player has a valid citizen ID
3. **Restart Resource**: Try restarting the kibra-smartpad resource
4. **Check INSURANCEDATABASE**: Verify the server-side database is being populated

### Common Issues

1. **Empty Insurance Data**: This usually means the database tables don't exist or are empty
2. **Callback Errors**: Check that all NUI callbacks are properly registered
3. **Permission Issues**: Ensure the player has access to the insurance app

## API Endpoints

The insurance system uses the following server callbacks:

- `Kibra:SmartPad:CreateInsurancePolicy` - Create new insurance policy
- `Kibra:SmartPad:CreateInsuranceClaim` - File new insurance claim
- `Kibra:SmartPad:GetInsuranceData` - Get player's insurance data

## Support

If you continue to have issues:

1. Check the FiveM console for error messages
2. Verify all database tables exist and have the correct structure
3. Ensure the player has a valid citizen ID in your framework
4. Check that the insurance app is enabled in your tablet configuration
