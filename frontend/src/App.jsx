import { useEffect, useState } from 'react'

function App() {
  const [status, setStatus] = useState(null)

  useEffect(() => {
    fetch('/api/health')
      .then((res) => res.json())
      .then((data) => setStatus(data.message))
      .catch(() => setStatus('Error connecting to Rails'))
  }, [])

  return (
    <div>
      <h1>Rails + React + Vite</h1>
      <p>API Status: {status ?? 'Loading...'}</p>
    </div>
  )
}

export default App
