class OrderController {
  int? id;
  String? nameClient;
  String? deliveryDate;
  String? deliveryTime;
  String? phone;
  bool? orderDelivered;
  String? createdAt;
  String? updatedAt;
  num? sum;
  List<ListProduct>? listProduct;

  OrderController(
      {this.id,
      this.nameClient,
      this.deliveryDate,
      this.deliveryTime,
      this.phone,
      this.orderDelivered,
      this.createdAt,
      this.updatedAt,
      this.sum,
      this.listProduct});

  OrderController.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameClient = json['name_client'];
    deliveryDate = json['delivery_date'];
    deliveryTime = json['delivery_time'];
    phone = json['phone'];
    orderDelivered = json['order_delivered'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sum = json['sum'];
    if (json['listProduct'] != null) {
      listProduct = <ListProduct>[];
      json['listProduct'].forEach((v) {
        listProduct!.add(new ListProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_client'] = this.nameClient;
    data['delivery_date'] = this.deliveryDate;
    data['delivery_time'] = this.deliveryTime;
    data['phone'] = this.phone;
    data['order_delivered'] = this.orderDelivered;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['sum'] = this.sum;
    if (this.listProduct != null) {
      data['listProduct'] = this.listProduct!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListProduct {
  int? id;
  int? orderId;
  String? nameProduct;
  num? amount;
  String? filling;
  num? value;
  String? comments;
  String? createdAt;
  String? updatedAt;

  ListProduct(
      {this.id,
      this.orderId,
      this.nameProduct,
      this.amount,
      this.filling,
      this.value,
      this.comments,
      this.createdAt,
      this.updatedAt});

  ListProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    nameProduct = json['name_product'];
    amount = json['amount'];
    filling = json['filling'];
    value = json['value'];
    comments = json['comments'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['name_product'] = this.nameProduct;
    data['amount'] = this.amount;
    data['filling'] = this.filling;
    data['value'] = this.value;
    data['comments'] = this.comments;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
