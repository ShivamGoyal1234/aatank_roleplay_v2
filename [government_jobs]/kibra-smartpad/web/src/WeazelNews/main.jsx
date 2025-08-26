import React, { useState, useEffect, useRef } from 'react';
import { ChevronDown, Search, Sun, Moon, Bell, User, Calendar, Clock, MessageSquare, TrendingUp, Shield, DollarSign, Trophy, Newspaper, X, Check, Trash2, Menu, ChevronRight, AlertCircle } from 'lucide-react';
import './main.css';
import ApplicationModal from './application'; // Path ayarla
import { callNui } from '@/nui';
import ColdModal from '@/SettingsApp/coldModal/main';
import CustomDropdown from './dropdown';

const WeazelNewsApp = ({lang, batteryLevel, news, isBoss, applications, playerGalleryData}) => {
  const [isDarkMode, setIsDarkMode] = useState(true);
  const [activeCategory, setActiveCategory] = useState('all');
  const [selectedArticle, setSelectedArticle] = useState(null);
  const [showStaffPanel, setShowStaffPanel] = useState(false);
  const [showApplications, setShowApplications] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [showBreakingNews, setShowBreakingNews] = useState(true);
  const [isOwner, setIsOwner] = useState(false);
  const [applicationsOpen, setApplicationsOpen] = useState(true);
  const [showMobileMenu, setShowMobileMenu] = useState(false);
  const [selectedMedias, setSelectedMedias] = useState([]);
  const [pato, setPato] = useState(false);
  const [isAnyLive, setLive] = useState(false);
  const [time, setTime] = useState(new Date());
  const [newArticleTags, setNewArticleTags] = useState([]);
  const [tagInput, setTagInput] = useState('');
  const [showApplyModal, setShowApplyModal] = useState(false);
  const [activeStaffTab, setActiveStaffTab] = useState('create');
  const [newPoll, setNewPoll] = useState({ question: '', options: ['', '', '', ''] });
  const [journalist, setJournalist] = useState([]);
  const [getGrades, setGrades] = useState([]);
  const [commentText, setCommentText] = useState('');
  const [players, setPlayers] = useState([]);
  const [nofity, setNofity] = useState({
    title: '',
    msg: ''
  });

  const [applikasyons, setNewApplikasyons] = useState([]);

  useEffect(() => {
    setNewApplikasyons(applications);
  }, [applications])

  useEffect(() => {
    setIsOwner(isBoss);
  }, [isBoss])

  const openStaffPanel = () => {
    callNui('getJournalists', {}, (data) => {
      if(data.data && data.data.length > 0){
        setJournalist(data.data);
        setGrades(data.getGrades);
        setPlayers(data.players);
        const immediateOptions = data.getGrades.map((grade) => ({
          value: grade.gradelevel,
          label: grade.label
        }));
      }
    })
    setShowStaffPanel(true);
  }

  const roleOptions = React.useMemo(() => {
    return (getGrades || []).map((grade) => ({
      value: grade.gradelevel,
      label: grade.label
    }))
  }, [getGrades])


  const handleUpdateNofity = (title, msg) => {
    setNofity(nofity => ({...nofity, title: title, msg: msg}))
    setPato(true);
  }
  
  function handleCreatePoll() {
    if (
      !newPoll.question.trim() ||
      newPoll.options.filter(opt => opt && opt.trim()).length < 2
    ) return;
    // Burada backend’e veya NUI’ya poll’u yolla
    // callNui('CreatePoll', newPoll);
    setNewPoll({ question: '', options: ['', '', '', ''] });
    // Kullanıcıya “anket paylaşıldı” bildirimi göster
  }

  const [galleryOpen, setGalleryOpen] = useState(false);
  const [playerGallery, setPlayerGallery] = useState([]); // bu zaten sende vardır büyük ihtimal
  const formattedTime = `${time.getHours().toString().padStart(2, "0")}:${time
      .getMinutes()
      .toString()
      .padStart(2, "0")}`;
  const [newArticle, setNewArticle] = useState({
    headline: '',
    summary: '',
    content: '',
    category: 'community',
    image: ''
  });
  const playerList = ['Emir', 'Kemir']
  const [newStaffName, setNewStaffName] = useState('');
  const [newStaffNameInput, setNewStaffNameInput] = useState('')

  const [newStaffCid, setNewStaffCid] = useState('');
  const [newStaffRole, setNewStaffRole] = useState('Kameraman')
  const [newStaffSalary, setNewStaffSalary] = useState('');
  const [currentIndexes, setCurrentIndexes] = useState({}); // { [article.id]: 0 }
  const [articles, setArticles] = useState([]);

  useEffect(() => {
    const sortedNews = news.map(article => ({
      ...article,
      comments: [...article.comments].reverse()
    }))
    setArticles(sortedNews)
  }, [news])


  const handlePrev = (e, articleId, imagesLen) => {
    e.stopPropagation();
    setCurrentIndexes(idx => ({
      ...idx,
      [articleId]: ((idx[articleId] || 0) - 1 + imagesLen) % imagesLen
    }));
  };
  const handleNext = (e, articleId, imagesLen) => {
    e.stopPropagation();
    setCurrentIndexes(idx => ({
      ...idx,
      [articleId]: ((idx[articleId] || 0) + 1) % imagesLen
    }));
  };
  
  const handleAddStaff = () => {
    console.log(newStaffName, newStaffRole)
    if (!newStaffName || !newStaffRole) {
      handleUpdateNofity(lang.error, lang.emptyFields)
      return // bu olmazsa devam eder hata verse bile
    }    
    const staffItem = {
      id: staff.length + 1,
      cid: newStaffCid,
      name: newStaffName,
      role: newStaffRole,
      joinDate: new Date(),
    }
    
    callNui('addNewStaff', {staffItem}, (res) => setJournalist(res));
    setStaff([...staff, staffItem])
    // setNewStaffNameInput('')
    setNewStaffRole('Kameraman')
    setNewStaffSalary('')
  }

    const [form, setForm] = useState({
      role: "Muhabir",
      name: "",
      age: "",
      experience: "",
      motivation: ""
    });
    const [submitting, setSubmitting] = useState(false);
//    useEffect(() => {
//   const disableScroll = showStaffPanel || showApplications || selectedArticle;
//   document.body.style.overflow = disableScroll ? 'hidden' : 'auto';
// }, [showStaffPanel, showApplications, selectedArticle]);


  // const playerGalleryData = [{"url":"https://r2.fivemanage.com/image/P5Svo7GAG8Vn.png","location":"Del Perro | South Rockford Dr","code":881583,"type":"photo","liked":true,"date":"20/07/2025"},{"url":"https://r2.fivemanage.com/image/6DvVncT7UgCG.png","location":"Del Perro | Prosperity St","code":722616,"type":"photo","date":"20/07/2025"},{"url":"https://r2.fivemanage.com/video/iRAN3IzN9VQQ.webm","location":"Del Perro | Prosperity St","code":217316,"type":"video","date":"20/07/2025"},{"url":"https://r2.fivemanage.com/image/EEjQUCIQV9Q3.png","location":"Del Perro | Prosperity St","code":984123,"type":"photo","date":"20/07/2025"},{"url":"https://r2.fivemanage.com/video/hskUv56bQ9i5.webm","location":"Del Perro | Boulevard Del Perro","code":400260,"type":"video","date":"20/07/2025"},{"url":"https://r2.fivemanage.com/image/2v68ImcmhUxc.png","location":"Del Perro | Prosperity St","code":698974,"type":"photo","date":"20/07/2025"},{"url":"https://r2.fivemanage.com/video/TlGdf5DHRz3T.webm","location":"Del Perro | Prosperity St","code":563420,"type":"video","date":"20/07/2025"},{"url":"https://r2.fivemanage.com/image/Q7xIhn1jEQhN.png","location":"Del Perro | Prosperity St","code":531222,"type":"photo","date":"20/07/2025"},{"url":"https://r2.fivemanage.com/video/uEKy8RAnAz0L.webm","location":"Del Perro | Prosperity St","code":679868,"type":"video","date":"20/07/2025"},{"url":"https://r2.fivemanage.com/video/NCACbp09KLCK.webm","location":"Del Perro | Boulevard Del Perro","code":456197,"type":"video","date":"20/07/2025"},{"url":"https://r2.fivemanage.com/image/hadGAgHl8pEo.jpg","location":"Del Perro | Prosperity St","date":"21/07/2025","type":"photo","code":682327},{"url":"https://r2.fivemanage.com/video/Fi1QZ0MJnb2x.webm","location":"Del Perro | Prosperity St","date":"21/07/2025","type":"video","code":519167}]

  useEffect(() => setPlayerGallery(playerGalleryData), [playerGalleryData]);

  // 1. ÖNCE useEffect'teki CSS'i tamamen değiştirin:

  // 5 saniye bekle, sonra test et

useEffect(() => {
  const style = document.createElement('style');
  style.textContent = `
    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }
    @keyframes slideDown {
      from { transform: translateY(-100%); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }
    @keyframes slideUp {
      from { transform: translateY(20px); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }
    .news-card:hover {
      transform: translateY(-4px);
      box-shadow: ${isDarkMode 
        ? '0 8px 30px rgba(0, 0, 0, 0.7)' 
        : '0 8px 30px rgba(0, 0, 0, 0.15)'};
    }
    .icon-button:hover {
      background-color: ${isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)'};
    }
    .category-button:hover {
      transform: scale(1.05);
    }
    .search-input:focus {
      background-color: ${isDarkMode ? 'rgba(255, 255, 255, 0.15)' : 'rgba(0, 0, 0, 0.08)'};
    }
    .button:hover {
      background-color: #0051D5;
      transform: scale(1.02);
    }
    .button:active {
      transform: scale(0.98);
    }
    
    /* SCROLL FIX - Mobile override'ı kaldırıldı */
    @media (max-width: 768px) {
  .header-actions > *:not(.mobile-menu-button) {
    display: none;
  }
  .mobile-menu-button {
    display: flex !important;
  }
  .search-bar {
    max-width: 200px;
  }
  /* news-grid kısmı tamamen kaldırıldı */
}
  `;
  document.head.appendChild(style);
  return () => document.head.removeChild(style);
}, [isDarkMode]);

  const [chatMessages, setChatMessages] = useState([
    { author: 'Anon2244', message: 'Selam millet!' },
    { author: 'Emir', message: 'Şu yayına bak aw' }
  ]);
  const [chatInput, setChatInput] = useState('');
  const [chatNameType, setChatNameType] = useState('anon');
  const playerName = 'Emir';
  useEffect(() => {
    const msgDiv = document.getElementById('live-chat-messages');
    if (msgDiv) msgDiv.scrollTop = msgDiv.scrollHeight;
  }, [chatMessages]);

  const [staff, setStaff] = useState([
    { id: 1, name: "Sarah Chen", role: "Senior Reporter", joinDate: new Date(2024, 0, 15) },
    { id: 2, name: "David Kim", role: "Financial Editor", joinDate: new Date(2024, 2, 20) },
    { id: 3, name: "James Rodriguez", role: "Sports Correspondent", joinDate: new Date(2024, 1, 10) }
  ]);

  const categories = [
    { id: 'all', name: lang.allnews, icon: Newspaper, color: '#007AFF' },
    { id: 'breaking', name: lang.breaking, icon: AlertCircle, color: '#FF3B30' },
    { id: 'crime', name: lang.crimea, icon: Shield, color: '#FF9500' },
    { id: 'community', name: lang.community, icon: User, color: '#34C759' },
    { id: 'economy', name: lang.economy, icon: DollarSign, color: '#5856D6' },
    { id: 'sports', name: lang.Sports, icon: Trophy, color: '#00C7BE' },
    { id: 'magazine', name: lang.magazine, icon: Newspaper, color: '#FF2D55'},
    // { id: 'live', name: 'Live', icon: 'live', color: '#fd4545ff'}
  ];

  const filteredArticles = news
    .filter(article => {
      const matchesCategory = activeCategory === 'all' || article.category === activeCategory;
      const matchesSearch = article.data.headline.toLowerCase().includes(searchQuery.toLowerCase()) ||
                            article.data.summary.toLowerCase().includes(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    })
    .reverse();


  const postComment = () => {
    callNui('postComment', {
      postId: selectedArticle.code,
      comment: commentText
    }, (res) => {
      if (res) {
        setSelectedArticle(prev => ({
          ...prev,
          comments: [res, ...prev.comments]
        }))
        setCommentText('')
      }
    })
  }


  const handleApplicationDecision = (appId, decision) => {
    const application = applications.find(app => app.id === appId);
    if (decision === 'accept' && application) {
      setStaff([...staff, {
        id: staff.length + 1,
        name: application.name,
        role: "Reporter",
        joinDate: new Date()
      }]);
    }
    setApplications(applications.filter(app => app.id !== appId));
  };

  const handleRemoveStaff = (staffId, staffName) => {
    callNui('removeJournalist', {staffId, staffName}, (res) => {
      setJournalist(prev => prev.filter(j => j.cid !== staffId));
    })
  };

  const handlePublishArticle = () => {
    if (
      newArticle.headline &&
      newArticle.summary &&
      newArticle.content &&
      (newArticle.image || selectedMedias.length > 0)
    ) {
      const mainImage = selectedMedias[0] || newArticle.image;
      const extraGallery = selectedMedias.slice(1);
      const article = {
        id: articles.length + 1,
        ...newArticle,
        image: mainImage,
        gallery: extraGallery,
        author: "Staff Reporter",
        timestamp: new Date(),
        likes: 0,
        comments: []
      };
      callNui('createNewHaber', { newArticle, selectedMedias, newArticleTags});
      // setArticles([article, ...articles]);
      // setNewArticle({
      //   headline: '',
      //   summary: '',
      //   content: '',
      //   category: 'community',
      //   image: ''
      // });
      setSelectedMedias([]);
      setShowStaffPanel(false);
    } else {
      handleUpdateNofity(lang.error, lang.emptyFields);
    }
  };

  const formatTime = (date) => {
    // Eğer zaten Date objesiyse değişmez, değilse çevir
    const d = (date instanceof Date) ? date : new Date(date * 1000); // saniyelik timestamp gelirse

    const now = new Date();
    const diff = now - d;
    const hours = Math.floor(diff / 3600000);

    if (hours < 1) return `${Math.floor(diff / 60000)}m ago`;
    if (hours < 24) return `${hours}h ago`;
    return d.toLocaleDateString();
  };


  const getCategoryColor = (categoryId) => {
    const category = categories.find(cat => cat.id === categoryId);
    return category ? category.color : '#007AFF';
  };

  const [currentModalIndex, setCurrentModalIndex] = useState(0);
  useEffect(() => {
    if (selectedArticle) setCurrentModalIndex(0); // Modal her açıldığında ilk foto göster
  }, [selectedArticle]);

  const styles = {
  app: {
    height: '100vh', 
    display: 'flex', 
    flexDirection: 'column',
    overflow: 'hidden' // Eklendi
  },
  mainContent: {
    flex: 1, 
    display: 'flex', 
    flexDirection: 'column', 
    minHeight: 0,
    overflow: 'hidden' // Eklendi
  },
    header: {
      backgroundColor: isDarkMode ? 'rgba(28, 28, 30, 0.95)' : 'rgba(255, 255, 255, 0.95)',
      backdropFilter: 'blur(20px)',
      borderBottom: `1px solid ${isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.1)'}`,
      position: 'sticky',
      top: 0,
      flexShrink: 0,
      zIndex: 100
    },
    headerContent: {
        maxWidth: '1200px',
        margin: '0 auto',
        height: '70px',
        padding: '0 32px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        gap: '16px',
        position: 'relative'
      },

    logo: {
      fontSize: '24px',
      fontWeight: '700',
      letterSpacing: '-0.5px',
      background: 'linear-gradient(135deg, rgb(227 32 32) 0%, rgb(223 112 112) 100%) text',
      WebkitTextFillColor: 'transparent',
      whiteSpace: 'nowrap'
    },
    searchBar: {
      flex: 1,
      maxWidth: '400px',
      position: 'relative'
    },
    searchInput: {
      width: '100%',
      padding: '10px 16px 10px 40px',
      backgroundColor: isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)',
      border: 'none',
      borderRadius: '10px',
      marginTop: '1rem',
      fontSize: '15px',
      color: isDarkMode ? '#FFFFFF' : '#000000',
      outline: 'none',
      transition: 'all 0.2s ease'
    },
    headerActions: {
      display: 'flex',
      alignItems: 'center',
      gap: '18px',
      minWidth: '220px',
      justifyContent: 'flex-end',
    },

    iconButton: {
      padding: '8px',
      backgroundColor: 'transparent',
      border: 'none',
      borderRadius: '8px',
      cursor: 'pointer',
      color: isDarkMode ? '#FFFFFF' : '#000000',
      transition: 'all 0.2s ease',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center'
    },
    breakingNews: {
      backgroundColor: '#FF3B30',
      color: '#FFFFFF',
      padding: '12px 24px',
      display: 'flex',
      flexShrink: 0,
      alignItems: 'center',
      gap: '12px',
      animation: 'slideDown 0.3s ease',
      position: 'relative'
    },
    categoryBar: {
      backgroundColor: isDarkMode ? 'rgba(28, 28, 30, 0.95)' : 'rgba(255, 255, 255, 0.95)',
      borderBottom: `1px solid ${isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.1)'}`,
      position: 'sticky',
      top: '70px',
      zIndex: 90,
      overflowX: 'auto',
      flexShrink: 0,
      WebkitOverflowScrolling: 'touch'
    },
    categoryContent: {
      maxWidth: '1200px',
      margin: '0 auto',
      padding: '12px 24px',
      display: 'flex',
      gap: '8px',
      minWidth: 'max-content'
    },
    categoryButton: {
      padding: '8px 16px',
      borderRadius: '20px',
      border: 'none',
      fontSize: '14px',
      fontWeight: '500',
      cursor: 'pointer',
      transition: 'all 0.2s ease',
      display: 'flex',
      alignItems: 'center',
      gap: '6px',
      whiteSpace: 'nowrap'
    },
 newsGrid: {
    flex: 1,
    overflowY: 'scroll',     // EKLE
    height: '60vh',          // EKLE
    overflowX: 'hidden', // Yatay scroll'u engelle
    padding: '24px',
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(320px, 1fr))',
    gap: '24px',
    boxSizing: 'border-box' // Padding dahil hesapla
  },
    newsCard: {
     background: isDarkMode 
        ? 'rgba(28, 28, 30, 0.55)' 
        : 'rgba(255, 255, 255, 0.55)',
      backdropFilter: 'blur(8px)',
      borderRadius: '16px',
      overflow: 'hidden',
      cursor: 'pointer',
      transition: 'all 0.3s ease',
      boxShadow: isDarkMode 
        ? '0 4px 20px rgba(0, 0, 0, 0.5)' 
        : '0 4px 20px rgba(0, 0, 0, 0.1)',
      transform: 'translateY(0)'
    },
    cardImage: {
      width: '100%',
      height: '200px',
      objectFit: 'cover'
    },
    cardContent: {
      padding: '20px'
    },
    cardCategory: {
      fontSize: '10px',
      fontWeight: '600',
      textTransform: 'uppercase',
      letterSpacing: '0.5px',
      marginBottom: '0px',
      display: 'inline-block',
      padding: '4px 8px',
      borderRadius: '4px',
    },
    cardHeadline: {
      fontSize: '20px',
      fontWeight: '700',
      lineHeight: '1.3',
      marginBottom: '8px',
      letterSpacing: '-0.3px'
    },
    cardSummary: {
      fontSize: '15px',
      lineHeight: '1.5',
      opacity: 0.7,
      marginBottom: '12px'
    },
    cardMeta: {
      display: 'flex',
      alignItems: 'center',
      gap: '16px',
      fontSize: '13px',
      opacity: 0.6
    },
    modal: {
      position: 'fixed',
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      backgroundColor: 'rgba(0, 0, 0, 0.5)',
      backdropFilter: 'blur(10px)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      zIndex: 100,
      padding: '24px',
      animation: 'fadeIn 0.2s ease'
    },
    modalContent: {
      backgroundColor: 'rgb(28, 28, 30)',
      borderRadius: '20px',
      maxWidth: '800px',
      width: '100%',
      maxHeight: '68vh',
      overflow: 'auto',
      animation: '0.3s ease 0s 1 normal none running slideUp',
      boxShadow: 'rgba(0, 0, 0, 0.3) 0px 20px 40px'
    },
    articleHeader: {
      position: 'relative'
    },
    articleImage: {
        width: '100%',
        height: '16rem',
        objectFit: 'cover'
    },
    articleBody: {
      padding: '28px'
    },
    articleHeadline: {
      fontSize: '32px',
      fontWeight: '800',
      lineHeight: '1.2',
      letterSpacing: '-0.5px',
      marginBottom: '16px'
    },
    articleMeta: {
      display: 'flex',
      alignItems: 'center',
      gap: '24px',
      marginBottom: '24px',
      paddingBottom: '24px',
      borderBottom: `1px solid ${isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.1)'}`
    },
    articleContent: {
      fontSize: '17px',
      lineHeight: '1.7',
      whiteSpace: 'pre-wrap'
    },
    closeButton: {
      position: 'absolute',
      top: '16px',
      right: '16px',
      width: '36px',
      height: '36px',
      borderRadius: '50%',
      backgroundColor: 'rgba(0, 0, 0, 0.5)',
      color: '#FFFFFF',
      border: 'none',
      cursor: 'pointer',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      transition: 'all 0.2s ease'
    },
    staffPanel: {
      backgroundColor: isDarkMode ? '#1C1C1E' : '#FFFFFF',
      borderRadius: '20px',
      padding: '32px',
      maxWidth: '600px',
      width: '100%',
      maxHeight: '61vh',
      overflow: 'auto'
    },
    panelTitle: {
      fontSize: '24px',
      fontWeight: '700',
      marginBottom: '24px',
      letterSpacing: '-0.3px'
    },
    form: {
      display: 'flex',
      flexDirection: 'column',
      gap: '16px'
    },
    input: {
      padding: '12px 16px',
      backgroundColor: isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)',
      border: 'none',
      borderRadius: '10px',
      fontSize: '15px',
      color: isDarkMode ? '#FFFFFF' : '#000000',
      outline: 'none',
      transition: 'all 0.2s ease'
    },
    textarea: {
      padding: '12px 16px',
      backgroundColor: isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)',
      border: 'none',
      borderRadius: '10px',
      fontSize: '15px',
      color: isDarkMode ? '#FFFFFF' : '#000000',
      outline: 'none',
      resize: 'vertical',
      minHeight: '120px',
      fontFamily: '-apple-system, BlinkMacSystemFont, "SF Pro Text", sans-serif',
      transition: 'all 0.2s ease'
    },
    select: {
      padding: '12px 16px',
      backgroundColor: isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)',
      border: 'none',
      borderRadius: '10px',
      fontSize: '15px',
      color: isDarkMode ? '#FFFFFF' : '#000000',
      outline: 'none',
      transition: 'all 0.2s ease'
    },
    button: {
      padding: '12px 24px',
      backgroundColor: '#007AFF',
      color: '#FFFFFF',
      border: 'none',
      borderRadius: '10px',
      fontSize: '15px',
      fontWeight: '600',
      cursor: 'pointer',
      transition: 'all 0.2s ease'
    },
    applicationCard: {
      backgroundColor: isDarkMode ? 'rgba(255, 255, 255, 0.05)' : 'rgba(0, 0, 0, 0.03)',
      borderRadius: '12px',
      padding: '20px',
      marginBottom: '16px'
    },
    staffMember: {
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: '16px',
      backgroundColor: isDarkMode ? 'rgba(255, 255, 255, 0.05)' : 'rgba(0, 0, 0, 0.03)',
      borderRadius: '10px',
      marginBottom: '8px'
    },
    tabs: {
      display: 'flex',
      gap: '8px',
      marginBottom: '24px',
      borderBottom: `1px solid ${isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.1)'}`,
      paddingBottom: '12px'
    },
    tab: {
      padding: '8px 16px',
      backgroundColor: 'transparent',
      border: 'none',
      borderRadius: '8px',
      fontSize: '15px',
      fontWeight: '500',
      cursor: 'pointer',
      transition: 'all 0.2s ease',
      color: isDarkMode ? '#FFFFFF' : '#000000',
      opacity: 0.6
    },
    activeTab: {
      backgroundColor: isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)',
      opacity: 1
    },
    toggleSwitch: {
      display: 'flex',
      alignItems: 'center',
      gap: '12px',
      marginBottom: '24px'
    },
    switch: {
      width: '48px',
      height: '28px',
      backgroundColor: applicationsOpen ? '#34C759' : isDarkMode ? 'rgba(255, 255, 255, 0.2)' : 'rgba(0, 0, 0, 0.2)',
      borderRadius: '14px',
      position: 'relative',
      cursor: 'pointer',
      transition: 'all 0.3s ease'
    },
    switchKnob: {
      width: '24px',
      height: '24px',
      backgroundColor: '#FFFFFF',
      borderRadius: '50%',
      position: 'absolute',
      top: '2px',
      left: applicationsOpen ? '22px' : '2px',
      transition: 'all 0.3s ease',
      boxShadow: '0 2px 4px rgba(0, 0, 0, 0.2)'
    }
  };

  useEffect(() => {
    const style = document.createElement('style');
    style.textContent = `
      @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
      }
      @keyframes slideDown {
        from { transform: translateY(-100%); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
      }
      @keyframes slideUp {
        from { transform: translateY(20px); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
      }
      .news-card:hover {
        transform: translateY(-4px);
        box-shadow: ${isDarkMode 
          ? '0 8px 30px rgba(0, 0, 0, 0.7)' 
          : '0 8px 30px rgba(0, 0, 0, 0.15)'};
      }
      .icon-button:hover {
        background-color: ${isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)'};
      }
      .category-button:hover {
        transform: scale(1.05);
      }
      .search-input:focus {
        background-color: ${isDarkMode ? 'rgba(255, 255, 255, 0.15)' : 'rgba(0, 0, 0, 0.08)'};
      }
      .button:hover {
        background-color: #0051D5;
        transform: scale(1.02);
      }
      .button:active {
        transform: scale(0.98);
      }
      @media (max-width: 768px) {
        .header-actions > *:not(.mobile-menu-button) {
          display: none;
        }
        .mobile-menu-button {
          display: flex !important;
        }
        .search-bar {
          max-width: 200px;
        }
        .news-grid {
          grid-template-columns: 1fr !important;
          overflow-y: visible !important;
        }
      }
    `;
    document.head.appendChild(style);
    return () => document.head.removeChild(style);
  }, [isDarkMode]);

  return (
    <>
    <div style={{marginBottom: '1rem'}} className="tablet-frame-homescreen-header">
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
              <div className="header-icons battery">
                  <div className="battery-shell">
                      <div
                      className="battery-level"
                      style={{
                          width: `${batteryLevel}%`,
                          backgroundColor: batteryLevel < 20 ? 'red' : 'rgb(227 227 227)',
                      }}
                      ></div>
                  </div>
                  <span className="battery-percent">{batteryLevel}%</span>
              </div>
              <div className='header-icons'>
                    <svg xmlns="http://www.w3.org/2000/svg" width="15" height="10" viewBox="0 0 15 10" fill="none">
                      <path d="M12.9512 4.246C13.0647 4.3525 13.2397 4.353 13.3502 4.243L14.4142 3.179C14.5287 3.064 14.5292 2.8745 14.4112 2.763C12.6022 1.0505 10.1607 0 7.47322 0C4.78572 0 2.34422 1.0505 0.535223 2.763C0.417223 2.8745 0.417723 3.064 0.532223 3.179L1.59622 4.243C1.70672 4.353 1.88172 4.3525 1.99522 4.246C3.42972 2.9015 5.35672 2.077 7.47322 2.077C9.58972 2.077 11.5167 2.9015 12.9512 4.246Z" fill="white"/>
                      <path d="M10.5043 6.69645C10.6198 6.79945 10.7923 6.80045 10.9018 6.69095L11.9643 5.62845C12.0798 5.51295 12.0803 5.32045 11.9603 5.20995C10.7793 4.12445 9.20385 3.46145 7.47334 3.46145C5.74285 3.46145 4.16735 4.12445 2.98635 5.20995C2.86635 5.32045 2.86685 5.51295 2.98235 5.62845L4.04485 6.69095C4.15435 6.80045 4.32685 6.79945 4.44235 6.69645C5.24835 5.97695 6.31035 5.53845 7.47334 5.53845C8.63634 5.53845 9.69835 5.97695 10.5043 6.69645Z" fill="white"/>
                      <path d="M9.5082 7.6611C9.6337 7.7661 9.6327 7.9616 9.5167 8.0776L7.6787 9.9156C7.5662 10.0281 7.3832 10.0281 7.2707 9.9156L5.4327 8.0776C5.3167 7.9616 5.3152 7.7661 5.4412 7.6611C5.9917 7.2006 6.7007 6.9231 7.4747 6.9231C8.2487 6.9231 8.9572 7.2006 9.5082 7.6611Z" fill="white"/>
                  </svg>
              </div>
          </div>
      </div>
      <div style={styles.app}>
        {/* Header */}
        <header style={styles.header}>
          <div style={{...styles.headerContent,  display: 'flex', alignItems: 'center', flex: 1 }}>
            <div style={styles.logo}>Weazel News</div>
            
            <div style={styles.searchBar} className="search-bar">
              <Search style={{ position: 'absolute', left: '12px', top: '66%', transform: 'translateY(-50%)', width: '18px', height: '18px', opacity: 0.5 }} />
              <input
                type="text"
                placeholder="Search news..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                style={styles.searchInput}
                className="search-input"
              />
            </div>

            <div style={styles.headerActions} className="header-actions">
              <button style={styles.iconButton} className="icon-button">
                <Bell size={20} />
              </button>
              {isOwner && (
                <>
                  <button 
                    style={styles.iconButton} 
                    className="icon-button"
                    onClick={() => openStaffPanel()}
                  >
                    <User size={20} />
                  </button>
                  {/* <button 
                    style={styles.iconButton} 
                    className="icon-button"
                    onClick={() => setShowApplications(true)}
                  >
                    <Newspaper size={20} />
                  </button> */}
                </>
              )}
              {applicationsOpen && (
                <button
                  style={styles.iconButton}
                  className="icon-button"
                  onClick={() => setShowApplyModal(true)}
                >
                  <i className="fa-solid fa-user-plus"></i>
                </button>
              )}
              {/* <button 
                style={styles.iconButton} 
                className="icon-button"
                onClick={() => setIsDarkMode(!isDarkMode)}
              >
                {isDarkMode ? <Sun size={20} /> : <Moon size={20} />}
              </button> */}
              <button 
                style={{...styles.iconButton, display: 'none'}} 
                className="icon-button mobile-menu-button"
                onClick={() => setShowMobileMenu(!showMobileMenu)}
              >
                <Menu size={20} />
              </button>
            </div>
          </div>
        </header>

        {/* Breaking News Banner */}
        {/* {showBreakingNews && (
          <div style={styles.breakingNews}>
            <AlertCircle size={20} />
            <div style={{ flex: 1 }}>
              <strong>BREAKING:</strong> Major traffic incident on Highway 68 - expect delays
            </div>
            <button 
              style={{ ...styles.iconButton, color: '#FFFFFF' }}
              onClick={() => setShowBreakingNews(false)}
            >
              <X size={18} />
            </button>
          </div>
        )} */}

        {/* Category Bar */}
        <div style={styles.categoryBar}>
          <div style={styles.categoryContent}>
            {categories.map(category => (
              <button
                key={category.id}
                style={{
                  ...styles.categoryButton,
                  backgroundColor: activeCategory === category.id 
                    ? category.color 
                    : isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)',
                  color: activeCategory === category.id ? '#FFFFFF' : isDarkMode ? '#FFFFFF' : '#000000'
                }}
                className="category-button"
                onClick={() => setActiveCategory(category.id)}
              >
                {category.icon !== 'live' ? 
                  <category.icon size={16} />
                : <i className="fa-solid fa-microphone-lines"></i>}
                {category.name}
              </button>
            ))}
          </div>
        </div>

        

        {/* Main Content */}
        <main style={styles.mainContent}>
            {activeCategory === 'live' ? (
              <div className="live-youtube-area">
                <div className="live-broadcast-left">
                  <div className="live-video-bg">
                    <img
                      src="https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=900&q=80"
                      className="live-video-bgimg"
                      alt="background"
                    />
                    <div className="live-video-player">
                      {/* Yayın entegresi için buraya iframe/video koyabilirsin */}
                      <div className="live-video-placeholder">
                        <span className="live-onair-dot"></span>
                        <span className="live-onair-label">CANLI YAYIN</span>
                      </div>
                    </div>
                  </div>
                  <div className="live-broadcast-info">
                    <div className="live-broadcast-title-row">
                      <div className="live-broadcast-title">Weazel News Özel Yayını: Şehir Gündemi</div>
                      <span className="live-viewer-chip">9.632 izleyici</span>
                    </div>
                    <div className="live-broadcast-channel">
                      <img
                        src="https://yt3.ggpht.com/yti/ANoDKi7A-channelimg=s68-c-k-c0x00ffffff-no-rj"
                        alt="Weazel News"
                        className="live-channel-img"
                      />
                      <div>
                        <div className="live-channel-name">Weazel News</div>
                        <div className="live-broadcast-date">Şu an Canlı</div>
                      </div>
                    </div>
                    <div className="live-broadcast-desc">
                      GTA şehirde bugün neler oluyor? Merak ettiklerinizi chatte sor, ekrana gelsin! Güncel olaylar, son dakika ve izleyici yorumları bu yayında.
                    </div>
                  </div>
                </div>
                <div className="live-chat-right">
                  <div className="live-chat-header">Canlı Sohbet</div>
                  <div className="live-chat-messages" id="live-chat-messages">
                    {chatMessages.map((m, i) => (
                      <div className="live-chat-msg" key={i}>
                        <span className="live-chat-author">{m.author}</span>
                        <span className="live-chat-text">{m.message}</span>
                      </div>
                    ))}
                  </div>
                  <form
                    className="live-chat-form"
                    onSubmit={e => {
                      e.preventDefault();
                      if (!chatInput.trim()) return;
                      setChatMessages([
                        ...chatMessages,
                        {
                          author: chatNameType === "anon" ? `Anon${Math.floor(Math.random() * 9000 + 1000)}` : playerName,
                          message: chatInput
                        }
                      ]);
                      setChatInput('');
                    }}
                    autoComplete="off"
                  >
                    <input
                      className="live-chat-input"
                      type="text"
                      placeholder="Sohbete mesaj gönder..."
                      value={chatInput}
                      onChange={e => setChatInput(e.target.value)}
                    />
                    <select
                      className="live-chat-select"
                      value={chatNameType}
                      onChange={e => setChatNameType(e.target.value)}
                    >
                      <option value="anon">{lang.anonymous}</option>
                      <option value="real">{lang.withyourname}</option>
                    </select>
                    <button className="live-chat-send" type="submit">{lang.send}</button>
                  </form>
                </div>
              </div>
            ) : (
              filteredArticles.length === 0 ? (
                <div style={{ textAlign: 'center', padding: '60px 0', opacity: 0.5 }}>
                  <Newspaper size={48} style={{ marginBottom: '16px' }} />
                  <p>{lang.noarticles}</p>
                </div>
              ) : (
               <div 
  style={{
    maxHeight: '37rem',
overflow: 'hidden scroll',
padding: '24px',
display: 'flex',
gap: '16px',
flexWrap: 'wrap',
background: 'rgba(0, 0, 0, 0.05)'
  }}
  id="news-container-final"
>
                  {filteredArticles.map(article => { 
                    const images = Array.isArray(article.media) ? article.media : [article.media];
                    return (
                      <article 
                        key={article.id} 
                        className="news-card"
                        onClick={() => setSelectedArticle(article)}
                      >
                        <img
                          src={images[0]}
                          alt={article.headline}
                          style={styles.cardImage}
                        />
                        <div style={styles.cardContent}>
                          <div 
                            style={{
                              ...styles.cardCategory,
                              backgroundColor: getCategoryColor(article.category) + '20',
                              color: getCategoryColor(article.category)
                            }}
                          >
                            {categories.find(cat => cat.id === article.category)?.name || article.category}
                          </div>
                          <h2 style={styles.cardHeadline}>{article.data.headline}</h2>
                          <p style={styles.cardSummary}>{article.data.summary}</p>
                          <div style={styles.cardMeta}>
                            <span>{article.author}</span>
                            <span>•</span>
                            <span>{formatTime(article.timestamp)}</span>
                            <span>•</span>
                            <span>{article.likes} likes</span>
                          </div>
                        </div>
                      </article>
                    )
                  })}
                </div>
              )
                    )}
                </main>


        {/* Article Modal */}
        {selectedArticle && (
            <div style={styles.modal} onClick={() => setSelectedArticle(null)}>
              <div style={styles.modalContent} onClick={e => e.stopPropagation()}>
                <div style={styles.articleHeader}>
                  <div style={{ position: "relative", width: "100%" }}>
                    {(() => {
                      const images = Array.isArray(selectedArticle.media) ? selectedArticle.media : [selectedArticle.media];
                      const src = images[currentModalIndex];
                      const isVideo = src?.endsWith(".mp4") || src?.endsWith(".webm") || src?.includes("video");
                      return (
                        <>
                          {isVideo ? (
                            <video controls style={styles.articleImage}>
                              <source src={src} />
                            </video>
                          ) : (
                            <img src={src} alt={selectedArticle.headline} style={styles.articleImage} />
                          )}
                          {images.length > 1 && (
                            <>
                              <button
                                onClick={e => { e.stopPropagation(); setCurrentModalIndex(i => (i - 1 + images.length) % images.length); }}
                                style={{
                                  position: "absolute",
                                  left: 8,
                                  top: "50%",
                                  transform: "translateY(-50%)",
                                  zIndex: 2,
                                  background: "#0008",
                                  color: "#fff",
                                  border: "none",
                                  borderRadius: 16,
                                  width: 36,
                                  height: 36,
                                  fontSize: 24,
                                  cursor: "pointer"
                                }}
                              >‹</button>
                              <button
                                onClick={e => { e.stopPropagation(); setCurrentModalIndex(i => (i + 1) % images.length); }}
                                style={{
                                  position: "absolute",
                                  right: 8,
                                  top: "50%",
                                  transform: "translateY(-50%)",
                                  zIndex: 2,
                                  background: "#0008",
                                  color: "#fff",
                                  border: "none",
                                  borderRadius: 16,
                                  width: 36,
                                  height: 36,
                                  fontSize: 24,
                                  cursor: "pointer"
                                }}
                              >›</button>
                              <div style={{
                                position: "absolute",
                                bottom: 12,
                                left: "50%",
                                transform: "translateX(-50%)",
                                display: "flex",
                                gap: 6
                              }}>
                                {images.map((_, idx) => (
                                  <span key={idx} style={{
                                    width: 8,
                                    height: 8,
                                    borderRadius: "50%",
                                    background: idx === currentModalIndex ? "#fff" : "#fff6",
                                    border: "1px solid #0004",
                                    display: "inline-block"
                                  }} />
                                ))}
                              </div>
                            </>
                          )}
                        </>
                      );
                    })()}
                    <button style={styles.closeButton} onClick={() => setSelectedArticle(null)}>
                      <X size={20} />
                    </button>
                  </div>
                </div>
                <div style={styles.articleBody}>
                  <div 
                    style={{
                      ...styles.cardCategory,
                      backgroundColor: getCategoryColor(selectedArticle.category) + '20',
                      color: getCategoryColor(selectedArticle.category),
                      marginBottom: '16px'
                    }}
                  >
                    {categories.find(cat => cat.id === selectedArticle.category)?.name || selectedArticle.category}
                  </div>
                  <h1 style={styles.articleHeadline}>{selectedArticle.data.headline}</h1>
                  <div style={styles.articleMeta}>
                    <span>{selectedArticle.author}</span>
                    <span>•</span>
                    <span>{formatTime(selectedArticle.timestamp)}</span>
                    <span>•</span>
                    <span>{selectedArticle.likes} {lang.likes}</span>
                  </div>
                  <div style={styles.articleContent}>{selectedArticle.data.content}</div>
                  <div style={{ marginTop: '48px' }}>
                    <h3 style={{ fontSize: '20px', fontWeight: '700', marginBottom: '24px' }}>
                      {lang.comments} ({selectedArticle.comments.length})
                    </h3>
                    {selectedArticle.comments.map(comment => (
                      <div key={comment.id} style={{ marginBottom: '16px', paddingBottom: '16px', borderBottom: `1px solid ${isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.1)'}` }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '8px' }}>
                          <strong>{comment.author}</strong>
                          <span style={{ opacity: 0.5, fontSize: '13px' }}>{formatTime(comment.timestamp)}</span>
                        </div>
                        <p style={{ fontSize: '15px', lineHeight: '1.5' }}>{comment.content}</p>
                      </div>
                    ))}
                    <div style={styles.form}>
                      <textarea
                        onChange={(e) => setCommentText(e.target.value)}
                        placeholder={lang.acomment}
                        value={commentText}
                        style={styles.textarea}
                      />
                      <button onClick={postComment} style={styles.button} className="button">{lang.postcomment}</button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          )}

        {/* Staff Panel */}
        {showStaffPanel && (
          <div style={styles.modal} onClick={() => setShowStaffPanel(false)}>
            <div style={styles.staffPanel} onClick={e => e.stopPropagation()}>
              <h2 style={styles.panelTitle}>{lang.smana}</h2>
              
              <div style={styles.tabs}>
                <button 
                  style={{...styles.tab, ...(activeStaffTab === 'create' ? styles.activeTab : {})}}
                  onClick={() => setActiveStaffTab('create')}
                >
                  {lang.cnews}
                </button>
                <button 
                  style={{...styles.tab, ...(activeStaffTab === 'manage' ? styles.activeTab : {})}}
                  onClick={() => setActiveStaffTab('manage')}
                >
                  {lang.mstaff}
                </button>
                 {/* <button 
                    style={{...styles.tab, ...(activeStaffTab === 'poll' ? styles.activeTab : {})}}
                    onClick={() => setActiveStaffTab('poll')}
                  >
                    Create Poll
                  </button> */}
              </div>

              {activeStaffTab === 'poll' && (
                <div style={styles.form}>
                  <input
                    type="text"
                    placeholder="Anket Sorusu"
                    value={newPoll.question}
                    onChange={e => setNewPoll({ ...newPoll, question: e.target.value })}
                    style={styles.input}
                  />
                  {[0,1,2,3].map(i => (
                    <input
                      key={i}
                      type="text"
                      placeholder={`Seçenek ${i+1}`}
                      value={newPoll.options[i] || ''}
                      onChange={e => {
                        const options = [...(newPoll.options || [])];
                        options[i] = e.target.value;
                        setNewPoll({ ...newPoll, options });
                      }}
                      style={styles.input}
                    />
                  ))}
                  <button
                    style={styles.button}
                    onClick={handleCreatePoll}
                    disabled={
                      !newPoll.question || !newPoll.options || newPoll.options.filter(opt => opt).length < 2
                    }
                  >
                    Anketi Paylaş
                  </button>
                </div>
              )}

              {activeStaffTab === 'create' && (
                <div style={styles.form}>
                  <input
                    type="text"
                    placeholder="Headline"
                    value={newArticle.headline}
                    onChange={e => setNewArticle({ ...newArticle, headline: e.target.value })}
                    style={styles.input}
                  />
                  <input
                    type="text"
                    placeholder="Summary"
                    value={newArticle.summary}
                    onChange={e => setNewArticle({ ...newArticle, summary: e.target.value })}
                    style={styles.input}
                  />
                  <textarea
                    placeholder="Full article content..."
                    value={newArticle.content}
                    onChange={e => setNewArticle({ ...newArticle, content: e.target.value })}
                    style={{ ...styles.textarea, minHeight: '200px' }}
                  />
                  <CustomDropdown
                      value={newArticle.category}
                      onChange={(value) => setNewArticle({ ...newArticle, category: value })}
                      options={categories
                        .filter(cat => cat.id !== 'all' && cat.id !== 'breaking' && cat.id !== 'live')
                        .map(cat => ({
                          value: cat.id,
                          label: cat.name
                        }))}
                      isDarkMode={isDarkMode}
                      placeholder={lang.selcat}
                    />

                  {/* Tag input alanı */}
                  <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', alignItems: 'center' }}>
                    {newArticleTags.map((tag, i) => (
                      <span key={i} style={{
                        background: '#007aff22',
                        color: '#007aff',
                        padding: '4px 12px',
                        borderRadius: '12px',
                        fontSize: 13,
                        marginRight: 4,
                        display: 'flex',
                        alignItems: 'center',
                      }}>
                        #{tag}
                        <span
                          onClick={() => setNewArticleTags(tags => tags.filter((_, idx) => idx !== i))}
                          style={{ marginLeft: 6, cursor: 'pointer', fontWeight: 700 }}
                        >×</span>
                      </span>
                    ))}
                   

                  {/* Çoklu medya gösterimi zaten var */}
                  <div style={{display: 'flex',flexWrap: 'wrap',width: '90%'}}>
                     <input
                      type="text"
                      value={tagInput}
                      style={{ ...styles.input, width: '100%', minWidth: 60 }}
                      placeholder="tag ekle"
                      onChange={e => setTagInput(e.target.value)}
                      onKeyDown={e => {
                        if ((e.key === 'Enter' || e.key === ',' || e.key === ' ' || e.key === ';') && tagInput.trim()) {
                          const val = tagInput.replace(/[,;]/g, '').trim();
                          if (val.length > 0 && !newArticleTags.includes(val)) {
                            setNewArticleTags([...newArticleTags, val]);
                            setTagInput('');
                          }
                          e.preventDefault();
                        } else if (e.key === 'Backspace' && tagInput.length === 0) {
                          setNewArticleTags(tags => tags.slice(0, -1));
                        }
                      }}
                    />
                    </div>
                    <button
                      type="button"
                      style={{ ...styles.button, minWidth: 32, padding: '11px 11px', marginLeft: '.5rem' }}
                      onClick={() => setGalleryOpen(true)}
                    >
                      <i className="fa-solid fa-images"></i>
                    </button>
                  </div>
                  {/* seçilen medyaları hemen URL inputun altında göster */}
                  <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap', marginTop: '8px' }}>
                    {selectedMedias.map(url => {
                      const isVideo = /\.(mp4|webm|ogg)$/i.test(url);
                      return (
                        <div key={url} style={{ position: 'relative' }}>
                          {isVideo ? (
                            <video
                              src={url}
                              width={120}
                              height={90}
                              style={{ objectFit: 'cover', borderRadius: 8 }}
                              controls
                            />
                          ) : (
                            <img
                              src={url}
                              width={120}
                              height={90}
                              style={{ objectFit: 'cover', borderRadius: 8 }}
                            />
                          )}
                          <button
                            onClick={() => setSelectedMedias(prev => prev.filter(u => u !== url))}
                            style={{
                              position: 'absolute',
                              top: 4,
                              right: 4,
                              background: 'rgba(0,0,0,0.5)',
                              border: 'none',
                              borderRadius: '50%',
                              width: 24,
                              height: 24,
                              display: 'flex',
                              alignItems: 'center',
                              justifyContent: 'center',
                              cursor: 'pointer'
                            }}
                          >
                            <Trash2 size={12} color="#fff" />
                          </button>
                        </div>
                      );
                    })}
                  </div>

                  <button style={styles.button} onClick={handlePublishArticle}>
                    {lang.particle}
                  </button>
                </div>
              )}



              {galleryOpen && (
                <div style={{
                  position: 'fixed', top: 0, left: 0, width: '100vw', height: '100vh',
                  background: 'rgba(0,0,0,0.32)', zIndex: 999, display: 'flex', alignItems: 'center', justifyContent: 'center'
                }}
                  onClick={() => setGalleryOpen(false)}
                >
                  <div style={{
                    background: '#fff', borderRadius: 16, padding: 24, minWidth: 320, minHeight: 220, maxWidth: 600, boxShadow: '0 8px 24px rgba(0,0,0,0.08)',
                    display: 'flex', flexWrap: 'wrap', gap: 16
                  }}
                    onClick={e => e.stopPropagation()}
                  >
                    {playerGallery.length === 0 && <div>Galeri boş.</div>}
                    {playerGallery.map(photo => {
                      const isVideo = /\.(mp4|webm|ogg)$/i.test(photo.url);
                      const selected = selectedMedias.includes(photo.url);
                      const borderStyle = selected ? '3px solid #1886fd' : '2px solid #eee';
                      const handleSelect = () => {
                        setSelectedMedias(prev =>
                          prev.includes(photo.url)
                            ? prev.filter(u => u !== photo.url)
                            : [...prev, photo.url]
                        );
                      };
                      return (
                        <div
                          key={photo.url}
                          className="newsapp-thumb"
                          onClick={handleSelect}
                          style={{ border: borderStyle, cursor: 'pointer' }}
                        >
                          {isVideo ? (
                            <video
                              src={photo.url}
                              width={120}
                              height={90}
                              style={{ objectFit: 'cover', borderRadius: 8 }}
                            />
                          ) : (
                            <img
                              src={photo.url}
                              alt={photo.location}
                              width={120}
                              height={90}
                              style={{ objectFit: 'cover', borderRadius: 8 }}
                            />
                          )}
                        </div>
                      );
                    })}
                  </div>
                </div>
              )}
              {activeStaffTab === 'manage' && (
                  <div>
                    <h3 style={{ fontSize: '18px', fontWeight: '600', marginBottom: '16px' }}>
                      {lang.curstaff}
                    </h3>
                    {journalist.map(member => (
                      <div key={member.cid} style={styles.staffMember}>
                        <div>
                          <div style={{ fontWeight: '600' }}>{member.name}</div>
                          <div style={{ fontSize: '14px', opacity: 0.6 }}>
                            {member.name} {member.grade ? `- ${member.grade}` : ''}
                          </div>
                        </div>
                        <button
                          style={{ ...styles.iconButton, color: '#FF3B30' }}
                          onClick={() => handleRemoveStaff(member.cid, member.name)}
                        >
                          <Trash2 size={18} />
                        </button>
                      </div>
                    ))}

                    <h4 style={{ fontSize: '16px', fontWeight: '600', marginTop: '24px' }}>
                      {lang.addstaff}
                    </h4>
                    <div style={{ display: 'flex', gap: '8px', marginBottom: '16px', position: 'relative' }}>
                      <div style={{ position: 'relative', flex: 1 }}>
                        <input
                          type="text"
                          placeholder={lang.firstName}
                          value={newStaffNameInput}
                          onChange={e => setNewStaffNameInput(e.target.value)}
                          style={{...styles.input, width: '17rem'}}
                        />
                        {newStaffNameInput && (
                          <div style={{
                            position: 'absolute',
                            top: 'calc(100% + 4px)',
                            left: 0,
                            width: '100%',
                            background: '#2c2c2e',
                            border: '1px solid #444',
                            borderRadius: 4,
                            maxHeight: '150px',
                            overflowY: 'auto',
                            boxShadow: '0 4px 8px rgba(0,0,0,0.3)',
                            zIndex: 10
                          }}>

                            {players
                              .filter(p => p.name.toLowerCase().includes(newStaffNameInput.toLowerCase()))
                              .map(player => (
                                <div
                                  key={player.name}
                                  onClick={() => {
                                    setNewStaffName(player.name)
                                    setNewStaffCid(player.cid);
                                    setNewStaffNameInput('');
                                  }}
                                  style={{
                                    padding: '8px 12px',
                                    cursor: 'pointer',
                                    color: '#fff'
                                  }}
                                  onMouseEnter={e => e.currentTarget.style.background = '#3a3a3c'}
                                  onMouseLeave={e => e.currentTarget.style.background = 'transparent'}
                                >
                                  {player.name}
                                </div>
                              ))
                            }

                          </div>
                        )}
                      </div>

                      <CustomDropdown
                        value={newStaffRole}
                        onChange={(value) => {
                          const fakeEvent = { target: { value } };
                          setNewStaffRole(fakeEvent.target.value);
                        }}
                        options={roleOptions}
                        isDarkMode={isDarkMode}
                        placeholder={lang.selrole}
                      />

                      <button style={styles.button} onClick={handleAddStaff}>
                        {lang.add}
                      </button>
                    </div>
                  </div>
                )}
            </div>
          </div>
        )}

        <ColdModal
            appName="News"
            title={nofity.title}
            message={nofity.msg}
            isOpen={pato}
            onClose={() => setPato(false)}
            buttons={[
                { label: lang.ok, onClick: () => setPato(false) }
            ]}
        />

        <ApplicationModal
          open={showApplyModal}
          onClose={() => setShowApplyModal(false)}
          lang={lang}
          isDarkMode={isDarkMode}
          onSubmit={async (data) => {
            // Başvuru gelince işle
            setApplications(apps => [
              ...apps,
              {
                id: Date.now(),
                ...data,
                status: "pending",
                timestamp: new Date()
              }
            ]);
          }}
          isDark={isDarkMode}
        />
        {/* Applications Panel */}
        {showApplications && (
          <div style={styles.modal} onClick={() => setShowApplications(false)}>
            <div style={styles.staffPanel} onClick={e => e.stopPropagation()}>
              <h2 style={styles.panelTitle}>{lang.jobapplics}</h2>
              
              <div style={styles.toggleSwitch}>
                <span style={{ fontWeight: '500' }}>{lang.openapplics}</span>
                <div 
                  style={styles.switch} 
                  onClick={() => setApplicationsOpen(!applicationsOpen)}
                >
                  <div style={styles.switchKnob} />
                </div>
              </div>

              {applications.length === 0 ? (
                <div style={{ textAlign: 'center', padding: '40px 0', opacity: 0.5 }}>
                  <User size={48} style={{ marginBottom: '16px' }} />
                  <p>{lang.nopenx}</p>
                </div>
              ) : (
                <div>
                  <h3 style={{ fontSize: '18px', fontWeight: '600', marginBottom: '16px' }}>
                    {lang.penx} ({applications.length})
                  </h3>
                  {applikasyons.map(app => (
                    <div key={app.id} style={styles.applicationCard}>
                      <div style={{ marginBottom: '12px' }}>
                        <div style={{ fontWeight: '600', fontSize: '16px' }}>{app.name}</div>
                        <div style={{ fontSize: '14px', opacity: 0.6 }}>{lang.age}: {app.age}</div>
                      </div>
                      <div style={{ marginBottom: '12px' }}>
                        <div style={{ fontSize: '14px', fontWeight: '500', marginBottom: '4px' }}>{lang.experience}:</div>
                        <div style={{ fontSize: '14px', opacity: 0.8 }}>{app.experience}</div>
                      </div>
                      <div style={{ marginBottom: '16px' }}>
                        <div style={{ fontSize: '14px', fontWeight: '500', marginBottom: '4px' }}>{lang.motivation}:</div>
                        <div style={{ fontSize: '14px', opacity: 0.8 }}>{app.motivation}</div>
                      </div>
                      <div style={{ display: 'flex', gap: '8px' }}>
                        <button
                          style={{ ...styles.button, backgroundColor: '#34C759', display: 'flex', alignItems: 'center' }}
                          className="button"
                          onClick={() => handleApplicationDecision(app.id, 'accept')}
                        >
                          <Check size={18} style={{ marginRight: '4px' }} />
                          {lang.accept}
                        </button>
                        <button
                          style={{ ...styles.button, backgroundColor: '#FF3B30', display: 'flex', alignItems: 'center' }}
                          className="button"
                          onClick={() => handleApplicationDecision(app.id, 'reject')}
                        >
                          <X size={18} style={{ marginRight: '4px' }} />
                          {lang.reject}
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        )}
      </div>
    </>
  );
};

export default WeazelNewsApp;
