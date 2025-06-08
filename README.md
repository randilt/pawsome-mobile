# Pawsome - Pet Store Mobile App

A Flutter mobile application for pet supplies shopping, developed as part of the Mobile Application Development module. The application features a clean UI, secure authentication, and a seamless shopping experience.

## Features

- 🔐 Secure Authentication with Biometric Support
- 🛍️ Product Browsing and Shopping Cart
- ❤️ Favorites System with Local Storage
- 🌓 Dark Mode Support
- 📱 Responsive Design
- 📦 Basic Order Management
- 📱 Hardware Integration

## Screenshots

### Authentication

[Add screenshot of login screen]
[Add screenshot of registration screen]

### Home & Product Browsing

[Add screenshot of home screen]
[Add screenshot of product details screen]

### Shopping Experience

[Add screenshot of cart screen]
[Add screenshot of checkout screen]
[Add screenshot of favorites screen]

## Technology Stack

### Frontend

- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language
- **Material Design**: UI/UX guidelines
- **Provider**: State management
- **SQLite**: Local storage for favorites
- **Local Authentication**: Biometric authentication

### Backend Integration

- **Laravel API**: Product and user data
- **HTTP**: API communication

## Architecture

The application follows the **Provider Pattern** architecture, which provides:

- **Separation of Concerns**: Clear separation between UI, business logic, and data layers
- **Testability**: Easy to write unit tests for business logic
- **Maintainability**: Modular code structure

### Directory Structure

```
lib/
├── config/         # Configuration files
├── models/         # Data models
├── screens/        # UI screens
├── services/       # Business logic and API services
├── widgets/        # Reusable UI components
└── main.dart       # Application entry point
```

## Features in Detail

### Authentication

- Email/Password authentication
- Biometric authentication for secure checkout
- Session management

### Shopping Experience

- Browse products by categories
- Add to cart
- Save favorites
- View product details
- Basic checkout process with biometric authentication

### User Profile

- View order history
- Manage personal information

### Hardware Integration

- Biometric authentication for secure checkout
- Camera integration for product reviews
- Location services for product delivery

### Local Storage

- Save favorite products
- Persistent login state
- Cart data persistence

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)

### Installation

1. Clone the repository:

```bash
git clone https://github.com/randilt/pawsome-mobile.git
```

2. Navigate to the project directory:

```bash
cd pawsome-mobile
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

## Development

This project was developed as part of the Mobile Application Development module, focusing on:

- Flutter mobile app development
- State management using Provider
- Local storage implementation
- API integration
- UI/UX design principles
- Authentication implementation
