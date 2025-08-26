import { useState, useEffect, useRef } from 'react'
import './App.css'
import { useNui, callNui } from "./utils/nui"

function DispatchList({visible, lang, data, dispatchData, location}) {
    const [searchValue, setValue] = useState('');
    const [isDragging, setIsDragging] = useState(false);
    const [position, setPosition] = useState({ x: 32, y: 32 }); 
    const [offset, setOffset] = useState({ x: 0, y: 0 });
    const alertBoxRef = useRef(null);

    const handleMouseDown = (e) => {
        setIsDragging(true);
        setOffset({
        x: e.clientX - position.x,
        y: e.clientY - position.y,
        });
    };

    const handleMouseMove = (e) => {
        if (isDragging) {
        setPosition({
            x: e.clientX - offset.x,
            y: e.clientY - offset.y,
        });
        }
    };

    const RespondAlert = (alertId) => {
        callNui("respondAlert", {
            alertId: alertId
        });
    }

    const handleMouseUp = () => {
        setIsDragging(false);
    };

    useEffect(() => {
        if (isDragging) {
        window.addEventListener('mousemove', handleMouseMove);
        window.addEventListener('mouseup', handleMouseUp);
        } else {
        window.removeEventListener('mousemove', handleMouseMove);
        window.removeEventListener('mouseup', handleMouseUp);
        }

        return () => {
        window.removeEventListener('mousemove', handleMouseMove);
        window.removeEventListener('mouseup', handleMouseUp);
        };
    }, [isDragging]);


    const ChangeValue = (e) => {
        setValue(e.target.value);
    }

    const filteredData = dispatchData.filter((item) => {
        const searchValueLower = searchValue.toLowerCase().trim();
        return (
            item.id.toString().includes(searchValueLower) || 
            item.type.toLowerCase().includes(searchValueLower)
        );
    });

    const DeleteDispatches = () => {
        callNui("deleteDispatches", {})
    }

    return (
        <div className={`${location} dispatchlist-container`}>
            <div className='dispatch-list-header'>
                <div className='dispatch-list-container-search'>
                    <span class="material-symbols-outlined">search</span>
                    <input 
                        className='dispatch-list-input' 
                        value={searchValue} 
                        onChange={ChangeValue} 
                        placeholder={lang.search}
                    />                
                </div>
                <div onMouseDown={handleMouseDown} className='dispatch-move-button'>
                    <span class="material-symbols-outlined">zoom_out_map</span>
                </div>
            </div>
            <div onClick={() => DeleteDispatches()}  className='delete-alerts-button'>{lang.deleteDispatches}</div>
            <div className='dispatch-list-alerts'>
            {filteredData.map((item, index) => (
                <div className={`dispatch-alert-box-custom ${(item.settingtype === 'DeathNotifications' || item.settingtype === 'emsWorkerInjured' || item.settingtype === 'civilianInjured') ? 'alert-code-ems-bg': ''}`}>
                 <div className='dispatch-alert-box-header'>
                     <div className='dispatch-alert-badge'>
                         <svg xmlns="http://www.w3.org/2000/svg" width="16" height="12" viewBox="0 0 16 16" fill="none">
                         <path d="M15.9507 8.88884C16.03 8.17434 16.0136 7.45244 15.9018 6.74229L14.7641 6.18232C14.5794 5.48637 14.287 4.82358 13.8975 4.21798L14.2574 3.00027C14.0336 2.72658 13.7931 2.46684 13.5375 2.22253C13.276 1.97619 12.9983 1.74755 12.7064 1.53812L11.5109 1.95143C10.8874 1.58941 10.2111 1.327 9.50659 1.1737L8.88884 0.0493121C8.17434 -0.0300143 7.45244 -0.0135736 6.74229 0.0981984L6.19565 1.23592C5.49838 1.42753 4.83552 1.72747 4.23131 2.12476L3.0136 1.76478C2.73599 1.98108 2.47181 2.21409 2.22253 2.46252C1.97314 2.72375 1.74152 3.00139 1.52923 3.29358L1.94254 4.48908C1.58052 5.11262 1.31811 5.78888 1.16481 6.49341L0.0493121 7.11116C-0.0300142 7.82566 -0.0135737 8.54756 0.0981983 9.25771L1.23592 9.81768C1.42753 10.515 1.72747 11.1778 2.12476 11.782L1.76478 12.9997C1.9815 13.2728 2.21451 13.5325 2.46252 13.7775C2.72403 14.0238 3.00167 14.2525 3.29358 14.4619L4.48908 14.0486C5.11262 14.4106 5.78888 14.673 6.49341 14.8263L7.11116 15.9507C7.82566 16.03 8.54756 16.0136 9.25771 15.9018L9.81768 14.7641C10.5136 14.5794 11.1764 14.287 11.782 13.8975L12.9997 14.2574C13.2734 14.0336 13.5332 13.7931 13.7775 13.5375C14.0238 13.276 14.2525 12.9983 14.4619 12.7064L14.0486 11.5109C14.4106 10.8874 14.673 10.2111 14.8263 9.50659L15.9507 8.88884ZM9.97767 8.64441L10.4443 11.3687L8 10.0977L5.55569 11.382L6.02233 8.65774L4.04021 6.72896L6.77784 6.33342L8 3.85355L9.22216 6.33342L11.9598 6.72896L9.97767 8.64441Z" fill="white"/>
                         </svg> 
                     </div>
                     <span className='dispatch-alert-title'>{!item.custom ? lang[item.type] : item.alertLabel}</span>
                     <div className='dispatch-alert-number'>#{item.id}</div>
                     <div className={`dispatch-alert-code ${(item.settingtype === 'DeathNotifications' || item.settingtype === 'emsWorkerInjured' || item.settingtype === 'civilianInjured') ? 'alert-code-ems': ''}`}>{item.code}</div>
                     <div className={`dispatch-alert-rightbox ${(item.settingtype === 'DeathNotifications' || item.settingtype === 'emsWorkerInjured' || item.settingtype === 'civilianInjured') ? 'dispatch-alert-box-right-ems' : ''}`}>
                        <i className={`fa-solid ${item.icon}`}></i>
                     </div>
                 </div>
                 <div className='dispatch-alert-box-middle'>
                     <div className='dispatch-alert-box-middle-item'>
                         <div className='dispatch-alert-box-middle-item-left'>
                             <svg xmlns="http://www.w3.org/2000/svg" width="12" height="9" viewBox="0 0 12 12" fill="none">
                             <path d="M11.9999 6.00052C11.9999 3.57254 10.5374 1.38642 8.29689 0.456385C6.05443 -0.471685 3.47252 0.0420364 1.75704 1.75754C0.0414695 3.47304 -0.472261 6.05288 0.457717 8.29521C1.38582 10.5376 3.5739 12 6.00014 12C9.31317 12 11.9999 9.31341 11.9999 6.00052ZM7.32189 9.03595C7.06315 9.19156 6.72939 9.13906 6.53067 8.9122L4.71762 6.84982C4.57887 6.69046 4.52825 6.47297 4.5845 6.2705L5.39635 3.33255H5.39822C5.48259 3.03632 5.76946 2.84509 6.07697 2.8807C6.38446 2.9182 6.61696 3.17506 6.62445 3.48441L6.68445 5.87864L7.58443 8.28036H7.5863C7.6913 8.56347 7.58063 8.88034 7.32189 9.03595Z" fill="white"/>
                             </svg>
                         </div>
                     <div className='dispatch-alert-box-middle-item-right'>
                         <p><span className='font-white'>{lang.time}: </span> {item.timestring}</p>
                     </div>
                     </div>
                    {item.vehicle && 
                        <>
                        <div className='dispatch-alert-box-middle-item'>
                            <div className='dispatch-alert-box-middle-item-left'>
                            <span class="material-symbols-outlined">car_rental</span>
                            </div>
                            <div className='dispatch-alert-box-middle-item-right'>
                            <p><span className='font-white'>{lang.plate}: </span> {item.eventVehicleData.vehiclePlate}</p>
                            </div>
                        </div>
                        <div className='dispatch-alert-box-middle-item'>
                            <div className='dispatch-alert-box-middle-item-left'>
                            <span class="material-symbols-outlined">directions_car</span>
                            </div>
                            <div className='dispatch-alert-box-middle-item-right'>
                            <p><span className='font-white'>{lang.class}: </span> {item.eventVehicleData.vehicleClassName}</p>
                            </div>
                        </div>
                        <div className='dispatch-alert-box-middle-item'>
                            <div className='dispatch-alert-box-middle-item-left'>
                                <span class="material-symbols-outlined">colorize</span>
                            </div>
                            <div className='dispatch-alert-box-middle-item-right'>
                            <p><span className='font-white'>{lang.color}: </span> {item.eventVehicleData.vehicleColorName}</p>
                            </div>
                        </div>
                     </>
                    }
                     <div className='dispatch-alert-box-middle-item'>
                         <div className='dispatch-alert-box-middle-item-left'>
                             <svg xmlns="http://www.w3.org/2000/svg" width="12" height="9" viewBox="0 0 12 12" fill="none">
                                 <path d="M6 0C2.69207 0 0 2.6921 0 6C0 9.3079 2.6921 12 6 12C9.3079 12 12 9.3079 12 6C12 2.6921 9.3079 0 6 0ZM8.29926 7.97218C8.03096 8.20086 7.65283 8.22576 7.35737 8.03557L6 7.16274L4.64263 8.03557C4.51018 8.12048 4.36188 8.16237 4.21356 8.16237C4.03017 8.16237 3.84791 8.09784 3.69961 7.97218C3.43131 7.7435 3.34639 7.37331 3.48791 7.05179L5.27322 2.97064C5.40114 2.67744 5.67962 2.4963 5.99888 2.4963C6.31814 2.4963 6.59662 2.67857 6.72454 2.97064L8.50985 7.05179C8.65023 7.37444 8.56532 7.74462 8.29702 7.97218H8.29926Z" fill="white"/>
                             </svg>
                         </div>
                         <div className='dispatch-alert-box-middle-item-right'>
                             <p><span className='font-white'>{lang.location}: </span> {item.address}</p>
                         </div>
                     </div>
                     <div className='dispatch-alert-box-middle-item'>
                         <div className='dispatch-alert-box-middle-item-left'>
                            <span class="material-symbols-outlined">groups</span>
                         </div>
                         <div className='dispatch-alert-box-middle-item-right'>
                            <p><span className='font-white'>{lang.responders}: </span> {item.responders.join(', ')}</p>
                         </div>
                     </div>
                      {item.weapon !== 'Fists' && item.weapon !== undefined && !item.vehicle ? (
                          <><div className='dispatch-alert-box-middle-item'>
                                <div className='dispatch-alert-box-middle-item-left'>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="9" viewBox="0 0 12 12" fill="none">
                                        <path d="M5.61176 9.19071C7.39189 8.29483 8.11125 5.94994 7.11417 4.27282C6.71072 4.51786 6.4043 4.88607 6.2439 5.31857C7.12317 8.93221 1.43583 9.72302 1.22452 5.99992C1.2254 5.34661 1.49538 4.7203 1.97524 4.25836C2.45511 3.79641 3.10569 3.53653 3.78431 3.53571C4.11085 3.53486 4.43444 3.59527 4.73698 3.71357C4.97659 3.37116 5.26937 3.06618 5.60507 2.80928C3.15692 1.45951 -0.0392427 3.27103 0.000364526 6.00005C0.00147496 6.85456 0.313972 7.6816 0.883408 8.33709C1.45284 8.99258 2.24312 9.43496 3.11654 9.58714V9.99857H2.59569C2.53671 9.99874 2.4802 10.0214 2.43849 10.0615C2.39679 10.1017 2.37328 10.1561 2.3731 10.2129V11.07C2.37328 11.1268 2.39679 11.1812 2.43849 11.2213C2.4802 11.2615 2.53671 11.2841 2.59569 11.2843H3.11654V11.7857C3.11672 11.8425 3.14023 11.8969 3.18193 11.9371C3.22364 11.9772 3.28015 11.9998 3.33913 12H4.22948C4.28846 11.9998 4.34498 11.9772 4.38668 11.9371C4.42839 11.8969 4.45189 11.8425 4.45207 11.7857V11.2843H4.97293C5.03191 11.2841 5.08842 11.2615 5.13012 11.2213C5.17183 11.1812 5.19534 11.1268 5.19551 11.07V10.2129C5.19534 10.1561 5.17183 10.1017 5.13012 10.0615C5.08842 10.0214 5.03191 9.99874 4.97293 9.99857H4.45207V9.58714C4.85866 9.51735 5.2505 9.3834 5.61176 9.19071Z" fill="white" />
                                        <path d="M8.90383 2.41285V1.85142L9.31117 2.11071C9.33766 2.12744 9.36755 2.13855 9.39885 2.14328C9.43016 2.14801 9.46215 2.14627 9.49269 2.13815C9.52324 2.13004 9.55163 2.11575 9.57599 2.09624C9.60034 2.07673 9.62009 2.05244 9.63392 2.02499L10.019 1.25142C10.0426 1.20394 10.0473 1.14975 10.0321 1.09917C10.0169 1.04859 9.98295 1.00515 9.93664 0.977136L8.35404 0.032135C8.31856 0.0111241 8.27772 0 8.23606 0C8.19441 0 8.15357 0.0111241 8.11809 0.032135L6.53549 0.977136C6.48918 1.00515 6.45519 1.04859 6.44001 1.09917C6.42482 1.14975 6.42949 1.20394 6.45313 1.25142L6.83821 2.02499C6.85204 2.05244 6.87179 2.07673 6.89614 2.09625C6.92049 2.11576 6.94889 2.13005 6.97944 2.13816C7.00998 2.14628 7.04197 2.14802 7.07327 2.14329C7.10458 2.13855 7.13447 2.12745 7.16096 2.11071L7.5683 1.85142V2.41285C5.07702 2.80159 3.66809 5.61528 4.90621 7.72501C5.30742 7.47949 5.61331 7.11344 5.77648 6.68357C5.60398 6.09346 5.66427 5.46278 5.94576 4.9129C6.22725 4.36302 6.71004 3.93278 7.30123 3.705C8.92459 3.05828 10.8326 4.29855 10.7958 6.00001C10.7949 6.65333 10.525 7.27965 10.0451 7.74162C9.56528 8.20358 8.91469 8.46347 8.23607 8.46428C7.90953 8.46513 7.58594 8.40472 7.2834 8.28643C7.0423 8.62774 6.74886 8.93191 6.41308 9.18857C11.6527 11.6228 14.5958 3.7366 8.90383 2.41285Z" fill="white" />
                                    </svg>
                                </div>
                                <div className='dispatch-alert-box-middle-item-right'>
                                    <p><span className='font-white'>{lang.gender} </span> {item.gender}</p>
                                </div>
                            </div><div className='dispatch-alert-box-middle-item'>
                                    <div className='dispatch-alert-box-middle-item-left'>
                                        <svg xmlns="http://www.w3.org/2000/svg" width="10" height="8" viewBox="0 0 12 10" fill="none">
                                            <path d="M1.566 1.59C1.566 2.016 1.728 2.412 2.031 2.715C2.4915 3.1755 3.2295 3.2925 3.8115 3.033C3.8805 2.382 4.2225 1.815 4.731 1.458C4.662 0.636 3.993 0 3.1515 0C2.2755 0 1.566 0.714 1.566 1.59Z" fill="white" />
                                            <path d="M8.844 3.18C9.72 3.18 10.434 2.466 10.434 1.59C10.434 0.714 9.72 0 8.844 0C8.0175 0 7.332 0.651 7.269 1.4625C7.773 1.8195 8.1105 2.382 8.184 3.0225C8.385 3.12 8.61 3.18 8.844 3.18Z" fill="white" />
                                            <path d="M10.116 3.0615C9.774 3.3555 9.333 3.546 8.844 3.546C8.619 3.546 8.3985 3.5025 8.1885 3.429C8.154 3.8895 7.983 4.305 7.7085 4.6425C8.652 5.1465 9.3615 6.0165 9.7245 7.0785C10.4625 7.0155 11.031 6.888 11.4165 6.7455C11.799 6.603 12 6.4425 12 6.3195C12 6.3195 11.9955 6.3195 11.9955 6.315C11.9955 4.8915 11.262 3.6345 10.116 3.0615Z" fill="white" />
                                            <path d="M5.997 1.4235C4.98 1.4235 4.158 2.25 4.158 3.2625C4.158 4.2795 4.98 5.1075 5.997 5.1075C7.014 5.1075 7.842 4.281 7.842 3.2625C7.842 2.25 7.0155 1.4235 5.997 1.4235Z" fill="white" />
                                            <path d="M7.4505 4.9155C7.059 5.2575 6.555 5.4735 5.997 5.4735C5.439 5.4735 4.935 5.259 4.5435 4.9155C3.8835 5.244 3.3405 5.772 2.958 6.4215C2.5815 7.0725 2.3655 7.845 2.3655 8.667C2.3655 9.024 3.5685 9.5625 5.7405 9.6015C5.829 9.606 5.916 9.612 5.9955 9.606C6.0885 9.606 6.1815 9.606 6.27 9.6015C7.3515 9.5775 8.187 9.435 8.76 9.2535C9.327 9.0675 9.6255 8.8425 9.6255 8.667C9.627 7.0245 8.772 5.571 7.4505 4.9155Z" fill="white" />
                                            <path d="M4.2855 4.6425C4.011 4.305 3.84 3.8895 3.8055 3.4335C3.5955 3.5025 3.375 3.546 3.15 3.546C2.676 3.546 2.2305 3.3705 1.878 3.0615C0.7335 3.6345 0 4.896 0 6.315V6.3195C0 6.5685 0.792 6.96 2.2695 7.077C2.6325 6.021 3.3405 5.1465 4.2855 4.6425Z" fill="white" />
                                        </svg>
                                    </div>

                                    <div className='dispatch-alert-box-middle-item-right' style={{ width: "54%", float: "left" }}>
                                        <p><span className='font-white'>{lang.weapon}: </span> {item.weapon}</p>
                                    </div>

                                    <div onClick={() => RespondAlert(item.id)} className={`dispatch-alert-box-responde active`}>
                                        <span className='dispatch-alert-box-respondo-string' style={{ "color": "#fff" }}>{lang.respond}</span>
                                    </div>
                                </div></>
                        ) : (
                            <div className='dispatch-alert-box-middle-item'>
                                <div className='dispatch-alert-box-middle-item-left'>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="10" height="8" viewBox="0 0 12 10" fill="none">
                                    <path d="M1.566 1.59C1.566 2.016 1.728 2.412 2.031 2.715C2.4915 3.1755 3.2295 3.2925 3.8115 3.033C3.8805 2.382 4.2225 1.815 4.731 1.458C4.662 0.636 3.993 0 3.1515 0C2.2755 0 1.566 0.714 1.566 1.59Z" fill="white"/>
                                    <path d="M8.844 3.18C9.72 3.18 10.434 2.466 10.434 1.59C10.434 0.714 9.72 0 8.844 0C8.0175 0 7.332 0.651 7.269 1.4625C7.773 1.8195 8.1105 2.382 8.184 3.0225C8.385 3.12 8.61 3.18 8.844 3.18Z" fill="white"/>
                                    <path d="M10.116 3.0615C9.774 3.3555 9.333 3.546 8.844 3.546C8.619 3.546 8.3985 3.5025 8.1885 3.429C8.154 3.8895 7.983 4.305 7.7085 4.6425C8.652 5.1465 9.3615 6.0165 9.7245 7.0785C10.4625 7.0155 11.031 6.888 11.4165 6.7455C11.799 6.603 12 6.4425 12 6.3195C12 6.3195 11.9955 6.3195 11.9955 6.315C11.9955 4.8915 11.262 3.6345 10.116 3.0615Z" fill="white"/>
                                    <path d="M5.997 1.4235C4.98 1.4235 4.158 2.25 4.158 3.2625C4.158 4.2795 4.98 5.1075 5.997 5.1075C7.014 5.1075 7.842 4.281 7.842 3.2625C7.842 2.25 7.0155 1.4235 5.997 1.4235Z" fill="white"/>
                                    <path d="M7.4505 4.9155C7.059 5.2575 6.555 5.4735 5.997 5.4735C5.439 5.4735 4.935 5.259 4.5435 4.9155C3.8835 5.244 3.3405 5.772 2.958 6.4215C2.5815 7.0725 2.3655 7.845 2.3655 8.667C2.3655 9.024 3.5685 9.5625 5.7405 9.6015C5.829 9.606 5.916 9.612 5.9955 9.606C6.0885 9.606 6.1815 9.606 6.27 9.6015C7.3515 9.5775 8.187 9.435 8.76 9.2535C9.327 9.0675 9.6255 8.8425 9.6255 8.667C9.627 7.0245 8.772 5.571 7.4505 4.9155Z" fill="white"/>
                                    <path d="M4.2855 4.6425C4.011 4.305 3.84 3.8895 3.8055 3.4335C3.5955 3.5025 3.375 3.546 3.15 3.546C2.676 3.546 2.2305 3.3705 1.878 3.0615C0.7335 3.6345 0 4.896 0 6.315V6.3195C0 6.5685 0.792 6.96 2.2695 7.077C2.6325 6.021 3.3405 5.1465 4.2855 4.6425Z" fill="white"/>
                                    </svg>
                                </div>                            
                                
                                <div className='dispatch-alert-box-middle-item-right' style={{width: "54%", float: "left"}}>
                                    <p><span className='font-white'>{lang.gender}: </span> {item.gender}</p>
                                </div>
                                
                                <div onClick={() => RespondAlert(item.id)} className={`dispatch-alert-box-responde active`}>
                                    <span className='dispatch-alert-box-respondo-string' style={{"color": "#fff"}}>RESPOND</span>
                                </div>
                            </div>
                        )}
                 </div>
             </div>
            ))}
            </div>
        </div>
    );
    
}


export default DispatchList;
