import React, {useState, useEffect} from 'react'
import './main.css'
import TabletNameModal from './modal';
import { callNui } from '@/nui';

const AboutDevice = ({themeMode, lang, allLang, tabData, Notification}) => {
    const [isModalOpen, closeModal] = useState(false);
    const [isLoading, setIsLoading] = useState(false);
    const [currLang, setNewLang] = useState(false);
    const [langScreen, setLangScreen] = useState(false);
    const [selectedLang, setLangSelect] = useState(null);
    const [IsAboutDevice, setAboutDevice] = useState(true);
    const [tabletName, setTabName] = useState('Tablet');

    useEffect(() => {
        setTabName(tabData.data.deviceName);
    }, []);

    const selectNewLang = (lang) => {
        setLangSelect(lang);
        setLangScreen(false);
        setAboutDevice(true);
        callNui("UpdateTabletData", {
            datatype: 'lang',
            result: lang
        })
    }

    const deviceInfos = [
        {"infoName": 'Name', "data": tabletName},
        {"infoName": 'resOSVersion', "data": "1.2.0"},
        {"infoName": 'Model', "data": "Kibra SmartPad 1"},
        {"infoName": 'Model Number', "data": 19484957812},
        {"infoName": 'Serial Number', "data": tabData.serialnumber},
        {"infoName": 'Photos', "data": tabData.gallery.length},
        {"infoName": 'Videos', "data": 4},
    ];    
    
    const openLangScreen = () => {
        setAboutDevice(false);
        setLangScreen(true);
    }

    const handleCheck = () => {
        setIsLoading(true); // Loader'ı göster
        setTimeout(() => {
          setIsLoading(false); // Loader'ı gizle
        }, 5000); // 5 saniye sonra işlemi tamamla
    };

    const toggleModal = () => {
        if(isModalOpen){
            closeModal(false)
        } else {
            closeModal(true);
        }
    };
    
    return(
        <div style={{width: '87%'}}>
            <div className='aboutdevice-frame'>
                {IsAboutDevice ? (
                    <div className='aboutdevice-frame-label'>{lang.aboutDevice}</div>
                ):                     
                    <div className='aboutdevice-frame-label'>{lang.selectLanguage}</div>
                }
                <div className={`aboutdevice-form ${themeMode == 'light' ? 'lightmode' : ''}`}>
                    {IsAboutDevice && (<> 
                        {deviceInfos.map((row) => (
                            <div className={`aboutdevice-form-item ${themeMode == 'light' ? 'lightmode' : ''}`}>
                                <div style={{float: 'left'}}>
                                    <span className='aboutdevice-form-item-left'>
                                        {row.infoName}
                                    </span>
                                </div>
                                <div style={{cursor: 'pointer',float: 'right'}}>
                                    {row.infoName == 'Name' ? (
                                        <span onClick={() => toggleModal()} className='aboutdevice-form-item-right'>
                                            {row.data}
                                        </span>  
                                    ): <span  className='aboutdevice-form-item-right'>
                                        {row.data}
                                        </span>
                                    }
                                </div>
                            </div> 
                        ))}

                        <div className={`aboutdevice-form-item ${themeMode == 'light' ? 'lightmode' : ''}`}>
                            <div style={{float: 'left'}}>
                                <span className='aboutdevice-form-item-left'>
                                    {lang.country}
                                </span>
                            </div>
                            <div style={{float: 'right'}}>
                                <span className='aboutdevice-form-item-right'>
                                    United States
                                </span>
                            </div>
                        </div>
                        <div onClick={openLangScreen} className={`aboutdevice-form-item accessible ${themeMode == 'light' ? 'lightmode' : ''}`}>
                            <div style={{float: 'left'}}>
                                <span className='aboutdevice-form-item-left'>
                                    {lang.language}
                                </span>
                            </div>
                            <div style={{float: 'right'}}>
                                <span className='aboutdevice-form-item-right'>
                                    <i style={{color: 'gray'}} class="fa-solid fa-chevron-right"></i>
                                </span>
                            </div>
                        </div>
                        <div className={`aboutdevice-form-item ${themeMode == 'light' ? 'lightmode' : ''}`}>
                            <div style={{float: 'left'}}>
                                <span className='aboutdevice-form-item-left'>
                                    {lang.softwareUpdate}
                                </span>
                            </div>
                            <div style={{ float: "right" }}>
                            <span className="aboutdevice-form-item-right">
                                <div
                                className="software-update-check checkbut"
                                onClick={handleCheck}
                                >
                                {isLoading ? (
                                    <div className="loader" />
                                ) : (
                                    "Check"
                                )}
                                </div>
                            </span>
                            </div>
                        </div>
                    </>)}

                    {langScreen && (
                        <> 
                          {Object.entries(allLang).map(([code, name]) => (
                            <div
                                key={code}
                                onClick={() => selectNewLang(code)}
                                className="aboutdevice-form-item accessible"
                            >
                                <span className="aboutdevice-form-item-left">{name}</span>
                                <span className="aboutdevice-form-item-right">
                                <i className="fa-solid fa-chevron-right"></i>
                                </span>
                            </div>
                            ))}
                        </>
                    )}

                </div>
            </div>

            {isModalOpen && <TabletNameModal closeModal={toggleModal} isModalOpen={isModalOpen} lang={lang} setTabName={setTabName} Notification={Notification}></TabletNameModal>}
        </div>
    )
}

export default AboutDevice;