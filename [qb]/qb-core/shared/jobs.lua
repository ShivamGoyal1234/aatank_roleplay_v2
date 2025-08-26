QBShared = QBShared or {}
QBShared.ForceJobDefaultDutyAtLogin = true -- true: Force duty state to jobdefaultDuty | false: set duty state from database last saved
QBShared.Jobs = {
	unemployed = { label = 'Civilian', defaultDuty = true, offDutyPay = true, grades = { ['0'] = { name = 'Freelancer', payment = 10 } } },
	bus = { label = 'Bus', defaultDuty = true, offDutyPay = true, grades = { ['0'] = { name = 'Driver', payment = 50 } } },
	judge = { label = 'Honorary', defaultDuty = true, offDutyPay = true, grades = { ['0'] = { name = 'Judge', payment = 100 } } },
	lawyer = { label = 'Law Firm', defaultDuty = true, offDutyPay = true, grades = { ['0'] = { name = 'Associate', payment = 50 } } },
	reporter = { label = 'Reporter', defaultDuty = true, offDutyPay = true, grades = { ['0'] = { name = 'Journalist', payment = 50 } } },
	trucker = { label = 'Trucker', defaultDuty = true, offDutyPay = true, grades = { ['0'] = { name = 'Driver', payment = 50 } } },
	tow = { label = 'Towing', defaultDuty = true, offDutyPay = true, grades = { ['0'] = { name = 'Driver', payment = 50 } } },
	garbage = { label = 'Garbage', defaultDuty = true, offDutyPay = true, grades = { ['0'] = { name = 'Collector', payment = 50 } } },
	vineyard = { label = 'Vineyard', defaultDuty = true, offDutyPay = true, grades = { ['0'] = { name = 'Picker', payment = 50 } } },
	hotdog = { label = 'Hotdog', defaultDuty = true, offDutyPay = true, grades = { ['0'] = { name = 'Sales', payment = 50 } } },

police = {
	label = 'Law Enforcement',
	type = 'leo',
	defaultDuty = true,
	offDutyPay = false,
	grades = {
		['0']  = { name = 'Cadet',          payment = 1000 },
		['1']  = { name = 'Solo Cadet',     payment = 1200 },
		['2']  = { name = 'Trooper',        payment = 1500 },
		['3']  = { name = 'Senior Trooper', payment = 2000 },
		['4']  = { name = 'Sergeant', payment = 2300 },
		['5']  = { name = 'Head Sergeant', payment = 3000 },
		['6']  = { name = 'Corporal', payment = 3500 },
		['7']  = { name = 'Lieutenant', payment = 5000 },
		['8']  = { name = 'Head Lieutenant', payment = 8000 },
		['9']  = { name = 'Deputy Cheif', isboss = true,payment = 10000 },
		['10']  = { name = 'Chief',  isboss = true, payment = 15000 },
	},
},


skyline = {
	label = 'Skyline’',
	type = 'skyline’',
	defaultDuty = true,
	offDutyPay = false,
	grades = {
		['0'] = { name = 'Dj', payment = 2000 },
		['1'] = { name = 'worker', payment = 3000 },
		['2'] = { name = 'manager', isboss = true, payment = 4000 },
		['3'] = { name = 'owner', isboss = true,  payment = 5000 },
	},
},


ambulance = {
	label = 'EMS',
	type = 'ems',
	defaultDuty = true,
	offDutyPay = false,
	grades = {
		['0'] = { name = 'Medical Intern', payment = 1000 },
		['1'] = { name = 'Emergency Medical Technician ', payment = 1444 },
		['2'] = { name = 'Resident ', payment = 1888 },
		['3'] = { name = 'Paramedic', payment = 2333 },
		['4'] = { name = 'Senior Paramedic', payment = 2777 },
		['5'] = { name = 'Doctor', payment = 3222 },
		['6'] = { name = 'Senior Doctor', payment = 3666 },
		['7'] = { name = 'Supervisor',isboss = true, payment = 4111 },
		['8'] = { name = 'Medical Director',isboss = true, payment = 4555 },
	},
},

realestate = {
	label = 'Real Estate',
	defaultDuty = true,
	offDutyPay = false,
	grades = {
		['0'] = { name = 'Recruit', payment = 150 },
		['1'] = { name = 'House Sales', payment = 200 },
		['2'] = { name = 'Business Sales', payment = 250 },
		['3'] = { name = 'Broker', payment = 300 },
		['4'] = { name = 'Manager', isboss = true, payment = 350 },
	},
},

taxi = {
	label = 'Taxi',
	defaultDuty = true,
	offDutyPay = false,
	grades = {
		['0'] = { name = 'Recruit', payment = 125 },
		['1'] = { name = 'Driver', payment = 150 },
		['2'] = { name = 'Event Driver', payment = 175 },
		['3'] = { name = 'Sales', payment = 200 },
		['4'] = { name = 'Manager', isboss = true, payment = 250 },
	},
},

cardealer = {
	label = 'Vehicle Dealer',
	defaultDuty = true,
	offDutyPay = false,
	grades = {
		['0'] = { name = 'Receptionist', payment = 500 },
		['1'] = { name = 'Sales Executive', payment = 1500 },
		['2'] = { name = 'Senior Sales Executive', payment = 2000 },
		['3'] = { name = 'Assistant Senior Manager', payment = 3500 },
		['4'] = { name = 'Senior Manager', payment = 4000 },
		['5'] = { name = 'Owner',  isboss = true, payment = 5000 },
	},
},
fmpdm = {
	label = 'EDM Dealer',
	defaultDuty = true,
	offDutyPay = false,
	grades = {
		['0'] = { name = 'Recruit', payment = 150 },
		['1'] = { name = 'Showroom Sales', payment = 200 },
		['2'] = { name = 'Business Sales', payment = 250 },
		['3'] = { name = 'Finance', payment = 300 },
		['4'] = { name = 'Manager', isboss = true, payment = 350 },
	},
},

mechanic = {
	label = 'BENNY\'S',
	type = 'mechanic',
	defaultDuty = true,
	offDutyPay = false,
	grades = {
		['0'] = { name = 'Recruit', payment = 1000 },
		['1'] = { name = 'Novice', payment = 1200 },
		['2'] = { name = 'Experienced', payment = 1400 },
		['3'] = { name = 'Advanced', payment = 1600 },
		['4'] = { name = 'Manager',  payment = 3000 },
		['5'] = { name = 'Owner', isboss = true, payment = 6000 },
	},
},

beeker = {
	label = 'Beeker\'s Garage',
	type = 'mechanic',
	defaultDuty = true,
	offDutyPay = false,
	grades = {
		['0'] = { name = 'Recruit', payment = 100 },
		['1'] = { name = 'Novice', payment = 150 },
		['2'] = { name = 'Experienced', payment = 200 },
		['3'] = { name = 'Advanced', payment = 250 },
		['4'] = { name = 'Manager', isboss = true, payment = 1000 },
	},
},
government = {
	label = 'LS Government',
	type = 'goverment',
	defaultDuty = true,
	offDutyPay = false,
	grades = {
		['0'] = { name = 'CHIEF OPERATING OFFICER',isboss = true, payment = 15000  },
		['1'] = { name = 'CHIEF FINANCIAL OFFICER',isboss = true, payment = 15000  },
		['2'] = { name = 'CHIEF MANAGMENT OFFICER',isboss = true, payment = 15000  },
		['3'] = { name = 'CHIEF REGULATORY OFFICER',isboss = true, payment = 15000  },
	},
},

pizza_delivery = { label = "Pizza Delivery", defaultDuty = true, offDutyPay = true, grades = { [0] = { name = "Courier", payment = 100 }, } },
news_delivery = { label = "News Delivery", defaultDuty = true, offDutyPay = true, grades = { [0] = { name = "Courier", payment = 100 }, } },
mobile_hotdog = { label = "Mobile Hotdog", defaultDuty = true, offDutyPay = true, grades = { [0] = { name = "Seller", payment = 100 }, } },
forklifter = { label = "Forklifter", defaultDuty = true, offDutyPay = true, grades = { [0] = { name = "Operator", payment = 150 }, } },
gardener = { label = "Gardener", defaultDuty = true, offDutyPay = true, grades = { [0] = { name = "Bahcivan", payment = 125 }, } },
trucker = { label = "Trucker", defaultDuty = true, offDutyPay = true, grades = { [0] = { name = "Operator", payment = 200 }, } },
roadhelper = { label = "Roadhelper", defaultDuty = true, offDutyPay = true, grades = { [0] = { name = "Operator", payment = 150 }, } },
bus_driver = { label = "Bus Driver", defaultDuty = true, offDutyPay = true, grades = { [0] = { name = "Driver", payment = 150 }, } },
fire_department = { label = "Fire Department", defaultDuty = true, offDutyPay = true, grades = { [0] = { name = "Fireman", payment = 2500 }, } },
hunter = { label = "Hunter", defaultDuty = true, offDutyPay = true, grades = { [0] = { name = "Hunter", payment = 150 }, } },
detectorist = { label = "Metal Detectorist", defaultDuty = true, offDutyPay = true, grades = { [0] = { name = "Employee", payment = 150 }, } },
project_car = { label = "Project Car", defaultDuty = true, offDutyPay = true, grades = { [0] = { name = "Engineer", payment = 200 }, } },
diver = { label = "Diver", defaultDuty = true, offDutyPay = true, grades = { [0] = { name = "Employee", payment = 200 }, } },
farmer = { label = "Farmer", defaultDuty = true, offDutyPay = true, grades = { [0] = { name = "Employee", payment = 150 }, } },
electrician = { label = "Electrician", defaultDuty = true, offDutyPay = true, grades = { [0] = { name = "Employee", payment = 150 }, } }
}
