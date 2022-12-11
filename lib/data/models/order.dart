// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

import '../../local_storage.dart';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  OrderModel({
    this.status,
    this.msg,
    this.data,
  });

  bool ?status;
  String ?msg;
  Data ?data;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    status: json["status"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int ?currentPage;
  List<OrderData> ?data;
  String ?firstPageUrl;
  int? from;
  int ?lastPage;
  String ?lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String ?path;
  int ?perPage;
  dynamic prevPageUrl;
  int? to;
  int ?total;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<OrderData>.from(json["data"].map((x) => OrderData.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class OrderData {
  OrderData({
    this.id,
    this.uuid,
    this.subtotal,
    this.discount,
    this.discountType,
    this.tax,
    this.deliveryFee,
    this.total,
    this.quantity,
    this.notes,
    this.clientId,
    this.orderStatusId,
    this.branchId,
    this.paymentMethodId,
    this.orderMethodId,
    this.couponId,
    this.createdAt,
    this.updatedAt,
    this.addressId,
    this.carId,
    this.driverId,
    this.durationTime,
    this.paymentMethod,
    this.client,

    this.address,
  });

  int? id;
  String ?uuid;
  int ?subtotal;
  double ?discount;
  dynamic discountType;
  double ?tax;
  int ?deliveryFee;
  double ?total;
  int ?quantity;
  String ?notes;
  int ?clientId;
  int ?orderStatusId;
  int ?branchId;
  int ?paymentMethodId;
  int ?orderMethodId;
  dynamic couponId;
  String ?createdAt;
  String ?updatedAt;
  dynamic addressId;
  dynamic carId;
  int ?driverId;
  int ?durationTime;
  PaymentMethod? paymentMethod;
  Client ?client;

  Address? address;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    id: json["id"],
    uuid: json["uuid"],
    subtotal: json["subtotal"],
    discount: double.parse(json["discount"].toString()),
    discountType: json["discount_type"],
    tax: json["tax"].toDouble(),
    deliveryFee: json["delivery_fee"],
    total: json["total"].toDouble(),
    quantity: json["quantity"],
    notes: json["notes"],
    clientId: json["client_id"],
    orderStatusId: json["order_status_id"],
    branchId: json["branch_id"],
    paymentMethodId: json["payment_method_id"],
    orderMethodId: json["order_method_id"],
    couponId: json["coupon_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    addressId: json["address_id"],
    carId: json["car_id"],

    driverId: json["driver_id"],
    durationTime: json["duration_time"],
    paymentMethod: PaymentMethod.fromJson(json["payment_method"]),
    client: Client.fromJson(json["client"]),
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "subtotal": subtotal,
    "discount": discount,
    "discount_type": discountType,
    "tax": tax,
    "delivery_fee": deliveryFee,
    "total": total,
    "quantity": quantity,
    "notes": notes,
    "client_id": clientId,
    "order_status_id": orderStatusId,
    "branch_id": branchId,
    "payment_method_id": paymentMethodId,
    "order_method_id": orderMethodId,
    "coupon_id": couponId,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "address_id": addressId,
    "car_id": carId,
    "driver_id": driverId,
    "duration_time": durationTime,
  "payment_method": paymentMethod!.toJson(),
    "client": client!.toJson(),
    "address": address == null ? null : address!.toJson(),
  };
}

class Client {
  Client({
    this.id,
    this.name,
    this.phone,
  });

  int? id;
  String ?name;
  String ?phone;

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
  };
}

class PaymentMethod {
  PaymentMethod({
    this.id,
    this.title,
  });

  int ?id;
  Title ?title;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json["id"],
    title: Title.fromJson(json["title"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title!.toJson(),
  };
}

class Title {
  Title({
    this.en,
    this.ar,
  });

  String? en;
  String ?ar;

  factory Title.fromJson(Map<String, dynamic> json) => Title(
    en:  LocalStorage.getData(key: "lang") == 'en' ? json["en"]: json["ar"],
    ar: json["ar"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
    "ar": ar,
  };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String ?label;
  bool ?active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"] == null ? null : json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "label": label,
    "active": active,
  };
}
class Address {
  Address({
    this.id,
    this.clientId,
    this.title,
    this.lat,
    this.long,
    this.notes,
  });

  int? id;
  int ?clientId;
  String? title;
  String ?lat;
  String ?long;
  String ?notes;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    clientId: json["client_id"],
    title: json["title"],
    lat: json["lat"],
    long: json["long"],
    notes: json["notes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "client_id": clientId,
    "title": title,
    "lat": lat,
    "long": long,
    "notes": notes,
  };
}
