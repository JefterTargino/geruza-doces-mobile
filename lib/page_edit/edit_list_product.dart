import 'package:flutter/material.dart';
import 'package:hello_world/models/ListModel.dart';
import 'package:hello_world/pages_view/view_order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import '../pages_add/add_list_product.dart';

class EditListProduct extends StatefulWidget {
  //const EditListProduct({Key? key}) : super(key: key);
  final int id;
  final bool option;
  EditListProduct({required this.id, required this.option});
  @override
  State<EditListProduct> createState() => _EditListProductState();
}

//Get de um pedido especifico
Future<ListModel> fetchListProductById(int id) async {
  final response = await http
      .get(Uri.parse('https://geruza-doces-api.herokuapp.com/listProduct/$id'));
  if (response.statusCode == 200) {
    return ListModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(Fluttertoast.showToast(
        backgroundColor: const Color(0xFFFFC02A), msg: response.body));
  }
}

final TextEditingController productController = TextEditingController();
final TextEditingController amountController = TextEditingController();
final TextEditingController fillingController = TextEditingController();
final TextEditingController commentsController = TextEditingController();

//Update de um produto da lista
Future<bool> updateProductList(int id) async {
  final response = await http.put(
      Uri.parse('https://geruza-doces-api.herokuapp.com/listProduct/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "name_product": productController.text,
        "amount": amountController.text,
        "filling": fillingController.text,
        "comments": commentsController.text,
      }));

  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    Fluttertoast.showToast(
      backgroundColor: const Color(0xFF35bb70),
      msg: 'Produto alterado com sucesso!',
    );
    return true;
  } else {
    Fluttertoast.showToast(
        backgroundColor: const Color(0xFFFFC02A), msg: 'Erro ao atualizar');
    return false;
  }
}

class _EditListProductState extends State<EditListProduct> {
  late String selectedValueP;

  @override
  void initState() {
    super.initState();
    fetchListProductById(widget.id);
    selectedValueP = '';
    getListProducts();
    //productController.clear();
  }

  List categoryItemList = [];

  Future getListProducts() async {
    var url = "https://geruza-doces-api.herokuapp.com/product/list";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryItemList = jsonData;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Future.delayed(
            const Duration(seconds: 2),
            () => Fluttertoast.showToast(
                  backgroundColor: const Color(0xFFFFC02A),
                  msg: 'Por favor, atualize o produto antes de voltar!',
                ));

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editando produto do pedido'),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<ListModel>(
              future: fetchListProductById(widget.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (productController.text.isEmpty) {
                    productController.text = '${snapshot.data!.nameProduct}';
                  }
                  amountController.text = '${snapshot.data!.amount}';
                  fillingController.text = '${snapshot.data!.filling}';
                  commentsController.text = '${snapshot.data!.comments}';
                  return Form(
                      key: _formKey,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(children: [
                                Flexible(
                                  flex: 6,
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, bottom: 25.0),
                                      child: DropdownButtonFormField(
                                        decoration: const InputDecoration(
                                          icon:
                                              Icon(Icons.add_business_rounded),
                                          labelText: 'Produto',
                                        ),
                                        isExpanded: true,
                                        value: snapshot.data!.nameProduct,
                                        items: categoryItemList.map((category) {
                                          return DropdownMenuItem(
                                              value: category['name_product'],
                                              child: Text(
                                                  category['name_product']));
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            productController.text =
                                                value.toString();
                                            selectedValueP = value.toString();
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Por favor, digite o produto';
                                          }
                                          return null;
                                        },
                                      )),
                                ),
                                Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: TextFormField(
                                      controller: amountController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          hintText: '1',
                                          icon: Icon(Icons.pin_outlined),
                                          labelText: 'Quantidade'),
                                      maxLength: 3,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, digite a quantidade';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: fillingController,
                                      //enabled: enableField,
                                      decoration: const InputDecoration(
                                          icon: Icon(Icons.food_bank),
                                          labelText: 'Recheio'),
                                      maxLength: 30,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, digite algum recheio';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      maxLines: 2,
                                      controller: commentsController,
                                      //enabled: enableField,
                                      decoration: const InputDecoration(
                                          icon: Icon(Icons.addchart),
                                          labelText: 'Observações'),
                                      maxLength: 70,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, digite alguma observação';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ]),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red)),
                                onPressed: () {
                                  setState(() {
                                    if (_formKey.currentState!.validate()) {
                                      updateProductList(widget.id);
                                      //enableField = !enableField;
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (BuildContext context) =>
                                      //             widget));
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  widget.option == true
                                                      ? ViewOrder(
                                                          id: snapshot
                                                              .data!.orderId!
                                                              .toInt())
                                                      : ViewListProduct(
                                                          id: snapshot
                                                              .data!.orderId!
                                                              .toInt())));
                                    }
                                  });
                                },
                                child: const Text('Atualizar produto'),
                              ),
                            ],
                          ),
                        ),
                      ));
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro ao visualizar o produto'),
                  );
                }
                return const SizedBox(
                  width: 420,
                  height: 700,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
