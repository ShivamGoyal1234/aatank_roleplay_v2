import React, { useState, useEffect } from "react";
import "./main.css";

const SopApp = ({ lang, theme }) => {
	const [selectedCategory, setSelectedCategory] = useState('general');
	const [selectedTab, setSelectedTab] = useState('sop'); // 'sop' or 'codes'

	// SOP data (static)
	const sopData = {
		general: [
			{
				title: "General Conduct",
				procedures: [
					"Always maintain professional behavior while on duty",
					"Treat all citizens with respect and dignity",
					"Follow department policies and procedures",
					"Maintain proper uniform and equipment standards",
					"Report any violations or incidents immediately"
				]
			},
			{
				title: "Communication",
				procedures: [
					"Use clear and professional language",
					"Maintain radio discipline",
					"Document all interactions properly",
					"Follow chain of command",
					"Use appropriate codes and signals"
				]
			}
		],
		traffic: [
			{
				title: "Traffic Stops",
				procedures: [
					"Activate emergency lights and siren when necessary",
					"Position vehicle safely and strategically",
					"Approach vehicle with caution",
					"Request license, registration, and insurance",
					"Explain reason for stop clearly",
					"Issue citations or warnings as appropriate"
				]
			},
			{
				title: "Accident Response",
				procedures: [
					"Secure the scene and ensure safety",
					"Provide medical assistance if needed",
					"Collect witness statements",
					"Document damage and injuries",
					"Direct traffic around the scene",
					"Complete accident report thoroughly"
				]
			}
		],
		arrest: [
			{
				title: "Arrest Procedures",
				procedures: [
					"Inform suspect of Miranda rights",
					"Use appropriate force only when necessary",
					"Search suspect for weapons and contraband",
					"Handcuff suspect securely",
					"Transport to booking facility",
					"Complete arrest report and documentation"
				]
			},
			{
				title: "Search and Seizure",
				procedures: [
					"Obtain warrant when required",
					"Document all evidence collected",
					"Maintain chain of custody",
					"Photograph evidence and scene",
					"Package evidence properly",
					"Submit to evidence room"
				]
			}
		],
		emergency: [
			{
				title: "Emergency Response",
				procedures: [
					"Respond immediately to emergency calls",
					"Assess situation and request backup if needed",
					"Provide first aid and medical assistance",
					"Secure perimeter and control access",
					"Coordinate with other emergency services",
					"Document all actions taken"
				]
			},
			{
				title: "Active Shooter Response",
				procedures: [
					"Stop the killing - engage threat immediately",
					"Stop the dying - provide medical aid",
					"Evacuate civilians to safety",
					"Establish command post",
					"Coordinate with SWAT and other units",
					"Preserve evidence and document scene"
				]
			}
		]
	};

	// SOP categories (static)
	const categories = [
		{ id: 'general', name: 'General Procedures', icon: 'fa-solid fa-shield' },
		{ id: 'traffic', name: 'Traffic Enforcement', icon: 'fa-solid fa-car' },
		{ id: 'arrest', name: 'Arrest & Search', icon: 'fa-solid fa-handcuffs' },
		{ id: 'emergency', name: 'Emergency Response', icon: 'fa-solid fa-exclamation-triangle' }
	];

	// 10 codes (static)
	const pd10Codes = {
		status: [
			{ code: "10-1", meaning: "Officer needs help - EMERGENCY!", priority: "high" },
			{ code: "10-2", meaning: "Signal good", priority: "low" },
			{ code: "10-3", meaning: "Stop transmitting", priority: "medium" },
			{ code: "10-4", meaning: "Acknowledged", priority: "low" },
			{ code: "10-5", meaning: "Relay", priority: "medium" },
			{ code: "10-6", meaning: "Busy - unless urgent", priority: "medium" },
			{ code: "10-7", meaning: "Out of service", priority: "medium" },
			{ code: "10-8", meaning: "In service", priority: "low" },
			{ code: "10-9", meaning: "Repeat", priority: "medium" },
			{ code: "10-10", meaning: "Fight in progress", priority: "high" }
		],
		calls: [
			{ code: "10-11", meaning: "SWAT call", priority: "high" },
			{ code: "10-12", meaning: "Notify news media", priority: "medium" },
			{ code: "10-13", meaning: "Weather and road report", priority: "low" },
			{ code: "10-14", meaning: "Prowler report", priority: "medium" },
			{ code: "10-15", meaning: "Civil disturbance", priority: "high" },
			{ code: "10-16", meaning: "Domestic problem", priority: "high" },
			{ code: "10-17", meaning: "Meet complainant", priority: "medium" },
			{ code: "10-18", meaning: "Quickly", priority: "high" },
			{ code: "10-19", meaning: "Return to station", priority: "medium" },
			{ code: "10-20", meaning: "Location", priority: "medium" }
		],
		situations: [
			{ code: "10-21", meaning: "Call by telephone", priority: "medium" },
			{ code: "10-22", meaning: "Disregard", priority: "low" },
			{ code: "10-23", meaning: "Arrived at scene", priority: "medium" },
			{ code: "10-24", meaning: "Assignment completed", priority: "low" },
			{ code: "10-25", meaning: "Report to (meet)", priority: "medium" },
			{ code: "10-26", meaning: "ETA (estimated time of arrival)", priority: "medium" },
			{ code: "10-27", meaning: "License/Permit information", priority: "medium" },
			{ code: "10-28", meaning: "Vehicle registration information", priority: "medium" },
			{ code: "10-29", meaning: "Check for wanted", priority: "medium" },
			{ code: "10-30", meaning: "Unnecessary use of radio", priority: "low" }
		],
		emergency: [
			{ code: "10-31", meaning: "Crime in progress", priority: "high" },
			{ code: "10-32", meaning: "Man with gun", priority: "high" },
			{ code: "10-33", meaning: "EMERGENCY! All units stand by", priority: "critical" },
			{ code: "10-34", meaning: "Riot", priority: "high" },
			{ code: "10-35", meaning: "Major crime alert", priority: "high" },
			{ code: "10-36", meaning: "Correct time", priority: "low" },
			{ code: "10-37", meaning: "(Investigate) suspicious vehicle", priority: "medium" },
			{ code: "10-38", meaning: "Stopping suspicious vehicle", priority: "medium" },
			{ code: "10-39", meaning: "Urgent - use light, siren", priority: "high" },
			{ code: "10-40", meaning: "Silent run - no light, siren", priority: "medium" }
		]
	};

	// 10 code categories (static)
	const codeCategories = [
		{ id: 'status', name: 'Status Codes', icon: 'fa-solid fa-circle-info' },
		{ id: 'calls', name: 'Call Types', icon: 'fa-solid fa-phone' },
		{ id: 'situations', name: 'Situations', icon: 'fa-solid fa-clipboard-list' },
		{ id: 'emergency', name: 'Emergency Codes', icon: 'fa-solid fa-triangle-exclamation' }
	];

	const getPriorityColor = (priority) => {
		switch (priority) {
			case 'critical': return '#ff4444';
			case 'high': return '#ff6b35';
			case 'medium': return '#ffa726';
			case 'low': return '#66bb6a';
			default: return '#4a90e2';
		}
	};

	// Helper: first category id per tab
	const getFirstCategoryId = (tab) => {
		if (tab === 'sop') return categories[0]?.id || 'general';
		return codeCategories[0]?.id || 'status';
	};

	// Keep selectedCategory valid when switching tabs
	useEffect(() => {
		setSelectedCategory(getFirstCategoryId(selectedTab));
	}, [selectedTab]);

	// Safety getters for current view
	const getCurrentSopData = () => {
		return sopData[selectedCategory] || [];
	};

	const getCurrentCodesData = () => {
		return pd10Codes[selectedCategory] || [];
	};

	const getCurrentCategoryName = () => {
		if (selectedTab === 'sop') {
			return categories.find(cat => cat.id === selectedCategory)?.name || 'Unknown';
		}
		return codeCategories.find(cat => cat.id === selectedCategory)?.name || 'Unknown';
	};

	return (
		<div className={`sop-container ${theme !== 'dark' ? 'light-theme' : ''}`}>
			<div className="sop-header">
				<div className="sop-header-content">
					<div className="sop-title-section">
						<h2 className={`sop-title ${theme !== 'dark' ? 'light-text' : ''}`}>
							<i className="fa-solid fa-book"></i>
							Standard Operating Procedures
						</h2>
						<p className={`sop-subtitle ${theme !== 'dark' ? 'light-text' : ''}`}>
							Department guidelines and procedures for law enforcement operations
						</p>
					</div>
					<div className="sop-tabs">
						<div 
							className={`sop-tab ${selectedTab === 'sop' ? 'active' : ''} ${theme !== 'dark' ? 'light-tab' : ''}`}
							onClick={() => setSelectedTab('sop')}
						>
							<i className="fa-solid fa-book"></i>
							<span>SOP</span>
						</div>
						<div 
							className={`sop-tab ${selectedTab === 'codes' ? 'active' : ''} ${theme !== 'dark' ? 'light-tab' : ''}`}
							onClick={() => setSelectedTab('codes')}
						>
							<i className="fa-solid fa-hashtag"></i>
							<span>10 Codes</span>
						</div>
					</div>
				</div>
			</div>

			<div className="sop-content">
				{selectedTab === 'sop' ? (
					<>
						<div className="sop-sidebar">
							<div className="sop-categories">
								<div className="sop-categories-header">
									<i className="fa-solid fa-list"></i>
									<span>Categories</span>
								</div>
								{categories.map((category) => (
									<div
										key={category.id}
										className={`sop-category ${selectedCategory === category.id ? 'active' : ''} ${theme !== 'dark' ? 'light-category' : ''}`}
										onClick={() => setSelectedCategory(category.id)}
									>
										<i className={category.icon}></i>
										<span>{category.name}</span>
									</div>
								))}
							</div>
						</div>

						<div className="sop-main">
							<div className="sop-procedures">
								{getCurrentSopData().map((section, index) => (
									<div key={index} className={`sop-section ${theme !== 'dark' ? 'light-section' : ''}`}>
										<div className="sop-section-header">
											<h3 className={`sop-section-title ${theme !== 'dark' ? 'light-text' : ''}`}>
												{section.title}
											</h3>
											<div className="sop-section-icon">
												<i className="fa-solid fa-clipboard-check"></i>
											</div>
										</div>
										<div className="sop-procedure-list">
											{section.procedures.map((procedure, procIndex) => (
												<div key={procIndex} className={`sop-procedure-item ${theme !== 'dark' ? 'light-item' : ''}`}>
													<div className="sop-procedure-number">{procIndex + 1}</div>
													<div className={`sop-procedure-text ${theme !== 'dark' ? 'light-text' : ''}`}>
														{procedure}
													</div>
												</div>
											))}
										</div>
									</div>
								))}
							</div>
						</div>
					</>
				) : (
					<>
						<div className="sop-sidebar">
							<div className="sop-categories">
								<div className="sop-categories-header">
									<i className="fa-solid fa-hashtag"></i>
									<span>Code Categories</span>
								</div>
								{codeCategories.map((category) => (
									<div
										key={category.id}
										className={`sop-category ${selectedCategory === category.id ? 'active' : ''} ${theme !== 'dark' ? 'light-category' : ''}`}
										onClick={() => setSelectedCategory(category.id)}
									>
										<i className={category.icon}></i>
										<span>{category.name}</span>
									</div>
								))}
							</div>
						</div>

						<div className="sop-main">
							<div className="sop-codes">
								<div className="sop-codes-header">
									<h3 className={`sop-codes-title ${theme !== 'dark' ? 'light-text' : ''}`}>
										{getCurrentCategoryName()}
									</h3>
									<div className="sop-codes-count">
										{getCurrentCodesData().length} codes
									</div>
								</div>
								<div className="sop-codes-grid">
									{getCurrentCodesData().map((code, index) => (
										<div key={index} className={`sop-code-item ${theme !== 'dark' ? 'light-code-item' : ''}`}>
											<div className="sop-code-header">
												<div 
													className="sop-code-number"
													style={{ backgroundColor: getPriorityColor(code.priority) }}
												>
													{code.code}
												</div>
												<div className={`sop-code-priority ${theme !== 'dark' ? 'light-priority' : ''}`}>
													{(code.priority || 'low').toUpperCase()}
												</div>
											</div>
											<div className={`sop-code-meaning ${theme !== 'dark' ? 'light-text' : ''}`}>
												{code.meaning}
											</div>
										</div>
									))}
								</div>
							</div>
						</div>
					</>
				)}
			</div>

			<div className="sop-footer">
				<div className={`sop-disclaimer ${theme !== 'dark' ? 'light-text' : ''}`}>
					<i className="fa-solid fa-info-circle"></i>
					{selectedTab === 'sop' 
						? "These procedures are guidelines and may be modified based on specific circumstances and department policies."
						: "These codes are standard police radio codes. Use appropriate codes based on department protocols and situation requirements."
					}
				</div>
			</div>
		</div>
	);
};

export default SopApp;
