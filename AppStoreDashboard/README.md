# App Store Reviews Dashboard

A modern React dashboard for displaying and managing App Store reviews, built with React Router, TypeScript, and TailwindCSS.

## Features

- 🚀 **Server-side rendering** with React Router
- ⚡️ **Hot Module Replacement** (HMR) for fast development
- 📦 **Asset bundling and optimization**
- 🔄 **API integration** for fetching reviews
- 🎨 **Responsive design** with dark mode support
- ⭐ **Interactive star ratings** display
- 🔒 **TypeScript** for type safety
- 🎉 **TailwindCSS** for modern styling
- � **Dashboard analytics** with summary statistics
- 🚨 **Error handling** with user-friendly error messages
- ⌛ **Loading states** with skeleton components

## Getting Started

### Installation

Install the dependencies:

```bash
npm install
```

### Environment Setup

There are a couple of environment variables you can set for the app:

* `API_BASE_URL`: The base URL for the API server
* `DEFAULT_APP_ID`: The default app ID to fetch reviews from the API

### Development

Start the development server:

```bash
npm run dev
```

Your application will be available at `http://localhost:5173`.

### Error Handling

The dashboard handles various error scenarios:
- **Network errors**: When the API server is unreachable
- **HTTP errors**: When the API returns error status codes
- **Data validation errors**: When the API returns invalid data format
- **JSON parsing errors**: When the API returns malformed JSON

All errors display user-friendly messages with retry options.

## Building for Production

Create a production build:

```bash
npm run build
```

## Project Structure

```
app/
├── components/          # Reusable UI components
│   ├── AppStoreDashboard.tsx
│   ├── ReviewCard.tsx
│   ├── StarRating.tsx
│   ├── LoadingSpinner.tsx
│   └── ErrorMessage.tsx
├── hooks/              # Custom React hooks
│   └── useReviews.ts
├── services/           # API services
│   └── ApiService.ts
├── types/              # TypeScript type definitions
│   └── Review.ts
├── data/               # Static data (now deprecated)
│   └── reviews.ts
└── routes/             # Route components
    └── home.tsx
```

## Deployment

### Docker Deployment

To build and run using Docker:

```bash
docker build -t my-app .

# Run the container
docker run -p 3000:3000 my-app
```

The containerized application can be deployed to any platform that supports Docker, including:

- AWS ECS
- Google Cloud Run
- Azure Container Apps
- Digital Ocean App Platform
- Fly.io
- Railway

### DIY Deployment

If you're familiar with deploying Node applications, the built-in app server is production-ready.

Make sure to deploy the output of `npm run build`

```
├── package.json
├── package-lock.json (or pnpm-lock.yaml, or bun.lockb)
├── build/
│   ├── client/    # Static assets
│   └── server/    # Server-side code
```

## Styling

This template comes with [Tailwind CSS](https://tailwindcss.com/) already configured for a simple default starting experience. You can use whatever CSS framework you prefer.

---

Built with ❤️ using React Router.
