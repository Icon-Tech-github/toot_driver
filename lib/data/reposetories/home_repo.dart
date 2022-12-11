import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../local_storage.dart';
import '../ServerConstants.dart';

abstract class HomeRepository {

  Future fetchNewOrders(int page);
  Future fetchOpenOrders(int page);
  Future fetchClosedOrders(int page);
  Future acceptOrder(int orderId);
  Future rejectOrder(int orderId,String reason);
  Future deliverOrder(int orderId);
  Future failedOrder(int orderId,String reason);
  Future info(String ?token);

}

class GetHomeRepository implements HomeRepository {

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
  String token = LocalStorage.getData(key: "token")??"";



  @override
  Future fetchNewOrders(int page) async{

    var response = await dio.get("${ServerConstants.newOrders}?page=$page",
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {

         return response.data['data'];
    } else {
      return null;
    }
  }

  @override
  Future fetchOpenOrders(int page) async{

    var response = await dio.get("${ServerConstants.openOrders}?page=$page",
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {

      return response.data['data']["data"];
    } else {
      return null;
    }
  }

  @override
  Future fetchClosedOrders(int page) async{

    var response = await dio.get("${ServerConstants.closedOrders}?page=$page",
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {

      return response.data['data']["data"];
    } else {
      return null;
    }
  }

  @override
  Future acceptOrder(int orderId) async{
    var _data = {
      "order_id": "$orderId",
    };
    var response = await dio.post("${ServerConstants.acceptOrder}",
        data: _data,
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {

      return response.data['data'];
    } else {
      return null;
    }
  }

  @override
  Future rejectOrder(int orderId,String reason) async{
    var _data = {
      "order_id": "$orderId",
    "notes":"$reason",
    };
    var response = await dio.post("${ServerConstants.rejectOrder}",
        data: _data,
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {

      return response.data['data'];
    } else {
      return null;
    }
  }
  @override
  Future info(String ?token) async {
    var _response = await dio.get(ServerConstants.statics,
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
      return _response.data['data'];
    } else {
      return null;
    }
  }
  @override
  Future deliverOrder(int orderId) async{
    var _data = {
      "order_id": "$orderId",
    };
    var response = await dio.post("${ServerConstants.deliverOrder}",
        data: _data,
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {

      return response.data['data'];
    } else {
      return null;
    }
  }

  @override
  Future failedOrder(int orderId, String reason) async{
    var _data = {
      "order_id": "$orderId",
      "notes":"$reason"
    };
    var response = await dio.post("${ServerConstants.failedOrder}",
        data: _data,
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {

      return response.data['data'];
    } else {
      return null;
    }
  }

  @override
  Future location(String lat,String long) async{
    var _data = {
      "lat": "$lat",
      "long": "$long",

    };
    var response = await dio.post("${ServerConstants.saveLocation}",
        data: _data,
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {

      return response.data;
    } else {
      return null;
    }
  }
}
