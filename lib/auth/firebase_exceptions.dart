import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  doNotMatch,
  invalidCode,
  expiredCode,
  userNotFound,
  userDisabled,
  userTokenExpired,
  invalidUserToken,
  invalidCredential,
  accountExistsWithDifferentCredential,
  credentialAlreadyInUse,
  invalidCustomToken,
  customTokenMismatch,
  tooManyRequests,
  operationNotAllowed,
  unknown,
}

class AuthExceptionHandler {
  static AuthStatus handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "password-do-not-match":
        status = AuthStatus.doNotMatch;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      case "invalid-action-code":
        status = AuthStatus.invalidCode;
        break;
      case "expired-action-code":
        status = AuthStatus.expiredCode;
        break;
      case "user-not-found":
        status = AuthStatus.userNotFound;
        break;
      case "user-disabled":
        status = AuthStatus.userDisabled;
        break;
      case "user-token-expired":
        status = AuthStatus.userTokenExpired;
        break;
      case "invalid-user-token":
        status = AuthStatus.invalidUserToken;
        break;
      case "invalid-credential":
        status = AuthStatus.invalidCredential;
        break;
      case "account-exists-with-different-credential":
        status = AuthStatus.accountExistsWithDifferentCredential;
        break;
      case "credential-already-in-use":
        status = AuthStatus.credentialAlreadyInUse;
        break;
      case "invalid-custom-token":
        status = AuthStatus.invalidCustomToken;
        break;
      case "custom-token-mismatch":
        status = AuthStatus.customTokenMismatch;
        break;
      case "too-many-requests":
        status = AuthStatus.tooManyRequests;
        break;
      case "operation-not-allowed":
        status = AuthStatus.operationNotAllowed;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(AuthStatus? error) {
    switch (error) {
      case AuthStatus.invalidEmail:
        return "Your email address appears to be malformed.";
      case AuthStatus.weakPassword:
        return "Your password should be at least 6 characters.";
      case AuthStatus.wrongPassword:
        return "Your email or password is incorrect.";
      case AuthStatus.doNotMatch:
        return "Confirm password does not match with the password.";
      case AuthStatus.emailAlreadyExists:
        return "The email address is already in use by another account.";
      case AuthStatus.expiredCode:
        return "The OTP code has expired.";
      case AuthStatus.invalidCode:
        return "The OTP code is invalid.";
      case AuthStatus.userNotFound:
        return "This email is not registered.";
      case AuthStatus.userDisabled:
        return "This account has been disabled by the administrator.";
      case AuthStatus.userTokenExpired:
        return "Your session has expired. Please log in again.";
      case AuthStatus.invalidUserToken:
        return "The user's token is invalid.";
      case AuthStatus.invalidCredential:
        return "The provided credentials are invalid or have expired.";
      case AuthStatus.accountExistsWithDifferentCredential:
        return "An account already exists with the same email but different sign-in credentials.";
      case AuthStatus.credentialAlreadyInUse:
        return "This credential is already associated with another account.";
      case AuthStatus.invalidCustomToken:
        return "The custom token format is incorrect. Please check the documentation.";
      case AuthStatus.customTokenMismatch:
        return "The custom token does not match the project's configuration.";
      case AuthStatus.tooManyRequests:
        return "You have made too many requests in a short period. Please try again later.";
      case AuthStatus.operationNotAllowed:
        return "This operation is not allowed. Please contact support.";
      default:
        return "An unknown error occurred. Please try again later.";
    }
  }
}
