import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shormeh_delivery/data/models/order.dart';
import 'package:shormeh_delivery/translations/locale_keys.g.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../data/reposetories/home_repo.dart';
import '../../local_storage.dart';
import '../../persentation/wedgits/loading.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final GetHomeRepository homeRepository;

  OrderCubit(this.homeRepository) : super(OrderInitial()) {
    newOrderOnLoad();
    info();
      Timer.periodic(Duration(seconds: 60), (Timer t) => getUserLocation());
   // getUserLocation();
  }
  Random random = new Random();
  static int ?activeId;
List<OrderData> allOrders=[];
static int categoryNum=1;
String ?note;
 int newTotal =0;
  String ? reason;
  static int deliveredOrders =0;
  static int refusedOrders =0;
  static int failedOrders =0;
  double? lat;
  double? lng;
  Position? currentLocation;
  bool loading = false;
  int page =1;
  RefreshController controller = RefreshController();


  void newOrderOnLoad()async{

    if (state is OrderLoading) return;

    final currentState = state;

    var oldOrders = <OrderData>[];
    if (currentState is OrderLoaded) {
      oldOrders= currentState.orders;
    }
    if(page == 1)
      oldOrders=[];
    emit(OrderLoading(oldOrders, isFirstFetch: page == 1));

    var data = await  homeRepository.fetchNewOrders(page);
    List<OrderData> orders2 = List<OrderData>.from(
        data['data'].map((dep) => OrderData.fromJson(dep)));
    page++;

    final orders = (state as OrderLoading).oldOrders;
    orders.addAll(orders2);
newTotal = data['total'];
print(newTotal);
//allOrders = orders;
    emit(OrderLoaded(orders: orders,total: newTotal));
    controller.loadComplete();
    loading = false;


  }
  void openOrderOnLoad()async{

    if (state is OrderLoading) return;

    final currentState = state;

    var oldOrders = <OrderData>[];
    if (currentState is OrderLoaded) {
      oldOrders= currentState.orders;
    }
    if(page == 1)
      oldOrders=[];
    emit(OrderLoading(oldOrders, isFirstFetch: page == 1));

    var data = await  homeRepository.fetchOpenOrders(page);
    List<OrderData> orders2 = List<OrderData>.from(
        data.map((dep) => OrderData.fromJson(dep)));
    page++;

    final orders = (state as OrderLoading).oldOrders;
    orders.addAll(orders2);

    emit(OrderLoaded(orders: orders));
    controller.loadComplete();
    loading = false;

  }
  void closedOrderOnLoad()async{

    if (state is OrderLoading) return;

    final currentState = state;

    var oldOrders = <OrderData>[];
    if (currentState is OrderLoaded) {
      oldOrders= currentState.orders;
    }
    if(page == 1)
      oldOrders=[];
    emit(OrderLoading(oldOrders, isFirstFetch: page == 1));

    var data = await  homeRepository.fetchClosedOrders(page);
    List<OrderData> orders2 = List<OrderData>.from(
        data.map((dep) => OrderData.fromJson(dep)));
    page++;

    final orders = (state as OrderLoading).oldOrders;
    orders.addAll(orders2);

    emit(OrderLoaded(orders: orders));
    controller.loadComplete();
    loading = false;


  }

  void acceptOrder(int id,context) {
    loading = true;
  //  emit(OrderLoading([], isFirstFetch: true));
  //  emit(OrderInitial());
   // LoadingScreen.show(context);
     homeRepository.acceptOrder(id).then((value) {
      if(value != null){
     //   categoryNum = 2;
        page=1;
        openOrderOnLoad();

      //  Navigator.pop(context);
     //   emit(AcceptSucess());
      }
    });


  }

  void rejectOrder(int id,context,) {
    //  emit(OrderInitial());
    LoadingScreen.show(context);
    homeRepository.rejectOrder(id,reason!).then((value) {
      if(value != null){
        //   categoryNum = 2;
        page =1;
        Navigator.pop(context);
        Navigator.pop(context);
        newOrderOnLoad();
        refusedOrders =refusedOrders+1;
        showTopSnackBar(
            context,
            Card(
              child: CustomSnackBar.success(
                message: "rejected successfully",
                backgroundColor: Colors.white,
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02),
              ),
            ));

      }
    });


  }

  void deliverOrder(int id,context) {
    //  emit(OrderInitial());
    LoadingScreen.show(context);
    homeRepository.deliverOrder(id).then((value) {
      if(value != null){

        page =1;
        Navigator.pop(context);
        newOrderOnLoad();
        deliveredOrders=deliveredOrders+1;
        showTopSnackBar(
            context,
            Card(
              child: CustomSnackBar.success(
                message: LocaleKeys.accept_order.tr(),
                backgroundColor: Colors.white,
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02),
              ),
            ));

      }
    });


  }

  void failedOrder(int id,context) {
    //  emit(OrderInitial());
    LoadingScreen.show(context);
    homeRepository.failedOrder(id,reason!).then((value) {
      if(value != null){

        page =1;
        Navigator.pop(context);
        Navigator.pop(context);
        newOrderOnLoad();
        failedOrders +=1;
        showTopSnackBar(
            context,
            Card(
              child: CustomSnackBar.success(
                message: LocaleKeys.accept_order.tr(),
                backgroundColor: Colors.white,
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02),
              ),
            ));

      }
    });


  }
  info() async {
   // emit(OrderInitial());
    homeRepository
        .info(LocalStorage.getData(key: "token")
    )
        .then((data) async {
      if(data == null){
        //  emit(AuthFailure(error: "not found"));
      }else {
        deliveredOrders=data['DeliveredOrders'];
        refusedOrders=data['RefusedOrders'];
        failedOrders=data['FailedOrders'];

        // LocalStorage.removeData(key: "token");
        // LocalStorage.removeData(key: "userName");

        //  emit(AuthSuccess());
      }
    });
  }
  getUserLocation() async {
    // Position position = await Geolocator.getCurrentPosition();
    currentLocation = await locateUser().then((value)  {
    LocalStorage.saveData(key: "lat", value: value.latitude);
        LocalStorage.saveData(key: "lng", value: value.longitude);

    lat = value.latitude;
    lng = value.longitude;
    location(value.latitude.toString(),  value.longitude.toString());
    });
    //setState(() {

   // });
  }

  Future<Position> locateUser() async {
    await Geolocator.requestPermission();
    return Geolocator.getCurrentPosition();
  }
  void location(String lat ,String long) {
   // loading = true;
    //  emit(OrderLoading([], isFirstFetch: true));
    //  emit(OrderInitial());
    // LoadingScreen.show(context);
    homeRepository.location(lat,long).then((value) {
      // if(value != null){
      //   //   categoryNum = 2;
      //   // page=1;
      //   // openOrderOnLoad();
      //
      //   //  Navigator.pop(context);
      //   //   emit(AcceptSucess());
      // }
    });


  }
  String getUnReadCount(){
    // emit(DepartmentsInitial());
    // emit(DepartmentLoaded(departments: allDep));
    return LocalStorage.getData(key: "unReadCount").toString();
  }
}


