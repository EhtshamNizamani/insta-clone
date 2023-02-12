// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/colors.dart';
import 'package:instagram_clone/firebase/firestroe_method.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/widget/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class PostCard extends StatefulWidget {
  final data;
  const PostCard(Map<String, dynamic> this.data, {super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  var commentLength = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    final comment = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.data['postId'])
        .collection('comments')
        .get();

    commentLength = comment.docs.length;
    setState(() {});
  }

  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.data['profImage'],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.data['username'],
                    style: const TextStyle(color: primaryColor, fontSize: 14),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              children: [
                                SimpleDialogOption(
                                  onPressed: () async {
                                    await FirestoreMethod()
                                        .deletePost(widget.data['postId']);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Delete'),
                                )
                              ],
                            );
                          });
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onDoubleTap: () async {
              setState(() {
                isLikeAnimating = true;
              });
              await FirestoreMethod().likePost(
                  user.uid, widget.data['postId'], widget.data['likes']);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.data['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  opacity: isLikeAnimating ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: LikeAnimation(
                    smallLike: false,
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 200,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: primaryColor,
                      size: 120,
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.data['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  splashColor: mobileBackgroundColor,
                  highlightColor: mobileBackgroundColor,
                  onPressed: () async {
                    await FirestoreMethod().likePost(
                        user.uid, widget.data['postId'], widget.data['likes']);
                  },
                  icon: widget.data['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite,
                          color: primaryColor,
                        ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CommentsScreen(postId: widget.data['postId'])));
                },
                icon: const Icon(Icons.message_outlined),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_outline),
                ),
              ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '${widget.data['likes'].length} Likes',
                style: const TextStyle(color: Colors.white38),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8),
                child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                      TextSpan(
                          text: widget.data['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' ${widget.data['desk']}')
                    ])),
              ),
              const SizedBox(height: 5),
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                              postId: widget.data['postId'],
                            ))),
                child: Text(
                  'View all $commentLength comments',
                  style: const TextStyle(color: Colors.white38, fontSize: 16),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                DateFormat.yMMMd().format(widget.data['datePublished'].toDate()),
                style: const TextStyle(color: Colors.white38, fontSize: 16),
              ),
            ]),
          ),
          const SizedBox(height: 35),
        ],
      ),
    );
  }
}
