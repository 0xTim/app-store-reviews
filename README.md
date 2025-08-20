# App Store Reviews Dashboard

A full-stack application that retrieves and displays App Store reviews for iOS applications. 

## Architecture Overview

This application consists of two main components working together:

### 🖥️ Backend (Swift/Vapor)
- **Location**: `AppStoreDashboardBackend/`
- **Technology**: Swift with Vapor framework
- **Database**: SQLite for local data storage
- **Purpose**: 
  - Fetches app reviews from the App Store API
  - Stores review data persistently in SQLite database
  - Provides REST API endpoints for the frontend
  - Handles background jobs for periodic review updates

### 🌐 Frontend (React/TypeScript)
- **Location**: `AppStoreDashboard/`
- **Technology**: React with TypeScript, Vite build system
- **Purpose**:
  - Displays app reviews in an intuitive dashboard interface
  - Provides filtering and pagination capabilities
  - Shows review analytics and star ratings
  - Responsive design for various screen sizes

## Getting Started

Each project has its own README explaining how to run.
