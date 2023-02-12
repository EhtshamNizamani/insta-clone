// ignore_for_file: prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/colors.dart';
import 'package:instagram_clone/firebase/firestroe_method.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController _postController = TextEditingController();
  bool isLoading = false;
  Uint8List? _file;
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.pop(context);

                  Uint8List file = await Utils.imagePicker(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await Utils.imagePicker(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Cancel',
                  textAlign: TextAlign.right,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void uploadPost(String uid, String username, String userProfile) async {
    setState(() {
      isLoading = true;
    });
    try {
      final String res = await FirestoreMethod().uploadPost(
          username: username,
          profileUrl: userProfile,
          uid: uid,
          desc: _postController.text,
          file: _file!);

      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        Utils.showToast('Posted!');
        clearImage();
      } else {
        Utils.showToast(res);
      }
    } catch (e) {
      Utils.showToast(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _postController.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Scaffold(
            body: Center(
                child: IconButton(
              onPressed: () {
                _selectImage(context);
              },
              icon: const Icon(Icons.upload),
            )),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _file = null;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text('Add Post'),
              actions: [
                TextButton(
                    onPressed: () {
                      uploadPost(user.uid, user.username, user.photoUrl);
                    },
                    child: const Text(
                      'Post',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                    ))
              ],
            ),
            body: Column(
              children: [
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        maxLines: 8,
                        controller: _postController,
                        decoration: const InputDecoration(
                            hintText: 'Write a Post...',
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      height: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image:
                                  DecorationImage(image: MemoryImage(_file!))),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
  }
}
