import 'package:comma_api/src/models/models.dart';

/// {@template comma_api}
/// The API interface to handle Commas
/// {@endtemplate}
abstract class CommaApi {
  /// {@macro comma_api}

  /// Provides a [Stream] of all todos.
  Stream<List<Comma>> getCommas();

  /// Fetchs a List of Commas based on pagination and userId.
  ///
  /// The pagination and userId params will be used in other API Impl.
  ///
  Future<void> fetchCommas(
    int offset,
    int resultsForPage,
    String userId,
  );

  /// Favorites a commad by id and user
  Future<void> favorite(String userId, Comma comma);

  /// Unfavorites a commad by id and user
  Future<void> desfavorite(String userId, Comma comma);
}
