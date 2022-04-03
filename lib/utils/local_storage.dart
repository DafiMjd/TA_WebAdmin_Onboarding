import 'package:universal_html/html.dart';

class LocalStorageHelper {
  static Storage localStorage = window.localStorage;

  // save data in local storage
  static void saveValue(String key, String value) {
    localStorage[key] = value;
  } 

  // get data
  static String getValue(String key) {
    return localStorage[key]!;
  }

  // remove data
  static void removeData(String key) {
    localStorage.remove(key);
  }

  // clear all
  static void clearAll() {
    localStorage.clear(); 
  }
}