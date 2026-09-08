import 'package:eClassify/Ui/screens/widgets/Errors/something_went_wrong.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../data/model/Personalized/personalized_settings.dart';
import '../firebase_options.dart';
import '../main.dart';
import '../utils/hive_keys.dart';

PersonalizedInterestSettings personalizedInterestSettings =
PersonalizedInterestSettings.empty();

void initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }

  /// Google Maps optimization
  if (!kIsWeb) {
    try {
      final mapsImplementation = GoogleMapsFlutterPlatform.instance;
      if (mapsImplementation is GoogleMapsFlutterAndroid) {
        mapsImplementation.useAndroidViewSurface = false;
      }
    } catch (_) {}
  }

  /// Hydrated Bloc
  try {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getApplicationDocumentsDirectory(),
    );
  } catch (e) {
    debugPrint("HydratedBloc error: $e");
  }

  /// Hive
  try {
    await Hive.initFlutter();
    await Hive.openBox(HiveKeys.userDetailsBox);
    await Hive.openBox(HiveKeys.authBox);
    await Hive.openBox(HiveKeys.languageBox);
    await Hive.openBox(HiveKeys.themeBox);
    await Hive.openBox(HiveKeys.svgBox);
    await Hive.openBox(HiveKeys.jwtToken);
    await Hive.openBox(HiveKeys.historyBox);
  } catch (e) {
    debugPrint("Hive error: $e");
  }

  if (kIsWeb) {
    runApp(const EntryPoint());
  } else {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
      (_) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        );
        runApp(const EntryPoint());
      },
    );
  }
}

