import React, {useState, useEffect} from 'react'
import './main.css'
import { motion, AnimatePresence } from "framer-motion";
import { callNui } from '../../nui';

const addAnnounceModal = ({isOpen, onClose, lang, NotificationX, theme}) => {
    const [onePut, setPut] = useState('');
    const [secondPut, setPut2] = useState('');

    const SendAnnounce = () => {
        if(onePut.trim() && secondPut.trim()){
            callNui('SendAnnounceForMdt', {
                title: onePut,
                message: secondPut
            }, function(data){
                if(data){
                    onClose();
                }
            });
            setPut('');
            setPut2('');
        } else {
            NotificationX(lang.invalid, lang.emptyFields);
        }
    }

    return (
        <div className={`mdt-addannouncemodal ${isOpen ? 'show':''}`}>
            <motion.div className={`mdt-announcemodal-container ${theme !== 'dark' ? 'modal-white': ''}`}>
                <div onClick={() => onClose()}className='close-announce-modal'><i className="fa-regular fa-xmark"></i></div>
                <span className={`header-label ${theme !== 'dark' ? 'header-white': ''}`}>{lang.sendAnnounce}</span>
                <div className='header-label-br'></div>
                <div className='enterprise'>
                    <span className='label-sp'>{lang.title}</span>
                    <input placeholder={lang.announceTitle} value={onePut} onChange={(e) => setPut(e.target.value)}></input>
                </div>
                <div className='enterprise'>
                    <span className='label-sp'>{lang.message}</span>
                    <input placeholder={lang.announceMessage} value={secondPut} onChange={(e) => setPut2(e.target.value)}></input>
                </div>
                <div onClick={() => SendAnnounce()} className='enterprise'>
                    <button>{lang.sendAnnounce}</button>
                </div>
            </motion.div>
        </div>
    )
}

export default addAnnounceModal;