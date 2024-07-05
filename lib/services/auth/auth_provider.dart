import 'package:notesapp/services/auth/auth_user.dart';

// La interfaz AuthProvider establece los métodos que deben ser implementados
// por cualquier clase que se use como proveedor de autenticación.
abstract class AuthProvider {
  // Método para inicializar el proveedor de autenticación
  Future<void> initialize(); 

  // Método para obtener el usuario actualmente autenticado
  AuthUser? get currentUser;

  // Método para registrar un nuevo usuario
  Future<AuthUser?> register({
    required String email,
    required String password,
  });

  // Método para iniciar sesión con un usuario existente
  Future<AuthUser?> login({
    required String email,
    required String password,
  });

  // Método para cerrar la sesión del usuario actual
  Future<void> logOut();

  // Método para enviar un correo de verificación al usuario
  Future<void> sendEmailVerification();
}