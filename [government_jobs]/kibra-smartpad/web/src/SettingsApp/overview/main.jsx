import React, {useEffect, useState} from 'react'
import './main.css'
import { callNui } from '../../nui';

const Overview = ({apps, themeMode, lang, tabData}) =>  {
    const [settings, setSettings] = useState({
        planemode: tabData.data.planemode,
        notifications: tabData.data.notifications,
        walkanduse: tabData.data.walkanduse
    });
    
    const handleToggle = (key) => {
        setSettings((prev) => {
            const newSettings = {
                ...prev,
                [key]: !prev[key],
            };
    
            callNui("UpdateTabletData", {
                datatype: key,
                result: newSettings[key],
            });
    
            return newSettings;
        });
    };
    
    return(
        <div className={`overview-page-container ${themeMode == 'light' ? 'lightmode' : ''}`}>
            <span className='overview-page-header'>{lang.generalSettings}</span>
            <div className="overview-items">
                <div className={`overview-item ${themeMode == 'light' ? 'lightmode':''}`}>
                    <div style={{float: 'left'}}>
                        <span className='overview-item-left'>{lang.planeMode}</span>
                    </div>
                    <div style={{float: 'right'}}>
                        <div className='overview-item-right'>
                            <label className="switch">
                                <input checked={settings.planemode}
                                    onChange={() => handleToggle("planemode")} 
                                    type="checkbox" 
                                />
                                <span className="slider"></span>
                            </label>
                        </div>
                    </div>
                </div>
                <div className={`overview-item ${themeMode == 'light' ? 'lightmode':''}`}>
                    <div style={{float: 'left'}}>
                        <span className='overview-item-left'>{lang.useTabletWhileWalking}</span>
                    </div>
                    <div style={{float: 'right'}}>
                        <div className='overview-item-right'>
                            <label className="switch">
                                <input checked={settings.walkanduse}
                                    onChange={() => handleToggle("walkanduse")} 
                                    type="checkbox"/>
                                <span className="slider"></span>
                            </label>
                        </div>
                    </div>
                </div>
                <div className={`overview-item ${themeMode == 'light' ? 'lightmode':''}`}>
                    <div style={{float: 'left'}}>
                        <span className='overview-item-left'>{lang.notifications}</span>
                    </div>
                    <div style={{float: 'right'}}>
                        <div className='overview-item-right'>
                            <label className="switch">
                                <input checked={settings.notifications}
                                    onChange={() => handleToggle("notifications")} 
                                    type="checkbox"/>
                                <span className="slider"></span>
                            </label>
                        </div>
                    </div>
                </div>
                <span className='apps-label'>{lang.applications}</span>
                <div className='apps-list'>
                    {apps.map((row) => 
                        <div className={`overview-item ${themeMode == 'light' ? 'lightmode':''}`}>
                            <div style={{float: 'left', justifyContent: 'flex-start', display: 'flex'}}>
                                <img src={row.icon}></img>
                                <span className='appname-item-left'>{row.name}</span>
                            </div>
                            {/* <div style={{float: 'right'}}>
                                <i style={{color: 'gray', marginRight: '1rem'}} className="fa-solid fa-chevron-right"></i>
                            </div> */}
                        </div>
                    )}
                </div>
            </div>
        </div>
    )
}

export default Overview;