import "package:universal_html/html.dart";

class LocalStorageHelper {
  static Storage localStorage = window.localStorage;

  static void saveValue(String key, String value) {
    localStorage[key] = value;
  }

  static String? getValue(String key) {
    return localStorage[key];
  }

  static void removeValue(String key) {
    localStorage.remove(key);
  }
}
