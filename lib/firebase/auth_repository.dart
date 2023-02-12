// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/firebase/storage_method.dart';
import 'package:instagram_clone/model/user.dart' as model;

class AuthRepositoryProvide {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<model.User?> getUserData() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot snap =
        await firestore.collection('users').doc(currentUser.uid).get();
    return model.User.toSnap(snap);
  }

  Future<String> signupUser({
    required String email,
    required String password,
    required String bio,
    required String username,
    required Uint8List profile,
  }) async {
    String res = 'some error occured';
    if (email.isNotEmpty ||
        password.isNotEmpty ||
        bio.isNotEmpty ||
        profile != null ||
        username.isNotEmpty) {
      try {
        final cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final String photoUrl = await StorageMethods()
            .uploadImageToStorage('ProfilePic', profile, false);
        model.User user = model.User(
            username: username,
            email: email,
            bio: bio,
            uid: cred.user!.uid,
            followers: [],
            following: [],
            photoUrl: photoUrl);

        firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

        res = 'success';
      } catch (e) {
        res = e.toString();
        if (kDebugMode) {
          print(res);
        }
      }
    } else {
      res = 'Please fill your filed correct';
    }
    return res;
  }

  //sign-in user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Something went wrong';
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
