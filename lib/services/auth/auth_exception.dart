//login exception
class UserNotFoundAuthException implements Exception{}
class WrongPasswordAuthException implements Exception{}
class InvalidCredentialAuthException implements Exception{}
class UserDisabledAuthException implements Exception{}

//register exception
class WeakPasswordAuthException implements Exception{}
class EmailAlreadyInUseException implements Exception{}
class InvalidPasswordException implements Exception{}
class InvalidEmailAuthException implements Exception{}

//Generic exception
class GenericAuthException implements Exception{}
class UserNotLoggedInAuthException implements Exception{}