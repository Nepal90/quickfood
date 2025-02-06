import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final String? userId;
  final UserCredential? userCredential;
  final bool isUserVerified;
  final bool isApiLoading;
  AuthState({
    this.userId,
    required this.isUserVerified,
    required this.isApiLoading,
    this.userCredential,
  });

  AuthState copyWith({
    String? userId,
    bool? isUserVerified,
    bool? isApiLoading,
    UserCredential? userCredential,
  }) {
    return AuthState(
      userId: userId ?? this.userId,
      isUserVerified: isUserVerified ?? this.isUserVerified,
      isApiLoading: isApiLoading ?? this.isApiLoading,
      userCredential: userCredential ?? this.userCredential,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier()
      : super(
          AuthState(
            isUserVerified: false,
            isApiLoading: false,
          ),
        );

  void signUp(
      {required String email,
      required String password,
      required String name}) async {
    state = state.copyWith(
      isApiLoading: true,
    );
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(
        isApiLoading: true,
        userCredential: userCredential,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(state.userCredential?.user!.uid)
          .set({
        'email': email,
        'role': "user",
      });
    } catch (e) {
      log('weeew$e');
    }
  }

  Future<UserCredential> signIn(String email, String password) {
    final user = FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return user;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
