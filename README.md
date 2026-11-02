# Process Navigator

**Right documents, right office, right fee, every time.**

Process Navigator is a Flutter app that gives step-by-step guides for official processes in Pakistan, such as getting a CNIC, renewing a passport, transferring a vehicle or applying for a police character certificate. For each process it shows what to bring, where to go, what it costs and how to submit, and it estimates what it will cost you to travel to the office.

Everything works on your device. Your personal details are never uploaded.

---

## Screenshots

<table>
  <tr>
    <td align="center"><img src="screenshots/home_screen.png" width="220" alt="Home screen"><br><sub><b>Home</b><br>Search, categories and saved details prompt</sub></td>
    <td align="center"><img src="screenshots/popular_guides.png" width="220" alt="Popular guides"><br><sub><b>Popular guides</b><br>Quick access to the most used processes</sub></td>
    <td align="center"><img src="screenshots/details_screen.png" width="220" alt="Category guides"><br><sub><b>Category guides</b><br>All processes in a category</sub></td>
    <td align="center"><img src="screenshots/process_screen.png" width="220" alt="Process documents checklist"><br><sub><b>Documents checklist</b><br>Tick off what you have, with progress</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/cost.png" width="220" alt="Office and travel cost"><br><sub><b>Office and travel cost</b><br>Pick a vehicle, enter the distance, see the cost</sub></td>
    <td align="center"><img src="screenshots/profile_screen.png" width="220" alt="Saved details"><br><sub><b>Saved details</b><br>Private, stored only on your device</sub></td>
    <td align="center"><img src="screenshots/settings_screen.png" width="220" alt="Settings"><br><sub><b>Settings</b><br>Theme and language</sub></td>
    <td></td>
  </tr>
</table>

---

## Features

### Guides
- **38 guides in 8 categories:** Identity Documents, Passport and Travel, Vehicles and Driving, Property, Certificates, Business and Tax, NOCs and Licenses, Education Attestation.
- **Search** across all guides from the home screen.
- **Popular guides** shortcut list.
- **Verified sources:** every guide shows the source and the date it was verified, with a **Report** button to flag wrong or outdated information.

### Inside every guide
| Tab | What you get |
|---|---|
| **Documents** | Checklist of required documents and copies, with a progress bar. Your ticks are saved on the device. |
| **Office** | Office name, address and timings, directions in Google Maps and the travel cost estimator. |
| **Fee** | Official fees for the process. |
| **Submit** | How and where to submit your application. |
| **Next** | What happens after you apply. |

### Travel cost estimator
- Choose **Bike, Car, Rickshaw or Bus**.
- Type the distance in km and the cost updates automatically.
- Shows one-way and round-trip cost, with fuel used for bike and car.
- For offices with a verified address, **Use my location** fills in the road distance for you.
- Petrol price, fuel efficiency and fares can be changed in **Edit fuel and fare rates**.
- Always shown as an estimate, because fuel prices, traffic and fares change.

### Saved details
- Name, father name, city, phone, CNIC, vehicle type, license and passport expiry.
- **Use my current location** fills in your city.
- Saved details are encrypted on the device and never uploaded. Every field is optional.
- Edit or erase everything at any time.

### Settings
- **Appearance:** System, Light or Dark.
- **Language:** English or Urdu, with right-to-left layout.

---

## Tech stack

| Area | Choice |
|---|---|
| Framework | Flutter (Dart `>=3.3.0 <4.0.0`) |
| State management | Provider |
| Local storage | Hive (`hive`, `hive_flutter`), AES-encrypted profile box |
| Key storage | `flutter_secure_storage` (holds the encryption key) |
| Location | `geolocator` |
| Distance and geocoding | OSRM (road distance) and Nominatim (address lookup) over `http` |
| Directions | `url_launcher` opens Google Maps |
| Localization | `flutter_localizations`, `intl`, English and Urdu |

---

## Project structure

```
lib/
├── main.dart                 App start-up: Hive, encryption key, providers
├── app.dart                  MaterialApp, themes, locale
├── core/
│   ├── constants/            App constants and storage keys
│   ├── localization/         English and Urdu strings
│   ├── theme/                Colours, palette, text styles, spacing, ThemeData
│   ├── utils/                Money formatting, responsive helpers
│   └── widgets/              Reusable widgets (cards, buttons, selectors)
├── data/
│   ├── datasources/          Bundled guide content, by category
│   ├── models/               Process, office, fee, profile, settings models
│   ├── repositories/         Hive-backed storage and process data access
│   └── services/             Location and routing services
├── domain/
│   └── trip_cost_calculator.dart   Cost formulas for each vehicle
├── providers/                Process, profile, checklist, trip, theme, locale
└── presentation/
    ├── splash/  home/  process_list/  process_detail/
    └── profile/  settings/  report/
```

The app follows a simple layered structure: **presentation** (screens and widgets), **providers** (state), **domain** (business rules), **data** (repositories, models, services).

---

## Getting started

### Prerequisites
- Flutter SDK with Dart 3.3 or newer
- Android Studio or VS Code with the Flutter plugin
- An Android emulator or device

### Run

```bash
git clone https://github.com/shaukatdj07/process_navigator.git
cd process_navigator
flutter pub get
flutter run
```

### Build a release APK

```bash
flutter build apk --release
```

The APK is created at `build/app/outputs/flutter-apk/app-release.apk`.

### Launcher icon

Icon settings are in `pubspec.yaml` under `flutter_launcher_icons`. To regenerate the icons:

```bash
dart run flutter_launcher_icons
```

### Android permissions

`android/app/src/main/AndroidManifest.xml` needs:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

and this inside `<queries>` so directions can open:

```xml
<intent>
    <action android:name="android.intent.action.VIEW"/>
    <data android:scheme="https"/>
</intent>
```

---

## Privacy

- Saved details stay on your device. Nothing is sent to a server.
- The profile is stored in an AES-encrypted Hive box. The key is kept in the Android Keystore through `flutter_secure_storage`.
- Location is requested only when you tap **Use my location** or **Use my current location**.
- Internet is used only for road distance, address lookup and opening directions.

---

## Notes and limitations

- Guide content is bundled in the app and is meant as guidance. **Always confirm fees, documents and timings with the office**, because rules change.
- Verified office addresses are available only for some cities. For other cities the app tells you to confirm the nearest branch locally.
- Distance lookup relies on free public services (OSRM and Nominatim). They are fine for light use but can be slow or unavailable.
- Travel costs are estimates, not exact fares.

---

## Roadmap

- More verified office addresses across Pakistan
- More guides and categories
- Optional Google Maps routing for exact road distance
- Reminders for license and passport expiry

---

## Contributing

Found wrong or outdated information? Use the **Report** button inside a guide, or open an issue. Pull requests are welcome.

---

## Author

**Shaukat Ullah**, Flutter developer
GitHub: [@shaukatdj07/](https://github.com/shaukatdj07)

---

## License


