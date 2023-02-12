import 'package:flutter/material.dart';

class WebScreen extends StatelessWidget {
  const WebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:
          SafeArea(child: SizedBox(child: Text('will try to upload web too '))),
    );
  }
}
