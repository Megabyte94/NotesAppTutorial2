import 'package:firebase_core/firebase_core.dart';
import 'package:notesapp/firebase_options.dart';
import 'package:notesapp/services/auth/auth_provider.dart';
import 'package:notesapp/services/auth/auth_user.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;

// FirebaseAuthProvider implementa AuthProvider, lo que significa que debe
// proporcionar las implementaciones de todos los métodos definidos en AuthProvider.
class FirebaseAuthProvider implements AuthProvider {
  @override
  AuthUser? get currentUser {
    // Obtiene el usuario actual de Firebase
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Si hay un usuario autenticado, lo convierte a AuthUser
      return AuthUser.fromFirebase(user);
    } else {
      // Si no hay un usuario autenticado, devuelve null
      return null;
    }
  }

  @override
  Future<AuthUser?> register({required String email, required String password}) async {
    try {
      // Intenta registrar un nuevo usuario con Firebase
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        // Si el registro es exitoso, devuelve el usuario autenticado
        return user;
      } else {
        // Si el usuario no está autenticado, lanza una excepción
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      // Maneja las excepciones específicas de Firebase
      switch (e.code) {
        case 'email-already-in-use':
          throw EmailAlreadyInUseAuthException();
        case 'weak-password':
          throw WeakPasswordAuthException();
        case 'invalid-email':
          throw InvalidEmailAuthException();
        default:
          throw UnknownAuthException();
      }
    } catch (e) {
      // Maneja cualquier otra excepción desconocida
      throw UnknownAuthException();
    }
  }

  @override
  Future<AuthUser?> login({required String email, required String password}) async {
    try {
      // Intenta iniciar sesión con Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        // Si el inicio de sesión es exitoso, devuelve el usuario autenticado
        return user;
      } else {
        // Si el usuario no está autenticado, lanza una excepción
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      // Maneja las excepciones específicas de Firebase
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'invalid-credential':
          throw WrongPasswordAuthException();
        case 'user-not-found':
          throw UserNotFoundAuthException();
        case 'wrong-password':
          throw WrongPasswordAuthException();
        default:
          throw UnknownAuthException();
      }
    } catch (e) {
      // Maneja cualquier otra excepción desconocida
      throw UnknownAuthException(); 
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Si hay un usuario autenticado, cierra la sesión
      await FirebaseAuth.instance.signOut();
    } else {
      // Si no hay un usuario autenticado, lanza una excepción
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Si hay un usuario autenticado, envía un correo de verificación
      await user.sendEmailVerification();
    } else {
      // Si no hay un usuario autenticado, lanza una excepción
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    // Inicializa Firebase con las opciones predeterminadas
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
