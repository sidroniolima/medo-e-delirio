import 'package:comma_api/comma_api.dart';

class AudioRepository {
  final CommaApi _commaApi;

  AudioRepository({required CommaApi commaApi}) : _commaApi = commaApi;

  Stream<List<Comma>> getAudios() => _commaApi.getCommas();

  Future<void> fetchCommas(
      int offset, int resultsForPage, String userId) async {
    await _commaApi.fetchCommas(0, 0, userId);
  }

  Future<void> toggleFavorite(String userId, Comma comma) async {
    if (comma.favorite) {
      await this.desfavorite(userId, comma);
    } else {
      await this.favorite(userId, comma);
    }
  }

  Future<void> favorite(String userId, Comma comma) async {
    await _commaApi.favorite(userId, comma);
  }

  Future<void> desfavorite(String userId, Comma comma) async {
    await _commaApi.desfavorite(userId, comma);
  }
}
