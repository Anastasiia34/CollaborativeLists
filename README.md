# Collaborative Lists

Full-stack pet project for creating and sharing collaborative lists.

The project includes:
- iOS app built with SwiftUI
- Backend API built with Vapor
- PostgreSQL database
- Docker setup for backend infrastructure

## Features

- User registration and login
- Token-based authentication
- Create, edit and delete lists
- Add and manage list items
- Share lists with other users as editors
- View lists where the user is either an owner or an editor

## Tech Stack

### iOS
- Swift
- SwiftUI
- MVVM
- async/await
- Swift Testing

### Backend
- Swift
- Vapor 4
- Fluent
- PostgreSQL
- Docker
- Swift Testing

## Project Structure

```
.
├── CollaborativeListsBackend/   # Vapor backend  
├── CollaborativeLists/       # SwiftUI iOS app  
└── README.md
```

## Run Backend

From the CollaborativeListsBackend/ directory:

```bash
docker compose up --build
```

## Run iOS App
1. Open the CollaborativeLists/ project in Xcode
2. Build and run the app on a simulator or a real device
3. On first launch, enter the backend URL in the app alert

Use:

http://localhost:8080

for the iOS Simulator.

Use your Mac's local network IP for a real iPhone:

http://<your-mac-local-ip>:8080 (Example: http://192.168.1.10:8080)

## Backend Tests

From the CollaborativeListsBackend/ directory, run:

```bash
docker compose up -d test-db
swift test
```

## Notes
- Backend is fully runnable via Docker Compose
- iOS app requires manual backend URL input on first launch
- No .env file is required; configuration is provided via Docker
