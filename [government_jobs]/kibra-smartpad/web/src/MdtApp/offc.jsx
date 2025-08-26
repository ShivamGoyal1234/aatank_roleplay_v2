import React, { useState, useEffect, useRef } from "react";
import "./main.css";
import "./OfficersPage.css";
import { callNui } from "@/nui";
import Avatar from '/public/avatar.png';

const OfficersPage = ({officers, grades, lang}) => {
    const [officersList, setOfficersList] = useState([]);
    const [searchValue, setSearchValue] = useState('');

    const returnPlayerPhoto = (cid) => {
        const path = `/web/pimg/${cid}.png`;
        const img = new Image();
        img.src = path;
      
        return new Promise((resolve) => {
          img.onload = () => resolve(path);
          img.onerror = () => resolve(Avatar);
        });
    }

    useEffect(()=>{
      // console.log('off prop',officers)
      const list=Array.isArray(officers)?officers:[officers]
      if(!list.length)return
      ;(async()=>{
        const nd=await Promise.all(list.map(async e=>({...e,photoUrl:await returnPlayerPhoto(e.cid)})))
        setOfficersList(nd.reverse())
      })()
    },[JSON.stringify(officers)])

    // useEffect(() => {
    //     console.log(JSON.stringify(officersList, null, 2))
    // }, [officersList]);

  return (
    <div className="officers-container">
      <div className="search-bar">
        <input type="text"   onChange={(e) => setSearchValue(e.target.value)} value={searchValue} placeholder={lang.searchofficer} />
        <label className="toggle-switch">
          <input type="checkbox" />
          <span className="slider3"></span>
          <span className="toggle-label">{lang.activeoffc}</span>
        </label>
      </div>

      <div className="table-wrapper">
        <table className="officers-table">
          <thead>
            <tr>
              <th>{lang.officer}</th>
              <th>{lang.rank}</th>
              <th>{lang.citizenid}</th>
            </tr>
          </thead>
          <tbody>
          {officersList
            .filter((officer) =>
              officer.name.toLowerCase().includes(searchValue.toLowerCase())
            )
            .map((officer, index) => {
              const jobGrades=grades[officer.job]||[]
            return (
              <tr key={index}>
                <td>
                  <div className="officer-info">
                    <img src={officer.photoUrl} alt="officer" />
                    <div>
                      <p className="officer-name">{officer.name}</p>
                      <p className={`officer-status ${officer.online ? 'on-duty' : 'in-office'}`}>
                        {officer.online ? 'On Duty' : 'Offline'}
                      </p>
                    </div>
                  </div>
                </td>
                <td>
                <select
                  value={String(officer.grade)}
                  onChange={(e) => {
                    const updatedList = [...officersList]
                    updatedList[index] = {
                      ...updatedList[index],
                      grade: e.target.value
                    }
                    setOfficersList(updatedList)

                    const selectedGrade = grades[officer.job].find(
                      (g) => String(g.label) === e.target.value
                    )

                    callNui('UpdateJob', {
                      gradename: selectedGrade.label,
                      gradelevel: selectedGrade.gradelevel,
                      job: officer.job,
                      cid: officer.cid
                    });


                  }}
                >
                  {jobGrades.map((element, i) => (
                    <option key={element.gradelevel} value={element.label}>
                      {element.label}
                    </option>
                  ))}
                </select>
                </td>
                <td>{officer.cid}</td>
              </tr>
            )})}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default OfficersPage;