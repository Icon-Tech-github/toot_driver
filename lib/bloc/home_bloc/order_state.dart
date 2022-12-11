part of 'order_cubit.dart';



@immutable
abstract class OrderState extends Equatable {}



class OrderInitial extends OrderState {

  @override
  List<Object> get props => [];

}

class AcceptSucess extends OrderState {

  @override
  List<Object> get props => [];

}

class OrderLoading extends OrderState {
  final List<OrderData> oldOrders;
  final bool isFirstFetch;

  OrderLoading(this.oldOrders, {this.isFirstFetch=false});

  @override
  List<Object> get props => [];

}


class OrderLoaded extends OrderState {
  final List<OrderData> orders ;
  int ?total;
  OrderLoaded({required this.orders ,this.total});

  @override
  List<Object> get props => [orders];
}

