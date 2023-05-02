class CustomFirebaseMessagingException implements Exception {
  final String message;

  CustomFirebaseMessagingException(this.message);
}