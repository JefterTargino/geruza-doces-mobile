class OrderController {
  int? id;
  String? nameClient;
  String? deliveryDate;
  String? deliveryTime;
  String? nameProduct;
  int? amount;
  String? filling;
  num? value;
  String? comments;
  bool? orderDelivered;
  String? createdAt;
  String? updatedAt;

  OrderController(
      {this.id,
      this.nameClient,
      this.deliveryDate,
      this.deliveryTime,
      this.nameProduct,
      this.amount,
      this.filling,
      this.value,
      this.comments,
      this.orderDelivered,
      this.createdAt,
      this.updatedAt});

  OrderController.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameClient = json['name_client'];
    deliveryDate = json['delivery_date'];
    deliveryTime = json['delivery_time'];
    nameProduct = json['name_product'];
    amount = json['amount'];
    filling = json['filling'];
    value = json['value'];
    comments = json['comments'];
    orderDelivered = json['order_delivered'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_client'] = this.nameClient;
    data['delivery_date'] = this.deliveryDate;
    data['delivery_time'] = this.deliveryTime;
    data['name_product'] = this.nameProduct;
    data['amount'] = this.amount;
    data['filling'] = this.filling;
    data['value'] = this.value;
    data['comments'] = this.comments;
    data['order_delivered'] = this.orderDelivered;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
