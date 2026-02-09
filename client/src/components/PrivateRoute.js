import React from 'react'
import { Navigate, Outlet } from 'react-router-dom'

const PrivateRoute = ({ children }) => {
  const isAuthenticated = () => {
    // Check if user is authenticated by verifying localStorage
    const userId = localStorage.getItem('userId')
    const userRole = localStorage.getItem('userRole')
    return userId && userRole
  }

  if (!isAuthenticated()) {
    return <Navigate to="/" replace />
  }

  return children ? children : <Outlet />
}

export default PrivateRoute
