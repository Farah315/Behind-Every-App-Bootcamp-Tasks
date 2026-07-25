/// Base class for all handled failures in the app.
/// Kept intentionally simple (no external packages) so the
/// presentation layer can display a friendly [message] regardless
/// of what went wrong under the hood.
abstract class Failure {
  const Failure(this.message);

  final String message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'R.I.P. our server is down']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'no internet connection']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'no one know whats going on']);
}
