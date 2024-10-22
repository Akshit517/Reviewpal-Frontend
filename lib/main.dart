import 'package:flutter/material.dart';

import 'asgrev_app.dart';
import 'features/injection.dart' as di;
void main() async {
  await di.init();
  runApp(const AsgRevApp());
}