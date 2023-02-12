// ignore_for_file: prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/firebase/auth_repository.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils.dart';
import 'package:instagram_clone/widget/entry_point.dart';

import '../colors.dart';
import '../widget/widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  Uint8List? image;
  bool _isLoading = false;
  final authRep = AuthRepositoryProvide();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void pickImage() async {
    image = await Utils.imagePicker(ImageSource.gallery);

    setState(() {});
  }

  void singupUser() async {
    if (image != null) {
      String res = await authRep.signupUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        bio: _bioController.text,
        username: _usernameController.text,
        profile: image!,
      );
      setState(() {
        _isLoading = true;
      });
      if (res == 'success') {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const EntryPoint()));
      } else {
        Utils.showToast(res);
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      Utils.showToast('Choose a profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/instagram.svg',
                height: 64,
                color: primaryColor,
              ),
              const SizedBox(height: 64),
              Stack(
                children: [
                  image != null
                      ? CircleAvatar(
                          radius: 70,
                          backgroundImage: MemoryImage(image!),
                        )
                      : const CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4lI0nFwQVSP-Dd91tX782thyq4HQHIfctCZPy0A4nEQ&s'),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                          onPressed: () {
                            pickImage();
                          },
                          icon: const Icon(Icons.camera_alt)))
                ],
              ),
              const SizedBox(height: 24),
              TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: 'Enter User Name',
                  textInputType: TextInputType.text),
              const SizedBox(height: 24),
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Enter you Email Address',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(height: 24),
              TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Enter your Passowrd',
                  isPass: true,
                  textInputType: TextInputType.text),
              const SizedBox(height: 24),
              TextFieldInput(
                  textEditingController: _bioController,
                  hintText: 'Enter Bio',
                  textInputType: TextInputType.text),
              const SizedBox(height: 24),
              InkWell(
                onTap: singupUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                  child: !_isLoading
                      ? const Text(
                          'Sign up',
                        )
                      : const CircularProgressIndicator(
                          color: primaryColor,
                        ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Already an Acc?',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Log in.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
