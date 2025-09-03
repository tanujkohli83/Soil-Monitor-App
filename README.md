🌱 Soil Health Monitoring App
=============================

A **Flutter mobile application** that monitors soil health parameters like **Temperature** and **Moisture** using **Bluetooth devices (BLE & Classic)**.The data is stored in **Firebase Firestore**, cached locally in **SharedPreferences**, and visualized with **charts** to observe trends.

📌 Features
-----------

*   🔐 **Authentication** (Firebase Email/Password login & signup)
    
*   📲 **Bluetooth Integration**
    
    *   Scan for BLE devices
        
    *   Connect & Disconnect
        
    *   Fetch mock sensor readings (temperature & moisture)
        
*   ☁️ **Firebase Firestore Integration**
    
    *   Store readings per user
        
    *   Sync data across sessions
        
*   💾 **SharedPreferences**
    
    *   Local offline storage of readings
        
    *   Auto-clears on logout
        
*   📊 **Data Visualization**
    
    *   Latest Reading shown on Home
        
    *   Report screen (latest + history)
        
    *   History screen with line chart for trends
        
*   ⚡ **Provider State Management**
    
    *   Efficient & reactive UI updates
        
    *   Separation of concerns (Bluetooth & Reading providers)
        

🛠️ Tech Stack
--------------

*   **Framework:** Flutter
    
*   **Language:** Dart
    
*   **State Management:** Provider
    
*   **Backend:** Firebase Auth & Firestore
    
*   **Storage:** SharedPreferences
    
*   **Bluetooth:** flutter\_blue\_plus
    
*   **Charts:** fl\_chart

### 3️⃣ Setup Firebase

1.  Go to [Firebase Console](https://console.firebase.google.com/)
    
2.  Create a new project.
    
3.  Enable **Authentication → Email/Password**.
    
4.  Enable **Firestore Database** (start in test mode for dev).
    
5.  Add Android & iOS apps:
    
    *   Download google-services.json (Android → put in android/app/)
        
    *   Download GoogleService-Info.plist (iOS → put in ios/Runner/)
        
6.  Add Firebase plugins in pubspec.yaml (already included).
    

### 4️⃣ Configure Android for Bluetooth

In AndroidManifest.xml add permissions:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML

For Android 12+, request runtime permissions.

▶️ Running the App
------------------

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   flutter run   `

📱 App Flow
-----------

1.  **Login / Signup**
    
    *   User signs in using Firebase Auth.
        
2.  **HomeScreen**
    
    *   Connect to a Bluetooth device.
        
    *   Generate readings (Test button).
        
    *   Save to Firebase + SharedPreferences.
        
    *   View latest reading.
        
3.  **ReportScreen**
    
    *   Shows latest reading + button to history.
        
4.  **HistoryScreen**
    
    *   Displays all readings from local cache.
        
    *   Chart button opens **TrendsScreen** with a line graph.
        
5.  **Logout**
    
    *   Clears SharedPreferences.
        
    *   Logs user out of Firebase.
        

📊 Sample Chart (TrendsScreen)
------------------------------

*   **Red Line** → Temperature
    
*   **Blue Line** → Moisture
    

Shows how soil parameters change over time.

🚀 Future Improvements
----------------------

*   Integrate **real hardware sensor readings** via Bluetooth.
    
*   Add **push notifications** when soil health goes beyond threshold.
    
*   Export reports as **PDF/CSV**.
    
*   Cloud Functions for analytics.
    

👨‍💻 Author
------------

Developed by **Tanuj**