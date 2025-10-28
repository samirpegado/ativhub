// lib/domain/auth/auth_repository.dart
import 'package:flutter/material.dart';

import '../../utils/result.dart';

abstract class AuthRepository extends ChangeNotifier {
  Future<Result<void>> login({required String email, required String password});
  Future<Result<void>> logout();
  Future<bool> get isAuthenticated;
}
