import React, {useState, useEffect, useRef} from 'react';
import './main.css';
import { callNui } from '@/nui';
import ColdModal from '@/SettingsApp/coldModal/main';

const BillingApp = ({lang, ownerJob, invoices, checkInvoice}) => {
    const [time, setTime] = useState(new Date());
    const [modTheme, setModdTheme] = useState(false);
    const [currentMenu, setCurr] = useState('all');
    const [allBillings, setAllShow] = useState(true);
    const [pendingBills, setPending] = useState(false);
    const [players, setPlayers] = useState([]);
    const [newBill, setNewBill] = useState(false);
    const today = new Date().toISOString().split('T')[0];
    const [invoiceDate, setInvoiceDate] = useState(today);
    const [selectedPlayer, setSelectedPlayer] = useState('')
    const VAT_RATE = 18;
    const [dueDate, setDueDate] = useState('')
    const [items, setItems] = useState([{ Description: '', Quantity: 1, Price: 0 }])
    const [vatRate, setVatRate] = useState(0)
    const [discount, setDiscount] = useState(0)
    const [status, setStatus] = useState(0);
    const [notes, setNotes] = useState('');
    const [alerto, setAlerto] = useState(false);
    const [alerto2, setAlerto2] = useState(false);
    const [payModal, setPayModal] = useState(false);
    const [selectedInvoice, setSelectedBillData] = useState([]);
    const formattedTime = `${time.getHours().toString().padStart(2, "0")}:${time
        .getMinutes()
        .toString()
        .padStart(2, "0")}`;

    const hideAll = () => {
        setAllShow(false);
        setPending(false);
        setNewBill(false);
    }

    const PayInvoice = () => {
      callNui('PayInvoice', {
        invoiceKey: selectedInvoice.ikey,
        invoicePrice: selectedInvoice.totalamount
      })
      setPayModal(false);
    }

    const capitalize = str =>
      str.charAt(0).toUpperCase() + str.slice(1)

    const setSelectedInvoice = (data) => {
        if(data.status == 0){
          setSelectedBillData(data);
          setPayModal(true);
        }
    }

    useEffect(() => {
        callNui('getNearestForBilling', {}, (res) => {
            setPlayers(res);
        }); 
    }, []);

    const changePage = (page) => {
        switch (page) {
            case "allbilling":
                hideAll();
                setCurr('all');
                setAllShow(true);
                break;
            case "new":
              if(checkInvoice){
                  hideAll();
                  setCurr('new');
                  setNewBill(true);
              } else {
                setAlerto(true);
              }
              break;
            case "pending":
                hideAll();
                setCurr('pending');
                setPending(true);
                break;
            default:
                break;
        }
    }

    const [open, setOpen] = useState(false);
    const [search, setSearch] = useState('');
    const ref = useRef(null);

    const filtered = players.filter(p =>
      p.name && p.name.toLowerCase().includes(search.toLowerCase())
    )

    useEffect(() => {
        const handleClickOutside = e => {
        if (ref.current && !ref.current.contains(e.target)) {
            setOpen(false);
        }
        };
        document.addEventListener('mousedown', handleClickOutside);
        return () => document.removeEventListener('mousedown', handleClickOutside);
    }, []);


    useEffect(() => {
      const today = new Date().toISOString().slice(0, 10)
      if (!invoiceDate) setInvoiceDate(today)
      if (!dueDate) setDueDate(today)
    }, [])

    const onInputChange = e => {
      setSearch(e.target.value)
      setOpen(true)
    }

    const onItemClick = p => {
      setSelectedPlayer(p.cid)
      setSearch(p.name)
      setOpen(false)
    }

    const addItem = () => {
      setItems([...items, { Description: '', Quantity: 1, Price: 0 }])
    }

    const updateItem = (i, field, value) => {
      const newItems = [...items]
      newItems[i][field] = field === 'Description' ? value : Number(value)
      setItems(newItems)
    }

    const removeItem = i => {
      setItems(items.filter((_, idx) => idx !== i))
    }

    const CreateNewInvoice = () => {
      const missing = []
      if(!selectedPlayer) missing.push('selectedPlayer')
      if(!invoiceDate) missing.push('invoiceDate')
      if(!dueDate) missing.push('dueDate')
      if(!items?.length) missing.push('items')
      if(subtotal==null) missing.push('subtotal')
      if(vatAmount==null) missing.push('vatAmount')
      if(total==null) missing.push('total')
      if(!notes) missing.push('notes')
      if(missing.length){
        setAlerto2(true);
        return
      }
      callNui('createNewInvoice',{selectedPlayer,invoiceDate,dueDate,items,subtotal,vatAmount,total,notes,status, ownerJob})
      setSelectedPlayer('');
      setItems([{ Description: '', Quantity: 1, Price: 0 }]);
    }



    const subtotal = items.reduce((sum, it) => sum + it.Quantity * it.Price, 0)
    const vatAmount = subtotal * vatRate / 100
    const discountAmount = discount > 0 ? (discount < 100 ? subtotal * discount / 100 : discount) : 0
    const total = subtotal + vatAmount - discountAmount

    return (
        <div className='bil-container'>
            <div className='bil-header-icon-time-part'>
                <span className='bil-time-string'>{formattedTime}</span>
            </div>
            <div className='bil-header-icon-part'>
                <div className='bil-header-icons'>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="12" viewBox="0 0 16 12" fill="none">
                        <path d="M0 3.31091L1.45455 4.76545C5.06909 1.15091 10.9309 1.15091 14.5455 4.76545L16 3.31091C11.5855 -1.10364 4.42182 -1.10364 0 3.31091ZM5.81818 9.12909L8 11.3109L10.1818 9.12909C9.89557 8.84208 9.55551 8.61437 9.18112 8.459C8.80672 8.30363 8.40535 8.22365 8 8.22365C7.59465 8.22365 7.19328 8.30363 6.81888 8.459C6.44449 8.61437 6.10443 8.84208 5.81818 9.12909ZM2.90909 6.22L4.36364 7.67454C5.32834 6.71064 6.63627 6.1692 8 6.1692C9.36373 6.1692 10.6717 6.71064 11.6364 7.67454L13.0909 6.22C10.2836 3.41273 5.72364 3.41273 2.90909 6.22Z" fill="white"/>
                    </svg>
                </div>
                <div className='bil-header-icons'>
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="12" viewBox="0 0 20 12" fill="none">
                        <path d="M14.375 0C15.2038 0 15.9987 0.316071 16.5847 0.87868C17.1708 1.44129 17.5 2.20435 17.5 3V3.9996L18.9587 4.0032C19.2349 4.0032 19.4998 4.10851 19.695 4.29598C19.8903 4.48344 20 4.73769 20 5.0028V7.0032C20 7.26831 19.8903 7.52256 19.695 7.71002C19.4998 7.89749 19.2349 8.0028 18.9587 8.0028L17.5 8.0004V9C17.5 9.79565 17.1708 10.5587 16.5847 11.1213C15.9987 11.6839 15.2038 12 14.375 12H3.125C2.2962 12 1.50134 11.6839 0.915291 11.1213C0.32924 10.5587 0 9.79565 0 9V3C0 2.20435 0.32924 1.44129 0.915291 0.87868C1.50134 0.316071 2.2962 0 3.125 0H14.375ZM14.6875 1.1352H3.125C2.3125 1.1352 1.36875 1.7304 1.26 2.4912L1.25 2.6352V9.2292C1.25 10.0056 1.865 10.6452 2.6525 10.722L2.8125 10.7292H14.6875C15.0741 10.7291 15.4469 10.5914 15.7339 10.3427C16.0209 10.094 16.2017 9.75199 16.2412 9.3828L16.25 9.2292V2.6352C16.2499 2.26406 16.1064 1.90614 15.8474 1.63064C15.5883 1.35513 15.2321 1.18161 14.8475 1.1436L14.6875 1.1352ZM3.5425 2.3388H12.705C13.2387 2.3388 13.6775 2.7204 13.7425 3.2148L13.75 3.3408V8.5332C13.7502 8.77726 13.6576 9.01299 13.4896 9.19615C13.3216 9.37931 13.0897 9.49731 12.8375 9.528L12.7063 9.5352H3.54375C3.28931 9.53568 3.04345 9.44691 2.8524 9.2856C2.66134 9.12428 2.53824 8.90152 2.50625 8.6592L2.5 8.532V3.3408C2.5 2.8296 2.89875 2.4084 3.4125 2.346L3.5425 2.3388Z" fill="white"/>
                    </svg>
                </div>
            </div>
            <div className='bil-left-bar'>
                <span className='bil-title-appz'>{lang.mybillings}</span>
                <span className='bil-spanxz'>{lang.inapp}</span>
                <div className='bil-spanler'>
                    <div onClick={() => changePage('allbilling')} className={`bil-settings-item ${modTheme ? 'light' : 'dark'} ${currentMenu == 'all' ? 'bil-selectedra': ''}`} style={{width: '77%',
marginLeft: '0.7rem',
height: '1.2rem'}}>
                        <div className={`bil-setting-item-logo ${currentMenu == 'all' ? 'bil-green2': 'bil-gray'}`}>
                           <i className="fa-solid fa-receipt"></i>
                        </div> 
                        <span className='bil-app-namex'>{lang.allin}</span>
                    </div>
                    <div onClick={() => changePage('pending')} className={`bil-settings-item ${modTheme ? 'light' : 'dark'} ${currentMenu == 'pending' ? 'bil-selectedra': ''}`} style={{width: '77%',
marginLeft: '0.7rem',
height: '1.2rem'}}>
                        <div className={`bil-setting-item-logo  ${currentMenu == 'pending' ? 'bil-green2': 'bil-gray'}`}>
                           <i className="fa-solid fa-hourglass-start"></i>
                        </div> 
                        <span className='bil-app-namex'>{lang.overduein}</span>
                    </div>
                    <span className='bil-createinm'>{lang.newin}</span>
                    <div onClick={() => changePage('new')} className={`bil-settings-item ${modTheme ? 'light' : 'dark'} ${currentMenu == 'new' ? 'bil-selectedra': ''}`} style={{width: '77%',
marginLeft: '0.7rem',
marginTop: '2.5rem',
height: '1.2rem'}}>
                        <div className={`bil-setting-item-logo  ${currentMenu == 'new' ? 'bil-green2': 'bil-gray'}`}>
                           <i className="fa-solid fa-plus"></i>
                        </div> 
                        <span className='bil-app-namex'>{lang.cbill}</span>
                    </div>
                </div>
            </div>

            <div className='bil-middle-part'>
                {allBillings && (
                  <>
                    <div className='bil-showedAllBillings'>
                      <span className='bil-title-boo'>{lang.allbills}</span>
                    </div>
                    <div className='bil-showed-list'>
                      {invoices.map((element, index) => {
                        const overdueDays = Math.floor((new Date() - new Date(element.duedate)) / (1000 * 60 * 60 * 24))
                        if (overdueDays > 0 && element.status != 1) {
                          const updatedAmount = (element.totalamount * (1 + overdueDays * 0.01)).toFixed(2);
                          const updated = { ...element, totalamount: updatedAmount }
                          return (
                            <div onClick={() => setSelectedInvoice(updated)} className="bil-invoice-card" key={index}>
                              <div className="bil-invoice-row bil-headerx">
                                <span className="bil-invoice-no">#{index + 1}</span>
                                <span className="bil-invoice-date">{element.date}</span>
                              </div>
                              <div className="bil-invoice-row bil-body">
                                <span className="bil-customer-name">{capitalize(element.job)}</span>
                                <span style={{ textDecoration: 'line-through', color: '#5f5f5f', fontSize: '12px' }}>
                                  ${element.totalamount}
                                </span>
                              </div>
                              <div className="bil-invoice-row bil-overtime">
                                <span className="bil-overdue-days">{lang.latetext.replace('%s', overdueDays)}</span>
                                <span className="bil-updated-amount">${updatedAmount}</span>
                              </div>
                              <div className="bil-invoice-row bil-footer">
                                <span className="bil-due-date">{lang.duedate}: {element.duedate}</span>
                                <span className="bil-status bil-late">{lang.late}</span>
                              </div>
                            </div>
                          )
                        }
                        return (
                          <div onClick={() => setSelectedInvoice(element)} className="bil-invoice-card" key={index}>
                            <div className="bil-invoice-row bil-headerx">
                              <span className="bil-invoice-no">#{index + 1}</span>
                              <span className="bil-invoice-date">{element.date}</span>
                            </div>
                            <div className="bil-invoice-row bil-body">
                              <span className="bil-customer-name">{capitalize(element.job)}</span>
                              <span className="bil-invoice-amount">${element.totalamount}</span>
                            </div>
                            <div className="bil-invoice-row bil-footer">
                              <span className="bil-due-date">{lang.duedate}: {element.duedate}</span>
                              <span className={`bil-status ${element.status == 0 ? 'bil-pending' : 'bil-paid'}`}>
                                {element.status == 0 ? lang.pending : lang.paid}
                              </span>
                            </div>
                          </div>
                        )
                      })}
                    </div>
                  </>
                )}

                {pendingBills && (
                  <>
                    <div className='bil-showedAllBillings'>
                      <span className='bil-title-boo'>{lang.overduein}</span>
                    </div>
                    <div className='bil-showed-list'>
                      {invoices
                        .filter(el => {
                          const overdueDays = Math.floor((new Date() - new Date(el.duedate)) / (1000 * 60 * 60 * 24))
                          return overdueDays > 0 && el.status != 1
                        })
                        .map((element, index) => {
                          const overdueDays = Math.floor((new Date() - new Date(element.duedate)) / (1000 * 60 * 60 * 24))
                          const updatedAmount = (element.totalamount * (1 + overdueDays * 0.01)).toFixed(2)
                          const updated = { ...element, totalamount: updatedAmount }
                          return (
                            <div onClick={() => setSelectedInvoice(updated)} className="bil-invoice-card" key={index}>
                              <div className="bil-invoice-row bil-headerx">
                                <span className="bil-invoice-no">#{index + 1}</span>
                                <span className="bil-invoice-date">{element.date}</span>
                              </div>
                              <div className="bil-invoice-row bil-body">
                                <span className="bil-customer-name">{capitalize(element.job)}</span>
                                <span style={{ color: '#5f5f5f', fontSize: '12px' }} className="bil-invoice-amount">
                                  <del>${element.totalamount.toFixed(2)}</del>
                                </span>
                              </div>
                              <div className="bil-invoice-row bil-overtime">
                                <span className="bil-overdue-days">{lang.latetext.replace('%s', overdueDays)}</span>
                                <span className="bil-updated-amount">${updatedAmount}</span>
                              </div>
                              <div className="bil-invoice-row bil-footer">
                                <span className="bil-due-date">{lang.duedate}: {element.duedate}</span>
                                <span className="bil-status bil-late">{lang.late}</span>
                              </div>
                            </div>
                          )
                        })}

                    </div>
                  </>
                )}

                {newBill&&(
                  <>
                    <div className='bil-showedAllBillings'>
                      <span className='bil-title-boo'>{lang.cbill} | <b>{ownerJob}</b></span>
                    </div>
                    <div style={{width: '66rem', height: '53rem', overflow: 'auto', background: 'transparent'}} className='bil-create-box'>
                      <div className='bil-data-data'>
                        <span className='bil-cucu'>{lang.customer}</span>
                        <div className='bil-player-dropdown-container' ref={ref}>
                          <input
                            type='text'
                            className='bil-player-dropdown-input'
                            value={search}
                            onChange={onInputChange}
                            onClick={()=>setOpen(true)}
                            placeholder={lang.splayer}
                          />
                          <div className={`bil-player-dropdown-list ${open?'':'bil-closed'}`}>
                            {filtered.map(p=>(
                              <div key={p} className='bil-player-dropdown-item' onClick={()=>onItemClick(p)}>
                                {p.name}
                              </div>
                            ))}
                          </div>
                        </div>
                      </div>
                      <div className='bil-data-data' style={{width:'48%'}}>
                        <span className='bil-cucu'>{lang.billdate}</span>
                        <input
                          type='date'
                          className='bil-invoice-date-input'
                          value={invoiceDate}
                          onChange={e=>setInvoiceDate(e.target.value)}
                        />
                      </div>
                      <div className='bil-data-data' style={{width:'48%'}}>
                        <span className='bil-cucu'>{lang.duedate}</span>
                        <input
                          type='date'
                          className='bil-invoice-date-input'
                          value={dueDate}
                          onChange={e=>setDueDate(e.target.value)}
                        />
                      </div>
                      <div className='bil-items-box'>
                        <span className='bil-cucu2'>{lang.lineitems}</span>
                        {items.map((it,i)=>(
                          <div key={i} className='bil-item-row'>
                            <input type='text' placeholder={lang.description} value={it.Description} onChange={e=>updateItem(i,'Description',e.target.value)}/>
                            <input type='number' placeholder={lang.amount} value={it.Quantity} onChange={e=>updateItem(i,'Quantity',e.target.value)}/>
                            <input type='number' placeholder={lang.unitprice} value={it.Price} onChange={e=>updateItem(i,'Price',e.target.value)}/>
                            <button onClick={()=>removeItem(i)}>×</button>
                          </div>
                        ))}
                        <button onClick={addItem} className='bil-add-item-btn'>+ {lang.addlineitem}</button>
                      </div>
                      <div className='bil-summary-box'>
                          <div className='bil-summary-row'>
                              <span>{lang.inttotal}:</span>
                              <span>{subtotal.toFixed(2)}</span>
                          </div>
                          <div className='bil-summary-row'>
                              <span>{lang.vat} ({VAT_RATE}%):</span>
                              <span>{vatAmount.toFixed(2)}</span>
                          </div>
                          <div className='bil-summary-row'>
                              <span>{lang.offer}</span>
                              <input
                                  type='number'
                                  value={discount}
                                  onChange={e=>setDiscount(Number(e.target.value))}
                                  placeholder={lang.tutar}
                              />
                              <span>{discountAmount.toFixed(2)}</span>
                          </div>
                          <div className='bil-summary-row bil-total'>
                              <span>{lang.generaltotal}:</span>
                              <span>{total.toFixed(2)}</span>
                          </div>
                      </div>
                  
                      <div style={{top: '-1rem'}} className='bil-data-data'>
                        <span className='bil-cucu'>{lang.state}</span>
                       <select
                        style={{marginTop: '.5rem', marginLeft: '1.5rem'}}
                        value={status}
                        onChange={e => setStatus(parseInt(e.target.value, 10))}
                      >
                        <option value={0}>{lang.pending}</option>
                        <option value={1}>{lang.paid}</option>
                      </select>

                      </div>

                      <div className='bil-notes-box'>
                        <span className='bil-cucu'>{lang.notes}</span>
                        <textarea value={notes} onChange={e=>setNotes(e.target.value)} placeholder={lang.notes}/>
                      </div>
                      <div onClick={CreateNewInvoice} className='bil-create-invoice'>{lang.cbill}</div>
                    </div>
                  </>
                )}
            </div>

              <ColdModal
                  appName="Billings"
                  title={lang.noauth}
                  message={lang.noauthmess}
                  isOpen={alerto}
                  onClose={() => setAlerto(false)}
                  buttons={[
                      { label: lang.ok, onClick: () => setAlerto(false) }
                  ]}
              />

              <ColdModal
                  appName="Billings"
                  title={lang.error}
                  message={lang.fillAllFields}
                  isOpen={alerto2}
                  onClose={() => setAlerto2(false)}
                  buttons={[
                      { label: lang.ok, onClick: () => setAlerto2(false) }
                  ]}
              />

              <ColdModal
                  appName="Billings"
                  title={lang.error}
                  message={lang.payinvoi.replace("%s", selectedInvoice.totalamount)}
                  isOpen={payModal}
                  onClose={() => setAlerto2(false)}
                  buttons={[
                      { label: lang.payx.replace("%s", selectedInvoice.totalamount), onClick: () => PayInvoice() },
                      { label: lang.cancel, onClick: () => {
                        setPayModal(false) 
                        setSelectedBillData([])
                      }}
                  ]}
              />
        </div>
    )
}

export default BillingApp;