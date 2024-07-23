import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper  {
  static SharedPreferences? sharedPreferences;
  static init() async {
    sharedPreferences  = await SharedPreferences.getInstance();
  }

  static Future<bool?> setData (String key,int value) async{
    return await sharedPreferences?.setInt(key, value);
  }
  static int? getData (String key) {
    return sharedPreferences?.getInt(key);
  }
}