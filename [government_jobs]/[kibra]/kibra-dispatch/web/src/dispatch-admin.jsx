import { useEffect, useState } from 'react'
import './App.css'
import { useNui, callNui } from "./utils/nui"

function DispatchAdmin({ lang, data, visible, onClose}) {
    const [settings, setSettings] = useState(data);
    const [openedAddReceiver, setAddReceiver] = useState(false);
    const [newJobName, setNewJobName] = useState('');
    const [willAddReceiver, setReceiverAddedType] = useState(null);
    const [zoneData, setZoneData] = useState(null);
    const [spamTime, setSpamTime] = useState('2');

    useEffect(() => {
        const exclusionData = settings.find(element => element.type === 'dispatchExclusion');
        const spamDelayData = settings.find(element => element.type == 'spamDelayTime');
        spamDelayData ? setSpamTime(spamDelayData.value) : setSpamTime(1);
        exclusionData ? setZoneData(exclusionData) : setZoneData({});
    }, [settings]);

    const ToggleReceiverMenu = (type) => {
        setAddReceiver(prevState => !prevState);
        setReceiverAddedType(type);
    };

    const ToggleAddCoordMenu = () => {
        callNui('setAddCoordScreen', {});
        onClose();
    }

    const handleCheckboxChange = (index) => {
        const newSettings = [...settings];
        if(index >= 0){
            newSettings[index].state = !newSettings[index].state;
            setSettings(newSettings); 
            callNui('updateSettingState', {
                type: newSettings[index].type, 
                datatype: 'state',
                data: newSettings[index].state
            })
        }
    };
    
    const handleAddJob = () => {
        callNui('addNewReceiver', {
            type: willAddReceiver,
            data: newJobName,
            datatype: 'receivers'
        }, function(data){
            if(data !== false){
                ToggleReceiverMenu(true);
                UpdateReceiverMenu(willAddReceiver, data);
                setNewJobName('');
            };
        });
    }
    
    const UpdateReceiverMenu = (type, newReceivers) => {
        const updatedSettings = settings.map(setting => {
            if (setting.type === type) {
                if (Array.isArray(setting.receivers)) {
                    return { ...setting, receivers: newReceivers };
                } else {
                    console.error('Receivers is not an array:', setting.receivers);
                    return setting; 
                }
            }
            return setting;
        });
        
        setSettings(updatedSettings);
    };

    const UpdateZones = (data) => {
        const updatedZoneData = {
            ...zoneData, 
            coords: data.coords 
        };
        
        setZoneData(updatedZoneData);
    };
    
    const RemoveSelectedJob = (data, typex) => {
        callNui('removeJobInSettings', {
            data: data,
            type: typex
        }, function(success){
            if (success !== false){
                UpdateReceiverMenu(data, success);
            }
        });
    }

    const DeleteZone = (data) => {
        callNui('removeZone', {
            zone: data
        }, function(callback){
            if(callback !== false){
                UpdateZones(callback);
            }
        });
    }

    const handleInputChange = (e) => {
        setNewJobName(e.target.value);
    }

    const UpdateDelayTime = (e) => {
        const value = e.target.value === "" ? "" : Number(e.target.value); 
        if (value === "" || value > 0) { 
            setSpamTime(value);
        }
    };
    

    const UpdateSpamDelayTime = () => {
        callNui('updateDelayTime', {
            data: spamTime,
            typex: 'spamDelayTime'
        });
    }

    return (
        <div className='dispatch-admin'>
            <div className='dispatch-admin-header'>
                <span className='dispatch-header-title'>{lang.dispatchAdmin}</span>
                <span className='dispatch-header-desc'>{lang.manageDispatchSystem}</span>
            </div>
            <div className='dispatch-admin-container'>
                <div className="dispatch-admin-item">
                    <span className='dispatch-admin-item-header'>
                        {lang.spamPeriod}
                    </span>
                    <div className='dispatch-item-infobro'>
                        <span className='dispatch-admin-item-header-infoland'>{lang.spamPeriodInfo}</span>
                        <div className='dispatch-item-receivers2'>
                            <input id='spamTime' className='dispatch-input' value={spamTime} onChange={UpdateDelayTime}></input>
                            <div onClick={() => UpdateSpamDelayTime()} className='dispatch-input-update-time'><span className="fontx material-symbols-outlined">check</span></div>
                        </div>
                    </div>
                </div>
                {settings.map((setting, index) => (
                    setting.type !== 'dispatchExclusion' && setting.type !== 'spamDelayTime' && (
                        <div className="dispatch-admin-item" key={index}>
                            <span className='dispatch-admin-item-header'>
                                {lang[setting.type]}
                            </span>
                            <label className="switch">
                                <input
                                    type="checkbox"
                                    checked={setting.state}
                                    onChange={() => handleCheckboxChange(index)}
                                />
                                <span className="slider"></span>
                            </label>
                            <div className='dispatch-item-infobro'>
                                <span onClick={() => ToggleReceiverMenu(setting.type)} className="material-symbols-outlined hajcn">add_circle</span>
                                <span className='dispatch-admin-item-header-infoland'>{lang.receiversString}</span>
                                <div className='dispatch-item-receivers'>
                                    {setting.receivers.map((jobName, indexLand) => (
                                        <div onClick={() => RemoveSelectedJob(setting.type, jobName)} className="dispatch-add-new-receiver" key={indexLand}>
                                            {jobName}
                                        </div>
                                    ))}
                                </div>
                            </div>
                        </div>
                    )
                ))}

                <div className="dispatch-admin-item">
                    <span className='dispatch-admin-item-header'>
                        {lang.dispatchExclusionZones}
                    </span>
                    <div className='dispatch-item-infobro'>
                        <span onClick={ToggleAddCoordMenu} className="material-symbols-outlined hajcn">add_circle</span>
                        <span className='dispatch-admin-item-header-infoland'>{lang.coordinates}</span>
                        <div className='dispatch-item-receivers'>
                            {zoneData?.coords?.map((element, indexLand) => (
                                <div onClick={() => DeleteZone(element.name)} className="dispatch-add-new-receiver" key={indexLand}>
                                    {element.name} (vector3({element.coord.x}, {element.coord.y}, {element.coord.z}))
                                </div>
                            ))}
                        </div>
                    </div>
                </div>

            </div>
            
            {openedAddReceiver && (
                <div className={`display-black ${openedAddReceiver ? 'show' : ''}`}>
                    <span className='display-black-add-title'>
                        {lang.addNewJob}
                    </span>
                    <input value={newJobName} onChange={handleInputChange} className='display-black-input' placeholder={lang.jobName}></input>
                    <div onClick={handleAddJob} className='display-black-add-button'>{lang.add}</div>
                    <div onClick={ToggleReceiverMenu} className='display-black-cancel-button'>{lang.cancel}</div>
                </div>
            )}
        </div>
    )
}

export default DispatchAdmin;
