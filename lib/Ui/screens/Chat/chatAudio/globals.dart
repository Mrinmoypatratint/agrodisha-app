import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ChatGlobals {
  ChatGlobals._();

  static void init() async {
    if (!kIsWeb) {
      documentPath = "${(await getApplicationDocumentsDirectory()).path}/";
    }
  }

  static const double borderRadius = 27;
  static const double defaultPadding = 8;
  static String documentPath = '';
  static GlobalKey<AnimatedListState> audioListKey =
      GlobalKey<AnimatedListState>();
}
