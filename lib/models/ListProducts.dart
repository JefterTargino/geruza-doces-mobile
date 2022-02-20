class listProducts {
  int? id;
  String? nameProduct;

  listProducts({this.id, this.nameProduct});

  listProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameProduct = json['name_product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_product'] = this.nameProduct;
    return data;
  }
}
