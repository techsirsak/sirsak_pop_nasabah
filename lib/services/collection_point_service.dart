import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_stock_model.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_points_response.dart';
import 'package:sirsak_pop_nasabah/services/api/dio_client.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

part 'collection_point_service.g.dart';

@riverpod
CollectionPointService collectionPointService(Ref ref) {
  return CollectionPointService(
    ref.read(apiClientProvider),
    ref.read(loggerServiceProvider),
  );
}

class CollectionPointService {
  CollectionPointService(this._apiClient, this._logger);

  final ApiClient _apiClient;
  final LoggerService _logger;

  /// Fetch collection points from /nasabah/collection-points
  ///
  /// [limit] - Maximum number of collection points to fetch (default: 500)
  Future<CollectionPointsResponse> getCollectionPoints({
    int limit = 500,
  }) async {
    _logger.info('[CollectionPointService] Fetching collection points');

    final response = await _apiClient.get(
      path: '/nasabah/collection-points',
      queryParameters: {'limit': limit},
      fromJson: CollectionPointsResponse.fromJson,
    );

    _logger.info(
      '[CollectionPointService] Fetched ${response.data.length} '
      'of ${response.total} points',
    );
    return response;
  }

  /// Fetches stock items for a specific BSU (collection point)
  Future<List<CollectionPointStockModel>> getCollectionPointStock({
    required String bsuId,
  }) async {
    _logger.info('[CollectionPointService] Fetching stock for BSU: $bsuId');

    final response = await _apiClient.getList(
      path: '/nasabah/collection-points/stock/$bsuId',
      fromJson: CollectionPointStockModel.fromJson,
    );

    _logger.info(
      '[CollectionPointService] Fetched ${response.length} stock items',
    );
    return response;
  }
}
