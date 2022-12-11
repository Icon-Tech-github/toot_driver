import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';

import '../../data/models/orders_model.dart';
import '../../data/reposetories/Order_details_repo.dart';
import '../../local_storage.dart';
part 'order_details_state.dart';


class OrderDetailsCubit extends Cubit<OrderDetailsState> {
 final OrderDetailsRepository orderDetailsRepository;
 int id;
  OrderDetailsCubit(this.orderDetailsRepository,this.id) : super(OrderDetailsInitial()){
    getOrder();
  }
 OrderDetailsModel? order ;

 Future getOrder()async{
   emit(OrderDetailsLoading());
   orderDetailsRepository.fetchOrder(LocalStorage.getData(key: 'token'), id).then((value) {
      log(value.toString());
      order = OrderDetailsModel.fromJson(value);
     emit(OrderDetailsLoaded(order: order!));
   });
 }

}
