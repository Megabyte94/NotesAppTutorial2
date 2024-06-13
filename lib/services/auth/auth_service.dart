import 'package:notes/services/auth/auth_provider.dart';
import 'package:notes/services/auth/auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser?> register({
    required String email,
    required String password,
  }) async {
    return provider.register(email: email, password: password);
  }

  @override
  Future<AuthUser?> login({
    required String email,
    required String password,
  }) async {
    return provider.login(email: email, password: password);
  }

  @override
  Future<void> logOut() async {
    return provider.logOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    return provider.sendEmailVerification();
  }
}
