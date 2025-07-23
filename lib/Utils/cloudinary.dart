import 'dart:convert';
import 'dart:io';

import 'package:blog/Config/env.dart';
import 'package:blog/Firebase/firebase.dart';
import 'package:blog/Utils/uuid.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class CloudinaryOperation {
  Cloudinary cloudinary = Cloudinary.fromStringUrl(Config.cloudinaryUrl);
  Logger logs = Logger(
    level: kReleaseMode ? Level.off : Level.debug,
    printer: PrettyPrinter(methodCount: 1, colors: true),
  );

  Future<String?> uploadImage(File file) async {
    try {
      final response = await cloudinary.uploader().upload(file);

      if (response == null) return null;

      String? rawResponse = response.rawResponse;

      if (rawResponse == null) return null;

      Map<String, dynamic> data = jsonDecode(rawResponse);

      logs.i("response $data");

      return data["secure_url"];
    } catch (error) {
      logs.e("$fileName.uploadImage ${error.toString()}");
    }
    return null;
  }
}
