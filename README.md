**App still under development**
# BlogSpace 🐦

A Flutter-based social media application inspired by Twitter/X interface, where users can share their thoughts and images publicly. Built to practice modern UI design and learn Twitter-like user experience patterns.

## 📱 Screenshots

<div align="center">
    <img src="Screenshot/homepage.png" alt="Home Page" width="250"  style="margin: 0 10px;">
    <img src="Screenshot/profilepage.png" alt="Profile Page" width="250"  style="margin: 0 10px;">
</div>

## ✨ Features

- 📝 **Post Tweets** - Share your thoughts with the world
- 📷 **Image Sharing** - Upload and share images with your posts
- 👤 **User Profiles** - Customizable user profiles
- 🔐 **Authentication** - Secure login and registration
- 📱 **Responsive Design** - Works seamlessly across devices
- 🎨 **Twitter-like UI** - Familiar and intuitive interface

## 🛠️ Built With

### Framework & Language
- **Flutter**: 3.29.3
- **Dart**: 3.7.2

### Platform Support
- **Android**: API Level 23+ (Android 6.0+)
- **iOS**: iOS 12.0+

### Backend & Database
- **Firebase**:
  - **cloud_firestore**: 5.6.11 - Database
  - **firebase_auth**: 5.6.2 - Authentication
- **Cloudinary**: Image storage and optimization

### State Management
- **Provider**: 6.1.5

### Development Tools
- **IDE**: VS Code
- **Version Control**: Git & GitHub

## 📋 Prerequisites

Before running this project, make sure you have:

- Flutter SDK (3.29.3 or higher)
- Dart SDK (3.7.2 or higher)
- Android Studio / VS Code
- Android SDK (API level 23+)
- Xcode (for iOS development)
- Git
- Firebase account
- Cloudinary account (for image storage)

## 🚀 Installation

### 1. Clone the repository
```bash
git clone https://github.com/kailash9712t/Blog-App.git
cd Blog-App
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Setup Firebase
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable Authentication and Firestore Database
3. Add your `google-services.json` to `android/app/`
4. Add your `GoogleService-Info.plist` to `ios/Runner/`

### 4. Setup Cloudinary
1. Create account at [Cloudinary](https://cloudinary.com)
2. Get your Cloud Name, API Key, and Secret Key

### 5. Environment Setup
Create `lib/Config/env.dart`:
```dart
class Config {
  static String cloudinaryCloudName = "your_cloud_name";
  static String apiKey = "your_api_key";
  static String secretKey = "your_secret_key";
  static String cloudinaryUrl =
      "CLOUDINARY_URL=cloudinary://$apiKey:$secretKey@$cloudinaryCloudName";
}
```

### 6. Run the app
```bash
flutter run
```

## 📊 Project Structure

```
lib/
├── Config/          # App configuration
├── Data/            # Data layer
├── Models/          # Data models
├── Routes/          # Route definitions
├── Components/      # Reusable widgets
├── Pages/           # UI screens
├── Firebase/        # Database and auth operations
├── Utils/           # Helper functions
└── main.dart        # App entry point
```

## 🔧 Configuration

### Firebase Setup
1. Install Firebase CLI:
```bash
npm install -g firebase-tools
```

2. Login and initialize:
```bash
firebase login
firebase init
```

3. Configure Firestore rules and Authentication providers

### Environment Variables
Update `lib/Config/env.dart` with your actual credentials:
- Cloudinary cloud name
- API key and secret key
- Any other service credentials

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📦 Build

### Android
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🐛 Known Issues

- [ ] Image upload optimization needed
- [ ] Dark mode implementation pending

## 🗺️ Roadmap

- [ ] **Push Notifications** - Real-time notifications
- [ ] **Direct Messaging** - Private messaging feature
- [ ] **Dark Mode** - Theme switching
- [ ] **Story Feature** - Instagram-like stories
- [ ] **Search Functionality** - Search users and posts
- [ ] **Hashtag Support** - Trending hashtags

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Rabari Kailash**

- 🐙 GitHub: [@kailash9712t](https://github.com/kailash9712t)
- 💼 LinkedIn: [Kailash Rabari](https://www.linkedin.com/in/kailash-rabari-51b647332/)
- 📧 Email: rabarikailash721@gmail.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Twitter/X for UI inspiration
- Cloudinary for image optimization

## 💡 Learning Journey

This project was built to:
- Learn modern Flutter UI design patterns
- Understand social media app architecture
- Practice Firebase integration
- Implement Twitter/X-like user experience

---

**If you found this project helpful, please give it a ⭐️!**