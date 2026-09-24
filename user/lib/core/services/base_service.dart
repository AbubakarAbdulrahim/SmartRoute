import 'dart:async';
import 'package:flutter/foundation.dart';
import '../error/app_exception.dart';

abstract class BaseService {
  @protected
  Future<T> handleError<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('Service Error: $e');
      throw handleFirebaseError(e);
    }
  }

  @protected
  Stream<T> handleStreamError<T>(Stream<T> stream) {
    return stream.handleError((error) {
      debugPrint('Stream Error: $error');
      throw handleFirebaseError(error);
    });
  }
}
