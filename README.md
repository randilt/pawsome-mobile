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
![WhatsApp Image 2025-06-08 at 2 17 51 PM](https://github.com/user-attachments/assets/eee1d2ee-b423-4614-906c-3a442fcf144b)
![WhatsApp Image 2025-06-08 at 2 17 52 PM](https://github.com/user-attachments/assets/031437de-90dd-448a-9953-824291ad983d)

### Home & Product Browsing
![WhatsApp Image 2025-06-08 at 2 17 53 PM](https://github.com/user-attachments/assets/3ce150fc-edde-4492-ba4a-41dd79199460)
![WhatsApp Image 2025-06-08 at 2 17 53 PM (1)](https://github.com/user-attachments/assets/6f8b18b8-d88e-4839-a3d1-ce70843c2c55)

### Shopping Experience
![WhatsApp Image 2025-06-08 at 2 17 53 PM (2)](https://github.com/user-attachments/assets/e2b43572-37ee-44b9-81d4-d8a34b23f1fc)
![WhatsApp Image 2025-06-08 at 2 17 54 PM](https://github.com/user-attachments/assets/0c7c5b5e-166c-4c65-b2df-48896f473870)
![WhatsApp Image 2025-06-08 at 2 17 54 PM (1)](https://github.com/user-attachments/assets/8dd59ffc-b0c6-41be-9869-b9e978606a4d)

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
