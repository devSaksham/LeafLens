import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  String? _cachedPlace;

  /// Returns a human-readable place (e.g. "Pune, Maharashtra, India") or null
  /// if permission is denied or location is unavailable. Requests permission
  /// on first call and caches the result.
  Future<String?> currentPlace() async {
    if (_cachedPlace != null) return _cachedPlace;
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      );

      final List<Placemark> marks = await Geocoding()
          .placemarkFromCoordinates(position.latitude, position.longitude);
      if (marks.isNotEmpty) {
        final Placemark p = marks.first;
        final parts = [p.locality, p.administrativeArea, p.country]
            .where((s) => s != null && s.isNotEmpty)
            .toList();
        _cachedPlace = parts.isEmpty ? null : parts.join(', ');
      }
      _cachedPlace ??=
          '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
      return _cachedPlace;
    } catch (_) {
      return null;
    }
  }

  /// Fire-and-forget permission prompt so the dialog appears early.
  Future<void> requestPermission() => currentPlace();
}
