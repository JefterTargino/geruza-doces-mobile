class ListModel {
  int? id;
  int? orderId;
  String? nameProduct;
  num? amount;
  String? filling;
  num? value;
  String? comments;
  String? createdAt;
  String? updatedAt;

  ListModel(
      {this.id,
      this.orderId,
      this.nameProduct,
      this.amount,
      this.filling,
      this.value,
      this.comments,
      this.createdAt,
      this.updatedAt});

  ListModel.fromJson(Map<String, dynamic> json) {
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
