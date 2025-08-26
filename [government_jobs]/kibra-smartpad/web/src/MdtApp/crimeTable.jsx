import React, { useState } from "react";
import './criminalTable.css';

const CrimeTable = ({lang, crimeList, vehCrimes}) => {
  const [activeTab, setActiveTab] = useState("personal");
  const [query, setQuery] = useState("");

  const activeList = activeTab === "personal" ? crimeList : vehCrimes;

  const filteredCrimes = activeList.filter((crime) =>
    crime.name.toLowerCase().includes(query.toLowerCase()) ||
    crime.description.toLowerCase().includes(query.toLowerCase())
  );

  return (
    <div className="crime-table-container">
      <div className="crime-tabs">
        <button
          className={activeTab === "personal" ? "active" : ""}
          onClick={() => setActiveTab("personal")}
        >
          {lang.poffences}
        </button>
        <button
          className={activeTab === "vehicle" ? "active" : ""}
          onClick={() => setActiveTab("vehicle")}
        >
          {lang.toffences}
        </button>
      </div>

      <div className="search-bar">
        <i style={{ color: 'gray' }} className="fa-solid fa-magnifying-glass"></i>
        <input
          type="text"
          placeholder={lang.scrime}
          value={query}
          onChange={(e) => setQuery(e.target.value)}
        />
      </div>

      <div className="crime-table-wrapper">
        <table className="crime-table">
          <thead>
            <tr>
              <th>#</th>
              <th>{lang.crime}</th>
              <th>{lang.penalty}</th>
              <th>{lang.description}</th>
            </tr>
          </thead>
          <tbody>
            {filteredCrimes.map((crime, i) => (
              <tr key={i}>
                <td>{crime.id}</td>
                <td>{crime.name}</td>
                <td>${crime.fine}</td>
                <td>{crime.description}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default CrimeTable;
