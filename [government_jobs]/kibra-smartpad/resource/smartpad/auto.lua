Resmon = exports["0r_lib"]:GetCoreObject()


MySQL.ready(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_tablets (
            id INT(11) NOT NULL AUTO_INCREMENT,
            serialnumber TEXT NOT NULL DEFAULT '1123',
            owner VARCHAR(255) DEFAULT NULL,
            data LONGTEXT NOT NULL DEFAULT '[]',
            notifications LONGTEXT NOT NULL DEFAULT '[]',
            gallery LONGTEXT NOT NULL DEFAULT '[]',
            albums TEXT NOT NULL DEFAULT '[]',
            email TEXT NOT NULL,
            PRIMARY KEY (id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_allergies (
            id INT(11) NOT NULL AUTO_INCREMENT,
            citizen_id VARCHAR(64) DEFAULT NULL,
            drug_name VARCHAR(100) DEFAULT NULL,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_crime_records (
            id INT(11) NOT NULL AUTO_INCREMENT,
            offenders LONGTEXT NOT NULL DEFAULT '[]',
            crime_id TEXT NOT NULL,
            date TEXT NOT NULL,
            officer_name VARCHAR(100) NOT NULL,
            officer_id VARCHAR(50) DEFAULT NULL,
            articles TEXT NOT NULL,
            description TEXT DEFAULT NULL,
            location VARCHAR(255) DEFAULT NULL,
            fine_amount INT(11) DEFAULT 0,
            jail_time INT(11) DEFAULT 0,
            created_at VARCHAR(255) NOT NULL,
            media LONGTEXT NOT NULL DEFAULT '[]',
            witnesses TEXT NOT NULL,
            vehicle_data LONGTEXT NOT NULL DEFAULT '[]',
            status INT(11) NOT NULL DEFAULT 0,
            approved_by TEXT NOT NULL,
            reason TEXT DEFAULT NULL,
            casedate TEXT NOT NULL,
            lawyer TEXT NOT NULL,
            timeline TEXT NOT NULL DEFAULT '[]',
            PRIMARY KEY (id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_newsapplications (
            id INT(11) NOT NULL AUTO_INCREMENT,
            name TEXT NOT NULL,
            age INT(11) NOT NULL,
            role TEXT NOT NULL,
            experience TEXT NOT NULL,
            motivation TEXT NOT NULL,
            cid VARCHAR(255) NOT NULL,
            PRIMARY KEY (id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
    ]])


    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_news (
            id INT(11) NOT NULL AUTO_INCREMENT,
            code TEXT NOT NULL,
            data TEXT NOT NULL DEFAULT '[]',
            author TEXT NOT NULL DEFAULT '[]',
            media TEXT NOT NULL DEFAULT '[]',
            category TEXT NOT NULL,
            tags TEXT NOT NULL,
            status INT(11) NOT NULL,
            timestamp FLOAT NOT NULL DEFAULT 0,
            comments TEXT NOT NULL DEFAULT '[]',
            likes FLOAT NOT NULL DEFAULT 0,
            PRIMARY KEY (id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci AUTO_INCREMENT=5;
    ]])


    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_court_hearings (
            id INT(11) NOT NULL AUTO_INCREMENT,
            case_id VARCHAR(50) NOT NULL,
            date DATE NOT NULL,
            time TIME NOT NULL,
            assigned_judge VARCHAR(100) NOT NULL,
            courtroom TEXT NOT NULL DEFAULT '[]',
            notes TEXT DEFAULT NULL,
            created_at TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP),
            PRIMARY KEY (id)
        )
    ]])



    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_doctor_notes (
            id INT(11) NOT NULL AUTO_INCREMENT,
            citizen_id VARCHAR(64) DEFAULT NULL,
            doctor_name VARCHAR(100) DEFAULT NULL,
            note TEXT DEFAULT NULL,
            created_at TEXT DEFAULT NULL,
            PRIMARY KEY (id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_invoices (
            id INT(11) NOT NULL AUTO_INCREMENT,
            ikey TEXT NOT NULL,
            owner VARCHAR(255) NOT NULL,
            date TEXT NOT NULL,
            duedate TEXT NOT NULL,
            content TEXT NOT NULL DEFAULT '[]',
            totalamount FLOAT NOT NULL DEFAULT 0,
            status INT(11) NOT NULL DEFAULT 0,
            notes LONGTEXT NOT NULL,
            job TEXT NOT NULL,
            PRIMARY KEY (id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_mails (
            id INT(11) NOT NULL AUTO_INCREMENT,
            receiver TEXT NOT NULL,
            from_name TEXT NOT NULL,
            data LONGTEXT NOT NULL DEFAULT '[]',
            `from` TEXT NOT NULL,
            type INT(11) NOT NULL DEFAULT 0,
            date TEXT NOT NULL,
            PRIMARY KEY (id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_mdt_announcements (
            id INT(11) NOT NULL AUTO_INCREMENT,
            title VARCHAR(100) NOT NULL,
            message TEXT NOT NULL,
            announcement_type ENUM('General','Emergency','Warning','Info') DEFAULT 'General',
            created_at TEXT NOT NULL,
            created_by VARCHAR(100) NOT NULL,
            PRIMARY KEY (id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_mdt_history (
            id INT(11) NOT NULL AUTO_INCREMENT,
            created_by VARCHAR(255) NOT NULL,
            transaction TEXT NOT NULL,
            casenumber TEXT NOT NULL,
            date TEXT NOT NULL,
            PRIMARY KEY (id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_treatments (
            id INT(11) NOT NULL AUTO_INCREMENT,
            patient_id VARCHAR(64) DEFAULT NULL,
            drug VARCHAR(100) DEFAULT NULL,
            responsible VARCHAR(100) DEFAULT NULL,
            date VARCHAR(100) DEFAULT NULL,
            PRIMARY KEY (id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_vehicle_crimes (
            id INT(11) NOT NULL AUTO_INCREMENT,
            case_id VARCHAR(255) NOT NULL,
            cars LONGTEXT NOT NULL DEFAULT '[]',
            dname VARCHAR(255) NOT NULL,
            fine_amount FLOAT NOT NULL DEFAULT 0,
            crimes LONGTEXT NOT NULL DEFAULT '[]',
            date TEXT NOT NULL,
            location VARCHAR(255) DEFAULT NULL,
            officer_id VARCHAR(50) DEFAULT NULL,
            officer_name VARCHAR(100) DEFAULT NULL,
            notes TEXT DEFAULT NULL,
            media LONGTEXT DEFAULT NULL,
            vehicle_data LONGTEXT NOT NULL DEFAULT '[]',
            PRIMARY KEY (id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_wanted_people (
            id INT(11) NOT NULL AUTO_INCREMENT,
            cid TEXT NOT NULL,
            first_name VARCHAR(50) NOT NULL,
            last_name VARCHAR(50) NOT NULL,
            crime_description TEXT NOT NULL,
            wanted_since TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
            last_seen_location VARCHAR(255) DEFAULT NULL,
            danger_level ENUM('Low','Medium','High') DEFAULT 'Low',
            added_by VARCHAR(100) NOT NULL,
            medias TEXT NOT NULL DEFAULT '[]',
            PRIMARY KEY (id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_wanted_vehicles (
            id INT(11) NOT NULL AUTO_INCREMENT,
            plate VARCHAR(10) NOT NULL,
            model VARCHAR(100) NOT NULL,
            modellabel VARCHAR(255) NOT NULL,
            color VARCHAR(50) DEFAULT NULL,
            last_seen_location VARCHAR(255) DEFAULT NULL,
            wanted_since TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
            danger_level ENUM('Low','Medium','High') DEFAULT 'Low',
            reason TEXT NOT NULL,
            added_by VARCHAR(100) NOT NULL,
            medias TEXT NOT NULL DEFAULT '[]',
            status INT(11) DEFAULT 1,
            approved_by TEXT NOT NULL,
            PRIMARY KEY (id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_weapon_licenses (
            id INT(11) NOT NULL AUTO_INCREMENT,
            citizen_id TEXT NOT NULL,
            playername VARCHAR(50) NOT NULL,
            dob DATE NOT NULL,
            license_number VARCHAR(50) NOT NULL,
            weapon_type VARCHAR(100) NOT NULL,
            expiration_date DATE NOT NULL,
            status ENUM('Active','Suspended','Revoked') DEFAULT 'Active',
            issued_by VARCHAR(100) NOT NULL,
            PRIMARY KEY (id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_resmoncloud (
            id INT(11) NOT NULL AUTO_INCREMENT,
            devices TEXT NOT NULL DEFAULT '[]',
            owner TEXT NOT NULL,
            firstname TEXT NOT NULL,
            lastname TEXT NOT NULL,
            birthdate TEXT NOT NULL,
            password TEXT NOT NULL,
            mail VARCHAR(255) NOT NULL,
            PRIMARY KEY (id)
        )
    ]])

    -- Enhanced Insurance Tables
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_health_insurance (
            id INT(11) NOT NULL AUTO_INCREMENT,
            citizen_id VARCHAR(64) NOT NULL,
            citizen_name VARCHAR(100) NOT NULL,
            insurance_type ENUM('Basic', 'Premium', 'Family', 'Emergency') DEFAULT 'Basic',
            policy_number VARCHAR(50) UNIQUE NOT NULL,
            start_date DATE NOT NULL,
            end_date DATE NOT NULL,
            monthly_premium FLOAT NOT NULL DEFAULT 0,
            coverage_amount FLOAT NOT NULL DEFAULT 0,
            status ENUM('Active', 'Expired', 'Cancelled', 'Pending') DEFAULT 'Active',
            emergency_contact VARCHAR(100) DEFAULT NULL,
            emergency_phone VARCHAR(20) DEFAULT NULL,
            medical_history LONGTEXT DEFAULT '[]',
            claims_history LONGTEXT DEFAULT '[]',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_insurance_claims (
            id INT(11) NOT NULL AUTO_INCREMENT,
            citizen_id VARCHAR(64) NOT NULL,
            policy_number VARCHAR(50) NOT NULL,
            claim_number VARCHAR(50) UNIQUE NOT NULL,
            date DATE NOT NULL,
            amount FLOAT NOT NULL DEFAULT 0,
            description TEXT NOT NULL,
            notes TEXT DEFAULT NULL,
            status ENUM('Pending', 'Approved', 'Rejected', 'Processing') DEFAULT 'Pending',
            approved_amount DECIMAL(10,2) DEFAULT NULL,
            approved_by VARCHAR(100) DEFAULT NULL,
            approved_date TIMESTAMP NULL DEFAULT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id)
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_medical_history (
            id INT(11) NOT NULL AUTO_INCREMENT,
            citizen_id VARCHAR(64) NOT NULL,
            condition_name VARCHAR(100) NOT NULL,
            diagnosis TEXT NOT NULL,
            treatment TEXT NOT NULL,
            doctor VARCHAR(100) NOT NULL,
            date DATE NOT NULL,
            notes TEXT DEFAULT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id)
        )
    ]])

    -- New Insurance Tables
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_insurance_plans (
            id INT(11) NOT NULL AUTO_INCREMENT,
            plan_name VARCHAR(100) NOT NULL,
            category VARCHAR(50) NOT NULL,
            monthly_premium DECIMAL(10,2) NOT NULL,
            coverage_amount DECIMAL(10,2) NOT NULL,
            description TEXT NOT NULL,
            features TEXT NOT NULL,
            deductible DECIMAL(10,2) NOT NULL,
            max_claims_per_year INT(11) NOT NULL,
            is_active TINYINT(1) NOT NULL DEFAULT 1,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY category (category),
            KEY is_active (is_active)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_insurance_providers (
            id INT(11) NOT NULL AUTO_INCREMENT,
            provider_name VARCHAR(100) NOT NULL,
            provider_code VARCHAR(20) NOT NULL,
            contact_email VARCHAR(100) DEFAULT NULL,
            contact_phone VARCHAR(20) DEFAULT NULL,
            address TEXT DEFAULT NULL,
            is_active TINYINT(1) NOT NULL DEFAULT 1,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY provider_code (provider_code)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_policy_renewals (
            id INT(11) NOT NULL AUTO_INCREMENT,
            policy_id INT(11) NOT NULL,
            renewal_date DATE NOT NULL,
            new_end_date DATE NOT NULL,
            renewal_amount DECIMAL(10,2) NOT NULL,
            status VARCHAR(20) NOT NULL DEFAULT 'Pending',
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY policy_id (policy_id),
            FOREIGN KEY (policy_id) REFERENCES kibra_smartpad_health_insurance (id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])

    -- Insert Sample Insurance Plans
    -- MySQL.query([[
    --     INSERT IGNORE INTO kibra_smartpad_insurance_plans 
    --     (plan_name, category, monthly_premium, coverage_amount, description, features, deductible, max_claims_per_year) VALUES
    --     ('Basic Health Plus', 'Basic', 150.00, 50000.00, 'Essential health coverage for individuals', 'Emergency room visits, Basic doctor visits, Prescription drugs', 500.00, 10),
    --     ('Basic Family Care', 'Basic', 250.00, 75000.00, 'Basic family health insurance', 'Family doctor visits, Emergency care, Basic dental', 750.00, 15),
    --     ('Basic Emergency', 'Basic', 100.00, 25000.00, 'Emergency-only coverage', 'Emergency room visits, Ambulance services, Urgent care', 1000.00, 5),
    --     ('Premium Health Elite', 'Premium', 350.00, 150000.00, 'Comprehensive health coverage', 'All doctor visits, Specialist consultations, Surgery coverage, Mental health', 250.00, 25),
    --     ('Premium Family Gold', 'Premium', 500.00, 200000.00, 'Premium family coverage', 'Family health, Dental, Vision, Mental health, Alternative medicine', 300.00, 30),
    --     ('Premium Executive', 'Premium', 750.00, 500000.00, 'Executive-level health coverage', 'VIP treatment, Private rooms, International coverage, Concierge service', 100.00, 50),
    --     ('Family Health Plus', 'Family', 400.00, 100000.00, 'Complete family health coverage', 'Family doctor, Pediatric care, Maternity coverage, Dental', 400.00, 20),
    --     ('Family Wellness', 'Family', 600.00, 150000.00, 'Comprehensive family wellness', 'Preventive care, Vaccinations, Health screenings, Mental health', 300.00, 25),
    --     ('Family Protection', 'Family', 800.00, 250000.00, 'Maximum family protection', 'All medical services, Dental, Vision, Alternative therapy', 200.00, 35),
    --     ('Emergency Response', 'Emergency', 75.00, 50000.00, 'Emergency medical coverage', 'Emergency room, Ambulance, Urgent care, Trauma care', 500.00, 10),
    --     ('Emergency Plus', 'Emergency', 120.00, 100000.00, 'Extended emergency coverage', 'Emergency care, Surgery, Hospital stays, Follow-up care', 300.00, 15),
    --     ('Emergency Premium', 'Emergency', 200.00, 200000.00, 'Premium emergency protection', 'All emergency services, Air ambulance, International coverage', 100.00, 20)
    -- ]])

    -- Insert Sample Insurance Providers
    MySQL.query([[
        INSERT IGNORE INTO kibra_smartpad_insurance_providers 
        (provider_name, provider_code, contact_email, contact_phone, address) VALUES
        ('HealthFirst Insurance', 'HFI001', 'contact@healthfirst.com', '555-0100', '123 Health St, Los Santos'),
        ('MediCare Plus', 'MCP002', 'info@medicareplus.com', '555-0200', '456 Medical Ave, Los Santos'),
        ('Family Health Group', 'FHG003', 'support@familyhealth.com', '555-0300', '789 Family Blvd, Los Santos')
    ]])

    -- Insurance Transactions Table
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_insurance_transactions (
            id INT(11) NOT NULL AUTO_INCREMENT,
            transaction_id VARCHAR(50) NOT NULL,
            policy_number VARCHAR(50) NOT NULL,
            type VARCHAR(50) NOT NULL,
            amount DECIMAL(10,2) NOT NULL,
            description TEXT NOT NULL,
            status VARCHAR(20) NOT NULL DEFAULT 'Completed',
            date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY transaction_id (transaction_id),
            KEY policy_number (policy_number),
            KEY type (type),
            KEY status (status)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])

    -- Enhanced Medical History Table
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS kibra_smartpad_medical_records (
            id INT(11) NOT NULL AUTO_INCREMENT,
            citizen_id VARCHAR(64) NOT NULL,
            player_name VARCHAR(100) NOT NULL,
            `condition` VARCHAR(100) NOT NULL,
            diagnosis TEXT NOT NULL,
            treatment TEXT NOT NULL,
            doctor VARCHAR(100) NOT NULL,
            notes TEXT DEFAULT NULL,
            severity ENUM('Low', 'Medium', 'High', 'Critical') DEFAULT 'Low',
            status VARCHAR(20) NOT NULL DEFAULT 'Active',
            date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY citizen_id (citizen_id),
            KEY severity (severity),
            KEY status (status)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])

    -- Insert Sample Transactions
    MySQL.query([[
        INSERT IGNORE INTO kibra_smartpad_insurance_transactions 
        (transaction_id, policy_number, type, amount, description, status) VALUES
        ('TXN-001', 'POL-ABC123', 'Premium Payment', -150.00, 'Monthly premium payment for Basic Health Plus', 'Completed'),
        ('TXN-002', 'POL-ABC123', 'Claim Payout', 2500.00, 'Claim payout for medical expenses', 'Completed'),
        ('TXN-003', 'POL-DEF456', 'Premium Payment', -350.00, 'Monthly premium payment for Premium Health Elite', 'Completed'),
        ('TXN-004', 'POL-GHI789', 'Policy Refund', 200.00, 'Refund for cancelled policy', 'Completed'),
        ('TXN-005', 'POL-JKL012', 'Late Fee', -25.00, 'Late payment fee', 'Completed')
    ]])
end)
