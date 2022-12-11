



import 'order.dart';

class OrderDetailsModel {
  dynamic id;
  String? uuid;
  double? subtotal;
  double? discount;
  String? discountType;
  double? tax;
  double? deliveryFee;
  double? total;
  int? quantity;
  String? notes;
  int? orderStatusId;
  int? branchId;
  int? paymentMethodId;
  int? orderMethodId;
  String? createdAt;
  String? updatedAt;
  OrderStatus? orderStatus;
  PaymentMethod? paymentMethod;
  List<Details>? details;
  Branch ?branch;

  PaymentMethod? orderMethod;

  OrderDetailsModel(
      {this.id,
        this.branch,
        this.uuid,
        this.subtotal,
        this.discount,
        this.discountType,
        this.tax,
        this.deliveryFee,
        this.total,
        this.quantity,
        this.notes,
        this.orderStatusId,
        this.branchId,
        this.paymentMethodId,
        this.orderMethodId,
        this.createdAt,
        this.updatedAt,
        this.orderStatus,
        this.paymentMethod,
        this.details,
        this.orderMethod});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    uuid = json['uuid'];
    subtotal = json['subtotal'].toDouble();
    discount = json['discount'].toDouble();
    discountType = json['discount_type'].toString();
    tax = json['tax'].toDouble();
    deliveryFee = json['delivery_fee'].toDouble();
    total = json['total'].toDouble();
    quantity = json['quantity'];
    notes = json['notes'];
    orderStatusId = json['order_status_id'];
    branchId = json['branch_id'];
    paymentMethodId = json['payment_method_id'];
    orderMethodId = json['order_method_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    branch = Branch.fromJson(json["branch"]);
    orderStatus = json['order_status'] != null
        ? new OrderStatus.fromJson(json['order_status'])
        : null;
    paymentMethod = json['payment_method'] != null
        ? new PaymentMethod.fromJson(json['payment_method'])
        : null;
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
    orderMethod = json['order_method'] != null
        ? new PaymentMethod.fromJson(json['order_method'])
        : null;
  }

}

class OrderStatus {
  int? id;
  Title? title;
  String? createdAt;

  OrderStatus({this.id, this.title, this.createdAt});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}



class PaymentMethod {
  int? id;
  Title? title;
  int? isActive;
  String? image;
  String? createdAt;

