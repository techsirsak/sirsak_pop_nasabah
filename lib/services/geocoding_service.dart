import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

part 'geocoding_service.g.dart';

@riverpod
GeocodingService geocodingService(Ref ref) => GeocodingService(
  logger: ref.read(loggerServiceProvider),
);

/// Service for geocoding addresses to coordinates using OpenStreetMap Nominatim
class GeocodingService {
  GeocodingService({required LoggerService logger}) : _logger = logger;

  final LoggerService _logger;
  final Dio _dio = Dio();

  /// Convert address string to coordinates using OpenStreetMap Nominatim API.
  ///
  /// Uses the free Nominatim geocoding service to convert a human-readable
  /// address into geographic coordinates (latitude/longitude).
  ///
  /// **API Details:**
  /// - Endpoint: `https://nominatim.openstreetmap.org/search`
  /// - Rate limit: 1 request/second (respect Nominatim usage policy)
  /// - Automatically appends ", Indonesia" to improve accuracy
  ///
  /// **Parameters:**
  /// - [address]: The address string to geocode
  ///   (e.g., "CIBINONG", "KABUPATEN BOGOR")
  ///
  /// **Returns:**
  /// - A record `({double lat, double lng})` if geocoding succeeds
  /// - `null` if:
  ///   - No results found for the address
  ///   - Network error occurs
  ///   - API returns invalid data
  ///
  /// **Example:**
  /// ```dart
  /// final coords = await geocodingService.getCoordinatesFromAddress(
  ///   'CIBINONG',
  /// );
  /// if (coords != null) {
  ///   print('Lat: ${coords.lat}, Lng: ${coords.lng}');
  /// }
  /// ```
  Future<({double lat, double lng})?> getCoordinatesFromAddress(
    String address,
  ) async {
    try {
      // Append "Indonesia" to improve results for Indonesian addresses
      final searchQuery = '$address, Indonesia';
      _logger.info('GeocodingService: Searching for "$searchQuery"');

      final response = await _dio.get<List<dynamic>>(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': searchQuery,
          'format': 'json',
          'limit': 1,
        },
        options: Options(
          headers: {
            'User-Agent': 'SirsakPopNasabah/1.0',
          },
        ),
      );

      if (response.data != null && response.data!.isNotEmpty) {
        final result = response.data![0] as Map<String, dynamic>;
        final lat = double.tryParse(result['lat'].toString());
        final lng = double.tryParse(result['lon'].toString());

        if (lat != null && lng != null) {
          _logger.info('GeocodingService: Found lat=$lat, lng=$lng');
          return (lat: lat, lng: lng);
        }
      }

      _logger.warning('GeocodingService: No results found for "$searchQuery"');
    } catch (e) {
      _logger.warning('GeocodingService: Error geocoding "$address": $e');
    }
    return null;
  }
}
