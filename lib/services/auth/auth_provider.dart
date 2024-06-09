import 'package:notes/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser?> register({
    required String email,
    required String password
  });
  Future<AuthUser?> login({
    required String email,
    required String password
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
}