  PaymentMethod(
      {this.id, this.title, this.isActive, this.image, this.createdAt});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    isActive = json['is_active'];
    image = json['image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    data['is_active'] = this.isActive;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Details {
  int? id;
  double? total;
  double? price;
  int? quantity;
  String? note;
  int? orderId;
  int? productId;
  String? createdAt;
  String? updatedAt;
  Product? product;
  List<AttributesOrderDetails> ?attributes;

  Details(
      {this.id,
        this.total,
        this.price,
        this.quantity,
        this.note,
        this.orderId,
        this.productId,
        this.createdAt,
        this.updatedAt,
        this.product,
      this.attributes});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'].toDouble();
    price = json['price'].toDouble();
    quantity = json['quantity'];
    note = json['note'];
    orderId = json['order_id'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    if (json['attributes'] != null) {
      attributes = <AttributesOrderDetails>[];
      json['attributes'].forEach((v) {
        attributes!.add(new AttributesOrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['total'] = this.total;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['note'] = this.note;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  Title? title;
  Title? description;
  double? price;
  double? newPrice;
  int? isActive;
  int? isSlider;
  String? sliderImage;
  int? categoryId;
  String? createdAt;
  String? updatedAt;
  int? inFavourite;
  ProductImage? images;

  Product(
      {this.id,
        this.title,
        this.description,
        this.price,
        this.newPrice,
        this.isActive,
        this.isSlider,
        this.sliderImage,
        this.categoryId,
        this.createdAt,
        this.updatedAt,
        this.inFavourite,this.images});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    description = json['description'] != null
        ? new Title.fromJson(json['description'])
        : null;
    price = json['price'].toDouble();
    newPrice = json['new_price'].toDouble();
    isActive = json['is_active'];
    isSlider = json['is_slider'];
    sliderImage = json['slider_image'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    inFavourite = json['in_favourite'];
    images =json['last_image'] != null ?ProductImage.fromJson(json['last_image']):null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description!.toJson();
    }
    data['price'] = this.price;
    data['new_price'] = this.newPrice;
    data['is_active'] = this.isActive;
    data['is_slider'] = this.isSlider;
    data['slider_image'] = this.sliderImage;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['in_favourite'] = this.inFavourite;
    return data;
  }


}

class ProductImage{
  int? id;
  String ?image;
  ProductImage({this.id,this.image});

  ProductImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];

  }

}

class AttributesOrderDetails {
  int? id;
  double? price;
  int? orderDetailsId;
  int? productId;
  int? productAttributeId;
  int? productAttributeValueId;
  String? createdAt;
  String? updatedAt;
  Attribute2? attribute;
  AttributeValue? attributeValue;

  AttributesOrderDetails(
      {this.id,
        this.price,
        this.orderDetailsId,
        this.productId,
        this.productAttributeId,
        this.productAttributeValueId,
        this.createdAt,
        this.updatedAt,
        this.attribute,
        this.attributeValue});

  AttributesOrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'].toDouble();
    orderDetailsId = json['order_details_id'];
    productId = json['product_id'];
    productAttributeId = json['product_attribute_id'];
    productAttributeValueId = json['product_attribute_value_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    attribute = json['attribute'] != null
        ? new Attribute2.fromJson(json['attribute'])
        : null;
    attributeValue = json['attribute_value'] != null
        ?  AttributeValue.fromJson(json["attribute_value"])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['order_details_id'] = this.orderDetailsId;
    data['product_id'] = this.productId;
    data['product_attribute_id'] = this.productAttributeId;
    data['product_attribute_value_id'] = this.productAttributeValueId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.attribute != null) {
      data['attribute'] = this.attribute!.toJson();
    }
    if (this.attributeValue != null) {
      data['attribute_value'] = this.attributeValue!.toJson();
    }
    return data;
  }
}

class Attribute2 {
  int? id;
  int? productId;
  Title? title;
  int? required;
  int? multiSelect;
  int? overridePrice;
  String? createdAt;
  String? updatedAt;

  Attribute2(
      {this.id,
        this.productId,
        this.title,
        this.required,
        this.multiSelect,
        this.overridePrice,
        this.createdAt,
        this.updatedAt});

  Attribute2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    required = json['required'];
    multiSelect = json['multi_select'];
    overridePrice = json['override_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    data['required'] = this.required;
    data['multi_select'] = this.multiSelect;
    data['override_price'] = this.overridePrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
class AttributeValue {
  AttributeValue({
    this.id,
    this.productAttributeId,
    this.attributeValue,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  int ?id;
  int ?productAttributeId;
  Title? attributeValue;
  double? price;
  String ?createdAt;
  String ?updatedAt;

  factory AttributeValue.fromJson(Map<String, dynamic> json) => AttributeValue(
    id: json["id"],
    productAttributeId: json["product_attribute_id"],
    attributeValue: Title.fromJson(json["attribute_value"]),
    price: json["price"].toDouble(),
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_attribute_id": productAttributeId,
    "attribute_value": attributeValue!.toJson(),
    "price": price,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class Branch {
  Branch({
    this.id,
    this.title,
    this.address,
    this.rate,
    this.long,
    this.lat,
    this.popupCategoryTitle,
  });

  int ?id;
  Title? title;
  String ?address;
  String ?lat;
  String ?long;
  int ?rate;
  dynamic popupCategoryTitle;

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    id: json["id"],
    title: Title.fromJson(json["title"]),
    address: json["address"],
    lat: json["lat"],
    long: json["long"],
    rate: json["rate"],
    popupCategoryTitle: json["popup_category_title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title!.toJson(),
    "address": address,
    "rate": rate,
    "popup_category_title": popupCategoryTitle,
  };
}