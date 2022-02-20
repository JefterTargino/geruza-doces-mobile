class ProductModel {
  int? id;
  String? nameProduct;
  double? value;
  String? comments;
  String? createdAt;
  String? updatedAt;

  ProductModel(
      {this.id,
      this.nameProduct,
      this.value,
      this.comments,
      this.createdAt,
      this.updatedAt});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameProduct = json['name_product'];
    value = double.parse(json['value'].toString());
    comments = json['comments'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_product'] = this.nameProduct;
    data['value'] = this.value;
    data['comments'] = this.comments;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
