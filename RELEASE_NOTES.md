# Release Notes - Sirsak Pop Nasabah

## v1.0.1+13 - RVM QR Scan & Guest Mode

**Release Date**: February 2026
**Build Version**: 1.0.1+13

---
### New Features

#### RVM QR Code Scanning
- Scan QR codes at RVM (Reverse Vending Machine) locations
- New dedicated RVM scan UI with improved user experience
- Secure encrypted payload handling for RVM transactions

#### Guest Mode
- Browse the app without creating an account
- View home content and explore collection points as a guest
- Landing page and profile sections now accessible without authentication
- Easy sign-up prompts when guest users want to access full features

### Improvements

#### Collection Points Map
- Resizable map view when searching for collection points, providing more space for the list
- New "Center to user location" button for quick navigation
- Waste items now grouped by category for better organization

#### UI Enhancements
- Updated bottom sheet design
- Improved denied permission UI
- Various visual refinements throughout the app

### Bug Fixes
- Fixed QR scan opening issue
- Sentry error reporting now only active in production builds
- Updated collection point API to use x-api-key header
- Fixed collection points not loading in guest mode
- Updated QR scan text for better clarity

---

## v0.1.5+10 - Initial Release

**Release Date**: February 2026
**Build Version**: 0.1.5+10

---

### What is Sirsak Pop Nasabah?

Turn your waste into rewards while making a real environmental impact. Sirsak Pop Nasabah connects you to Indonesia's waste value chain network, allowing you to:

- Find nearby Bank Sampah and RVM (Reverse Vending Machine) locations
- Drop off recyclable waste and earn Sirsak Points
- Track your environmental impact and contributions

---

### Key Features

#### Authentication & Account
- Secure login with email and password
- Multi-step registration with optional QR code scan for Bank Sampah linkage
- Password recovery via email
- Email verification for new accounts

#### Home Dashboard
- View your Sirsak Points balance at a glance
- Track environmental impact metrics (waste collected, recycled, carbon footprint reduced)
- See available challenges and badges to earn
- Discover upcoming events in your area

#### Wallet & Transactions
- Dual wallet system: Sirsak Points and Bank Sampah Balance
- Complete transaction history with detailed breakdown
- Monthly earnings tracking
- Filter transactions by type (Points vs Bank Sampah)

#### Collection Points Discovery
- GPS-powered search for nearby Bank Sampah and RVM locations
- Interactive map with collection point markers
- List view with distance calculation
- Search and filter by name or type
- View stock availability at each location (plastic bottles, aluminum cans, etc.)
- Access directions via map integration

#### QR Code Scanning
- Scan QR codes at collection points
- Secure encrypted data handling
- Register with Bank Sampah via QR scan
- Deeplink support for seamless integration

#### User Profile
- View and edit personal information
- Change password securely
- Track your environmental achievements and badges
- Delete account option with confirmation
- Quick access to support contacts (WhatsApp, Email, Instagram)
- FAQ access

#### Localization
- Available in English and Bahasa Indonesia
- Switch languages anytime from settings

---

### Technical Highlights

- Built with Flutter 3.29.0
- Riverpod MVVM architecture for robust state management
- Secure token-based authentication
- Real-time GPS location services
- AES-256 encryption for QR code payloads
- Sentry integration for crash reporting

---

### Supported Platforms

- iOS 12.0+
- Android 5.0+ (API level 21)

---

### Known Limitations

- Map requires active internet connection
- Some features require location permissions to function

---

### Coming Soon

- More detailed impact analytics
- Community features and social sharing
- Reward redemption marketplace

---

### Feedback & Support

- **WhatsApp**: Contact via in-app profile section
- **Email**: Available via in-app contact
- **Instagram**: Follow us for updates
