import React, { useState, useEffect } from 'react';
import { Grip, Plus, Trash2, X, Check, Smartphone } from 'lucide-react';
import './main.css';

const AppManager = () => {
  const [apps, setApps] = useState([]);
  const [isOpen, setIsOpen] = useState(true);
  const [showAddModal, setShowAddModal] = useState(false);
  const [draggedIndex, setDraggedIndex] = useState(null);
  const [newApp, setNewApp] = useState({
    App: '',
    AppHash: '',
    Icon: '',
    Default: false,
    Widget: false,
    Jobs: []
  });

  // FiveM'den gelen veriyi simüle et
  useEffect(() => {
    // Bu kısımda FiveM'den gelen JSON verisi olacak
    const mockData = [
      { App: 'Weather', AppHash: 'weather', Default: false, Slot: 1, Widget: true },
      { App: 'Clock', AppHash: 'clock', Default: true, Slot: 2, Widget: true },
      { App: 'mail', AppHash: 'mail', Default: true, Slot: 3, Widget: true },
      { App: 'Settings', Icon: 'settings.png', AppHash: 'settings', Default: true, Slot: 4, Widget: false },
      { App: 'Camera', Icon: 'camera.png', AppHash: 'camera', Default: false, Slot: 5, Widget: false },
      { App: 'Gallery', Icon: 'gallery.png', AppHash: 'gallery', Default: false, Slot: 6, Widget: false },
      { App: 'Notes', Icon: 'notes.png', AppHash: 'notes', Default: true, Slot: 7, Widget: false },
      { App: 'MyBillings', Icon: 'billings.png', AppHash: 'billing', Default: true, Slot: 8, Widget: false },
      { App: 'Mail', Icon: 'mail.png', AppHash: 'mail', Default: true, Slot: 9, Widget: false },
      { App: 'Calculator', Icon: 'calculator.png', AppHash: 'calculator', Default: false, Slot: 10, Widget: false },
      { App: 'MDT', Icon: 'mdt.png', AppHash: 'mdt', Default: false, Jobs: ["police"], Slot: 11, Widget: false },
      { App: 'Map', Icon: 'map.png', AppHash: 'map', Default: true, Slot: 12, Widget: false },
      { App: 'EMS', Icon: 'ems.png', AppHash: 'ems', Default: false, Jobs: ["ambulance", "police"], Slot: 13, Widget: false },
      { App: 'VerdictOS', Icon: 'dojapp.png', AppHash: 'dojapp', Default: false, Jobs: ["police", "lawyer", "prosecutor", "judge"], Slot: 14, Widget: false },
      { App: 'Housing', Icon: 'houseapp.png', AppHash: 'housing', Default: false, Slot: 15, Widget: false },
      { App: 'MyApartment', Icon: 'myapartment.png', AppHash: 'myapartment', Default: false, Slot: 16, Widget: false }
    ];
    setApps(mockData);
  }, []);

  const handleDragStart = (e, index) => {
    setDraggedIndex(index);
    e.dataTransfer.effectAllowed = 'move';
  };

  const handleDragOver = (e) => {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'move';
  };

  const handleDrop = (e, dropIndex) => {
    e.preventDefault();
    if (draggedIndex === null) return;

    const draggedApp = apps[draggedIndex];
    const newApps = [...apps];
    newApps.splice(draggedIndex, 1);
    newApps.splice(dropIndex, 0, draggedApp);

    // Slot numaralarını yeniden düzenle
    const updatedApps = newApps.map((app, index) => ({
      ...app,
      Slot: index + 1
    }));

    setApps(updatedApps);
    setDraggedIndex(null);

    // FiveM'e veriyi gönder
    if (window.invokeNative) {
      window.invokeNative('updateApps', JSON.stringify(updatedApps));
    }
  };

  const handleAddApp = () => {
    const newSlot = apps.length + 1;
    const appToAdd = {
      ...newApp,
      Slot: newSlot,
      Jobs: newApp.Jobs.length > 0 ? newApp.Jobs : undefined
    };

    const updatedApps = [...apps, appToAdd];
    setApps(updatedApps);
    setShowAddModal(false);
    setNewApp({
      App: '',
      AppHash: '',
      Icon: '',
      Default: false,
      Widget: false,
      Jobs: []
    });

    // FiveM'e veriyi gönder
    if (window.invokeNative) {
      window.invokeNative('updateApps', JSON.stringify(updatedApps));
    }
  };

  const handleDeleteApp = (index) => {
    const updatedApps = apps.filter((_, i) => i !== index).map((app, idx) => ({
      ...app,
      Slot: idx + 1
    }));
    setApps(updatedApps);

    // FiveM'e veriyi gönder
    if (window.invokeNative) {
      window.invokeNative('updateApps', JSON.stringify(updatedApps));
    }
  };

  const handleClose = () => {
    setIsOpen(false);
    // FiveM'e kapatma sinyali gönder
    if (window.invokeNative) {
      window.invokeNative('closeAppManager');
    }
  };

  const handleJobsChange = (e) => {
    const jobsText = e.target.value;
    const jobsArray = jobsText.split(',').map(job => job.trim()).filter(job => job);
    setNewApp({ ...newApp, Jobs: jobsArray });
  };

  return (
    <>
      <div className={`app-manager-overlay ${!isOpen ? 'closed' : ''}`}>
        <div className="app-manager-container">
          {/* Header */}
          <div className="app-header">
            <div className="app-header-title">
              <Smartphone size={24} style={{ color: '#60A5FA' }} />
              <h2>Uygulama Yönetici</h2>
            </div>
            <button onClick={handleClose} className="close-button">
              <X size={24} />
            </button>
          </div>

          {/* Content */}
          <div className="app-content">
            {/* Add Button */}
            <button onClick={() => setShowAddModal(true)} className="add-button">
              <Plus size={20} />
              <span>Yeni Uygulama Ekle</span>
            </button>

            {/* Apps List */}
            <div className="apps-list">
              {apps.map((app, index) => (
                <div
                  key={`${app.AppHash}-${index}`}
                  draggable
                  onDragStart={(e) => handleDragStart(e, index)}
                  onDragOver={handleDragOver}
                  onDrop={(e) => handleDrop(e, index)}
                  className={`app-item ${draggedIndex === index ? 'dragging' : ''}`}
                >
                  <div className="app-item-left">
                    <Grip size={20} className="drag-handle" />
                    <div className="app-icon">
                      <span>{app.App.substring(0, 2)}</span>
                    </div>
                    <div className="app-info">
                      <h3>{app.App}</h3>
                      <div className="app-tags">
                        <span>Slot: {app.Slot}</span>
                        {app.Widget && <span className="app-tag widget">Widget</span>}
                        {app.Default && <span className="app-tag default">Varsayılan</span>}
                        {app.Jobs && (
                          <span className="app-tag jobs">
                            {app.Jobs.join(', ')}
                          </span>
                        )}
                      </div>
                    </div>
                  </div>
                  <button onClick={() => handleDeleteApp(index)} className="delete-button">
                    <Trash2 size={20} />
                  </button>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Add App Modal */}
      {showAddModal && (
        <div className="modal-overlay">
          <div className="modal-container">
            <h3 className="modal-title">Yeni Uygulama Ekle</h3>
            
            <div className="form-group">
              <label className="form-label">Uygulama Adı</label>
              <input
                type="text"
                value={newApp.App}
                onChange={(e) => setNewApp({ ...newApp, App: e.target.value })}
                className="form-input"
                placeholder="Örn: Calculator"
              />
            </div>

            <div className="form-group">
              <label className="form-label">App Hash</label>
              <input
                type="text"
                value={newApp.AppHash}
                onChange={(e) => setNewApp({ ...newApp, AppHash: e.target.value })}
                className="form-input"
                placeholder="Örn: calculator"
              />
            </div>

            <div className="form-group">
              <label className="form-label">İkon Dosyası</label>
              <input
                type="text"
                value={newApp.Icon}
                onChange={(e) => setNewApp({ ...newApp, Icon: e.target.value })}
                className="form-input"
                placeholder="Örn: calculator.png"
              />
            </div>

            <div className="form-group">
              <label className="form-label">Meslekler (virgülle ayırın)</label>
              <input
                type="text"
                value={newApp.Jobs?.join(', ') || ''}
                onChange={handleJobsChange}
                className="form-input"
                placeholder="Örn: police, ambulance"
              />
            </div>

            <div className="checkbox-group">
              <label className="checkbox-label">
                <input
                  type="checkbox"
                  checked={newApp.Default}
                  onChange={(e) => setNewApp({ ...newApp, Default: e.target.checked })}
                />
                <span>Varsayılan</span>
              </label>

              <label className="checkbox-label">
                <input
                  type="checkbox"
                  checked={newApp.Widget}
                  onChange={(e) => setNewApp({ ...newApp, Widget: e.target.checked })}
                />
                <span>Widget</span>
              </label>
            </div>

            <div className="modal-buttons">
              <button onClick={() => setShowAddModal(false)} className="modal-button cancel">
                İptal
              </button>
              <button
                onClick={handleAddApp}
                disabled={!newApp.App || !newApp.AppHash}
                className="modal-button submit"
              >
                <Check size={20} />
                <span>Ekle</span>
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default AppManager;