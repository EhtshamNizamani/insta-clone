import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../global_variabls.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout(
      {super.key,
      required this.mobileScreenLayout,
      required this.webScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    isLoading = true;
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.refreshUser().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > web) {
              //web layout
              return widget.webScreenLayout;
            } else {
              //mobile layout
              return widget.mobileScreenLayout;
            }
          });
  }
}
