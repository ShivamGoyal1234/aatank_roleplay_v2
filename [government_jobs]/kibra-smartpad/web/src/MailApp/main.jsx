import React, {useState, useEffect} from 'react';
import './main.css';
import MailComposerModal from './mailCreate';

const MailApp = ({lang, tabMails, allMails, myMail, tabOwner, sentedMails, isPolice, isDojApp, dbMails, dojMail, policeMail}) => {
    const [selectedPart, setPart] = useState('all');
    const [allInboxes, setAll] = useState(true);
    const [sented, setSented] = useState(false);
    const [time, setTime] = useState(new Date());
    const [billingMail, setBillingMail] = useState(false);
    const [showComposer, setShowComposer] = useState(false);
    const [selectedMail, setMailData] = useState(null);
    const [selectedMailId, setSelectedMailId] = useState(null)
    const [showPoliceMail, setPoliceMails] = useState(false);
    const [showDoj, setShowDoj] = useState(false);
    const formattedTime = `${time.getHours().toString().padStart(2, "0")}:${time
        .getMinutes()
        .toString()
        .padStart(2, "0")}`;
  
    const hideAll = () => {
        setAll(false);
        setSented(false);
        setPoliceMails(false);
        setShowDoj(false);
    }

    const justPoliceMailBox = dbMails.filter(item => item.from === policeMail);
    const justDojMailBox = dbMails.filter(item => item.from === dojMail);

    const changePage = (page) => {
        switch (page) {
            case "all":
                hideAll();
                setPart('all');
                setAll(true);
                break;
            case "sented":
                hideAll();
                setPart('sented');
                setSented(true);
                break;
            case "policeMails":
                hideAll();
                setPart('policeMails');
                setPoliceMails(true);
                break;
            case "dojMails":
                hideAll();
                setPart('dojMails');
                setShowDoj(true);
                break;
            default:
                break;
        }
    }
    return (
        <>
            <div className='mailapp-frame'>
                <div className='header-icon-time-part'>
                    <span className='time-string'>{formattedTime}</span>
                </div>
                <div className='header-icon-part'>
                    <div className='header-icons'>
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="10" viewBox="0 0 18 10" fill="none">
                        <path d="M14.5227 0.617317C14.4465 0.801088 14.4465 1.03406 14.4465 1.5V8.5C14.4465 8.96594 14.4465 9.19891 14.5227 9.38268C14.6241 9.62771 14.8188 9.82239 15.0638 9.92388C15.2476 10 15.4806 10 15.9465 10C16.4125 10 16.6454 10 16.8292 9.92388C17.0742 9.82239 17.2689 9.62771 17.3704 9.38268C17.4465 9.19891 17.4465 8.96594 17.4465 8.5V1.5C17.4465 1.03406 17.4465 0.801088 17.3704 0.617317C17.2689 0.372288 17.0742 0.177614 16.8292 0.0761205C16.6454 0 16.4125 0 15.9465 0C15.4806 0 15.2476 0 15.0638 0.0761205C14.8188 0.177614 14.6241 0.372288 14.5227 0.617317Z" fill="white"/>
                        <path d="M9.94653 3.5C9.94653 3.03406 9.94653 2.80109 10.0227 2.61732C10.1241 2.37229 10.3188 2.17761 10.5638 2.07612C10.7476 2 10.9806 2 11.4465 2C11.9125 2 12.1454 2 12.3292 2.07612C12.5742 2.17761 12.7689 2.37229 12.8704 2.61732C12.9465 2.80109 12.9465 3.03406 12.9465 3.5V8.5C12.9465 8.96594 12.9465 9.19891 12.8704 9.38268C12.7689 9.62771 12.5742 9.82239 12.3292 9.92388C12.1454 10 11.9125 10 11.4465 10C10.9806 10 10.7476 10 10.5638 9.92388C10.3188 9.82239 10.1241 9.62771 10.0227 9.38268C9.94653 9.19891 9.94653 8.96594 9.94653 8.5V3.5Z" fill="white"/>
                        <path d="M5.52265 4.61732C5.44653 4.80109 5.44653 5.03406 5.44653 5.5V8.5C5.44653 8.96594 5.44653 9.19891 5.52265 9.38268C5.62415 9.62771 5.81882 9.82239 6.06385 9.92388C6.24762 10 6.48059 10 6.94653 10C7.41247 10 7.64545 10 7.82922 9.92388C8.07424 9.82239 8.26892 9.62771 8.37041 9.38268C8.44653 9.19891 8.44653 8.96594 8.44653 8.5V5.5C8.44653 5.03406 8.44653 4.80109 8.37041 4.61732C8.26892 4.37229 8.07424 4.17761 7.82922 4.07612C7.64545 4 7.41247 4 6.94653 4C6.48059 4 6.24762 4 6.06385 4.07612C5.81882 4.17761 5.62415 4.37229 5.52265 4.61732Z" fill="white"/>
                        <path d="M1.02265 6.11732C0.946533 6.30109 0.946533 6.53406 0.946533 7V8.5C0.946533 8.96594 0.946533 9.19891 1.02265 9.38268C1.12415 9.62771 1.31882 9.82239 1.56385 9.92388C1.74762 10 1.98059 10 2.44653 10C2.91247 10 3.14545 10 3.32922 9.92388C3.57424 9.82239 3.76892 9.62771 3.87041 9.38268C3.94653 9.19891 3.94653 8.96594 3.94653 8.5V7C3.94653 6.53406 3.94653 6.30109 3.87041 6.11732C3.76892 5.87229 3.57424 5.67761 3.32922 5.57612C3.14545 5.5 2.91247 5.5 2.44653 5.5C1.98059 5.5 1.74762 5.5 1.56385 5.57612C1.31882 5.67761 1.12415 5.87229 1.02265 6.11732Z" fill="white"/>
                    </svg>
                    </div>
                    <div className='header-icons'>
                        <svg xmlns="http://www.w3.org/2000/svg" width="15" height="10" viewBox="0 0 15 10" fill="none">
                            <path d="M12.9512 4.246C13.0647 4.3525 13.2397 4.353 13.3502 4.243L14.4142 3.179C14.5287 3.064 14.5292 2.8745 14.4112 2.763C12.6022 1.0505 10.1607 0 7.47322 0C4.78572 0 2.34422 1.0505 0.535223 2.763C0.417223 2.8745 0.417723 3.064 0.532223 3.179L1.59622 4.243C1.70672 4.353 1.88172 4.3525 1.99522 4.246C3.42972 2.9015 5.35672 2.077 7.47322 2.077C9.58972 2.077 11.5167 2.9015 12.9512 4.246Z" fill="white"/>
                            <path d="M10.5043 6.69645C10.6198 6.79945 10.7923 6.80045 10.9018 6.69095L11.9643 5.62845C12.0798 5.51295 12.0803 5.32045 11.9603 5.20995C10.7793 4.12445 9.20385 3.46145 7.47334 3.46145C5.74285 3.46145 4.16735 4.12445 2.98635 5.20995C2.86635 5.32045 2.86685 5.51295 2.98235 5.62845L4.04485 6.69095C4.15435 6.80045 4.32685 6.79945 4.44235 6.69645C5.24835 5.97695 6.31035 5.53845 7.47334 5.53845C8.63634 5.53845 9.69835 5.97695 10.5043 6.69645Z" fill="white"/>
                            <path d="M9.5082 7.6611C9.6337 7.7661 9.6327 7.9616 9.5167 8.0776L7.6787 9.9156C7.5662 10.0281 7.3832 10.0281 7.2707 9.9156L5.4327 8.0776C5.3167 7.9616 5.3152 7.7661 5.4412 7.6611C5.9917 7.2006 6.7007 6.9231 7.4747 6.9231C8.2487 6.9231 8.9572 7.2006 9.5082 7.6611Z" fill="white"/>
                        </svg>
                    </div>
                    <div className='header-icons'>
                        <svg xmlns="http://www.w3.org/2000/svg" width="15" height="10" viewBox="0 0 15 10" fill="none">
                            <path d="M12.9512 4.246C13.0647 4.3525 13.2397 4.353 13.3502 4.243L14.4142 3.179C14.5287 3.064 14.5292 2.8745 14.4112 2.763C12.6022 1.0505 10.1607 0 7.47322 0C4.78572 0 2.34422 1.0505 0.535223 2.763C0.417223 2.8745 0.417723 3.064 0.532223 3.179L1.59622 4.243C1.70672 4.353 1.88172 4.3525 1.99522 4.246C3.42972 2.9015 5.35672 2.077 7.47322 2.077C9.58972 2.077 11.5167 2.9015 12.9512 4.246Z" fill="white"/>
                            <path d="M10.5043 6.69645C10.6198 6.79945 10.7923 6.80045 10.9018 6.69095L11.9643 5.62845C12.0798 5.51295 12.0803 5.32045 11.9603 5.20995C10.7793 4.12445 9.20385 3.46145 7.47334 3.46145C5.74285 3.46145 4.16735 4.12445 2.98635 5.20995C2.86635 5.32045 2.86685 5.51295 2.98235 5.62845L4.04485 6.69095C4.15435 6.80045 4.32685 6.79945 4.44235 6.69645C5.24835 5.97695 6.31035 5.53845 7.47334 5.53845C8.63634 5.53845 9.69835 5.97695 10.5043 6.69645Z" fill="white"/>
                            <path d="M9.5082 7.6611C9.6337 7.7661 9.6327 7.9616 9.5167 8.0776L7.6787 9.9156C7.5662 10.0281 7.3832 10.0281 7.2707 9.9156L5.4327 8.0776C5.3167 7.9616 5.3152 7.7661 5.4412 7.6611C5.9917 7.2006 6.7007 6.9231 7.4747 6.9231C8.2487 6.9231 8.9572 7.2006 9.5082 7.6611Z" fill="white"/>
                        </svg>
                    </div>
                </div>
                <div style={{display: 'flex', justifyContent: 'flex-start'}}>
                    <div className='new-mail-part2'>
                        <div style={{display: 'flex', alignContent: 'center', justifyContent: 'center', flexDirection: 'column'}}>
                            <span className='mail-app-title'>{lang.mapp}</span>
                            <div className='listed-mails'>
                                <div onClick={() => changePage('all')} className={`photo-bar ${selectedPart == 'all' ? 'selected-bar':''}`}>
                                    <i className="fa-regular fa-images"></i> &nbsp; &nbsp; 
                                    {lang.allinboxes}
                                </div>
                                <div onClick={() => changePage('sented')} className={`photo-bar ${selectedPart == 'sented' ? 'selected-bar':''}`}>
                                    <i className="fa-solid fa-paper-plane"></i> &nbsp; &nbsp; 
                                    {lang.sentmails}
                                </div>

                                {isPolice && (
                                    <div onClick={() => changePage('policeMails')} className={`photo-bar ${selectedPart == 'policeMails' ? 'selected-bar':''}`}>
                                        <i className="fa-solid fa-paper-plane"></i> &nbsp; &nbsp; 
                                        {lang.pmails}
                                    </div>
                                )}

                                {isDojApp && (
                                    <div onClick={() => changePage('dojMails')} className={`photo-bar ${selectedPart == 'dojMails' ? 'selected-bar':''}`}>
                                        <i className="fa-solid fa-paper-plane"></i> &nbsp; &nbsp; 
                                        {lang.dojmails}
                                    </div>
                                )}
                            </div>
                        </div>
                    </div>
                    <div className='new-mail-middle'>
                        <div className='middle-mail-header'>
                            <span className='mail-box-header'>{lang.allinboxes}</span>
                            <span className='mail-box-header-desc'>{lang.connecting}</span>
                        </div>
                        <div className='mail-list-x'>
                            {allInboxes && tabMails.map((element, index) => (
                                <div
                                    key={element.id || index}
                                    onClick={() => {
                                    setMailData(element)
                                    setSelectedMailId(element.id)
                                    }}
                                    className={`mail-list-x-item${selectedMailId === element.id ? ' selected' : ''}`}
                                >
                                    <div className='mail-minibox'>
                                    <div className='mail-info'>
                                        <span className='mailt-subject'>{element.from_name}</span>
                                        <span className='mail-titlea'>{
                                        (() => {
                                            const subject = (element.data.subject || '').trim().replace(/\s+/g, ' ');
                                            const words = subject.split(' ');
                                            return words.length > 3
                                            ? words.slice(0, 3).join(' ') + '...'
                                            : subject;
                                        })()
                                        }</span>
                                        <span className='mail-desc'>
                                            {
                                                (() => {
                                                    const msg = (element.data.message || '').trim().replace(/\s+/g, ' ');
                                                    const words = msg.split(' ');
                                                    return words.length > 20
                                                    ? words.slice(0, 20).join(' ') + '...'
                                                    : msg;
                                                })()
                                            }
                                                                                            
                                        </span>
                                    </div>
                                    <span className='mail-time'>{element.date}</span>
                                    </div>
                                    <div className='border-land'></div>
                                </div>
                            ))}

                            {showPoliceMail && justPoliceMailBox.map((element, index) => (
                                <div
                                    key={element.id || index}
                                    onClick={() => {
                                    setMailData(element)
                                    setSelectedMailId(element.id)
                                    }}
                                    className={`mail-list-x-item${selectedMailId === element.id ? ' selected' : ''}`}
                                >
                                    <div className='mail-minibox'>
                                    <div className='mail-info'>
                                        <span className='mailt-subject'>{element.from_name}</span>
                                        <span className='mail-titlea'>{
                                        (() => {
                                            const subject = (element.data.subject || '').trim().replace(/\s+/g, ' ');
                                            const words = subject.split(' ');
                                            return words.length > 3
                                            ? words.slice(0, 3).join(' ') + '...'
                                            : subject;
                                        })()
                                        }</span>
                                        <span className='mail-desc'>
                                            {
                                                (() => {
                                                    const msg = (element.data.message || '').trim().replace(/\s+/g, ' ');
                                                    const words = msg.split(' ');
                                                    return words.length > 20
                                                    ? words.slice(0, 20).join(' ') + '...'
                                                    : msg;
                                                })()
                                            }
                                                                                            
                                        </span>
                                    </div>
                                    <span className='mail-time'>{element.date}</span>
                                    </div>
                                    <div className='border-land'></div>
                                </div>
                            ))}

                            {showDoj && justDojMailBox.map((element, index) => (
                                <div
                                    key={element.id || index}
                                    onClick={() => {
                                    setMailData(element)
                                    setSelectedMailId(element.id)
                                    }}
                                    className={`mail-list-x-item${selectedMailId === element.id ? ' selected' : ''}`}
                                >
                                    <div className='mail-minibox'>
                                    <div className='mail-info'>
                                        <span className='mailt-subject'>{element.from_name}</span>
                                        <span className='mail-titlea'>{
                                        (() => {
                                            const subject = (element.data.subject || '').trim().replace(/\s+/g, ' ');
                                            const words = subject.split(' ');
                                            return words.length > 3
                                            ? words.slice(0, 3).join(' ') + '...'
                                            : subject;
                                        })()
                                        }</span>
                                        <span className='mail-desc'>
                                            {
                                                (() => {
                                                    const msg = (element.data.message || '').trim().replace(/\s+/g, ' ');
                                                    const words = msg.split(' ');
                                                    return words.length > 20
                                                    ? words.slice(0, 20).join(' ') + '...'
                                                    : msg;
                                                })()
                                            }
                                                                                            
                                        </span>
                                    </div>
                                    <span className='mail-time'>{element.date}</span>
                                    </div>
                                    <div className='border-land'></div>
                                </div>
                            ))}

                            {sented && sentedMails.map((element, index) => (
                                <div
                                    key={element.id || index}
                                    onClick={() => {
                                        setMailData(element)
                                        setSelectedMailId(element.id)
                                    }}
                                    className={`mail-list-x-item${selectedMailId === element.id ? ' selected' : ''}`}
                                >
                                    <div className='mail-minibox'>
                                    <div className='mail-info'>
                                        <span className='mailt-subject'>{element.from_name}</span>
                                        <span className='mail-titlea'>{
  (() => {
    const subject = (element.data.subject || '').trim().replace(/\s+/g, ' ');
    const words = subject.split(' ');
    return words.length > 3
      ? words.slice(0, 3).join(' ') + '...'
      : subject;
  })()
}</span>
                                        <span className='mail-desc'> {
  (() => {
    const msg = (element.data.message || '').trim().replace(/\s+/g, ' ');
    const words = msg.split(' ');
    return words.length > 20
      ? words.slice(0, 20).join(' ') + '...'
      : msg;
  })()
}
</span>
                                    </div>
                                    <span className='mail-time'>{element.date}</span>
                                    </div>
                                    <div className='border-land'></div>
                                </div>
                            ))}
                        </div>
                    </div>
                    <div className='middle-cizgi'></div>
                    <div className='mail-ana-part'>
                        <div onClick={() => setShowComposer(true)} className='mail-anapart-de'>
                            <i className="fa-solid fa-pen-to-square"></i>
                        </div>

                        {selectedMail && (
                            <div className='mail-box-ax'>
                                <div className='mail-box-bra-x'>
                                    <span className='tabii-x'>{selectedMail.from_name}</span>
                                    <span className='tabii-x2'>{lang.tox} {selectedMail.receiver}</span>
                                    <div className='borxer'></div>
                                </div>
                                <div className='mailcontent'>
                                    <span className='mail-bold'>{selectedMail.data.subject}</span>
                                    {selectedMail.type == 0 ? 
                                        <span className='mail-conta'>{selectedMail.data.message}</span>
                                    : ''} 

                                    {selectedMail.type === 1 && (
                                        <div className="fine-mail-container">
                                            <h2 className="fine-mail-title">🚨 {selectedMail.data.subject}</h2>
                                            <p className="fine-mail-date">{lang.date}: {selectedMail.date}</p>

                                            <p className="fine-mail-text">
                                                {lang.dcitizen},<br/>
                                                {lang.youhavelspdmail}
                                            </p>

                                            <ul className="fine-mail-list">
                                               {selectedMail.data.fines.map((element, index) => (
                                                 <li>
                                                    <span className="crime-name">{element.fineLabel}</span>
                                                    <span className="crime-fine">${element.price}</span>
                                                </li>
                                               ))}
                                            </ul>

                                            <div className="fine-mail-total">
                                                <span>{lang.totalPri}</span>
                                                <span>${selectedMail.data.totalPrice}</span>
                                            </div>

                                            <p className="fine-mail-footer">
                                                {lang.billInfo}
                                            </p>
                                        </div>
                                    )}

                                    {selectedMail.type === 2 && (
                                            <div className="invoice-mail-container">
                                            <h2 className="invoice-mail-title">🧾 {lang.newinx}</h2>
                                            <p className="invoice-mail-sub">{lang.yourecex}</p>
                                            <p className="invoice-mail-date">{selectedMail.date}</p>

                                            <div className="invoice-mail-body">
                                                <div className="invoice-mail-from">
                                                <span>{lang.fromx}</span>
                                                <strong>&nbsp; {selectedMail.from_name}</strong>
                                                </div>

                                                <ul className="invoice-mail-list">
                                                    {selectedMail.data.getProducts.map((element, index) => (
                                                        <li>
                                                            <span className="item-desc">{element.label}</span>
                                                            <span className="item-price">${element.fine}</span>
                                                        </li>
                                                    ))}
                                                </ul>

                                                <div className="invoice-mail-total">
                                                    <span>{lang.generaltotal}</span>
                                                    <span>${selectedMail.data.totalPrice}</span>
                                                </div>
                                                <p className="invoice-mail-note">{lang.duedate}:  {selectedMail.data.DueDate}</p>
                                            </div>
                                        </div>
                                    )}
                                </div>
                            </div>
                        )}
                    </div>
                </div>
            </div>
            <MailComposerModal tabOwner={tabOwner} lang={lang} myMail={myMail} allMails={allMails} isOpen={showComposer} onClose={() => setShowComposer(false)} />
        </>
    )
}

export default MailApp;