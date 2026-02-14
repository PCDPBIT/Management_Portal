// pages/NotFoundPage.jsx
import React from "react";
import { useNavigate } from "react-router-dom";
import MainLayout from "../components/MainLayout";

function NotFoundPage() {
  const navigate = useNavigate();

  return (
    <MainLayout title="" subtitle="">
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="text-center">
          <h1 className="text-2xl font-normal text-gray-800">
            Request URL 404 | Not Found
          </h1>
          
          <div className="mt-8 flex gap-3 justify-center">
            <button
              onClick={() => navigate('/dashboard')}
              className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              Go to Dashboard
            </button>
            
            <button
              onClick={() => navigate(-1)}
              className="px-6 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors"
            >
              Go Back
            </button>
          </div>
        </div>
      </div>
    </MainLayout>
  );
}

export default NotFoundPage;