import { useEffect, useState } from 'react'

function HomePage() {
  const [status, setStatus] = useState(null)

  useEffect(() => {
    const check = async () => {
      try {
        const res = await fetch('/api/v1/health')
        if (res.ok) {
          const data = await res.json()
          setStatus(data.message || 'Rails API is running')
          return
        }
      } catch (_e) {
        // try legacy endpoint next
      }

      try {
        const res = await fetch('/api/health')
        const data = await res.json()
        setStatus(data.message || 'Rails API is running')
      } catch (_e) {
        setStatus('Error connecting to Rails')
      }
    }

    check()
  }, [])

  return (
    <div style={{ maxWidth: 720, margin: '48px auto', padding: 16 }}>
      <h1>Rails + React + Vite</h1>
      <p>API Status: {status ?? 'Loading...'}</p>
      <p>
        <a href="/login">Go to Login Page</a>
      </p>
    </div>
  )
}

function LoginPage() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState(null)

  const onSubmit = async (e) => {
    e.preventDefault()
    setLoading(true)
    setResult(null)

    try {
      const res = await fetch('/api/v1/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ user: { email, password } }),
      })

      const text = await res.text()
      let payload = null
      try {
        payload = JSON.parse(text)
      } catch (_e) {
        payload = { raw: text }
      }

      setResult({ status: res.status, payload })
    } catch (_e) {
      setResult({ status: 'NETWORK_ERROR', payload: { message: 'Could not reach backend' } })
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={{ maxWidth: 720, margin: '48px auto', padding: 16 }}>
      <h1>Login</h1>
      <form onSubmit={onSubmit} style={{ display: 'grid', gap: 12 }}>
        <label>
          Email
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            style={{ width: '100%', padding: 8, marginTop: 4 }}
          />
        </label>

        <label>
          Password
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            style={{ width: '100%', padding: 8, marginTop: 4 }}
          />
        </label>

        <button type="submit" disabled={loading} style={{ padding: '10px 14px' }}>
          {loading ? 'Signing in...' : 'Sign In'}
        </button>
      </form>

      {result && (
        <pre style={{ marginTop: 16, padding: 12, background: '#f5f5f5', overflowX: 'auto' }}>
{JSON.stringify(result, null, 2)}
        </pre>
      )}

      <p>
        <a href="/">Back to Home</a>
      </p>
    </div>
  )
}

function App() {
  const path = window.location.pathname
  if (path === '/login') return <LoginPage />
  return <HomePage />
}

export default App
