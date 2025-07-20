import 'dart:io';

import 'package:blog/Config/env.dart';
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

  Future<void> uploadImage(File file) async {
    try {
      String id = UUID().newId();
      logs.i(id);

      final response = await cloudinary.uploader().upload(file);

      logs.i("response ${response?.data}");
    } catch (error) {
      logs.e("uploadImage ${error.toString()}");
    }
  }
}
