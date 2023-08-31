import 'package:chat/config/logger.dart';
import 'package:chat/entities/user.dart';
import 'package:chat/providers/auth/auth_state.dart';
import 'package:chat/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_login/twitter_login.dart';

final authUserStreamProvider = StreamProvider.autoDispose<auth.User?>((ref) {
  return ref.watch(userRepositoryProvider).authUserStream();
});

final currentUserProvider = StreamProvider.autoDispose<User?>((ref) {
  return ref
      .watch(userRepositoryProvider)
      .stream(id: auth.FirebaseAuth.instance.currentUser!.uid);
});

final userInfoProvider = StreamProvider.autoDispose.family<User?, String>(
  (ref, id) => ref.watch(userRepositoryProvider).stream(id: id),
);

final authStateNotifierProvider =
    StateNotifierProvider.autoDispose<AuthStateNotifier, AuthState>(
  (ref) {
    final userRepository = ref.watch(userRepositoryProvider);
    return AuthStateNotifier(userRepository);
  },
);

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(this._repository) : super(const AuthState());

  final BaseUserRepository _repository;
  final userAuth = auth.FirebaseAuth.instance;

  Future<void> signUp(String email, String password, String userName) async {
    try {
      final user = await userAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await user.user?.updateDisplayName(userName);
      await user.user?.sendEmailVerification();
      await signOut();
    } on Exception catch (e) {
      logger.e('⚡ ERROR: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final user = await userAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!user.user!.emailVerified) {
        await signOut();
        throw auth.FirebaseException(
          plugin: 'firebase_auth',
          code: 'not_verify_email',
          message: 'Please verify your email first and try again',
        );
      }
    } on Exception catch (e) {
      logger.e('⚡ ERROR: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> googleSignIn() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credential = auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await userAuth.signInWithCredential(credential);
      } else {
        throw auth.FirebaseException(
          plugin: 'firebase_auth',
          code: 'select_one',
        );
      }
    } on auth.FirebaseAuthException catch (e) {
      logger.e('⚡ ERROR: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> facebookSignIn() async {
    try {
      final fbAuth = await FacebookAuth.instance.login();
      if (fbAuth.status == LoginStatus.success) {
        final facebookAuthCredential =
            auth.FacebookAuthProvider.credential(fbAuth.accessToken!.token);
        await userAuth.signInWithCredential(facebookAuthCredential);
      } else {
        throw auth.FirebaseException(
          plugin: 'firebase_auth',
          code: 'select_one',
        );
      }
    } on auth.FirebaseAuthException catch (e) {
      logger.e('⚡ ERROR: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> twitterSignIn() async {
    try {
      final twitterLogin = TwitterLogin(
        apiKey: 'KWxmToHkZis4iyLIOWA8IYLFn',
        apiSecretKey: 'xjpupwYNecgRBdQRCjJLq3ofDAcCOfMdTBEyBFwnq79ncftXSR',
        redirectURI: 'mtmchat-twitter-login://',
      );
      final twitterAuth = await twitterLogin.login();
      if (twitterAuth.status == TwitterLoginStatus.loggedIn) {
        final twitterAuthCredential = auth.TwitterAuthProvider.credential(
          accessToken: twitterAuth.authToken!,
          secret: twitterAuth.authTokenSecret!,
        );
        await userAuth.signInWithCredential(twitterAuthCredential);
      } else {
        throw auth.FirebaseException(
          plugin: 'firebase_auth',
          code: 'select_one',
        );
      }
    } on auth.FirebaseAuthException catch (e) {
      logger.e('⚡ ERROR: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> addUser({
    required auth.User authUser,
  }) async {
    final user = await _repository.fetch(id: authUser.uid);
    if (user == null) {
      await _repository.create(
        user: authUser,
      );
    }
  }

  Future<void> updateProfile({
    required User user,
  }) async {
    userAuth.currentUser!.updateDisplayName(user.name);
    await _repository.update(
      user: user,
    );
  }

  Future<bool> checkPassword({required String currentPassword}) async {
    final currentUser = userAuth.currentUser;
    if (currentUser!.providerData.first.providerId == 'password') {
      try {
        final user = await currentUser
            .reauthenticateWithCredential(auth.EmailAuthProvider.credential(
          email: userAuth.currentUser!.email!,
          password: currentPassword,
        ));
        return user.user != null;
      } on auth.FirebaseAuthException {
        return false;
      }
    }
    return false;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await checkPassword(currentPassword: currentPassword)
        ? await userAuth.currentUser!.updatePassword(newPassword)
        : null;
  }

  Future<String> updateProfilePhoto(
      {required userId, required Uint8List imageBytes}) async {
    return await _repository.uploadProfileImage(
        userId: userId, imageBytes: imageBytes);
  }

  Future<void> forgotPassword(String email) async {
    try {
      await auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on auth.FirebaseAuthException catch (e) {
      logger.e('⚡ ERROR: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (userAuth.currentUser!.providerData.first.providerId
        .contains('facebook')) {
      await FacebookAuth.instance.logOut();
    } else if (userAuth.currentUser!.providerData.first.providerId
        .contains('google')) {
      await GoogleSignIn().signOut();
    }
    await userAuth.signOut();
    logger.i('User : ${userAuth.currentUser}');
  }
}
