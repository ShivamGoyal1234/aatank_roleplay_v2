import React, { useState, useEffect } from 'react';
import { 
  DollarSign, 
  Users, 
  TrendingUp, 
  Bell, 
  Lock,
  Plus,
  Trash2,
  Edit3,
  ChevronRight,
  Briefcase,
  Calendar,
  Clock,
  AlertCircle,
  Check,
  X
} from 'lucide-react';
import './main.css';
import { motion, AnimatePresence } from "framer-motion";

const BossDeskApp = () => {
  // State Management
  const [activeTab, setActiveTab] = useState('kasa');
  const [companyBalance, setCompanyBalance] = useState(150000);
  const [employees, setEmployees] = useState([
    { id: 1, name: 'Ahmet Yılmaz', role: 'Müdür', lastActive: '5 dakika önce', salary: 15000, sales: 23, revenue: 45000, permissions: ['view', 'manage'] },
    { id: 2, name: 'Ayşe Demir', role: 'Satış Uzmanı', lastActive: '12 dakika önce', salary: 8500, sales: 18, revenue: 32000, permissions: ['view'] },
    { id: 3, name: 'Mehmet Kaya', role: 'Kasa Görevlisi', lastActive: '1 saat önce', salary: 7000, sales: 14, revenue: 7000, permissions: ['view'] },
    { id: 4, name: 'Fatma Öz', role: 'Satış Danışmanı', lastActive: '3 saat önce', salary: 6500, sales: 9, revenue: 12000, permissions: [] }
  ]);
  const [transactions, setTransactions] = useState([
    { id: 1, type: 'in', amount: 5000, employee: 'Ayşe Demir', date: '2024-01-15 14:30', description: 'Satış geliri' },
    { id: 2, type: 'out', amount: 2000, employee: 'Ahmet Yılmaz', date: '2024-01-15 12:15', description: 'Kırtasiye alımı' },
    { id: 3, type: 'out', amount: 15000, employee: 'Sistem', date: '2024-01-14 09:00', description: 'Maaş ödemesi - Ahmet Yılmaz' }
  ]);
  const [announcements, setAnnouncements] = useState([
    { id: 1, title: 'VIP Müşteri Ziyareti', content: 'Yarın saat 14:00\'da VIP müşteri gelecek. Herkes temiz gömlek giysin.', date: '2024-01-15', priority: 'high' },
    { id: 2, title: 'Aylık Toplantı', content: 'Cuma günü saat 16:00\'da aylık değerlendirme toplantısı yapılacak.', date: '2024-01-14', priority: 'medium' }
  ]);
  
  // Modal States
  const [showTransactionModal, setShowTransactionModal] = useState(false);
  const [showEmployeeModal, setShowEmployeeModal] = useState(false);
  const [showAnnouncementModal, setShowAnnouncementModal] = useState(false);
  const [editingEmployee, setEditingEmployee] = useState(null);
  
  // Form States
  const [transactionForm, setTransactionForm] = useState({ type: 'in', amount: '', description: '' });
  const [employeeForm, setEmployeeForm] = useState({ name: '', role: '', salary: '', permissions: [] });
  const [announcementForm, setAnnouncementForm] = useState({ title: '', content: '', priority: 'medium' });

  // Handlers
  const handleTransaction = () => {
    if (!transactionForm.amount) return;
    
    const newTransaction = {
      id: transactions.length + 1,
      type: transactionForm.type,
      amount: parseFloat(transactionForm.amount),
      employee: 'Manuel İşlem',
      date: new Date().toLocaleString('tr-TR'),
      description: transactionForm.description || (transactionForm.type === 'in' ? 'Para yatırma' : 'Para çekme')
    };
    
    setTransactions([newTransaction, ...transactions]);
    setCompanyBalance(prev => 
      transactionForm.type === 'in' 
        ? prev + parseFloat(transactionForm.amount)
        : prev - parseFloat(transactionForm.amount)
    );
    setShowTransactionModal(false);
    setTransactionForm({ type: 'in', amount: '', description: '' });
  };

  const handleEmployeeSubmit = () => {
    if (!employeeForm.name || !employeeForm.role || !employeeForm.salary) return;
    
    if (editingEmployee) {
      setEmployees(employees.map(emp => 
        emp.id === editingEmployee.id 
          ? { ...emp, ...employeeForm, salary: parseFloat(employeeForm.salary) }
          : emp
      ));
    } else {
      const newEmployee = {
        id: employees.length + 1,
        name: employeeForm.name,
        role: employeeForm.role,
        salary: parseFloat(employeeForm.salary),
        lastActive: 'Şimdi',
        sales: 0,
        revenue: 0,
        permissions: employeeForm.permissions
      };
      setEmployees([...employees, newEmployee]);
    }
    
    setShowEmployeeModal(false);
    setEditingEmployee(null);
    setEmployeeForm({ name: '', role: '', salary: '', permissions: [] });
  };

  const handleDeleteEmployee = (id) => {
    if (window.confirm('Bu çalışanı silmek istediğinize emin misiniz?')) {
      setEmployees(employees.filter(emp => emp.id !== id));
    }
  };

  const handleAnnouncementSubmit = () => {
    if (!announcementForm.title || !announcementForm.content) return;
    
    const newAnnouncement = {
      id: announcements.length + 1,
      ...announcementForm,
      date: new Date().toISOString().split('T')[0]
    };
    
    setAnnouncements([newAnnouncement, ...announcements]);
    setShowAnnouncementModal(false);
    setAnnouncementForm({ title: '', content: '', priority: 'medium' });
  };

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('tr-TR', {
      style: 'currency',
      currency: 'TRY',
      minimumFractionDigits: 0
    }).format(amount);
  };

  return (
    <>
      
      <div className="boss-desk-app">
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
                </div>
        <div className="app-header">
          <div className="header-left">
            <h1><Briefcase size={24} /> BossDesk</h1>
            <span className="company-name">Şirket Yönetim Sistemi</span>
          </div>
          <div className="header-right">
            {/* <div className="balance-display">
              <DollarSign size={20} />
              <span>{formatCurrency(companyBalance)}</span>
            </div> */}
            <div className="user-info">
              <Lock size={16} />
              <span>Patron</span>
            </div>
          </div>
        </div>

        {/* Navigation */}
        <div className="nav-tabs">
          <button 
            className={`nav-tab ${activeTab === 'kasa' ? 'active' : ''}`}
            onClick={() => setActiveTab('kasa')}
          >
            <DollarSign size={18} />
            <span>Kasa Takibi</span>
          </button>
          <button 
            className={`nav-tab ${activeTab === 'calisanlar' ? 'active' : ''}`}
            onClick={() => setActiveTab('calisanlar')}
          >
            <Users size={18} />
            <span>Çalışanlar</span>
          </button>
          <button 
            className={`nav-tab ${activeTab === 'performans' ? 'active' : ''}`}
            onClick={() => setActiveTab('performans')}
          >
            <TrendingUp size={18} />
            <span>Performans</span>
          </button>
          <button 
            className={`nav-tab ${activeTab === 'duyurular' ? 'active' : ''}`}
            onClick={() => setActiveTab('duyurular')}
          >
            <Bell size={18} />
            <span>Duyurular</span>
          </button>
        </div>

        {/* Content */}
        <div className="app-content">
          {/* Kasa Takibi */}
          {activeTab === 'kasa' && (
            <div className="tab-content">
              <div className="content-header">
                <h2>Kasa Takibi</h2>
                <button className="btn-primary" onClick={() => setShowTransactionModal(true)}>
                  <Plus size={18} />
                  İşlem Yap
                </button>
              </div>
              <div className="stat-card">
                  <div className="stat-icon green">
                    <TrendingUp size={24} />
                  </div>
                  <div className="stat-info">
                    <span className="stat-label">Mevcut Bakiye</span>
                    <span className="stat-value">{formatCurrency(5000)}</span>
                  </div>
                </div>
              <div className="stats-grid">
                
                <div className="stat-card">
                  <div className="stat-icon green">
                    <TrendingUp size={24} />
                  </div>
                  <div className="stat-info">
                    <span className="stat-label">Bugün kü giriş</span>
                    <span className="stat-value">{formatCurrency(5000)}</span>
                  </div>
                </div>
                <div className="stat-card">
                  <div className="stat-icon red">
                    <TrendingUp size={24} style={{ transform: 'rotate(180deg)' }} />
                  </div>
                  <div className="stat-info">
                    <span className="stat-label">Bugünkü Çıkış</span>
                    <span className="stat-value">{formatCurrency(17000)}</span>
                  </div>
                </div>
              </div>

              <div className="transactions-list">
                <h3>Son İşlemler</h3>
                {transactions.map(transaction => (
                  <div key={transaction.id} className={`transaction-item ${transaction.type}`}>
                    <div className="transaction-left">
                      <div className={`transaction-icon ${transaction.type}`}>
                        {transaction.type === 'in' ? '+' : '-'}
                      </div>
                      <div className="transaction-info">
                        <span className="transaction-desc">{transaction.description}</span>
                        <span className="transaction-meta">{transaction.employee} • {transaction.date}</span>
                      </div>
                    </div>
                    <div className={`transaction-amount ${transaction.type}`}>
                      {transaction.type === 'in' ? '+' : '-'}{formatCurrency(transaction.amount)}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Çalışanlar */}
          {activeTab === 'calisanlar' && (
            <div className="tab-content">
              <div className="content-header">
                <h2>Çalışan Yönetimi</h2>
                <button className="btn-primary" onClick={() => setShowEmployeeModal(true)}>
                  <Plus size={18} />
                  Çalışan Ekle
                </button>
              </div>

              <div className="employees-list">
                {employees.map(employee => (
                  <div key={employee.id} className="employee-card">
                    <div className="employee-header">
                      <div className="employee-info">
                        <h4>{employee.name}</h4>
                        <span className="employee-role">{employee.role}</span>
                      </div>
                      <div className="employee-actions">
                        <button 
                          className="btn-icon"
                          onClick={() => {
                            setEditingEmployee(employee);
                            setEmployeeForm(employee);
                            setShowEmployeeModal(true);
                          }}
                        >
                          <Edit3 size={16} />
                        </button>
                        <button 
                          className="btn-icon delete"
                          onClick={() => handleDeleteEmployee(employee.id)}
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </div>
                    <div className="employee-details">
                      <div className="detail-item">
                        <Clock size={14} />
                        <span>{employee.lastActive}</span>
                      </div>
                      <div className="detail-item">
                        <DollarSign size={14} />
                        <span>{formatCurrency(employee.salary)}/ay</span>
                      </div>
                      <div className="detail-item">
                        <Lock size={14} />
                        <span>{employee.permissions.length > 0 ? employee.permissions.join(', ') : 'Yetki yok'}</span>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Performans */}
          {activeTab === 'performans' && (
            <div className="tab-content">
              <div className="content-header">
                <h2>İş Performansı</h2>
              </div>

              <div className="performance-grid">
                {employees.map(employee => (
                  <div key={employee.id} className="performance-card">
                    <div className="performance-header">
                      <h4>{employee.name}</h4>
                      <span className="role-badge">{employee.role}</span>
                    </div>
                    <div className="performance-stats">
                      <div className="perf-stat">
                        <span className="perf-label">Toplam Satış</span>
                        <span className="perf-value">{employee.sales}</span>
                      </div>
                      <div className="perf-stat">
                        <span className="perf-label">Kazandırdığı</span>
                        <span className="perf-value green">{formatCurrency(employee.revenue)}</span>
                      </div>
                      <div className="perf-stat">
                        <span className="perf-label">Verimlilik</span>
                        <div className="progress-bar">
                          <div 
                            className="progress-fill"
                            style={{ width: `${Math.min((employee.revenue / 50000) * 100, 100)}%` }}
                          ></div>
                        </div>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Duyurular */}
          {activeTab === 'duyurular' && (
            <div className="tab-content">
              <div className="content-header">
                <h2>Duyurular & Görevler</h2>
                <button className="btn-primary" onClick={() => setShowAnnouncementModal(true)}>
                  <Plus size={18} />
                  Duyuru Ekle
                </button>
              </div>

              <div className="announcements-list">
                {announcements.map(announcement => (
                  <div key={announcement.id} className={`announcement-card ${announcement.priority}`}>
                    <div className="announcement-header">
                      <h4>{announcement.title}</h4>
                      <span className={`priority-badge ${announcement.priority}`}>
                        {announcement.priority === 'high' ? 'Yüksek' : announcement.priority === 'medium' ? 'Orta' : 'Düşük'}
                      </span>
                    </div>
                    <p>{announcement.content}</p>
                    <div className="announcement-footer">
                      <Calendar size={14} />
                      <span>{announcement.date}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>

        <AnimatePresence>
  {showTransactionModal && (
    <motion.div
      className="modal-overlayx"
      onClick={() => setShowTransactionModal(false)}
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
    >
      <motion.div
        className="modalx"
        onClick={(e) => e.stopPropagation()}
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        exit={{ opacity: 0, scale: 0.95 }}
        transition={{ duration: 0.2, ease: "easeInOut" }}
      >
        <div className="modal-headerx">
          <h3>Kasa İşlemi</h3>
          <button className="btn-icon" onClick={() => setShowTransactionModal(false)}>
            <X size={20} />
          </button>
        </div>
        <div className="modal-bodyx">
          <div className="form-group">
            <label>İşlem Tipi</label>
            <div className="radio-group">
              <label className="radio-label">
                <input
                  type="radio"
                  name="type"
                  value="in"
                  checked={transactionForm.type === "in"}
                  onChange={(e) => setTransactionForm({ ...transactionForm, type: e.target.value })}
                />
                <span>Para Girişi</span>
              </label>
              <label className="radio-label">
                <input
                  type="radio"
                  name="type"
                  value="out"
                  checked={transactionForm.type === "out"}
                  onChange={(e) => setTransactionForm({ ...transactionForm, type: e.target.value })}
                />
                <span>Para Çıkışı</span>
              </label>
            </div>
          </div>
          <div className="form-group">
            <label>Tutar</label>
            <input
              type="number"
              placeholder="0.00"
              value={transactionForm.amount}
              onChange={(e) => setTransactionForm({ ...transactionForm, amount: e.target.value })}
            />
          </div>
          <div className="form-group">
            <label>Açıklama</label>
            <input
              type="text"
              placeholder="İşlem açıklaması..."
              value={transactionForm.description}
              onChange={(e) => setTransactionForm({ ...transactionForm, description: e.target.value })}
            />
          </div>
        </div>
        <div className="modal-footerx">
          <button className="btn-secondary" onClick={() => setShowTransactionModal(false)}>
            İptal
          </button>
          <button className="btn-primary" onClick={handleTransaction}>
            İşlemi Kaydet
          </button>
        </div>
      </motion.div>
    </motion.div>
  )}
</AnimatePresence>

        {/* Announcement Modal */}
        <AnimatePresence>
            {showAnnouncementModal && (
                <motion.div
                className="modal-overlayx"
                onClick={() => setShowAnnouncementModal(false)}
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                >
                <motion.div
                    className="modalx"
                    onClick={e => e.stopPropagation()}
                    initial={{ opacity: 0, scale: 0.9 }}
                    animate={{ opacity: 1, scale: 1 }}
                    exit={{ opacity: 0, scale: 0.9 }}
                    transition={{ duration: 0.2, ease: "easeInOut" }}
                >
                    <div className="modal-headerx">
                    <h3>Yeni Duyuru</h3>
                    <button className="btn-icon" onClick={() => setShowAnnouncementModal(false)}>
                        <X size={20} />
                    </button>
                    </div>
                    <div className="modal-bodyx">
                    <div className="form-group">
                        <label>Başlık</label>
                        <input 
                        type="text" 
                        placeholder="Duyuru başlığı..."
                        value={announcementForm.title}
                        onChange={e => setAnnouncementForm({...announcementForm, title: e.target.value})}
                        />
                    </div>
                    <div className="form-group">
                        <label>İçerik</label>
                        <textarea 
                        placeholder="Duyuru içeriği..."
                        rows="4"
                        value={announcementForm.content}
                        onChange={e => setAnnouncementForm({...announcementForm, content: e.target.value})}
                        />
                    </div>
                    <div className="form-group">
                        <label>Öncelik</label>
                        <select 
                        value={announcementForm.priority}
                        onChange={e => setAnnouncementForm({...announcementForm, priority: e.target.value})}
                        >
                        <option value="low">Düşük</option>
                        <option value="medium">Orta</option>
                        <option value="high">Yüksek</option>
                        </select>
                    </div>
                    </div>
                    <div className="modal-footerx">
                    <button className="btn-secondary" onClick={() => setShowAnnouncementModal(false)}>
                        İptal
                    </button>
                    <button className="btn-primary" onClick={handleAnnouncementSubmit}>
                        Duyuru Yap
                    </button>
                    </div>
                </motion.div>
                </motion.div>
            )}
            </AnimatePresence>


            <AnimatePresence>
  {showEmployeeModal && (
    <motion.div
      className="modal-overlayx"
      onClick={() => {
        setShowEmployeeModal(false);
        setEditingEmployee(null);
        setEmployeeForm({ name: '', role: '', salary: '', permissions: [] });
      }}
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
    >
      <motion.div
        className="modalx"
        onClick={(e) => e.stopPropagation()}
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        exit={{ opacity: 0, scale: 0.95 }}
        transition={{ duration: 0.2, ease: "easeInOut" }}
      >
        <div className="modal-headerx">
          <h3>{editingEmployee ? 'Çalışan Düzenle' : 'Yeni Çalışan Ekle'}</h3>
          <button className="btn-icon" onClick={() => {
            setShowEmployeeModal(false);
            setEditingEmployee(null);
            setEmployeeForm({ name: '', role: '', salary: '', permissions: [] });
          }}>
            <X size={20} />
          </button>
        </div>
        <div className="modal-bodyx">
          <div className="form-group">
            <label>Ad Soyad</label>
            <input 
              type="text" 
              placeholder="Çalışan adı..."
              value={employeeForm.name}
              onChange={e => setEmployeeForm({...employeeForm, name: e.target.value})}
            />
          </div>
          <div className="form-group">
            <label>Görev</label>
            <input 
              type="text" 
              placeholder="Görev/Pozisyon..."
              value={employeeForm.role}
              onChange={e => setEmployeeForm({...employeeForm, role: e.target.value})}
            />
          </div>
          <div className="form-group">
            <label>Aylık Maaş</label>
            <input 
              type="number" 
              placeholder="0.00"
              value={employeeForm.salary}
              onChange={e => setEmployeeForm({...employeeForm, salary: e.target.value})}
            />
          </div>
          <div className="form-group">
            <label>Yetkiler</label>
            <div className="checkbox-group">
              <label className="checkbox-label">
                <input 
                  type="checkbox" 
                  checked={employeeForm.permissions?.includes('view')}
                  onChange={e => {
                    const perms = [...(employeeForm.permissions || [])];
                    if (e.target.checked) {
                      perms.push('view');
                    } else {
                      const index = perms.indexOf('view');
                      if (index > -1) perms.splice(index, 1);
                    }
                    setEmployeeForm({...employeeForm, permissions: perms});
                  }}
                />
                <span>Görüntüleme</span>
              </label>
              <label className="checkbox-label">
                <input 
                  type="checkbox" 
                  checked={employeeForm.permissions?.includes('manage')}
                  onChange={e => {
                    const perms = [...(employeeForm.permissions || [])];
                    if (e.target.checked) {
                      perms.push('manage');
                    } else {
                      const index = perms.indexOf('manage');
                      if (index > -1) perms.splice(index, 1);
                    }
                    setEmployeeForm({...employeeForm, permissions: perms});
                  }}
                />
                <span>Yönetim</span>
              </label>
            </div>
          </div>
        </div>
        <div className="modal-footerx">
          <button className="btn-secondary" onClick={() => {
            setShowEmployeeModal(false);
            setEditingEmployee(null);
            setEmployeeForm({ name: '', role: '', salary: '', permissions: [] });
          }}>
            İptal
          </button>
          <button className="btn-primary" onClick={handleEmployeeSubmit}>
            {editingEmployee ? 'Güncelle' : 'Ekle'}
          </button>
        </div>
      </motion.div>
    </motion.div>
  )}
</AnimatePresence>
      </div>
    </>
  );
};

export default BossDeskApp;