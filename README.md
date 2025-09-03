# 🌱 Soil Health Monitoring App

A **Flutter mobile application** that monitors soil health parameters like **Temperature** and **Moisture** using **Bluetooth devices (BLE & Classic)**.  
The data is stored in **Firebase Firestore**, cached locally in **SharedPreferences**, and visualized with **charts** to observe trends.

---

## 📌 Features

- 🔐 **Authentication** (Firebase Email/Password login & signup)
- 📲 **Bluetooth Integration**
    - Scan for BLE devices
    - Connect & Disconnect
    - Fetch mock sensor readings (temperature & moisture)
- ☁️ **Firebase Firestore Integration**
    - Store readings per user
    - Sync data across sessions
- 💾 **SharedPreferences**
    - Local offline storage of readings
    - Auto-clears on logout
- 📊 **Data Visualization**
    - Latest Reading shown on Home
    - Report screen (latest + history)
    - History screen with line chart for trends
- ⚡ **Provider State Management**
    - Efficient & reactive UI updates
    - Separation of concerns (Bluetooth & Reading providers)

---

## 🛠️ Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **State Management:** Provider
- **Backend:** Firebase Auth & Firestore
- **Storage:** SharedPreferences
- **Bluetooth:** flutter_blue_plus
- **Charts:** fl_chart

---

## 📂 Project Structure

```bash
lib/
│── main.dart                # App entry point
│
├── Provider/
│   ├── bluetooth_provider.dart  # Bluetooth state & device handling
│   └── reading_provider.dart    # Reading generation, Firebase & local sync
│
├── services/
│   └── bluetooth_service.dart   # Low-level BluetoothManager
│
├── screens/
│   ├── LoginScreen.dart         # Firebase login
│   ├── SignupScreen.dart        # Firebase signup
│   ├── HomeScreen.dart          # Main dashboard
│   ├── ReportScreen.dart        # Latest reading + history shortcut
│   ├── HistoryScreen.dart       # All readings + chart button
│   └── TrendsScreen.dart        # Line chart visualization
│
└── widgets/
    ├── reading_card.dart        # UI card for readings
    └── BluetoothDevicesDialog.dart # Device list dialog

```

## ⚙️ Setup & Installation
#### 1. Clone the Repository

```bash
git clone https://github.com/tanujkohli83/Soil-Monitor-App.git

cd soil-health-monitoring
```

#### 2. Install Dependencies

```bash
flutter pub get
```

### 3️⃣ Setup Firebase
-  Go to [Firebase Console](https://console.firebase.google.com/)
-  Create a new project.
-  Enable **Authentication → Email/Password**.
-  Enable **Firestore Database** (start in test mode for dev).
-  Add your Flutter app using **FlutterFire CLI**:

   ```bash
   dart pub global activate flutterfire_cli

   flutterfire configure
    ```


### 4. Configure Android for Bluetooth

```bash
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
```



## ▶️ Running the App

```bash
flutter run

```

## 📱 App Flow

* Login / Signup

    * User signs in using Firebase Auth.

* HomeScreen

    * Connect to a Bluetooth device.

    * Generate readings (Test button).

    * Save to Firebase + SharedPreferences.

    * View latest reading.

* ReportScreen

    - Shows latest reading + button to history.

* HistoryScreen

    - Displays all readings from local cache.

    - Chart button opens TrendsScreen with a line graph.

* Logout

    - Clears SharedPreferences.

    - Logs user out of Firebase.


### 📊 Sample Chart (TrendsScreen)

* Red Line → Temperature

* Blue Line → Moisture

  Shows how soil parameters change over time.


### 👨‍💻 Author

Developed by Tanuj Kohli