import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/resources/routes/routes.dart';
import 'asgrev_app.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  CustomNavigationHelper.initialize();
  runApp(const AsgRevApp());
}