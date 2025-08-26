import React, { useState, useMemo, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { callNui } from "@/nui";

function ToggleSwitch({ checked, onChange, label, input }) {
  return (
    <label className="toggle-row" style={{
      display: "flex", alignItems: "center", gap: 13, fontWeight: 600, cursor: "pointer", marginBottom: 7
    }}>
      <span style={{ minWidth: 124 }}>{label}</span>
      <span className="toggle-switch2">
        <input
          type="checkbox"
          checked={checked}
          onChange={onChange}
          style={{ display: "none" }}
        />
        <span className={`slider6${checked ? " on" : ""}`}></span>
      </span>
      {input}
    </label>
  );
}

export default function EnterVerdictModal({ open, onClose, onSubmit, lang, data, allCrimes }) {
  const presetOffenseIds = useMemo(
    () => (Array.isArray(data?.articles) ? data.articles.map(s => s.case_id) : []),
    [data?.articles]
  );

  const [selectedOffenses, setSelectedOffenses] = useState([]);
  const [prison, setPrison] = useState(false);
  const [prisonTime, setPrisonTime] = useState(""); // kaç ay/gün (örn: 8 ay)
  const [communityService, setCommunityService] = useState(false);
  const [communityTime, setCommunityTime] = useState(""); // kaç saat/gün

  useEffect(() => {
    if (open) setSelectedOffenses(presetOffenseIds);
  }, [open, presetOffenseIds]);

  const [notes, setNotes] = useState("");
  const [search, setSearch] = useState("");

  const handleOffenseChange = (id) => {
    setSelectedOffenses(prev =>
      prev.includes(id)
        ? prev.filter(o => o !== id)
        : [...prev, id]
    );
  };

  // Arama filtreli suçlar
  const filteredCrimes = useMemo(() => {
    const s = search.toLowerCase();
    return (allCrimes || []).filter(
      c => c.name.toLowerCase().includes(s) || String(c.fine).includes(s)
    );
  }, [allCrimes, search]);



  // Toplam ceza
  const totalFine = allCrimes
    .filter(c => selectedOffenses.includes(c.id))
    .reduce((sum, crime) => sum + (crime.fine || 0), 0);

  const totalSentence = allCrimes
    .filter(c => selectedOffenses.includes(c.id))
    .reduce((sum, crime) => sum + (crime.sentence || 0), 0);

  const handleSubmit = () => {
    if (selectedOffenses.length === 0) {
      alert("Bir suç seçmek zorundasın, hakim bey/hanım!");
      return;
    }
    if (prison && (!prisonTime || isNaN(prisonTime) || prisonTime < 1)) {
      alert("Hapise gönderiyorsan geçerli bir süre gir!");
      return;
    }
    if (communityService && (!communityTime || isNaN(communityTime) || communityTime < 1)) {
      alert("Kamu cezası veriyorsan geçerli bir süre gir!");
      return;
    }
    onSubmit({
      crimes: allCrimes.filter(c => selectedOffenses.includes(c.id)),
      notes,
      totalSentence,
      totalFine,
      prison,
      prisonTime: prison ? Number(prisonTime) : 0,
      communityService,
      communityTime: communityService ? Number(communityTime) : 0,
    });

    callNui('verdictCase', {
        crimeId: data.crime_id,
        crimes: allCrimes.filter(c => selectedOffenses.includes(c.id)),
        notes,
        totalSentence,
        totalFine,
        prison,
        prisonTime: prison ? Number(prisonTime) : 0,
        communityService,
        communityTime: communityService ? Number(communityTime) : 0,
    });
    
    setSelectedOffenses([]);
    setNotes("");
    setPrison(false);
    setPrisonTime("");
    setCommunityService(false);
    setCommunityTime("");
    onClose();
  };

  // Stiller biraz büyütülmüş ve kutu genişletildi
  return (
    <>
      <style>{`
  .modal2-backdrop {
         position: fixed;
    inset: 0;
    background: rgb(4 4 4 / 88%);
    z-index: 100;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .modal2-box {
        background: #0c0c0c;
    color: #e0e3ee;
    border-radius: 16px;
    width: 600px;
    max-width: 94vw;
    box-shadow: 0 16px 48px 0 #01040eaa;
    padding: 32px 30px 22px 30px;
    position: relative;
    max-height: 88vh;
    overflow-y: auto;
    border: 1.5px solid #202020;
    font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
    font-smooth: always;
    letter-spacing: 0.01em;
  }
  .modal2-close-btn {
    position: absolute;
    right: 18px;
    top: 10px;
    background: none;
    color: #9298a6;
    border: none;
    font-size: 27px;
    font-weight: 700;
    cursor: pointer;
    transition: color .18s;
  }
  .modal2-close-btn:hover {
    color: #e74c3c;
  }
  .suspect-list {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
    margin-bottom: 12px;
  }
  .suspect-badge {
        background: #222736;
    color: #e0eaff;
    border-radius: 7px;
    padding: 3px 7px 3px 7px;
    font-family: 'SF PRO TEXT';
    font-weight: 100;
    font-size: 11px;
    box-shadow: 0 1px 2px #0004;
    border: 1px solid #31394d;
  }
  .police-note {
        background: #1c1c1c;
    color: #fcba61;
    border-radius: 7px;
    padding: 8px 13px;
    margin-bottom: 13px;
    font-size: 13px;
    font-weight: 500;
    border-left: 3px solid #ffcb6b;
  }
  .modal-search {
       width: 100%;
    margin-bottom: 10px;
    padding: 8px 12px;
    border-radius: 8px;
    border: 1px solid #2c2c2c;
    background: #0e0e10;
    color: #f0f0f0;
    font-family: 'SF Pro Text';
    font-size: 13px;
    transition: border .13s;
  }
  .modal-search:focus {
    border: 1.5px solid #448aff;
    outline: none;
  }
  .offense-list {
        margin-top: 4px;
    margin-bottom: 12px;
    max-height: 148px;
    font-weight: 100;
    font-family: SF Pro Text;
    overflow-y: auto;
    border: 1px solid #2e2e2e;
    border-radius: 7px;
    padding: 7px 9px 7px 8px;
    background: #0e0e0e;
    font-size: 12.2px;
  }
  .offense-item {
       display: flex;
    align-items: center;
    padding: 5px 2px 5px 2px;
    cursor: pointer;
    border-radius: 6px;
    margin-bottom: 1px;
    transition: background .13s, color .11s;
    color: #d3d7e7;
    user-select: none;
  }
  .offense-item.selected {
    background: #129dff45;
    color: #36c3ee;
  }
  .offense-item:hover {
    background: #212531;
    color: #5db0fa;
  }
  textarea {
       width: 100%;
    min-height: 60px;
    margin-top: 12px;
    font-weight: 100;
    border-radius: 7px;
    border: 1px solid #24273a;
    padding: 8px;
    resize: vertical;
    background: #191d29;
    color: #f5f5f7;
    font-size: 13.5px;
    font-family: 'SF Pro Text';
    letter-spacing: 0.01em;
  }
  .modalxx-actions {
    display: flex;
    gap: 10px;
    margin-top: 18px;
  }
  .modalxx-btn {
    padding: 10px 18px;
    border: none;
    border-radius: 7px;
    font-weight: 600;
    font-size: 16px;
    cursor: pointer;
    transition: background .15s, color .12s, box-shadow .13s;
    box-shadow: 0 1px 3px #0002;
    letter-spacing: 0.01em;
  }
  .modalxx-btn-primary {
    background: #35c8a1;
    color: #091012;
    font-weight: 700;
  }
  .modalxx-btn-primary:hover {
    background: #26997c;
    color: #f5fffa;
  }
  .modalxx-btn-secondary {
    background: #212535;
    color: #dde1ff;
  }
  .modalxx-btn-secondary:hover {
    background: #181a25;
    color: #ef5350;
  }
  h2 {
    font-family: inherit;
    font-size: 26px;
    font-weight: 700;
    letter-spacing: .02em;
    color: #d7e2fa;
    margin-bottom: 15px;
    margin-top: 4px;
    text-shadow: 0 1px 2px #0003;
  }
  ::-webkit-scrollbar { width: 7px; background: #161823; }
  ::-webkit-scrollbar-thumb { background: #21242e; border-radius: 6px; }
`}</style>

      <AnimatePresence>
        {open && (
          <motion.div
            className="modal2-backdrop"
            variants={{
              visible: { opacity: 1 },
              hidden: { opacity: 0 }
            }}
            initial="hidden"
            animate="visible"
            exit="hidden"
            onClick={onClose}
          >
            <motion.div
              className="modal2-box"
              variants={{
                hidden: { scale: 0.92, opacity: 0, y: 40 },
                visible: { scale: 1, opacity: 1, y: 0 }
              }}
              initial="hidden"
              animate="visible"
              exit="hidden"
              onClick={e => e.stopPropagation()}
            >
              <button className="modal2-close-btn" onClick={onClose}>×</button>
              <h2 style={{ fontWeight: 600, fontSize: 25, marginBottom: 16 }}>{lang.enterdec}</h2>

              <div className="suspect-list">
                {(Array.isArray(data?.offenders) ? data.offenders : []).map((name, index) => (
                  <span key={name?.name || name || index} className="suspect-badge">
                    {name?.name || name || `${suspici} ${index + 1}`}
                  </span>
                ))}
              </div>
              <div className="police-note">
                {data?.description ? data.description : lang.nonot}
              </div>
              {Array.isArray(data?.media) && data.media.length > 0 && (
                <div style={{
                  margin: "18px 0 8px 0",
                  background: "#181b23",
                  borderRadius: 8,
                  border: "1px solid #23263a",
                  padding: 12,
                  boxShadow: "0 1px 4px #0004"
                }}>
                  <div style={{ fontWeight: 600, fontSize: 15.5, color: "#82d4ff", marginBottom: 7 }}>
                    {lang.evidence}
                  </div>
                  <div style={{ display: "flex", flexWrap: "wrap", gap: 14 }}>
                    {Array.isArray(data?.evidence) && data.evidence.length > 0 && (
                        <div style={{
                          margin: "18px 0 8px 0",
                          background: "#181b23",
                          borderRadius: 8,
                          border: "1px solid #23263a",
                          padding: 12,
                          boxShadow: "0 1px 4px #0004"
                        }}>
                          <div style={{ fontWeight: 600, fontSize: 15.5, color: "#82d4ff", marginBottom: 7 }}>
                            {lang.evidence}
                          </div>
                          <div style={{ display: "flex", flexWrap: "wrap", gap: 14 }}>
                            {data.evidence.map((e, idx) => (
                              <div key={e.url || idx} style={{
                                display: "flex", flexDirection: "column", alignItems: "center",
                                background: "#222632", borderRadius: 7, padding: 8, width: 110, boxShadow: "0 1px 4px #0002"
                              }}>
                                <img src={e.url} alt={e.desc || lang.evidence} style={{
                                  width: 90, height: 70, objectFit: "cover", borderRadius: 6, border: "1.2px solid #262b3a"
                                }} />
                                <div style={{
                                  color: "#bcc7db", fontSize: 12.5, marginTop: 5, textAlign: "center", fontWeight: 500,
                                  maxWidth: 100, wordBreak: "break-word"
                                }}>{e.desc || lang.evidence}</div>
                              </div>
                            ))}
                          </div>
                        </div>
                      )}
                  </div>
                </div>
              )}
              <div style={{fontWeight: 600, marginBottom: 8, marginTop: 16}}>{lang.offpunish}</div>
              
              <input
                className="modal-search"
                type="text"
                placeholder={lang.crsearch}
                value={search}
                onChange={e => setSearch(e.target.value)}
              />

              <div className="offense-list">
                {filteredCrimes.map(crime => (
                  <div 
                    key={crime.id}
                    className={`offense-item ${selectedOffenses.includes(crime.id) ? 'selected' : ''}`}
                    onClick={() => handleOffenseChange(crime.id)}
                  >
                    <span>{crime.name} — ${crime.fine}</span>
                  </div>
                ))}
              </div>

               {/* Custom switchlerle ceza seçenekleri */}
              <div style={{ margin: "14px 0 5px 0", display: "flex", gap: 25, flexWrap: "wrap" }}>
                <ToggleSwitch
                  checked={prison}
                  onChange={e => setPrison(e.target.checked)}
                  label={lang.sendjail}
                  input={
                    <input
                      type="number"
                      placeholder={lang.durmonth}
                      style={{
                        width: 66, marginLeft: 7, background: prison ? "#23242b" : "#19191a",
                        color: "#e7eaf5", border: "1px solid #292929", borderRadius: 5,
                        padding: "4px 6px", fontSize: 13, opacity: prison ? 1 : 0.6,
                        transition: "background .16s, opacity .18s"
                      }}
                      min={1}
                      disabled={!prison}
                      value={prisonTime}
                      onChange={e => setPrisonTime(e.target.value.replace(/^0+/, ""))}
                    />
                  }
                />
                <ToggleSwitch
                  checked={communityService}
                  onChange={e => setCommunityService(e.target.checked)}
                  label={lang.publicceza}
                  input={
                    <input
                      type="number"
                      placeholder={lang.timeand}
                      style={{
                        width: 66, marginLeft: 7, background: communityService ? "#23242b" : "#19191a",
                        color: "#e7eaf5", border: "1px solid #292929", borderRadius: 5,
                        padding: "4px 6px", fontSize: 13, opacity: communityService ? 1 : 0.6,
                        transition: "background .16s, opacity .18s"
                      }}
                      min={1}
                      disabled={!communityService}
                      value={communityTime}
                      onChange={e => setCommunityTime(e.target.value.replace(/^0+/, ""))}
                    />
                  }
                />
              </div>


              {/* CEZA TOPLAMI */}
              <div style={{ marginTop: 13 }}>
                <b>{lang.totalceza}:</b> ${totalFine} <br />
              </div>

              <textarea
                value={notes}
                onChange={e => setNotes(e.target.value)}
                placeholder="Hakim açıklaması (opsiyonel)"
              />

              <div className="modalxx-actions">
                <button className="modalxx-btn modalxx-btn-primary" onClick={handleSubmit}>{lang.approvedecision}</button>
                <button className="modalxx-btn modalxx-btn-secondary" onClick={onClose}>{lang.cancel}</button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
}