import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/colors.dart';
import 'package:instagram_clone/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  var length = 0;
  bool isShowUser = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: TextFormField(
              controller: searchController,
              onFieldSubmitted: (_) {
                setState(() {});
                length = 0;
                isShowUser = true;
              },
              decoration: const InputDecoration(
                labelText: 'Search for user',
              ),
            )),
        body: isShowUser
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: searchController.text.trim())
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  length = snapshot.data?.docs.length ?? 0;
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return length < 1
                          ? const Center(
                              child: Text('No user Fount with this name'),
                            )
                          : ListView.builder(
                              itemCount: length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (ctx) => ProfileScreen(
                                              uid: snapshot.data!.docs[index]
                                                  ['uid']))),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(snapshot
                                          .data!.docs[index]['photoUrl']),
                                    ),
                                    title: Text(
                                      snapshot.data!.docs[index]['username'],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              });
                    }
                  }

                  return const Center(
                    child: Text('No user Fount with this name'),
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 3,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 5,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: snapshot.data!.docs[index]['postUrl'],
                          fit: BoxFit.contain,
                        );
                      },
                      staggeredTileBuilder: (int index) {
                        return StaggeredTile.count(
                            (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1);
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }));
  }
}
