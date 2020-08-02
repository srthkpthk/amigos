import 'package:amigos/src/model/userModel/UserEntity.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._sharedPreferencesHelper) : super(SplashInitial());
  final _sharedPreferencesHelper;
  checkIfUserIsRegistered() async {
    if (await checkIfInternetIsThere()) {
      String uid = await _sharedPreferencesHelper.getUid();
      if (uid == null) {
        emit(UnAuthenticatedUser());
      } else {
        emit(AuthenticatedUser(await Firestore.instance
            .collection('Users')
            .document(uid)
            .get()
            .then((value) => UserEntity.fromJsonMap(value.data))));
      }
    } else {
      emit(InternetNotAvailable());
    }
  }

  Future<bool> checkIfInternetIsThere() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi
        ? true
        : false;
  }
}
