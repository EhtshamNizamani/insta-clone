import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/firebase/storage_method.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:instagram_clone/utils.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<String> uploadPost({
    required String username,
    required String profileUrl,
    required String uid,
    required String desc,
    required Uint8List file,
  }) async {
    String respons = 'An error occured';
    try {
      final photoUrl =
          await StorageMethods().uploadImageToStorage('Post', file, true);

      final postId = const Uuid().v1();
      Post post = Post(
          datePublished: DateTime.now(),
          username: username,
          uid: uid,
          desk: desc,
          postUrl: photoUrl,
          postId: postId,
          profImage: profileUrl,
          likes: []);
      firestore.collection('posts').doc(postId).set(post.toJson());
      respons = 'success';
    } catch (err) {
      return err.toString();
    }

    return respons;
  }

  Future<void> likePost(String uid, String postId, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> postComment(String uid, String postId, String text, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        final commentId = const Uuid().v1();
        await firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'username': name,
          'profilePic': profilePic,
          'uid': uid,
          'comment': text,
          'postId': postId,
          'datePublished': DateTime.now()
        });
      } else {
        Utils.showToast('Comment is empty!');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      Utils.showToast(e.toString());
    }
  }

  Future<void> followUser(String userUid, String followUid) async {
    DocumentSnapshot snap =
        await firestore.collection('users').doc(userUid).get();
    List following = (snap.data()! as dynamic)['following'];

    if (following.contains(followUid)) {
      await firestore.collection('users').doc(followUid).update({
        'followers': FieldValue.arrayRemove([userUid])
      });
      await firestore.collection('users').doc(userUid).update({
        'following': FieldValue.arrayRemove([followUid])
      });
    } else {
      await firestore.collection('users').doc(followUid).update({
        'followers': FieldValue.arrayUnion([userUid])
      });
      await firestore.collection('users').doc(userUid).update({
        'following': FieldValue.arrayUnion([followUid])
      });
    }
  }
}
