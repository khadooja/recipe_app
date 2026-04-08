import 'package:uuid/uuid.dart';

/// Thin wrapper around the `uuid` package.
///
/// Using a wrapper means we can swap the ID strategy later
/// (e.g. server-generated IDs) without touching model code.
class IdGenerator {
  static const Uuid _uuid = Uuid();

  /// Generate a new v4 (random) UUID string.
  static String generate() => _uuid.v4();
}
