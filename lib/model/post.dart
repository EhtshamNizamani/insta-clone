// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_typing_uninitialized_variables
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String desk;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;
  Post({
    required this.desk,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'desk': desk,
        'profImage': profImage,
        'postId': postId,
        'postUrl': postUrl,
        'datePublished': datePublished,
        'likes': likes
      };

  static toSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      desk: snapshot['desk'],
      profImage: snapshot['profImage'],
      postId: snapshot['postId'],
      postUrl: snapshot['postUrl'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
    );
  }
}
