# SensGrid IoT Controller

A Flutter mobile application for connecting to ESP32 devices and accessing the SensGrid IoT platform. Features dark/light theme switching and dual-mode web navigation.

![Flutter](https://img.shields.io/badge/Flutter-3.13+-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Android-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## 🌟 Features

- **ESP32 Device Control**: Connect to local ESP32 devices via WiFi hotspot
- **Dual Theme System**: Switch between light and dark modes
- **Web Navigation**: Quick access to SensGrid platform + custom websites
- **IP Management**: Change device IP addresses with validation
- **Professional UI**: Material Design with SensGrid branding
- **Offline Capable**: Works without internet for local devices

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.13.0 or higher
- Android Studio / VS Code
- Android device or emulator

### Installation

1. **Clone the repository**
   
   ```bash
   git clone https://github.com/nipulsandeepa/sensgrid-mobile-app.git
   cd sensgrid-mobile-app

3. **Install dependencies**
   
   ```bash
   flutter pub get
   

4. **Run the App on an Android Device**

  ⚠️ **Important:**  
  
   `WebView` does **not work properly** in browser emulators (Chrome/Edge).  
   Use a **real Android device** for testing.

  ---

  ### 🔧 Setting Up Your Android Device

  #### a. Enable Developer Options
   1. Open **Settings → About Phone**  
   2. Tap **Build Number** **7 times** until you see  
      *"You are now a developer!"*

  ---

  #### b. Enable USB Debugging
   1. Go to **Settings → Developer Options**  
   2. Enable **USB Debugging**  
   3. Also enable **Install via USB**

  ---

  #### c. Connect Your Device
   1. Connect your Android phone to your computer using a **USB cable**  
   2. When prompted, **allow USB debugging** on your phone  

  ---

  #### d. Check Device Detection
  Run the following command to confirm your device is detected:

    flutter devices

5. **Building APK**
   
   ```bash
   flutter build apk --release
   
The APK will be generated at: build/app/outputs/flutter-apk/app-release.apk

# 🔧 Usage Guide

## 🚀 Connecting to ESP32 Devices
1. **Power on** your ESP32 device (it should create a WiFi hotspot).  
2. **Connect your phone** to the ESP32 WiFi network.  
3. **Turn off mobile data** *(critical for local connections)*.  
4. **Open the app** – it will automatically load the ESP32 interface.  

---

## 🌐 Changing Device IP
1. Tap the **settings icon (⚙️)** in the app bar.  
2. Enter the new IP address (format: `XXX.XXX.XXX.XXX`).  
3. Tap **Save** to reconnect.  

---

## 🧭 Using Website Navigation
1. Tap the **globe icon (🌐)** in the app bar.  
2. Choose one of the following options:  
   - 🌍 **SensGrid Website** – Direct access to the SensGrid platform  
   - 🧩 **Custom Website** – Enter any website URL  

---

## 🎨 Theme Switching
- Tap the **theme icon (☀️ / 🌙)** to switch between light and dark modes.  
- Theme preference is **saved automatically** for next use.  

---

💡 *Tip:* For best performance, ensure your ESP32 is powered properly and that your phone remains connected to the ESP32 WiFi network while using the app.---

# 📋 Troubleshooting

> Common issues and quick fixes to keep your app running smoothly.

---

### ❌ **App can't connect to ESP32**
🛠 **Possible Solutions**
- ✅ Ensure you're connected to **ESP32 WiFi**  
- 📴 Turn off **mobile data**  
- ⚡ Verify **ESP32 is powered on**  
- 🌐 Check IP address is correct *(default: `192.168.4.1`)*  

---

### ❌ **Website not loading**
🌍 **Try the following:**
- 📶 Check **internet connection**  
- 🔗 Verify URL starts with **`http://`** or **`https://`**  
- ⏳ Wait a few seconds — some sites may take longer to load  

---

### ❌ **Build errors**
💡 **Fix build-related issues**
1. Run the following commands:
   ```bash
   flutter clean && flutter pub get

- Ensure Flutter SDK is up to date
- Verify your Android SDK installation

## 📄 License

This project is licensed under the MIT License – see the LICENSE
 file for details.

## 🙏 Acknowledgments

# Special thanks to the following:

- 💼 SLT Digital Labs – for the internship opportunity
- 🧩 Flutter Team – for the excellent framework
- ⚙️ ESP32 Community – for IoT device support


