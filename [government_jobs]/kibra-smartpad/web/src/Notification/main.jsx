import { useState, useEffect } from "react"
import { motion } from "framer-motion"
import { useNui } from "@/nui"
import './main.css'

export default function Notification() {
  const [notification, setNotification] = useState(null);

  let lastPlayed = 0

  const playNotificationSound = () => {
    const now = Date.now()
    if (now - lastPlayed < 500) return // 500ms içinde tekrar oynatma
    lastPlayed = now

    const audio = new Audio("/web/build/notify.mp3")
    audio.volume = 0.5
    audio.play()
  }


  useEffect(() => {
    const unsub = useNui("tabletNotification", (data) => {
      const notif = {
        title: data.title,
        message: data.message,
        icon: data.icon,
        location: data.location,
        type: data.opened ? 'internal' : 'external'
      }

      setNotification(notif)
      playNotificationSound()

      setTimeout(() => {
        setNotification(null)
      }, data.opened ? 3000 : 6000)
    })

    return () => unsub?.() // cleanup old listener if needed
  }, []) // sadece 1 kere bağlan

  return (
    <>
      {notification && (
        <>
          {notification.type === 'external' && (
            <motion.div
              className={`notifyx external ${notification.location || 'top-right'}`}
              initial={{ opacity: 0, y: -50 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -50 }}
              style={{ zIndex: 9999 }}
            >
              <div className="notif-content external-box">
                <div className="external-icon">
                  <img
                    src={`/web/build/appicons/${notification.icon}.png`}
                    alt="App Icon"
                  />
                </div>
                <div>
                  <h4 style={{ margin: 0 }}>{notification.title}</h4>
                  <p style={{ margin: "4px 0 0", fontSize: "13px" }}>{notification.message}</p>
                </div>
              </div>
            </motion.div>
          )}

          {notification.type === 'internal' && (
            <motion.div
              className={`iosNotBox`}
              initial={{ opacity: 0, y: -50 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -50 }}
              style={{ zIndex: 9999 }}
            >
              <div style={{display: 'flex', flexDirection: 'columnb'}}>
                <img src={`/web/build/appicons/${notification.icon}.png`}></img>
                <span className='iosAppName'>{notification.title}</span>
              </div>
              <span className='notifMessage'>{notification.message}</span>
            </motion.div>
          )}
        </>
      )}
    </>
  );

}
