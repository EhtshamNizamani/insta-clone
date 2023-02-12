import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';

import 'screens/add_post_screen.dart';
import 'screens/feed_screen.dart';

const web = 700;

List<Widget> homeNavigation = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notifi'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
