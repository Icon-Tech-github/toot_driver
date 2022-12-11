import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../ServerConstants.dart';
import '../models/user_model.dart';



abstract class AuthRepository {
  Future changeLang(String ?token);


  Future logout(String ?token);
  Future login({String phone, String password});
  Future available(String ?token);
  Future deleteAcount(String ?token);



}

class AuthRepo implements AuthRepository {
  var dio = Dio()
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));

  //
  static Map<String, String> apiHeaders = {
    "Content-Type": "application/json",
    "X-Requested-With": "XMLHttpRequest",
    "Content-Language": "en",
  };
@override
  Future login({String ?phone, String ?password,String ? fcmToken,String ?lang}) async {
    var _data = {
      "phone": "$phone",
      "password": "$password",
      "fcm_token":"$fcmToken",
      "lang":"$lang"
    };
    print('login start');
    // Http Request
    var _response = await dio.post(ServerConstants.login,
        data: _data,
        options: Options(
          headers: {...apiHeaders
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));


    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
    final  user = UserModel.fromJson(_response.data);
      return user;
    } else if (_response.statusCode == 307) {
      return "307";
    }else if (_response.statusCode == 401) {
      return "401";
    }else if (_response.statusCode == 422) {
      return "422";
    }
    else{
      return null;
    }
  }

  @override
  Future changePass({String ?oldPassword, String ?newPassword,String? token}) async {
    var _data = {
      "old_password": "$oldPassword",
      "new_password": "$newPassword",
      // "fcm_token":"$fcmToken",
      // "lang":"$lang"
    };
    print('login start');
    // Http Request
    var _response = await dio.post(ServerConstants.changePassword,
        data: _data,
        options: Options(
          headers: {...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));


    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      final  user = UserModel.fromJson(_response.data);
      return user;
    } else if (_response.statusCode == 307) {
      return "307";
    }else if (_response.statusCode == 401) {
      return "401";
    }else if (_response.statusCode == 422) {
      return "422";
    }
    else{
      return null;
    }
  }
  @override
  Future logout(String ?token) async {
    var _response = await dio.post(ServerConstants.logout,
        options: Options(
          headers: {...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));


    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      return _response.data;
    } else {
      return null;
    }
  }

  @override
  Future available(String ?token) async {
    var _response = await dio.post(ServerConstants.availability,
        options: Options(
          headers: {...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));


    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      return _response.data;
    } else {
      return null;
    }
  }

  @override
  Future deleteAcount(String ?token) async {
    var _response = await dio.post(ServerConstants.unActive,
        options: Options(
          headers: {...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));


    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      return _response.data;
    } else {
      return null;
    }
  }

  @override
  Future changeLang(String ?token) async {
    var _response = await dio.post(ServerConstants.lang,
        options: Options(
          headers: {...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));


    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      return _response.data;
    } else {
      return null;
    }
  }
}