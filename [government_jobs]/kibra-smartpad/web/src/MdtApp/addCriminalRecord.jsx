import React, { useState, useEffect, useRef } from "react";
import "./citizenProfileScreen.css"

const AddCriminalRecordModal = ({ isOpen, onClose }) => {
    const crimes = [
      { id: 1, name: "Theft", price: "$500" },
      { id: 2, name: "Assault", price: "$1,000" },
      { id: 3, name: "Vandalism", price: "$750" },
      { id: 4, name: "Drug Trafficking", price: "$5,000" },
    ];
    
    const [photo, setPhoto] = useState(null);
    const handlePhotoChange = (event) => {
      const file = event.target.files[0];
      if (file) {
        setPhoto(URL.createObjectURL(file));
      }
    };
    const [filteredCrimes, setFilteredCrimes] = useState(crimes);
    
    const handleCrimeSearch = (query) => {
      const results = crimes.filter((crime) =>
        crime.name.toLowerCase().includes(query.toLowerCase())
      );
      setFilteredCrimes(results);
    };
    
    const handleCrimeSelect = (crime) => {
      // console.log("Selected Crime:", crime);
    };

    return (
      <div className={`modal-overlay ${isOpen ? "show" : ""}`} onClick={onClose}>
        <div
          className="modal-content-large"
          onClick={(e) => e.stopPropagation()} // İçeriğe tıklamayı engelle
        >
          <h2>Add Criminal Record</h2>
          <form>
            <div className="form-group">
              <label htmlFor="date">Date</label>
              <input type="date" id="date" name="date" required />
            </div>

            <div className="form-group">
              <label htmlFor="responsible">Responsible Person</label>
              <input type="text" id="responsible" name="responsible" placeholder="Enter name" required />
            </div>
            <div className="form-group">
              <label htmlFor="crimeType">Crime Type</label>
              <input
                type="text"
                id="crimeSearch"
                name="crimeSearch"
                placeholder="Search for a crime"
                onChange={(e) => handleCrimeSearch(e.target.value)}
              />
              <div className={`crime-list ${theme !== 'dark' ? 'crime-list-white' : ''}`}>
                {filteredCrimes.map((crime) => (
                  <div key={crime.id} className="crime-item" onClick={() => handleCrimeSelect(crime)}>
                    <span>{crime.name}</span>
                    <span className="crime-price">{crime.price}</span>
                  </div>
                ))}
              </div>
            </div>
            <div className="form-group">
            <label htmlFor="photo">Upload Photo</label>
            <input
              type="file"
              id="photo"
              name="photo"
              accept="image/*"
              onChange={handlePhotoChange}
            />
            {photo && (
              <div className="photo-preview">
                <img src={photo} alt="Selected" />
              </div>
            )}
          </div>
            <div className="modal-actions">
              <button type="button" onClick={onClose} className="cancel-btn">
                Cancel
              </button>
              <button type="submit" className="submit-btn">
                Submit
              </button>
            </div>
          </form>
        </div>
      </div>


    );
  };
  
  export default AddCriminalRecordModal;