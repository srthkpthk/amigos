import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  final _sp = SharedPreferences.getInstance();

  Future<String> getUid() =>
      _sp.then((value) => value.getString('currentUser_uid'));

  saveUid(String uid) =>
      _sp.then((value) => value.setString('currentUser_uid', uid));
}
