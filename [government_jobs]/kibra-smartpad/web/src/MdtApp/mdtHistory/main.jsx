import React, { useState, useEffect, useRef } from "react";
import "./main.css";

const MdtHistory = ({ lang, history, theme}) => {
    const [query, setQuery] = useState("");    
    const filtered = history.filter((c) => {
        return (
            c.created_by || c.casenumber.toLowerCase().includes(query.toLowerCase())
        );
    });
    
    return (
        <>
            <div className='vehicle-query-main-frame'>
                <div className='cquery-head'>
                    <div className={`cquery-put ${theme !== 'dark' ? 'white-bold':''}`}>
                        <svg style={{marginLeft: '1rem'}} xmlns="http://www.w3.org/2000/svg" width="17" height="18" viewBox="0 0 17 18" fill="none">
                            <path d="M16.8042 8.31747L15.2908 6.86681L13.9482 4.09644C13.8329 3.90301 13.6713 3.74347 13.4789 3.63319C13.2865 3.52291 13.0698 3.46561 12.8497 3.46682H5.28256C5.06247 3.46561 4.84579 3.52291 4.6534 3.63319C4.461 3.74347 4.29938 3.90301 4.18409 4.09644L2.84153 6.86681L1.32809 8.31747C1.26644 8.37647 1.21727 8.44797 1.18366 8.5275C1.15006 8.60703 1.13275 8.69286 1.13281 8.77962V14.1705C1.13281 14.3375 1.19711 14.4976 1.31155 14.6157C1.426 14.7338 1.58122 14.8001 1.74307 14.8001H4.18409C4.4282 14.8001 4.79435 14.5483 4.79435 14.2964V13.5409H13.3379V14.1705C13.3379 14.4224 13.582 14.8001 13.8261 14.8001H16.3892C16.5511 14.8001 16.7063 14.7338 16.8207 14.6157C16.9352 14.4976 16.9995 14.3375 16.9995 14.1705V8.77962C16.9995 8.69286 16.9822 8.60703 16.9486 8.5275C16.915 8.44797 16.8659 8.37647 16.8042 8.31747ZM5.40461 4.72607H12.7277L13.9482 7.24459H4.18409L5.40461 4.72607ZM6.01486 10.5187C6.01486 10.7705 5.64871 11.0224 5.40461 11.0224H2.84153C2.59743 11.0224 2.35333 10.6446 2.35333 10.3927V9.00755C2.47538 8.62977 2.71948 8.37792 3.08563 8.50384L5.52666 9.00755C5.77076 9.00755 6.01486 9.38532 6.01486 9.63718V10.5187ZM15.779 10.3927C15.779 10.6446 15.5349 11.0224 15.2908 11.0224H12.7277C12.4836 11.0224 12.1174 10.7705 12.1174 10.5187V9.63718C12.1174 9.38532 12.3615 9.00755 12.6056 9.00755L15.0467 8.50384C15.4128 8.37792 15.6569 8.62977 15.779 9.00755V10.3927Z" fill="white"/>
                        </svg>
                        <input placeholder={lang.searchcrime} value={query} onChange={(e) => setQuery(e.target.value)}></input>
                    </div>
                </div>
                <div className={`cquery-box ${theme !== 'dark' ? 'cqbox':''}`}>
                    <div className={`cquery-header ${theme !== 'dark' ? 'white-bold' : ''}`}>
                        <span className={`part-title ${theme !== 'dark' ? 'black-text': ''}`}>{lang.history}</span>
                    </div>
                    <>
                    <div className={`cquery-mini-header ${theme !== 'dark' ? 'cquery-white':''}`}>
                    <div style={{marginLeft: '1rem', width: '15rem'}}>
                                {lang.performedby}
                            </div>
                            <div style={{width: '39rem'}}>
                                {lang.transaction}
                            </div>
                            <div style={{width: '10rem'}}>
                                {lang.date}
                            </div>
                        </div>
                        <div className='citizen-list'>
                            {filtered.map((crime, index) => {
                                return (
                                <div className={`citizen-list-item ${theme !== 'dark' ? 'c-list-white' : ''}`}>
                                    <div style={{marginLeft: '1rem', width: '15rem',color: '#FFF',fontFamily: '"SF Pro Display"',fontSize: '16px',fontStyle: 'normal',alignItems: 'center',fontWeight: '700',lineHeight: '14.461px',display: 'flex'}}>
                                        {crime.created_by}
                                    </div>
                                    <div style={{width: '39rem',display: 'flex',color: '#64666E',fontFamily: '"SF Pro Display"',fontSize: '16px',fontStyle: 'normal',fontWeight: '700',lineHeight: '14.461px',alignItems: 'center'}}>
                                       {crime.transaction}
                                    </div>
                
                                    <div style={{width: '10rem',display: 'flex',alignItems: 'center'}}>
                                        {crime.date}
                                    </div>
                                </div>
                                );
                            })}
                        </div>
                    </> 
                </div>
            </div>
        </>
    )
}

export default MdtHistory;