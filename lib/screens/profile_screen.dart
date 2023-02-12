// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/colors.dart';
import 'package:instagram_clone/firebase/firestroe_method.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils.dart';
import 'package:instagram_clone/widget/follower.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userSnap;
  int postLength = 0;
  int following = 0;
  int followers = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    isLoading = true;
    try {
      userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      final userPost = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      isLoading = false;
      postLength = userPost.docs.length;

      followers = userSnap.data()['followers'].length;
      following = userSnap.data()['following'].length;
      isFollowing = userSnap
          .data()['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      Utils.showToast(e.toString());
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                title: const Text('Profile')),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(userSnap.data()!['photoUrl']),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildColunm(postLength, 'posts'),
                                    buildColunm(followers, 'followers'),
                                    buildColunm(following, 'following'),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    widget.uid ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                        ? Followers(
                                            borderColor: Colors.white38,
                                            textColor: primaryColor,
                                            backgroudColor:
                                                mobileBackgroundColor,
                                            text: 'Log out',
                                            function: () async {
                                              await FirebaseAuth.instance
                                                  .signOut();
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen()));
                                            },
                                          )
                                        : isFollowing
                                            ? Followers(
                                                borderColor: primaryColor,
                                                textColor:
                                                    mobileBackgroundColor,
                                                backgroudColor: primaryColor,
                                                function: () async {
                                                  await FirestoreMethod()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          widget.uid);

                                                  setState(() {
                                                    followers--;
                                                    isFollowing = false;
                                                  });
                                                },
                                                text: 'Unfollow')
                                            : Followers(
                                                borderColor: blueColor,
                                                textColor: primaryColor,
                                                backgroudColor: blueColor,
                                                text: 'Follow',
                                                function: () async {
                                                  await FirestoreMethod()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          widget.uid);
                                                  setState(() {
                                                    followers++;
                                                    isFollowing = true;
                                                  });
                                                },
                                              ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.only(top: 15),
                          alignment: Alignment.centerLeft,
                          child: Text(userSnap.data()!['username'])),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          padding: const EdgeInsets.only(top: 1),
                          alignment: Alignment.centerLeft,
                          child: Text(userSnap.data()!['bio'])),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                              (snapshot.data! as dynamic).docs[index];
                          return SizedBox(
                              child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: snap['postUrl']));
                        });
                  },
                ),
              ],
            ),
          );
  }

  Column buildColunm(int num, String lable) {
    return Column(
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
        ),
        const SizedBox(height: 10),
        Text(
          lable.toString(),
          style: const TextStyle(fontSize: 16, color: Colors.white38),
        ),
      ],
    );
  }
}
