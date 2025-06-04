import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<bool> requestLocationPermission() async {
    try {
      final status = await Permission.location.request();
      return status.isGranted;
    } catch (e) {
      print('Error requesting location permission: $e');
      return false;
    }
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(
            'Location services are disabled. Please enable location services in your device settings.');
      }

      // Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception(
              'Location permission denied. Please grant location permission to use this feature.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied. Please enable them in app settings.');
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      print('Error getting location: $e');
      rethrow;
    }
  }

  Future<Map<String, String>> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Build address components
        String street = '';
        if (place.street != null && place.street!.isNotEmpty) {
          street = place.street!;
        }
        if (place.subThoroughfare != null &&
            place.subThoroughfare!.isNotEmpty) {
          street = '${place.subThoroughfare} $street'.trim();
        }

        String city = place.locality ?? place.subAdministrativeArea ?? '';
        String state = place.administrativeArea ?? '';
        String postalCode = place.postalCode ?? '';
        String country = place.country ?? '';

        // Create full address
        List<String> addressParts = [];
        if (street.isNotEmpty) addressParts.add(street);
        if (city.isNotEmpty) addressParts.add(city);
        if (state.isNotEmpty) addressParts.add(state);
        if (postalCode.isNotEmpty) addressParts.add(postalCode);

        return {
          'street': street,
          'city': city,
          'state': state,
          'postalCode': postalCode,
          'country': country,
          'fullAddress': addressParts.join(', '),
        };
      }

      throw Exception('No address found for the given coordinates');
    } catch (e) {
      print('Error getting address: $e');
      throw Exception('Unable to get address from location');
    }
  }

  Future<Map<String, String>?> getCurrentAddress() async {
    try {
      final position = await getCurrentLocation();
      if (position != null) {
        return await getAddressFromCoordinates(
            position.latitude, position.longitude);
      }
      return null;
    } catch (e) {
      print('Error getting current address: $e');
      rethrow;
    }
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
