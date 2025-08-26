import { motion, AnimatePresence } from 'framer-motion'

const LabelModal = ({ show, onClose, onCreate }) => {
  const [input, setInput] = useState('')

  const handleSubmit = () => {
    if (!input.trim()) return
    onCreate(input)
    setInput('')
    onClose()
  }

  return (
    <AnimatePresence>
      {show && (
        <motion.div className="modal-overlay"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}>
          <motion.div className="modal-box"
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0.8, opacity: 0 }}
            transition={{ duration: 0.2 }}>
            <h3 style={{ color: '#fff', fontFamily: 'SF Pro Display' }}>Not Etiketi</h3>
            <input
              type="text"
              value={input}
              onChange={e => setInput(e.target.value)}
              placeholder="örnek: Olay Yeri, İfade..."
            />
            <button onClick={handleSubmit}>Oluştur</button>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}
