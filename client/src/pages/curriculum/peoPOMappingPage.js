import React, { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import MainLayout from '../../components/MainLayout'
import { API_BASE_URL } from '../../config'

function PEOPOMappingPage() {
  const { id } = useParams()
  const navigate = useNavigate()
  
  const [peos, setPeos] = useState([])
  const [pos, setPos] = useState([])
  const [psos, setPsos] = useState([])
  const [poMatrix, setPoMatrix] = useState({})
  const [psoPoMatrix, setPsoPoMatrix] = useState({})
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  useEffect(() => {
    fetchData()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id])

  const fetchData = async () => {
    try {
      setLoading(true)
      
      // Fetch department overview (for PEOs and POs)
      const overviewResponse = await fetch(`${API_BASE_URL}/curriculum/${id}/overview`)
      if (!overviewResponse.ok) {
        throw new Error('Failed to fetch department overview')
      }
      const overviewData = await overviewResponse.json()
      setPeos(overviewData.peos || [])
      setPos(overviewData.pos || [])
      setPsos(overviewData.psos || [])

      // Fetch existing PEO-PO-PSO mappings
      const mappingResponse = await fetch(`${API_BASE_URL}/curriculum/${id}/peo-po-mapping`)
      if (!mappingResponse.ok) {
        throw new Error('Failed to fetch PEO-PO-PSO mappings')
      }
      const mappingData = await mappingResponse.json()
      setPoMatrix(mappingData.poMatrix || {})
      setPsoPoMatrix(mappingData.psoPoMatrix || {})
      
      setError('')
    } catch (err) {
      console.error('Error fetching data:', err)
      setError('Failed to load data')
    } finally {
      setLoading(false)
    }
  }

  const handleSave = async () => {
    try {
      // Convert matrix objects to array for backend with 1-based indexing
      const mappings = []
      
      // Add PEO-PO mappings
      peos.forEach((_, peoIndex) => {
        pos.forEach((_, poIndex) => {
          const key = `${peoIndex}-${poIndex}`
          const value = poMatrix[key] || 0
          if (value > 0) { // Only save non-zero values
            mappings.push({
              peo_index: peoIndex + 1,  // Convert to 1-based for database
              po_index: poIndex + 1,    // Convert to 1-based for database
              pso_index: null,
              mapping_value: value
            })
          }
        })
      })
      
      // Add PSO-PO mappings
      const psoPoMappings = []
      psos.forEach((_, psoIndex) => {
        pos.forEach((_, poIndex) => {
          const key = `${psoIndex}-${poIndex}`
          const value = psoPoMatrix[key] || 0
          if (value > 0) { // Only save non-zero values
            psoPoMappings.push({
              pso_index: psoIndex + 1,  // Convert to 1-based for database
              po_index: poIndex + 1,    // Convert to 1-based for database
              mapping_value: value
            })
          }
        })
      })

      const response = await fetch(`${API_BASE_URL}/curriculum/${id}/peo-po-mapping`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ mappings, psoPoMappings })
      })

      if (!response.ok) {
        throw new Error('Failed to save mappings')
      }

      setSuccess('PEO-PO and PSO-PO mappings saved successfully!')
      setTimeout(() => setSuccess(''), 3000)
      setError('')
    } catch (err) {
      console.error('Error saving mappings:', err)
      setError('Failed to save mappings')
    }
  }

  const updatePoValue = (peoIndex, poIndex, value) => {
    const key = `${peoIndex}-${poIndex}`
    setPoMatrix({
      ...poMatrix,
      [key]: parseInt(value)
    })
  }

  const getPoValue = (peoIndex, poIndex) => {
    const key = `${peoIndex}-${poIndex}`
    return poMatrix[key] || 0
  }

  const updatePsoPoValue = (psoIndex, poIndex, value) => {
    const key = `${psoIndex}-${poIndex}`
    setPsoPoMatrix({
      ...psoPoMatrix,
      [key]: parseInt(value)
    })
  }

  const getPsoPoValue = (psoIndex, poIndex) => {
    const key = `${psoIndex}-${poIndex}`
    return psoPoMatrix[key] || 0
  }

  if (loading) {
    return (
      <MainLayout title="PEO-PO & PSO-PO Mapping" subtitle="Loading...">
        <div className="flex items-center justify-center min-h-screen">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-indigo-600"></div>
        </div>
      </MainLayout>
    )
  }

  if (peos.length === 0 || (pos.length === 0 && psos.length === 0)) {
    return (
      <MainLayout title="PEO-PO & PSO-PO Mapping" subtitle={`Curriculum ID: ${id}`}>
        <div className="card-custom p-12 text-center">
          <svg className="w-20 h-20 text-yellow-400 mx-auto mb-4" fill="currentColor" viewBox="0 0 20 20">
            <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
          </svg>
          <h3 className="text-xl font-semibold text-gray-900 mb-2">PEOs, POs, or PSOs Not Found</h3>
          <p className="text-gray-600 mb-6">Please add Program Educational Objectives (PEOs), Program Outcomes (POs), and Program Specific Outcomes (PSOs) in the Department Overview page before creating mappings.</p>
          <button onClick={() => navigate(`/curriculum/${id}/overview`)} className="btn-primary-custom">Go to Department Overview</button>
        </div>
      </MainLayout>
    )
  }

  if (peos.length === 0 || pos.length === 0) {
    return (
      <MainLayout title="PEO-PO Mapping" subtitle={`Curriculum ID: ${id}`}>
        <div className="card-custom p-12 text-center">
          <svg className="w-20 h-20 text-yellow-400 mx-auto mb-4" fill="currentColor" viewBox="0 0 20 20">
            <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
          </svg>
          <h3 className="text-xl font-semibold text-gray-900 mb-2">PEOs or POs Not Found</h3>
          <p className="text-gray-600 mb-6">Please add Program Educational Objectives (PEOs) and Program Outcomes (POs) in the Department Overview page before creating PEO-PO mappings.</p>
          <button onClick={() => navigate(`/curriculum/${id}/overview`)} className="btn-primary-custom">Go to Department Overview</button>
        </div>
      </MainLayout>
    )
  }

  return (
    <MainLayout 
      title="PEO-PO & PSO-PO Mapping"
      subtitle={`Curriculum ID: ${id}`}
      actions={
        <div className="flex items-center space-x-3">
          <button onClick={() => navigate(-1)} className="btn-secondary-custom flex items-center space-x-2">
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            <span>Back</span>
          </button>
          <button onClick={handleSave} className="btn-primary-custom flex items-center space-x-2">
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-1 4l-3 3m0 0l-3-3m3 3V4" />
            </svg>
            <span>Save Mapping</span>
          </button>
        </div>
      }
    >
      <div className="min-w-screen mx-auto space-y-4">

        {/* Messages */}
        {error && (
          <div className="flex items-start space-x-3 p-4 bg-red-50 border border-red-200 rounded-lg">
            <svg className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
            </svg>
            <p className="text-sm font-medium text-red-600">{error}</p>
          </div>
        )}
        
        {success && (
          <div className="flex items-start space-x-3 p-4 bg-green-50 border border-green-200 rounded-lg">
            <svg className="w-5 h-5 text-green-600 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
            </svg>
            <p className="text-sm font-medium text-green-600">{success}</p>
          </div>
        )}

        {/* Legend */}
        <div className="card-custom p-6 bg-white border border-gray-300">
          <h3 className="font-bold text-lg text-gray-900 mb-4 flex items-center gap-2">
            <span className="text-xl">📊</span>
            Mapping Scale Legend
          </h3>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="flex items-center gap-3 p-3 bg-white rounded-lg border border-gray-200 shadow-sm">
              <div className="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center">
                <span className="font-bold text-lg text-gray-600">0</span>
              </div>
              <div>
                <div className="font-semibold text-gray-900 text-sm">No Correlation</div>
                <div className="text-xs text-gray-500">Not related</div>
              </div>
            </div>
            <div className="flex items-center gap-3 p-3 bg-white rounded-lg border border-gray-200 shadow-sm">
              <div className="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
                <span className="font-bold text-lg text-green-700">1</span>
              </div>
              <div>
                <div className="font-semibold text-gray-900 text-sm">Low Correlation</div>
                <div className="text-xs text-gray-500">Slightly related</div>
              </div>
            </div>
            <div className="flex items-center gap-3 p-3 bg-white rounded-lg border border-gray-200 shadow-sm">
              <div className="w-10 h-10 bg-yellow-100 rounded-full flex items-center justify-center">
                <span className="font-bold text-lg text-yellow-700">2</span>
              </div>
              <div>
                <div className="font-semibold text-gray-900 text-sm">Medium Correlation</div>
                <div className="text-xs text-gray-500">Moderately related</div>
              </div>
            </div>
            <div className="flex items-center gap-3 p-3 bg-white rounded-lg border border-gray-200 shadow-sm">
              <div className="w-10 h-10 bg-red-100 rounded-full flex items-center justify-center">
                <span className="font-bold text-lg text-red-700">3</span>
              </div>
              <div>
                <div className="font-semibold text-gray-900 text-sm">High Correlation</div>
                <div className="text-xs text-gray-500">Strongly related</div>
              </div>
            </div>
          </div>
          <div className="mt-4 p-3 bg-background rounded-lg border border-blue-200">
            <p className="text-sm text-blue-800">
              <strong>How to use:</strong> Select the appropriate correlation level (0-3) for each PEO-PO and PSO-PO relationship in the matrices below.
            </p>
          </div>
        </div>

        {/* PEO-PO Mapping Matrix */}
        {pos.length > 0 && (
          <div className="card-custom overflow-hidden border-gray-300">
            <div className="px-6 py-4 bg-gray-200">
              <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                <span className="text-2xl">🎯</span>
                PEO - PO Mapping Matrix
              </h2>
            </div>
            <div className="p-6 overflow-x-auto">
              <table className="w-full border-collapse">
                <thead>
                  <tr>
                    <th className="border border-gray-300 bg-gray-100 px-4 py-3 text-sm font-semibold text-gray-700 sticky left-0 z-10">
                      PEO / PO
                    </th>
                    {pos.map((_, poIndex) => (
                      <th key={poIndex} className="border border-gray-300 bg-gray-100 px-4 py-3 text-sm font-semibold text-gray-700">
                        PO{poIndex + 1}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {peos.map((_, peoIndex) => (
                    <tr key={peoIndex} className="hover:bg-gray-50">
                      <td className="border border-gray-300 px-4 py-3 font-semibold text-sm text-gray-700 bg-gray-50 sticky left-0 z-10">
                        PEO{peoIndex + 1}
                      </td>
                      {pos.map((_, poIndex) => (
                        <td key={poIndex} className="border border-gray-300 px-2 py-2">
                          <select
                            value={getPoValue(peoIndex, poIndex)}
                            onChange={(e) => updatePoValue(peoIndex, poIndex, e.target.value)}
                            className="w-full px-2 py-1.5 border border-gray-300 rounded focus:border-indigo-500 focus:outline-none text-center font-semibold text-sm"
                          >
                            <option value="0">0</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                          </select>
                        </td>
                      ))}
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {psos.length > 0 && pos.length > 0 && (
          <div className="card-custom overflow-hidden">
            <div className="px-6 py-4 bg-gradient-to-r from-green-50 to-green-100 border-b border-gray-200">
              <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                <span className="text-2xl">🔗</span>
                PSO - PO Mapping Matrix
              </h2>
            </div>
            <div className="p-6 overflow-x-auto">
              <table className="w-full border-collapse">
                <thead>
                  <tr>
                    <th className="border border-gray-300 bg-gray-100 px-4 py-3 text-sm font-semibold text-gray-700 sticky left-0 z-10">
                      PSO / PO
                    </th>
                    {pos.map((_, poIndex) => (
                      <th key={poIndex} className="border border-gray-300 bg-gray-100 px-4 py-3 text-sm font-semibold text-gray-700">
                        PO{poIndex + 1}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {psos.map((_, psoIndex) => (
                    <tr key={psoIndex} className="hover:bg-gray-50">
                      <td className="border border-gray-300 px-4 py-3 font-semibold text-sm text-gray-700 bg-gray-50 sticky left-0 z-10">
                        PSO{psoIndex + 1}
                      </td>
                      {pos.map((_, poIndex) => (
                        <td key={poIndex} className="border border-gray-300 px-2 py-2">
                          <select
                            value={getPsoPoValue(psoIndex, poIndex)}
                            onChange={(e) => updatePsoPoValue(psoIndex, poIndex, e.target.value)}
                            className="w-full px-2 py-1.5 border border-gray-300 rounded focus:border-indigo-500 focus:outline-none text-center font-semibold text-sm"
                          >
                            <option value="0">0</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                          </select>
                        </td>
                      ))}
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {/* PEOs, POs and PSOs Reference */}
        <div className="grid grid-cols-1 gap-4">
          <div className="card-custom p-6">
            <h3 className="font-semibold text- text-gray-900 mb-4 flex items-center gap-2">
              <span className="text-2xl">📋</span>
              Program Educational Objectives (PEOs)
            </h3>
            <div className="space-y-2">
              {peos.map((peo, index) => (
                <div key={index} className="flex gap-3 text-sm">
                  <span className="font-semibold text-gray-800 min-w-[70px]">PEO{index + 1}:</span>
                  <span className="text-gray-700">{peo.text || peo}</span>
                </div>
              ))}
            </div>
          </div>

          {pos.length > 0 && (
            <div className="card-custom p-6">
              <h3 className="font-semibold text-gray-900 mb-4 flex items-center gap-2">
                <span className="text-2xl">🎓</span>
                Program Outcomes (POs)
              </h3>
              <div className="space-y-2">
                {pos.map((po, index) => (
                  <div key={index} className="flex gap-3 text-sm">
                    <span className="font-semibold text-gray-800 min-w-[60px]">PO{index + 1}:</span>
                    <span className="text-gray-700">{po.text || po}</span>
                  </div>
                ))}
              </div>
            </div>
          )}

          {psos.length > 0 && (
            <div className="card-custom p-6">
              <h3 className="font-semibold text-gray-900 mb-4 flex items-center gap-2">
                <span className="text-2xl">🎯</span>
                Program Specific Outcomes (PSOs)
              </h3>
              <div className="space-y-2">
                {psos.map((pso, index) => (
                  <div key={index} className="flex gap-3 text-sm">
                    <span className="font-semibold text-gray-800 min-w-[70px]">PSO{index + 1}:</span>
                    <span className="text-gray-700">{pso.text || pso}</span>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>
    </MainLayout>
  )
}

export default PEOPOMappingPage
