import React, { Component } from 'react';
import './App.css';
import Dispatch from './dispatch';
import DispatchAdmin from './dispatch-admin';
import DispatchList from './dispatch-list';
import { useNui, callNui } from "./utils/nui";

export default class App extends Component {    
    state = {
        visible: false,
        showDispatchAdmin: false,
        showDispatch: false,
        lang: {},
        settings: {},
        topAlerts: 0,
        dataDispatch: [],
        location: null,
        currentAlert: 0,
        dispatchList: [],
        dispatchData: [],
        showDispatchList: false,
        latestAlertId: null 
    }

    handleKeyDown = (event) => {
        if (event.key === 'Escape') {
            this.setState({ showDispatchAdmin: false, showDispatchList: false});
            callNui('disableNUI', {});
        }
    }

    componentDidMount() {
        useNui("OpenDispatchAdmin", (data) => {
            this.setState({
                showDispatchAdmin: true,
                lang: data.lang,
                settings: data.settings
            });
        });

        useNui("alertSiren", (data) => {
            this.runAlertSiren(data.id);
        });

        useNui("closeDispatchList", (data) => {
            callNui('disableNUI', {});
            this.setState({
                showDispatchList: false
            })
        });

        useNui("OpenDispatchList", (data) => {
            this.setState({
                lang: data.lang, 
                dispatchList: data.dispatchData,
                dispatchData: data.dispatchlist,
                location: data.location,
                showDispatchList: true
            })
        });

        useNui("DispatchAlert", (data) => {
            this.setState((prevState) => ({
                lang: data.lang,
                location: data.location,
                currentAlert: data.dispatchData.id,
                dataDispatch: [data.dispatchData, ...prevState.dataDispatch],
                showDispatch: true,
                latestAlertId: data.dispatchData.id 
            }));
        });
        
        useNui("hideAlert", (data) => {
            this.hideAlert(data.id);
        });

        useNui("changeAlert", (data) => {
            const previousAlertBox = document.querySelector(`.dispatch-alert-box.selected`);
            if (previousAlertBox) {
                previousAlertBox.classList.remove('selected');
            }

            const alertIndex = this.state.dataDispatch.findIndex((alert) => alert.id === data.topalerts);
            if (alertIndex !== -1) {
                const alertBox = document.querySelector(`.dispatch-alert-box[data-id="${data.topalerts}"]`);
                if (alertBox) {
                    alertBox.classList.add('selected');
                }
            }
        });
        
        document.addEventListener('keydown', this.handleKeyDown);
    }

    componentWillUnmount() {
        document.removeEventListener('keydown', this.handleKeyDown);
    }

    closeDispatchAdmin = () => {
        this.setState({ showDispatchAdmin: false });
        callNui('disableNUI', {});
    }
    

    runAlertSiren = (id) => {
        const alertIndex = this.state.dataDispatch.findIndex((alert) => alert.id === id);
        if (alertIndex !== -1) {
            const alertBox = document.querySelector(`.dispatch-alert-box[data-id="${id}"]`);
            alertBox.classList.add('siren');
        }
    }

    hideAlert = (id) => {
        const alertIndex = this.state.dataDispatch.findIndex((alert) => alert.id === id);
        if (alertIndex !== -1) {
            const alertBox = document.querySelector(`.dispatch-alert-box[data-id="${id}"]`);
            if (alertBox) {
                alertBox.classList.add('slide-out');
                
                setTimeout(() => {
                    this.setState((prevState) => ({
                        dataDispatch: prevState.dataDispatch.filter((alert) => alert.id !== id)  
                    }));
                }, 500); 
            } else {
                // console.log(`Alert box with id ${id} not found.`);
            }
        }
    }

    disableRespondButton = (id, key, respond, typec) => {
        const alertId = this.state.currentAlert;
        const previousAlertId = alertId > 1 ? alertId - 1 : null;
        const alertBox = document.querySelector(`.dispatch-alert-box[data-id="${alertId}"]`);
        if (previousAlertId) {
            const previousAlertBox = document.querySelector(`.dispatch-alert-box[data-id="${previousAlertId}"]`);
            if (previousAlertBox) {
                const previousRespondeDiv = previousAlertBox.querySelector('.dispatch-alert-box-responde');
                if (previousRespondeDiv) {
                    const previousButton = previousRespondeDiv.querySelector('.dispatch-alert-box-responde-button');
                    if (previousButton) {
                        previousButton.remove(); 
                    }
                }
            }
        }
    
        if (alertBox) {
            let respondeDiv = alertBox.querySelector('.dispatch-alert-box-responde');
            if (!respondeDiv) {
                respondeDiv = document.createElement('div');
                respondeDiv.className = 'dispatch-alert-box-responde';
                alertBox.appendChild(respondeDiv);
            }
    
            let eButton = respondeDiv.querySelector('.dispatch-alert-box-responde-button');
            if (!eButton) {
                eButton = document.createElement('div');
                eButton.className = 'dispatch-alert-box-responde-button';
                respondeDiv.insertBefore(eButton, respondeDiv.firstChild);
            }
            eButton.textContent = key;
    
            let respondText = respondeDiv.querySelector('.dispatch-alert-box-respondo-string');
            if (!respondText) {
                respondText = document.createElement('span');
                respondText.className = 'dispatch-alert-box-respondo-string';
                respondeDiv.appendChild(respondText);
            }
            respondText.textContent = respond;
            respondText.style.color = 'white';
        } else {
            // console.log(`Alert box with id ${this.state.currentAlert} not found.`);
        }
    };      
    
    render() {
        return (
            <div id='rootLand'>
                <div className={`dispatch-alert-wrapper ${this.state.location}`}>
                    {this.state.showDispatch && 
                        this.state.dataDispatch.map((data, index) => (
                        <div className={`dispatch-alert-scale-wrapper`} key={data.id}>
                            <Dispatch 
                            id={data.id} 
                            visible={this.state.showDispatch} 
                            lang={this.state.lang}
                            data={data} 
                            location={this.state.location}
                            index={index}
                            disableRespond={this.disableRespondButton}
                            currentId={this.state.currentAlert}
                            />
                        </div>
                        ))
                    }
                 </div>



                {this.state.showDispatchAdmin && 
                    <DispatchAdmin 
                        visible={this.state.showDispatchAdmin} 
                        lang={this.state.lang} 
                        data={this.state.settings} 
                        onClose={this.closeDispatchAdmin} 
                    />
                }

                {this.state.showDispatchList &&
                    <DispatchList
                        visible={this.state.showDispatchList}
                        lang={this.state.lang}
                        data={this.state.dispatchList}
                        location={this.state.location}
                        dispatchData={this.state.dispatchData}
                    />
                }
            </div>
        );
    }
}
