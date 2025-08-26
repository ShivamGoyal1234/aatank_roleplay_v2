import React, { useState, useEffect, useRef } from "react";
import "./main.css";
import "./OfficersPage.css";
import { callNui } from "@/nui";
import Avatar from '/public/avatar.png';
import { motion, AnimatePresence } from "framer-motion";

const OfficersPage = ({officers, grades, lang, theme}) => {
  const [officersList, setOfficersList] = useState([]);
  const [searchValue, setSearchValue] = useState("");
  const [showActive, setShowActive] = useState(true);
  const [openIdx, setOpenIdx] = useState(null);

   const returnPlayerPhoto = (cid) => {
      const path = `/web/pimg/${cid}.png`;
      const img = new Image();
      img.src = path;
    
      return new Promise((resolve) => {
        img.onload = () => resolve(path);
        img.onerror = () => resolve(Avatar);
      });
  }

  useEffect(() => {
    const list = Array.isArray(officers) ? officers : [officers];
    if (!list.length) return;
    (async () => {
      const nd = await Promise.all(
        list.map(async e => {
          const photoUrl = await returnPlayerPhoto(e.cid);
          return { ...e, photoUrl };
        })
      );
      setOfficersList(nd.reverse());
    })();
  }, [JSON.stringify(officers)]);
  
  useEffect(() => {
    const handleGlobalClick = () => setOpenIdx(null);
    document.addEventListener("click", handleGlobalClick);
    return () => document.removeEventListener("click", handleGlobalClick);
  }, []);

  const filtered = officersList
    .filter(o => o.name.toLowerCase().includes(searchValue.toLowerCase()))
    .filter(o => (showActive ? o.online : true));

  return (
    <div className="officers-container">
      <div className='bothofthem'>
          <div className={`search-part ${theme !== 'dark' ? 'search-white':''}`}>
            <div style={{float: 'left'}}>
              <svg xmlns="http://www.w3.org/2000/svg" width="15" height="16" viewBox="0 0 15 16" fill="none">
                <path d="M13.125 13.625L10.4062 10.9062M11.875 7.375C11.875 10.1364 9.63642 12.375 6.875 12.375C4.11358 12.375 1.875 10.1364 1.875 7.375C1.875 4.61358 4.11358 2.375 6.875 2.375C9.63642 2.375 11.875 4.61358 11.875 7.375Z" stroke="white" stroke-width="1.25" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <div style={{float: 'left'}}>
              <input
                className="inpat"
                placeholder={lang.searchofficer}
                onChange={e => setSearchValue(e.target.value)}
                value={searchValue}
              />
            </div>
          </div>
          <div className='search-button'>
              Search
            </div>
            <div className="showactiveoffc">
              <label className="switch2">
                <input
                  checked={showActive}
                  onChange={e => setShowActive(e.target.checked)}
                  type="checkbox"
                />
                <span className="slider2"></span>
              </label>
              {lang.activeoffc}
            </div>
        </div>
        <div className={`yenimenum ${theme !== 'dark' ? 'border-white':''}`}>
            <div className={`yenimenum-header ${theme !== 'dark' ? 'white-hed':''}`}>
              <div style={{width: '25rem'}} className={`header-menx ${theme !== 'dark' ? 'black-text' : ''}`}>
              {lang.officer}
              </div>
              <div style={{width: '12rem'}} className={`header-menx ${theme !== 'dark' ? 'black-text' : ''}`}>
              {lang.rank}
              </div>
              <div style={{width: '22rem',
paddingRight: '2rem',
justifyContent: 'end'}} className={`header-menx ${theme !== 'dark' ? 'black-text' : ''}`}>
                {lang.citizenid}
              </div>
            </div>
            {filtered.map((officer, idx) => {
              const jobGrades = grades[officer.job] || [];
              return (
                <div key={idx} className={`like-man ${theme !== 'dark' ? 'border-whitex':''}`}>
                  <div style={{ width: "35rem" }} className="like-man-part">
                    <div className="like-manx">
                      <img style={{ width: "40px" }} src={officer.photoUrl} alt="officer" />
                      <div className={`like-manxv ${theme !== 'dark' ? 'black-text':''}`}>
                        <span className="activeoffc">{officer.name}</span>
                        <span className={`activeoffc ${officer.online ? "onlinec" : ""}`}>{officer.online ? "On Duty" : "Offline"}</span>
                      </div>
                    </div>
                  </div>
                  <div style={{ width: "36rem" }} className="like-man-part">
                    <div className={`like-manx ${theme !== 'dark' ? 'black-text':''}`}>
                      <div
                        className={`dropbown ${theme !== 'dark' ? 'vc' : ''}`}
                        onClick={e => {
                          e.stopPropagation()
                          setOpenIdx(openIdx === idx ? null : idx)
                        }}
                      >
                        {officer.grade} &nbsp; <i class="fa-solid fa-arrow-right"></i>
                      </div>
                      <AnimatePresence>
                        {openIdx === idx && (
                          <motion.div
                            className={`dropdown-menu3 ${theme !== 'dark' ? 'vcx' : ''}`}
                            onClick={e => e.stopPropagation()}
                            initial={{ height: 0, opacity: 0 }}
                            animate={{ height: "auto", opacity: 1 }}
                            exit={{ height: 0, opacity: 0 }}
                            transition={{ duration: 0.2, ease: "easeInOut" }}
                          >
                            <div
                              className={`dropdown-item3 ${theme !== 'dark' ? 'black-text' : ''}`}
                              onClick={e => {
                                e.stopPropagation()
                                const u = [...officersList]
                                u[idx] = { ...u[idx], grade: "Unemployed" }
                                setOfficersList(u)
                                callNui("UpdateJob", {
                                  gradename: "Unemployed",
                                  gradelevel: 0,
                                  job: "unemployed",
                                  cid: officer.cid
                                })
                                setOpenIdx(null)
                              }}
                            >
                              {lang.unemployed}
                            </div>
                            {jobGrades.map(el => (
                              <div
                                key={el.gradelevel}
                                className="dropdown-item3"
                                onClick={e => {
                                  e.stopPropagation()
                                  const u = [...officersList]
                                  u[idx] = { ...u[idx], grade: el.label }
                                  setOfficersList(u)
                                  callNui("UpdateJob", {
                                    gradename: el.label,
                                    gradelevel: el.gradelevel,
                                    job: officer.job,
                                    cid: officer.cid
                                  })
                                  setOpenIdx(null)
                                }}
                              >
                                {el.label}
                              </div>
                            ))}
                          </motion.div>
                        )}
                      </AnimatePresence>
                    </div>
                  </div>

                  <div style={{ width: "16rem" }} className="like-man-part">
                    <div className="like-manx" style={{ float: "right", marginRight: "1.5rem" }}>
                      <div className="citizenid">{officer.cid}</div>
                    </div>
                  </div>
                </div>
              );
            })}
        </div>
    </div>
  );
};

export default OfficersPage;