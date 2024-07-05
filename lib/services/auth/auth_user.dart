import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);

  Future<void> reload() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload(); 
    }
  }

  factory AuthUser.fromFirebase(User? user) {
    return AuthUser(user?.emailVerified ?? false);
  }
}