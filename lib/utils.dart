// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/colors.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  static showToast(message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: mobileSearchColor,
        textColor: Colors.redAccent,
        fontSize: 16.0);
  }

  static Future<Uint8List> imagePicker(source) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: source);
    return await image!.readAsBytes();
  }
}
