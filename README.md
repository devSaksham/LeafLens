# LeafLens

A Flutter app that identifies plant leaf diseases from a photo, entirely on the phone, and tells you how to treat them. It works in English and Hindi.

**Download (Android, arm64):** [`app-arm64-v8a-release.apk`](build/app/outputs/flutter-apk/app-arm64-v8a-release.apk)

## Features

- **On-device diagnosis.** A TensorFlow Lite model (`assets/model/model.tflite`) classifies a camera or gallery photo into one of 38 PlantVillage classes (healthy or diseased leaves across 14 crops). The image never leaves the device.
- **Treatment plans.** For each disease: cause, severity (healthy, monitor, act soon or urgent), what to do now, organic and chemical options, and prevention. Plans are read from a Supabase table and fall back to the bundled `assets/treatments.json` when offline.
- **AI assistant.** A follow-up chat with Google Gemini that knows the diagnosis, your language and your location (via geolocator + reverse geocoding), so its advice fits the local conditions.
- **Scan history.** Past scans are saved on the device with their photos, and you can reopen or delete them.
- **Google sign-in** through Supabase Auth.
- **English and हिन्दी**, switchable in the app (Flutter `gen-l10n`, strings in `lib/l10n/*.arb`).

## Build it

Requires Flutter with Dart SDK 3.12+.

1. Create `lib/config/gemini_config.dart`. It is gitignored so API keys stay out of the repo:

   ```dart
   import 'dart:math';

   class GeminiConfig {
     static const String model = 'gemini-2.5-flash';
     static const List<String> _keys = ['YOUR_GEMINI_API_KEY'];
     static String get randomKey => _keys[Random().nextInt(_keys.length)];
   }
   ```

2. Install and run:

   ```bash
   flutter pub get
   flutter run
   ```

The app points at the project's Supabase instance by default. To use your own, pass `--dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...` and apply `supabase/migrations/0001_treatments.sql`, which creates the read-only `treatments` table and seeds it from `assets/treatments.json`.

## Layout

```
lib/
  main.dart                  app entry, Supabase init, routing
  auth/                      Google sign-in
  ml/                        TFLite classifier, diagnosis model, Gemini assistant
  screens/                   welcome, home, detect, treatment, assistant, session detail
  sessions/                  local scan history
  treatment/                 Supabase-first, JSON-fallback treatment lookup
  location/                  current place for the assistant
  l10n/                      English and Hindi strings
  theme/                     colours, spacing, typography, icons
assets/model/                model.tflite + labelmap.txt
assets/treatments.json       treatment data for every class
supabase/migrations/         treatments table + seed
design/                      design-system spec the UI follows
```

## License

MIT
