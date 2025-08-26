const bankingApp = Vue.createApp({
    data() {
        return {
            isBankOpen: false,
            isATMOpen: false,
            showPinPrompt: false,
            notification: null,
            activeView: "home",
            accounts: [],
            statements: {},
            selectedAccountStatement: null,
            playerName: "",
            accountNumber: "",
            playerCash: 0,
            selectedMoneyAmount: 0,
            moneyReason: "",
            transferType: "internal",
            internalToAccount: null,
            internalTransferAmount: 0,
            externalAccountNumber: "",
            externalTransferAmount: 0,
            transferReason: "",
            debitPin: "",
            enteredPin: "",
            acceptablePins: [],
            tempBankData: null,
            currentCardData: null, // New: To store debit card details
            createAccountName: "",
            createAccountAmount: 0,
            editAccount: null,
            editAccountName: "",
            manageAccountName: null,
            manageUserName: "",
            filteredUsers: [],
            showUsersDropdown: false,
            hasExistingCard: false,
            existingCardNumber: "",
            existingCardHolderName: "",
            existingCardPin: "",
            newPin: "",
            confirmNewPin: "",
            showChangePinPrompt: false,
            nearbyPlayers: [], // New data property
            knownUsers: {}, // New: To cache citizenid to name mapping
            fetchQueue: [], // New: Queue for fetchUserName requests
            isProcessingQueue: false, // New: Flag to indicate if queue is being processed
            showAllTransactionsFlag: false, // New data property
            filterStartDate: '', // New data property for start date filter
            filterEndDate: '',   // New data property for end date filter
            showLostCardPrompt: false, // New: controls visibility of lost card prompt
            showDeleteConfirmPrompt: false, // New: controls visibility of custom delete confirmation
            accountToDeleteName: "", // New: stores the name of the account to be deleted
        };
    },
    computed: {
        accountStatements() {
            if (this.selectedAccountStatement && this.statements[this.selectedAccountStatement.name]) {
                return this.statements[this.selectedAccountStatement.name];
            }
            return [];
        },
        limitedStatements() {
            let statementsToFilter = this.statements[this.selectedAccountStatement.name] || [];

            // Apply date filter if dates are set
            if (this.filterStartDate && this.filterEndDate) {
                const startDate = new Date(this.filterStartDate);
                const endDate = new Date(this.filterEndDate);
                endDate.setHours(23, 59, 59, 999); // Set to end of the day

                statementsToFilter = statementsToFilter.filter(statement => {
                    const statementDate = new Date(parseInt(statement.date));
                    return statementDate >= startDate && statementDate <= endDate;
                });
            }

            if (this.showAllTransactionsFlag) {
                return statementsToFilter;
            } else {
                return statementsToFilter.slice(0, 5);
            }
        },
        hasMoreTransactions() {
            const accountStatements = this.statements[this.selectedAccountStatement.name] || [];
            return accountStatements.length > 5;
        },
        sharedAccountUsersWithNames() {
            if (!this.selectedAccountStatement || this.selectedAccountStatement.type !== 'shared') {
                return [];
            }

            let allUserCitizenIds = new Set();

            // Add the account owner's citizenid
            if (this.selectedAccountStatement.citizenid) {
                allUserCitizenIds.add(this.selectedAccountStatement.citizenid);
            }

            // Add citizenids from the users array
            if (this.selectedAccountStatement.users) {
                try {
                    const parsedUsers = JSON.parse(this.selectedAccountStatement.users);
                    if (Array.isArray(parsedUsers)) {
                        parsedUsers.forEach(citizenid => allUserCitizenIds.add(citizenid));
                    }
                } catch (e) {
                    console.error("Error parsing shared account users:", e);
                }
            }

            const usersToDisplay = Array.from(allUserCitizenIds).map(citizenid => {
                const userName = this.knownUsers[citizenid];

                return { citizenid: citizenid, name: userName || 'Loading...' };
            });
            return usersToDisplay;
        },
    },
    watch: {
        selectedAccountStatement: {
            handler(newVal, oldVal) {
                if (newVal && newVal.type === 'job' && this.activeView === 'accountOptions') {
                    this.setActiveView('home');
                }
                if (newVal) {
                    this.showAllTransactionsFlag = false; // Reset when account changes
                    this.filterStartDate = ''; // Reset date filters when account changes
                    this.filterEndDate = ''; // Reset date filters when account changes
                    this.$nextTick(() => {
                        this.renderChart(); // Re-render chart when account or statements change
                    });
                }
            },
            deep: true,
        },
        // Also watch statements for changes that affect the graph data
        statements: {
            handler(newVal, oldVal) {
                if (this.selectedAccountStatement) {
                    this.$nextTick(() => {
                        this.renderChart();
                    });
                }
            },
            deep: true,
        },
        "manageAccountName.users": function () {
            this.filterUsers();
        },
        nearbyPlayers: function (newVal) {

            this.filterUsers();
        },
    },
    methods: {
        showAllTransactions() {
            this.showAllTransactionsFlag = true;
        },
        applyDateFilter() {
            // The computed property `limitedStatements` will automatically react to changes in filterStartDate and filterEndDate
            // No direct action needed here other than perhaps a re-render if the graph also depends on filtered data
            this.$nextTick(() => {
                this.renderChart(); // Re-render chart based on new filters if applicable
            });
        },
        renderChart() {
            const ctx = document.getElementById('myChart');
            if (!ctx) {
                console.warn('Chart canvas not found.');
                return;
            }

            // Destroy existing chart instance if it exists
            if (this.myChart) {
                this.myChart.destroy();
            }

            const accountStatements = this.statements[this.selectedAccountStatement.name] || [];
            const sevenDaysAgo = new Date();
            sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 6); // Adjusted to include today
            sevenDaysAgo.setHours(0, 0, 0, 0); // Set to start of the day

            const recentTransactions = accountStatements.filter(stmt => {
                const statementDate = new Date(parseInt(stmt.date)); // Ensure date is parsed as an integer
                return statementDate >= sevenDaysAgo;
            });

            // Initialize data for last 7 days
            const dailyData = {};
            for (let i = 0; i < 7; i++) {
                const date = new Date(sevenDaysAgo);
                date.setDate(sevenDaysAgo.getDate() + i);
                const dateString = this.formatDate(date.getTime()); // Corrected to pass timestamp
                dailyData[dateString] = { withdraw: 0, deposit: 0 };
            }

            recentTransactions.forEach(stmt => {
                const dateString = this.formatDate(stmt.date); // Simplified to use raw timestamp
                if (dailyData[dateString]) {
                    const amount = parseFloat(stmt.amount); // Ensure amount is a float
                    if (stmt.type === 'withdraw') {
                        dailyData[dateString].withdraw += Math.abs(amount);
                    } else if (stmt.type === 'deposit') {
                        dailyData[dateString].deposit += Math.abs(amount);
                    }
                }
            });


            const labels = Object.keys(dailyData);
            const withdrawData = labels.map(label => dailyData[label].withdraw);
            const depositData = labels.map(label => dailyData[label].deposit);

            this.myChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: 'Deposits',
                            data: depositData,
                            backgroundColor: 'rgba(75, 192, 192, 0.6)', // Greenish for deposits
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1,
                            borderRadius: 5,
                        },
                        {
                            label: 'Withdrawals',
                            data: withdrawData,
                            backgroundColor: 'rgba(255, 99, 132, 0.6)', // Reddish for withdrawals
                            borderColor: 'rgba(255, 99, 132, 1)',
                            borderWidth: 1,
                            borderRadius: 5,
                        },
                    ],
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        title: {
                            display: false,
                            text: 'Last 7 Days Financial Activity',
                            color: 'var(--md-on-surface)',
                        },
                        legend: {
                            labels: {
                                color: 'var(--md-on-surface-variant)',
                            },
                        },
                    },
                    scales: {
                        x: {
                            stacked: true,
                            grid: {
                                color: 'rgba(255, 255, 255, 0.1)',
                                borderColor: 'var(--md-outline-variant)',
                            },
                            ticks: {
                                color: 'var(--md-on-surface-variant)',
                            },
                        },
                        y: {
                            stacked: true,
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(255, 255, 255, 0.1)',
                                borderColor: 'var(--md-outline-variant)',
                            },
                            ticks: {
                                color: 'var(--md-on-surface-variant)',
                                callback: function (value) {
                                    return '$' + value.toLocaleString();
                                },
                            },
                        },
                    },
                },
            });
        },
        getNearbyPlayers() {
            let existingUsers = [];
            if (this.selectedAccountStatement && this.selectedAccountStatement.type === 'shared' && this.selectedAccountStatement.users) {
                try {
                    existingUsers = JSON.parse(this.selectedAccountStatement.users);
                } catch (e) {
                    console.error("Error parsing existing users:", e);
                }
            }

            axios.post("https://qb-banking/getNearbyPlayers", {
                existingUsers: existingUsers
            })
                .then(response => {
                    if (response.data.success) {
                        this.nearbyPlayers = response.data.players;
                    } else {
                        this.addNotification(response.data.message, "error");
                    }
                });
        },
        openBank(accounts, statements, playerData) {
            this.playerName = playerData.charinfo.firstname;
            this.accountNumber = playerData.citizenid;
            this.playerCash = playerData.money.cash;
            this.accounts = [];
            accounts.forEach((account) => {
                this.accounts.push({
                    name: account.account_name,
                    type: account.account_type,
                    balance: account.account_balance,
                    users: account.users,
                    id: account.id,
                    citizenid: account.citizenid,
                });
            });
            this.statements = {};
            Object.keys(statements).forEach((accountKey) => {
                this.statements[accountKey] = statements[accountKey].map((statement) => ({
                    id: statement.id,
                    date: statement.date,
                    reason: statement.reason,
                    amount: statement.amount,
                    type: statement.statement_type,
                    user: statement.citizenid,
                }));
            });

            // Set the initial selected account to 'personal account' object
            const personalAccount = this.accounts.find(account => account.name === 'personal account');
            if (personalAccount) {
                this.selectedAccountStatement = personalAccount;
            }

            const debitCard = playerData.debitCard;
            if (debitCard && debitCard.card_number) {
                this.hasExistingCard = true;
                this.existingCardNumber = debitCard.card_number;
                this.existingCardHolderName = debitCard.card_holder_name;
                this.existingCardPin = debitCard.card_pin;
            } else {
                this.hasExistingCard = false;
                this.existingCardNumber = "";
                this.existingCardHolderName = "";
                this.existingCardPin = "";
            }
            this.isBankOpen = true;
        },
        openATM(bankData) {
            const playerData = bankData.playerData;
            this.playerName = playerData.charinfo.firstname;
            this.accountNumber = playerData.citizenid;
            this.playerCash = playerData.money.cash;
            this.accounts = [];
            bankData.accounts.forEach((account) => {
                this.accounts.push({
                    name: account.account_name,
                    type: account.account_type,
                    balance: account.account_balance,
                    users: account.users,
                    id: account.id,
                });
            });
            // For ATM, always select the personal account
            const personalAccount = this.accounts.find(account => account.name === 'personal account');
            if (personalAccount) {
                this.selectedAccountStatement = personalAccount;
            }
            // this.isATMOpen = true; // REMOVED: Only open ATM after successful PIN

            // NEW: Set currentCardData from bank_card in playerData.items
            const bankCard = playerData.items.find(item => {
                return item && item.name === 'bank_card';
            });


            if (bankCard && bankCard.info) {

                this.currentCardData = {
                    card_number: bankCard.info.cardNumber,
                    card_pin: bankCard.info.cardPin,
                };
            } else {
                console.error('Client: Bank card not found in player data or missing info.', JSON.stringify(playerData.items));
                this.addNotification("Bank card data not found. Please try again.", "error");
                // Optionally, prevent opening ATM if card data is essential
                this.isATMOpen = false;
                return;
            }
            this.tempBankData = bankData; // Store bankData for re-use after PIN verification

            // NEW: Directly verify PIN from card data
            if (this.currentCardData) {
            
                
                axios.post("https://qb-banking/verifyCardPin", {
                    cardPin: this.currentCardData.card_pin,
                    cardNumber: this.currentCardData.card_number,
                })
                .then(response => {

                    if (response.data.success) {
                        this.isATMOpen = true; // Open ATM UI
                        this.isBankOpen = false; // Ensure main bank UI is hidden
                        this.showPinPrompt = false; // Ensure PIN prompt is hidden
                        this.enteredPin = ""; // Clear entered PIN
                        this.addNotification("PIN verified. ATM opened.", "success");

                    } else {
                        this.addNotification(response.data.message, "error");
                        this.isATMOpen = false; // Keep ATM UI closed on failure
                        this.isBankOpen = false; // Ensure bank UI is also closed
                        this.showPinPrompt = false; // Ensure PIN prompt is hidden
                        this.enteredPin = ""; // Clear entered PIN
                        axios.post("https://qb-banking/closeApp"); // Close UI on failed PIN
                    }
                })
                .catch(error => {
                    console.error("Error during card PIN verification (via axios.post):");
                    if (error.response) {
                        console.error('Client: Server responded with non-2xx status:', error.response.data);
                        console.error('Client: Status:', error.response.status);
                        console.error('Client: Headers:', error.response.headers);
                        self.addNotification("Error: " + (error.response.data.message || "Unknown server error."), "error");
                    } else if (error.request) {
                        console.error('Client: No response received:', error.request);
                        self.addNotification("Error: No response from server.", "error");
                    } else {
                        console.error('Client: Error setting up request:', error.message);
                        self.addNotification("Error: " + error.message, "error");
                    }
                    this.isATMOpen = false;
                    this.isBankOpen = false;
                    this.showPinPrompt = false;
                    this.enteredPin = "";
                    axios.post("https://qb-banking/closeApp"); // Close UI on error
                });

            } else {
                this.addNotification("No card data found for PIN verification.", "error");
                this.isATMOpen = false;
                this.isBankOpen = false;
                this.showPinPrompt = false;
                this.enteredPin = "";
                axios.post("https://qb-banking/closeApp"); // Close UI if no card data
            }
        },
        // REMOVED: pinPrompt function (no longer used for initial ATM access)
        // pinPrompt() {
        //     // ... (previous pinPrompt logic)
        // },
        withdrawMoney() {
            if (!this.selectedAccountStatement || this.selectedMoneyAmount <= 0) {
                return;
            }
            axios
                .post("https://qb-banking/withdraw", {
                    accountName: this.selectedAccountStatement.name,
                    amount: this.selectedMoneyAmount,
                    reason: this.moneyReason,
                })
                .then((response) => {
                    if (response.data.success) {
                        const account = this.accounts.find((acc) => acc.name === this.selectedAccountStatement.name);
                        if (account) {
                            account.balance -= this.selectedMoneyAmount;
                            this.playerCash += this.selectedMoneyAmount;
                            this.addStatement(this.accountNumber, this.selectedAccountStatement.name, this.moneyReason, this.selectedMoneyAmount, "withdraw");
                            this.selectedMoneyAmount = 0;
                            this.moneyReason = "";
                        }
                        this.addNotification(response.data.message, "success");
                    } else {
                        this.addNotification(response.data.message, "error");
                    }
                });
        },
        depositMoney() {
            if (!this.selectedAccountStatement || this.selectedMoneyAmount <= 0) {
                return;
            }
            axios
                .post("https://qb-banking/deposit", {
                    accountName: this.selectedAccountStatement.name,
                    amount: this.selectedMoneyAmount,
                    reason: this.moneyReason,
                })
                .then((response) => {
                    if (response.data.success) {
                        const account = this.accounts.find((acc) => acc.name === this.selectedAccountStatement.name);
                        if (account) {
                            account.balance += this.selectedMoneyAmount;
                            this.playerCash -= this.selectedMoneyAmount;
                            this.addStatement(this.accountNumber, this.selectedAccountStatement.name, this.moneyReason, this.selectedMoneyAmount, "deposit");
                            this.selectedMoneyAmount = 0;
                            this.moneyReason = "";
                        }
                        this.addNotification(response.data.message, "success");
                    } else {
                        this.addNotification(response.data.message, "error");
                    }
                });
        },
        internalTransfer() {
            if (!this.selectedAccountStatement || !this.internalToAccount || this.internalTransferAmount <= 0) {
                return;
            }
            axios
                .post("https://qb-banking/internalTransfer", {
                    fromAccountName: this.selectedAccountStatement.name,
                    toAccountName: this.internalToAccount.name,
                    amount: this.internalTransferAmount,
                    reason: this.transferReason,
                })
                .then((response) => {
                    if (response.data.success) {
                        const fromAccount = this.accounts.find((acc) => acc.name === this.selectedAccountStatement.name);
                        if (fromAccount) {
                            fromAccount.balance -= this.internalTransferAmount;
                        }
                        const toAccount = this.accounts.find((acc) => acc.name === this.internalToAccount.name);
                        if (toAccount) {
                            toAccount.balance += this.internalTransferAmount;
                        }
                        this.addStatement(this.accountNumber, this.selectedAccountStatement.name, this.transferReason, this.internalTransferAmount, "withdraw");
                        this.addStatement(this.accountNumber, this.internalToAccount.name, this.transferReason, this.internalTransferAmount, "deposit");
                        this.internalTransferAmount = 0;
                        this.transferReason = "";
                        this.internalToAccount = null;
                        this.addNotification(response.data.message, "success");
                    } else {
                        this.addNotification(response.data.message, "error");
                    }
                });
        },
        externalTransfer() {
            if (!this.selectedAccountStatement || !this.externalAccountNumber || this.externalTransferAmount <= 0) {
                return;
            }
            axios
                .post("https://qb-banking/externalTransfer", {
                    fromAccountName: this.selectedAccountStatement.name,
                    toAccountNumber: this.externalAccountNumber,
                    amount: this.externalTransferAmount,
                    reason: this.transferReason,
                })
                .then((response) => {
                    if (response.data.success) {
                        const fromAccount = this.accounts.find((acc) => acc.name === this.selectedAccountStatement.name);
                        if (fromAccount) {
                            fromAccount.balance -= this.externalTransferAmount;
                        }
                        this.addStatement(this.accountNumber, this.selectedAccountStatement.name, this.transferReason, this.externalTransferAmount, "withdraw");
                        this.externalTransferAmount = 0;
                        this.transferReason = "";
                        this.externalAccountNumber = "";
                        this.addNotification(response.data.message, "success");
                    } else {
                        this.addNotification(response.data.message, "error");
                    }
                });
        },
        orderDebitCard() {
            if (!this.debitPin) {
                this.addNotification("Please enter a PIN.", "error");
                return;
            }
            if (this.selectedAccountStatement.name !== "personal account") { // Corrected: Compare name property
                this.addNotification("Debit cards can only be ordered for your personal account.", "error");
                return;
            }

            axios
                .post("https://qb-banking/orderCard", {
                    pin: this.debitPin,
                    accountName: this.selectedAccountStatement.name, // Corrected: Send account name
                })
                .then((response) => {
                    if (response.data.success) {
                        this.debitPin = "";
                        this.addNotification(response.data.message, "success");
                    } else {
                        this.addNotification(response.data.message, "error");
                    }
                });
        },
        openAccount() {
            if (!this.createAccountName || this.createAccountAmount < 0) {
                return;
            }

            axios
                .post("https://qb-banking/openAccount", {
                    accountName: this.createAccountName,
                    amount: this.createAccountAmount,
                })
                .then((response) => {
                    if (response.data.success) {
                        const checkingAccount = this.accounts.find((acc) => acc.name === "personal account");
                        checkingAccount.balance -= this.createAccountAmount;
                        this.accounts.push({
                            name: this.createAccountName,
                            type: "shared",
                            balance: this.createAccountAmount,
                            users: JSON.stringify([this.playerName]),
                        });
                        this.addStatement(this.accountNumber, "personal account", "Initial deposit for " + this.createAccountName, this.createAccountAmount, "withdraw");
                        this.addStatement(this.accountNumber, this.createAccountName, "Initial deposit", this.createAccountAmount, "deposit");
                        this.createAccountName = "";
                        this.createAccountAmount = 0;
                        this.addNotification(response.data.message, "success");
                    } else {
                        this.createAccountName = "";
                        this.createAccountAmount = 0;
                        this.addNotification(response.data.message, "error");
                    }
                });
        },
        renameAccount() {
            if (!this.editAccount || !this.editAccountName) {
                return;
            }

            axios
                .post("https://qb-banking/renameAccount", {
                    oldName: this.editAccount.name,
                    newName: this.editAccountName,
                })
                .then((response) => {
                    if (response.data.success) {
                        const account = this.accounts.find((acc) => acc.name === this.editAccount.name);
                        if (account) {
                            account.name = this.editAccountName;
                        }
                        this.editAccount = null;
                        this.editAccountName = "";
                        this.addNotification(response.data.message, "success");
                    } else {
                        this.addNotification(response.data.message, "error");
                    }
                });
        },
        async deleteAccount() {
            if (!this.selectedAccountStatement) {
                this.addNotification("No account selected for deletion.", "error");
                return;
            }

            if (this.selectedAccountStatement.type !== 'shared') {
                this.addNotification("Only shared accounts can be deleted from here.", "error");
                return;
            }

            // Show custom confirmation dialog
            this.accountToDeleteName = this.selectedAccountStatement.name;
            this.showDeleteConfirmPrompt = true;
        },

        async confirmDeleteAccount() {
            this.showDeleteConfirmPrompt = false; // Close the confirmation dialog

            try {
                const response = await axios.post(`https://${GetParentResourceName()}/deleteAccount`, {
                    accountName: this.selectedAccountStatement.name,
                });

                if (response.data.success) {
                    this.addNotification(response.data.message || "Account deleted successfully!", "success");
                    this.accounts = this.accounts.filter(account => account.name !== this.selectedAccountStatement.name);
                    if (this.selectedAccountStatement.name === response.data.deletedAccountName) {
                        this.selectedAccountStatement = null;
                        this.activeView = 'home';
                    }
                    this.openBank(response.data.accounts, response.data.statements, response.data.playerData);
                } else {
                    this.addNotification(response.data.message || "Failed to delete account.", "error");
                }
            } catch (error) {
                console.error("Error deleting account:", error);
                this.addNotification("An error occurred while deleting the account.", "error");
            }
        },

        cancelDeleteAccount() {
            this.showDeleteConfirmPrompt = false;
            this.accountToDeleteName = "";
        },

        addUserToAccount() {
            if (!this.selectedAccountStatement || !this.manageUserName) { // Use selectedAccountStatement for account
                return;
            }
            axios
                .post("https://qb-banking/addUser", {
                    accountName: this.selectedAccountStatement.name, // Use selectedAccountStatement.name
                    userName: this.manageUserName,
                })
                .then((response) => {
                    if (response.data.success) {
                        let usersArray = JSON.parse(this.selectedAccountStatement.users);
                        usersArray.push(this.manageUserName);
                        this.selectedAccountStatement.users = JSON.stringify(usersArray);
                        this.addNotification(response.data.message, "success");

                        // Immediately fetch the name for the newly added user
                        this.fetchUserName(this.manageUserName);

                        this.manageUserName = "";
                    } else {
                        this.addNotification(response.data.message, "error");
                    }
                });
        },
        removeUserFromAccount(userToRemove) { // Modified to accept user as parameter
            if (!this.selectedAccountStatement || !userToRemove) {
                return;
            }

            axios
                .post("https://qb-banking/removeUser", {
                    accountName: this.selectedAccountStatement.name,
                    userName: userToRemove,
                })
                .then((response) => {
                    if (response.data.success) {
                        let usersArray = JSON.parse(this.selectedAccountStatement.users);
                        usersArray = usersArray.filter((user) => user !== userToRemove);
                        this.selectedAccountStatement.users = JSON.stringify(usersArray);
                        this.manageUserName = "";
                        this.addNotification(response.data.message, "success");
                    } else {
                        this.addNotification(response.data.message, "error");
                    }
                });
        },
        addStatement(accountNumber, accountName, reason, amount, type) {
            let newStatement = {
                date: Date.now(),
                user: accountNumber,
                reason: reason,
                amount: amount,
                type: type,
            };

            if (!this.statements[accountName]) {
                this.statements[accountName] = [];
            }

            this.statements[accountName].push(newStatement);
        },
        addNotification(message, type) {
            this.notification = {
                message: message,
                type: type,
            };

            setTimeout(() => {
                this.notification = null;
            }, 3000);
        },
        appendNumber(number) {
            this.enteredPin += number.toString();
        },
        selectAccount(account) {
            this.selectedAccountStatement = account;
        },
        setTransferType(type) {
            this.transferType = type;
        },
        setActiveView(view) {
            this.activeView = view;
            if (view === 'accountOptions' && this.selectedAccountStatement && this.selectedAccountStatement.type === 'shared') {
                this.getNearbyPlayers();
                this.filterUsers(); // Call filterUsers immediately after getting nearby players
                // Fetch names for existing shared account users (including the owner)
                let existingUsersToFetch = new Set();

                if (this.selectedAccountStatement.citizenid) {
                    existingUsersToFetch.add(this.selectedAccountStatement.citizenid);
                }

                if (this.selectedAccountStatement.users) {
                    try {
                        const parsedUsers = JSON.parse(this.selectedAccountStatement.users);
                        if (Array.isArray(parsedUsers)) {
                            parsedUsers.forEach(citizenid => existingUsersToFetch.add(citizenid));
                        }
                    } catch (e) {
                        console.error("Error parsing existing users for name fetch:", e);
                    }
                }
                
                Array.from(existingUsersToFetch).forEach(citizenid => {
                    if (!this.knownUsers[citizenid]) {
                        this.fetchUserName(citizenid);
                    }
                });
                // After queuing all fetches, start processing the queue
                this.processFetchQueue();
            } else if (view === 'home') { // Add this condition to re-render chart on home view activation
                this.$nextTick(() => {
                    this.renderChart();
                });
            }
        },
        formatCurrency(amount) {
            return new Intl.NumberFormat().format(amount);
        },
        filterUsers() {


            if (!this.nearbyPlayers || typeof this.nearbyPlayers !== "object" || this.nearbyPlayers.length === 0) {
                this.filteredUsers = [];

                return;
            }

            let existingUsers = [];
            if (this.selectedAccountStatement && this.selectedAccountStatement.users) {
                try {
                    existingUsers = JSON.parse(this.selectedAccountStatement.users);
                } catch (e) {
                    console.error("Error parsing existing users in filterUsers:", e);
                }
            }

            const availablePlayers = this.nearbyPlayers.filter(player => {
                return !existingUsers.includes(player.citizenid);
            });

            if (this.manageUserName === "") {
                this.filteredUsers = availablePlayers; // Show all available players if input is empty

            } else {
                const lowerCaseQuery = this.manageUserName.toLowerCase();
                this.filteredUsers = availablePlayers.filter((player) => {
                    return player.name.toLowerCase().includes(lowerCaseQuery) || player.citizenid.toLowerCase().includes(lowerCaseQuery);
                });

            }
        },
        selectUser(citizenid) {
            const selectedPlayer = this.nearbyPlayers.find(player => player.citizenid === citizenid);
            if (selectedPlayer) {
                this.manageUserName = selectedPlayer.citizenid; // Use citizenid instead of name
            } else {
                this.manageUserName = citizenid; // Fallback to citizenid if name not found
            }
            this.showUsersDropdown = false;
        },
        hideDropdown() {
            // Use a slight delay to allow click events on list items to register
            setTimeout(() => {
                this.showUsersDropdown = false;
            }, 100);
        },
        submitNewPin() {
            if (!this.existingCardNumber) { // Check if a card exists for the account first
                this.addNotification('You don\'t have a debit card for this account.', 'error');
                return;
            }

            // Client-side check if card is in inventory
            // Directly call proceedToChangePin if card is found, otherwise show lost card prompt
            // Assuming QBCore.Functions.HasItem is available client-side via NUI export or similar setup
            // For direct NUI access without a FiveM event, we'd need a client-side Lua callback that returns player inventory data.
            // For simplicity and based on typical QBCore setups, we'll simulate a client-side check if a direct export isn't immediately obvious.
            // A more robust solution might involve a `TriggerEvent('qb-banking:client:checkCard', cardNumber)` which then responds via `NUI` message.

            // Placeholder for client-side inventory check:
            axios.post("https://qb-banking/checkDebitCardInInventoryClient", {
                cardNumber: this.existingCardNumber,
            }).then(response => {
                if (response.data.isInInventory) {
                    this.proceedToChangePin();
                } else {
                    this.showChangePinPrompt = false; // Hide current prompt
                    this.showLostCardPrompt = true; // Show lost card prompt
                }
            }).catch(error => {
                this.addNotification('An error occurred while checking card presence.', "error");
            });
        },
        proceedToChangePin() {

            if (!this.newPin || !this.confirmNewPin) {
                this.addNotification("Please fill in both PIN fields.", "error");
                return;
            }
            if (this.newPin.length !== 4 || this.confirmNewPin.length !== 4) {
                this.addNotification("PIN must be 4 digits long.", "error");

                return;
            }
            if (this.newPin !== this.confirmNewPin) {
                this.addNotification("New PIN and Confirm PIN do not match.", "error");

                return;
            }

            axios.post("https://qb-banking/changeDebitCardPin", {
                cardNumber: this.existingCardNumber,
                newPin: this.newPin,
            }).then((response) => {
                if (response.data.success) {
                    this.addNotification(response.data.message, "success");
                    this.existingCardPin = this.newPin; // Update local state
                    this.newPin = "";
                    this.confirmNewPin = "";
                    this.showChangePinPrompt = false;
                } else {
                    this.addNotification(response.data.message, "error");

                }
            });
        },
        buyLostCard() {
            axios.post("https://qb-banking/buyLostDebitCard", {
                accountName: this.selectedAccountStatement.name,
            }).then(response => {
                if (response.data.success) {
                    this.addNotification(response.data.message, 'success');
                    this.showLostCardPrompt = false;
                    // Update local card details if needed (new PIN will be in response.newPin)
                    this.existingCardNumber = response.data.cardNumber; // Should be the same
                    this.existingCardPin = response.data.newPin; // Update with new PIN
                } else {
                    this.addNotification(response.data.message, 'error');
                }
            }).catch(error => {
                console.error('Error buying lost card:', error);
                this.addNotification('An error occurred while buying a new card.', "error");
            });
        },
        formatDate(timestamp) {
            const date = new Date(parseInt(timestamp));
            const month = (date.getMonth() + 1).toString().padStart(2, "0");
            const day = date.getDate().toString().padStart(2, "0");
            const year = date.getFullYear();
            return `${month}/${day}/${year}`;
        },
        balanceClass(statementType) {
            return statementType === "deposit" ? "positive-balance" : "negative-balance";
        },
        formatCardNumber(cardNumber) {
            if (!cardNumber) return "";
            return cardNumber.replace(/(\d{4})(?=\d)/g, '$1 ');
        },
        handleMessage(event) {
            const action = event.data.action;
            const resource = event.data.resource; // Capture resource if sent

            // Existing handleMessage logic
            if (action === "openBank") {
                this.openBank(event.data.accounts, event.data.statements, event.data.playerData);
            } else if (action === "openATM") {
                this.openATM(event.data);
                // REMOVED: Initial UI state handled by openATM function after PIN check
                // this.isBankOpen = false; 
                // this.isATMOpen = false;
                // this.showPinPrompt = true; 
            } else if (action === "setNearbyPlayers") {

                this.nearbyPlayers = event.data.players;
            }
            // Handle response for testNui via postMessage
            if (action === "testNuiResponse" && resource === "qb-banking") {
            }

            // Handle PIN verification response from Lua client event
            if (action === "pinVerificationResponse") {

                if (event.data.success) {
                    this.showPinPrompt = false;
                    this.isATMOpen = true;
                    this.enteredPin = "";
                } else {
                    this.addNotification(event.data.message, "error");
                    this.enteredPin = "";
                }
            }
        },
        handleKeydown(event) {
            if (event.key === "Escape") {
                if (this.showPinPrompt) {
                    this.showPinPrompt = false;
                    this.enteredPin = "";
                } else if (this.showChangePinPrompt) { // Also handle the change pin prompt
                    this.showChangePinPrompt = false;
                    this.newPin = "";
                    this.confirmNewPin = "";
                } else if (this.showLostCardPrompt) { // Handle lost card prompt as well
                    this.showLostCardPrompt = false;
                } else if (this.showDeleteConfirmPrompt) { // Handle delete confirm prompt
                    this.showDeleteConfirmPrompt = false;
                    this.accountToDeleteName = "";
                } else {
                    this.closeApplication();
                }
            }
        },
        closeApplication() {
            axios.post("https://qb-banking/closeApp");
            const bankingContainer = document.querySelector('.banking-container');
            if (bankingContainer) {
                bankingContainer.classList.add('fadeOut');
                setTimeout(() => {
                    this.isBankOpen = false;
                    this.isATMOpen = false;
                    this.notification = null;
                    this.activeView = "home";
                    this.selectedAccountStatement = "personal account";
                    this.selectedMoneyAmount = 0;
                    this.moneyReason = "";
                    this.transferType = "internal";
                    this.internalToAccount = null;
                    this.internalTransferAmount = 0;
                    this.externalAccountNumber = "";
                    this.externalTransferAmount = 0;
                    this.transferReason = "";
                    this.debitPin = "";
                    this.enteredPin = ""; // Clear entered PIN
                    this.tempBankData = null;
                    this.createAccountName = "";
                    this.createAccountAmount = 0;
                    this.editAccount = null;
                    this.editAccountName = "";
                    this.manageAccountName = null;
                    this.manageUserName = "";
                    this.filteredUsers = [];
                    this.showUsersDropdown = false;
                    this.nearbyPlayers = []; // Clear nearby players on close
                    this.showLostCardPrompt = false;
                    this.showDeleteConfirmPrompt = false; // Clear delete confirmation on close
                    this.accountToDeleteName = ""; // Clear account to delete name
                    bankingContainer.classList.remove('fadeOut');
                }, 400); // Duration of fadeOut animation in style.css
            } else {
                this.isBankOpen = false;
                this.isATMOpen = false;
                this.notification = null;
                this.activeView = "home";
                this.selectedAccountStatement = "personal account";
                this.selectedMoneyAmount = 0;
                this.moneyReason = "";
                this.transferType = "internal";
                this.internalToAccount = null;
                this.internalTransferAmount = 0;
                this.externalAccountNumber = "";
                this.externalTransferAmount = 0;
                this.transferReason = "";
                this.debitPin = "";
                this.enteredPin = ""; // Clear entered PIN
                this.tempBankData = null;
                this.createAccountName = "";
                this.createAccountAmount = 0;
                this.editAccount = null;
                this.editAccountName = "";
                this.manageAccountName = null;
                this.manageUserName = "";
                this.filteredUsers = [];
                this.showUsersDropdown = false;
                this.nearbyPlayers = []; // Clear nearby players on close
                this.showLostCardPrompt = false;
                this.showDeleteConfirmPrompt = false; // Clear delete confirmation on close
                this.accountToDeleteName = ""; // Clear account to delete name
            }
        },
        fetchUserName(citizenid) {

            // Add to queue instead of immediate fetch
            this.fetchQueue.push(citizenid);
            this.processFetchQueue();
        },

        async processFetchQueue() {
            if (this.isProcessingQueue || this.fetchQueue.length === 0) {
                return;
            }
            this.isProcessingQueue = true;
            const citizenidToFetch = this.fetchQueue.shift(); // Get next item from queue

            try {
                const response = await axios.post("https://qb-banking/getPlayerNameByCitizenId", { citizenid: citizenidToFetch });

                if (response.data.success) {
                    this.knownUsers = { ...this.knownUsers, [citizenidToFetch]: response.data.name };
                } else {
                    console.error("Failed to fetch name for citizen ID", citizenidToFetch, ":", response.data.message);
                    this.knownUsers = { ...this.knownUsers, [citizenidToFetch]: 'Unknown User (Failed Fetch)' };
                }
            } catch (error) {
                console.error("Error fetching name for citizen ID", citizenidToFetch, ":", error);
                this.knownUsers = { ...this.knownUsers, [citizenidToFetch]: 'Unknown User (Error)' };
            } finally {
                this.isProcessingQueue = false;
                // Process next item in queue after a short delay
                setTimeout(() => {
                    this.processFetchQueue();
                }, 50); // Small delay between requests
            }
        },
    },
    mounted() {
        window.addEventListener("message", this.handleMessage);
        window.addEventListener("keydown", this.handleKeydown);
    },
    beforeUnmount() {
        window.removeEventListener("message", this.handleMessage);
        window.removeEventListener("keydown", this.handleKeydown);
    },
}).mount("#app");
