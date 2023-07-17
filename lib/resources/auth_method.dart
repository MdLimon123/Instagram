import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/resources/storage_method.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<UserModel> getUserDetails()async{
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel.fromSnap(snap);

  }

  // sign up user

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoUrl =
            await StorageMethod().uploadImageStorage('profilePic', file, false);

        // add user to our database
        UserModel user = UserModel(
            email: email,
            uid: cred.user!.uid,
            username: username,
            photoUrl: photoUrl,
            bio: bio,
            followers: [],
            following: []);

        _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // logging in user

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
