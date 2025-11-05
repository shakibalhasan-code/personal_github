import 'package:flutter/material.dart';
import 'package:personal_github/app.dart';
import 'package:personal_github/config/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.setup();
  runApp(const MyApp());
}
