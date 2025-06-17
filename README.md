# 💰 TrackIt - Smart Expense Tracker

A modern, feature-rich expense tracking Flutter application that helps you manage your finances, set budgets, and generate detailed reports. Built with Flutter and Firebase for seamless cross-platform experience.

![TrackIt App](https://img.shields.io/badge/Flutter-3.7.0-blue?style=for-the-badge&logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Cloud%20Firestore-orange?style=for-the-badge&logo=firebase)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey?style=for-the-badge)

## ✨ Features

### 📊 **Expense Tracking**
- Add income and expense transactions
- Categorize transactions (Food, Travel, Leisure, Work, Money)
- Add notes and descriptions to transactions
- Real-time balance updates
- Transaction history with search and filtering

### 💳 **Budget Management**
- Set monthly budgets for different categories
- Visual progress indicators with color coding
- Budget vs actual spending comparison
- 50-50 split layout for overview and active budgets
- Easy budget creation and deletion

### 📈 **Financial Reports**
- Monthly overview with income/expense breakdown
- Category-wise spending analysis
- Spending trends over 6 months
- Yearly financial summary
- Visual charts and statistics

### 🎨 **User Experience**
- Modern, intuitive UI design
- Dark/Light theme support
- Responsive design for all screen sizes
- Smooth animations and transitions
- Swipe to delete transactions

### 🔐 **Authentication & Security**
- Firebase Authentication
- Secure user data storage
- Real-time data synchronization
- Offline capability

## 📱 Screenshots

<h3>Home Screen:</h3>
<p align="center">
  <img src="https://github.com/user-attachments/assets/5f7f0ea3-f4ca-4101-b269-4637f911f6bd" alt="Home Screen" width="250"/>
</p>

### Add Transaction:
<p align="center">
  <img src="https://github.com/user-attachments/assets/9f4cbd0e-308a-4a12-b6b2-a6cf7a49a05c" alt="Add Transaction" width="250"/>
</p>

### Budget Management:
<p align="center">
  <img src="https://github.com/user-attachments/assets/bfcb8e2d-0b5f-4391-9505-cfd69e197161" alt="Budget Management" width="250"/>
</p>

### Financial Reports:
<p align="center">
  <img src="https://github.com/user-attachments/assets/9ba5d0c0-a84f-428b-aca3-e4e993376fad" alt="Financial Reports" width="250"/>
</p>

You can find more images here: [images](https://github.com/zeel011/MoneyTracker/tree/88efcada10119ecbd9d5c44b3b78f5e517a68708/images)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.7.0 or higher)
- Dart SDK (2.19.0 or higher)
- Android Studio / VS Code
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/zeel011/trackit.git
   cd trackit
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication (Email/Password)
   - Enable Cloud Firestore
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the respective platform folders

4. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── src/
│   ├── constants/
│   │   └── color.dart        # App color constants
│   ├── controllers/
│   │   ├── user_controller.dart
│   │   ├── transaction_controller.dart
│   │   ├── budget_controller.dart
│   │   └── reports_controller.dart
│   ├── models/
│   │   ├── transaction_model.dart
│   │   ├── user_model.dart
│   │   └── budget_model.dart
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── splash_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   └── widgets/
│   │   ├── add_transaction/
│   │   │   └── add_transaction.dart
│   │   ├── budget/
│   │   │   ├── budget_screen.dart
│   │   │   └── add_budget_screen.dart
│   │   └── reports/
│   │       └── reports_screen.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── transaction_service.dart
│   │   └── budget_service.dart
│   └── Theme/
│       └── theme.dart        # App theme configuration
```

## 🛠️ Technologies Used

- **Frontend**: Flutter 3.7.0
- **Backend**: Firebase
- **Database**: Cloud Firestore
- **Authentication**: Firebase Auth
- **State Management**: GetX
- **UI Components**: Material Design 3

## 📋 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  get: ^4.6.6
  intl: ^0.18.1
  google_fonts: ^6.1.0
```

## 🎯 Key Features Explained

### **Transaction Management**
- Add transactions with category, amount, and notes
- Filter transactions by category and date
- Swipe gestures for quick deletion
- Real-time balance calculation

### **Budget System**
- Set category-wise monthly budgets
- Visual progress bars with color indicators
- Budget vs actual spending tracking
- Easy budget modification and deletion

### **Reporting System**
- Comprehensive financial reports
- Monthly and yearly summaries
- Category-wise spending analysis
- Trend visualization

## 🔧 Configuration

### Firebase Configuration
1. Enable Email/Password authentication
2. Set up Firestore database with security rules
3. Configure app for Android and iOS platforms

### Environment Variables
Create a `.env` file in the root directory:
```env
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
```

## 📱 Platform Support

- ✅ Android (API 21+)
- ✅ iOS (12.0+)
- ✅ Web (Chrome, Firefox, Safari)
- ✅ Desktop (Windows, macOS, Linux)

---
