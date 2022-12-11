import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';

import 'package:meta/meta.dart';

import '../../data/reposetories/auth_repo.dart';
import '../../local_storage.dart';
import '../../translations/locale_keys.g.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;


  AuthCubit(this.authRepo) : super(AuthInitial()){
  FirebaseMessaging.instance.getToken().then((value) {

  tokenFCM = value!;
  });
 // print(tokenFCM);
}
  String tokenFCM = '';
  bool ?status = true;
  String? phone, password,oldPass,newPass;
  bool isPassword = true;
  bool? availability ;



  final formKey = GlobalKey<FormState>();
  // Future<bool> check() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     status = true;
  //     return true;
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     status = true;
  //     return true;
  //   }
  //   status =false;
  //   print(status);
  //   return false;
  // }
  login() async {
    emit(AuthLoading());
    LocalStorage.saveData(key: 'counter', value: 0);
   await authRepo
        .login(
      password: password,
      phone: phone,
     fcmToken: tokenFCM,
     lang: LocalStorage.getData(key: "lang")
    )
        .then((data) async {
      if(data == null){
        emit(AuthFailure(error: LocaleKeys.not_found.tr()));
      }else  if (data ==  "307"){
        emit(AuthFailure(error: LocaleKeys.not_valid_number.tr()));
      }else  if (data ==  "401"){
        emit(AuthFailure(error: LocaleKeys.login_401.tr()));
      }else  if (data ==  "422"){
        emit(AuthFailure(error: LocaleKeys.login_422.tr()));
      }
      else{
        emit(AuthSuccess());
      }
    });
  }
  changePass() async {
    emit(AuthLoading());
    LocalStorage.saveData(key: 'counter', value: 0);
    await authRepo
        .changePass(
        oldPassword: oldPass,
        newPassword: newPass,
        token:  LocalStorage.getData(key: "token"),
           )
        .then((data) async {
      if(data == null){
        emit(AuthFailure(error: LocaleKeys.not_found.tr()));
      }else  if (data ==  "307"){
        emit(AuthFailure(error: LocaleKeys.not_valid_number.tr()));
      }else  if (data ==  "401"){
        emit(AuthFailure(error: LocaleKeys.login_401.tr()));
      }else  if (data ==  "422"){
        emit(AuthFailure(error: LocaleKeys.login_422.tr()));
      }
      else{
        emit(AuthSuccess());
      }
    });
  }

bool ? isResend = false;




  // newPassword({String? phone, String? password}) async {
  //   emit(AuthLoading());
  //   await authRepo
  //       .newPassword(
  //     password: password,
  //     phone: phone,
  //   )
  //       .then((data) async {
  //     if(data == null){
  //       emit(AuthFailure(error:  LocaleKeys.not_found.tr()));
  //     }else {
  //       emit(AuthSuccess());
  //     }
  //   });
  // }

  logout() async {
    emit(AuthLoading());
    await authRepo
        .logout(LocalStorage.getData(key: "token")
    )
        .then((data) async {
      if(data == null){
        emit(AuthFailure(error: "not found"));
      }else {
        LocalStorage.removeData(key: "token");
        LocalStorage.removeData(key: "userName");

        emit(AuthSuccess());
      }
    });
  }


  available(context) async {
    emit(AuthLoading());
    await authRepo
        .available(LocalStorage.getData(key: "token")
    )
        .then((data) async {
      if(data == null){
        emit(AvailableFailure(error: "wrong"));
      }else {
        if(LocalStorage.getData(key: "lastStatus") == true) {
        //  availability = false;
          LocalStorage.saveData(key: "lastStatus", value: false);
        }
        else if(LocalStorage.getData(key: "lastStatus") == false){
         // availability = true;
          LocalStorage.saveData(key: "lastStatus", value: true);
        }else if(LocalStorage.getData(key: "lastStatus") == null){
          //availability = false;
          LocalStorage.saveData(key: "lastStatus", value: false);
        }

        Navigator.pop(context);
        emit(AvailableSuccess());
      }
    });
  }
  changeLang() async {
   // emit(AuthLoading());
    await authRepo
        .changeLang(LocalStorage.getData(key: "token")
    )
        .then((data) async {
      if(data == null){
       // emit(AuthFailure(error: "not found"));
      }else {
        // LocalStorage.removeData(key: "token");
        // LocalStorage.removeData(key: "userName");

     //   emit(AuthSuccess());
      }
    });
  }
  swichLag (context)async{
    emit(AuthInitial());
    if (context.locale.toString() == 'ar') {
      // SharedPreferences prefs =
      //     await SharedPreferences.getInstance();
      // prefs.setString("lang", "en");
      await context.setLocale(
        Locale("en"),
      );

    } else {
      // SharedPreferences prefs =
      //     await SharedPreferences.getInstance();
      // prefs.setString("lang", "ar");
      await context.setLocale(
        Locale("ar"),
      );

    }
  }
  deleteAcount() async {
    emit(AuthLoading());
    await authRepo
        .deleteAcount(LocalStorage.getData(key: "token")
    )
        .then((data) async {
      if(data == null){
        emit(AuthFailure(error: "not found"));
      }else {
        LocalStorage.removeData(key: "token");
        LocalStorage.removeData(key: "userName");

        emit(AuthSuccess());
      }
    });
  }
}
