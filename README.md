# Seedsaver-wallet
## Description
This is the companion app for Seedener Hardware Wallet Device, where you can create vaults and interact with the chia blockchain.

# User guide info
At the current moment you can import spend bundles via file upload and display them via QR Transfer loop in site the app. After scanning and signing with Seedener Hardware Device, you can scan signed spend bundles with Seedsaver Wallet app and share it to your computer where chia custody tool lives.

### Feature Highlights:
* Upload and Scan spend bundles
* Scan Pub keys

### Planned Upcoming Improvements / Functionality:
* Create vaults via app api
* Request status of vaults
* Rekey vaults
* Clawback spend
* Export vault configuration files
* Editable api for Chia full-node and custody backend

### Considerations:
* Add full chia wallet support
* CAT vault management
* other hardware device support

## Manual Installation
```
git clone https://github.com/MaximEdogawa/seedsaver_wallet.git
```

### Flutter Install
Follow these tutorials to install flutter for your platform [here](https://docs.flutter.dev/get-started/install)

### Android build
```
flutter pub get
```
```
flutter pub build apk
```
```
flutter run
```

### iOS build
Follow these steps to that you can register your iOS app with your Apple-ID [here](https://docs.flutter.dev/deployment/ios)
```
flutter pub get
```

Create app launch icons
```
flutter packages pub run flutter_launcher_icons:main
```
```
flutter pub build ipk
```
```
flutter run
```