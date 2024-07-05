import 'package:notesapp/services/auth/auth_provider.dart';
import 'package:notesapp/services/auth/auth_user.dart';
import 'package:notesapp/services/auth/firebase_auth_provider.dart';

// AuthService implementa AuthProvider, lo que significa que debe proporcionar
// las implementaciones de todos los métodos definidos en AuthProvider.
class AuthService implements AuthProvider {
  // Una instancia de AuthProvider que se utilizará para delegar el trabajo.
  final AuthProvider authProvider;
 
  // Constructor constante que toma un AuthProvider y lo asigna al campo authProvider.
  // La palabra clave 'const' indica que este constructor puede ser utilizado
  // para crear constantes en tiempo de compilación.
  const AuthService(this.authProvider);

  // Constructor de fábrica que crea una instancia de AuthService utilizando
  // FirebaseAuthProvider. La palabra clave 'factory' se usa para definir un 
  // constructor de fábrica, que puede contener lógica adicional y no necesariamente
  // crea una nueva instancia de la clase cada vez que se invoca.
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  // Implementación del getter currentUser. Este método delega la llamada
  // al método currentUser del authProvider subyacente.
  @override
  AuthUser? get currentUser => authProvider.currentUser;

  // Implementación del método register. Este método delega la llamada al
  // método register del authProvider subyacente.
  @override
  Future<AuthUser?> register({
    required String email,
    required String password,
  }) async {
    return authProvider.register(email: email, password: password);
  }

  // Implementación del método login. Este método delega la llamada al
  // método login del authProvider subyacente.
  @override
  Future<AuthUser?> login({
    required String email,
    required String password,
  }) async {
    return authProvider.login(email: email, password: password);
  }

  // Implementación del método logOut. Este método delega la llamada al
  // método logOut del authProvider subyacente.
  @override
  Future<void> logOut() async {
    return authProvider.logOut();
  }

  // Implementación del método sendEmailVerification. Este método delega la
  // llamada al método sendEmailVerification del authProvider subyacente.
  @override
  Future<void> sendEmailVerification() async {
    return authProvider.sendEmailVerification();
  }

  // Implementación del método initialize. Este método delega la llamada al
  // método initialize del authProvider subyacente.
  @override
  Future<void> initialize() => authProvider.initialize();
}