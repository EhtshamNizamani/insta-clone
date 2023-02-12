// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:instagram_clone/colors.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 8),
      margin: const EdgeInsets.only(top: 10),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(snap['profilePic']),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: '${snap['username']} ',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: snap['comment']),
                    ]),
                  ),
                  Text(DateFormat.yMMMd()
                      .format(snap['datePublished'].toDate())),
                ],
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  color: primaryColor,
                  Icons.favorite,
                  size: 20,
                ))
          ]),
    );
  }
}
