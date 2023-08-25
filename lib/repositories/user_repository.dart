import 'package:chat/constants/url.dart';
import 'package:chat/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userRepositoryProvider = Provider.autoDispose<UserRepositoryImpl>(
  (ref) => UserRepositoryImpl(),
);

abstract class BaseUserRepository {
  Stream<auth.User?> authUserStream();
  Future<void> create({
    required auth.User user,
  });
  Future<void> update({
    required User user,
  });
  Future<User?> fetch({required String id});

  Stream<List<User>> fetchAllUsers();

  Stream<User?> stream({required String id});

  Future<String> uploadProfileImage(
      {required userId, required Uint8List imageBytes});
}

class UserRepositoryImpl implements BaseUserRepository {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  final usersCol = 'users';

  @override
  Stream<auth.User?> authUserStream() {
    return auth.FirebaseAuth.instance.authStateChanges();
  }

  @override
  Future<void> create({
    required auth.User user,
  }) async {
    final newUser = User(
      id: user.uid,
      name: user.displayName!,
      email: user.email!,
      phone: '',
      address: '',
      profilePhoto: user.photoURL ?? defaultProfile,
      createdAt: DateTime.now(),
    );
    await _firestore.collection(usersCol).doc(user.uid).set(newUser.toJson());
  }

  @override
  Future<void> update({
    required User user,
  }) async {
    await _firestore.collection(usersCol).doc(user.id).set(
          user.toJson(),
        );
  }

  @override
  Stream<List<User>> fetchAllUsers() {
    return _firestore.collection(usersCol).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => User.fromJson(doc.data())).where(
        (user) {
          return user.id != auth.FirebaseAuth.instance.currentUser!.uid;
        },
      ).toList();
    });
  }

  @override
  Future<User?> fetch({required String id}) async {
    final doc = await _firestore.collection(usersCol).doc(id).get();
    if (doc.exists) {
      return User.fromJson(doc.data()!);
    } else {
      return null;
    }
  }

  @override
  Stream<User?> stream({required String id}) {
    return _firestore.collection(usersCol).doc(id).snapshots().map((event) {
      final data = event.data();
      if (data == null) {
        return null;
      }
      return User.fromJson(data);
    });
  }

    @override
  Future<String> uploadProfileImage(
      {required userId, required Uint8List imageBytes}) async {
    final storageReference =
        _storage.ref().child('profile_photos').child('$userId.jpg');
    final uploadTask = storageReference.putData(imageBytes);
    final snapshot = await uploadTask;
    final imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }
}
