// Login exceptions
class InvalidEmailAuthException implements Exception {

}
class InvalidCredentialAuthException implements Exception {

}
/* class WrongPasswordAuthException implements Exception {

}
class UserNotFoundAuthException implements Exception {

} */

// Register exceptions
class EmailAlreadyInUseAuthException implements Exception {

}
class WeakPasswordAuthException implements Exception {

}

// General exceptions
class UnknownAuthException implements Exception {

}
class UserNotLoggedInAuthException implements Exception {

}