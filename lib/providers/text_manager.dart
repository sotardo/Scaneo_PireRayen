import 'package:flutter/foundation.dart';

class TextManager extends ChangeNotifier {
  static TextManager? _instance;
  static TextManager get instance {
    if (_instance == null) {
      _instance = TextManager();
    }
    return _instance!;
  }

  List<String> texts = [];

  void setText(String value) {
    texts.add(value);
    notifyListeners();
  }

  void deleteText(int index) {
    texts.removeAt(index);
    notifyListeners();
  }
}