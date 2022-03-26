import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/models/ListModel.dart';
import 'package:hello_world/pages_view/view_order.dart';
import 'package:http/http.dart' as http;
import '../../models/OrderController.dart';
import 'package:intl/intl.dart';
import 'package:hello_world/masks/masks.dart';

import '../page_edit/edit_list_product.dart';

class ViewListProduct extends StatefulWidget {
  //const ViewListProduct({ Key? key }) : super(key: key);
  final int id;
  ViewListProduct({
    required this.id,
  });
  @override
  State<ViewListProduct> createState() => _ViewListProductState();
}

//Get de um pedido especifico
Future<OrderController> fetchOrderById(int id) async {
  final response = await http
      .get(Uri.parse('https://geruza-doces-api-final.herokuapp.com/order/$id'));
  if (response.statusCode == 200) {
    return OrderController.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(Fluttertoast.showToast(
        backgroundColor: const Color(0xFFFFC02A), msg: response.body));
  }
}

//Delete de um pedido da lista
Future<ListModel> deleteProduct(int id) async {
  final response = await http.delete(
    Uri.parse('https://geruza-doces-api-final.herokuapp.com/listProduct/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    Fluttertoast.showToast(
      backgroundColor: const Color(0xFF35bb70),
      msg: 'Produto excluido com sucesso!',
    );
    return ListModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(Fluttertoast.showToast(
        backgroundColor: const Color(0xFFFFC02A), msg: response.body));
  }
}

final TextEditingController orderController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController amountController = TextEditingController();
final TextEditingController fillingController = TextEditingController();
final TextEditingController commentsController = TextEditingController();

class _ViewListProductState extends State<ViewListProduct> {
  late String selectedValueP;

  Future<ListModel> createListProduct() async {
    final response = await http.post(
        (Uri.parse(
            'https://geruza-doces-api-final.herokuapp.com/listProduct/')),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "order_id": widget.id,
          "name_product": selectedValueP,
          "amount": double.parse(amountController.text),
          "filling": fillingController.text,
          "comments": commentsController.text,
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      Fluttertoast.showToast(
        backgroundColor: const Color(0xFF35bb70),
        msg: 'Pedido criado com sucesso!',
      );
      return ListModel.fromJson(jsonDecode(response.body));
    } else {
      Fluttertoast.showToast(
          backgroundColor: const Color(0xFFFFC02A),
          msg: 'Por favor, preencher novamente!');
      return createListProduct();
    }
  }

  late ListModel _listProduct;
  late Future lista;
  @override
  void initState() {
    super.initState();
    amountController.clear();
    fillingController.clear();
    commentsController.clear();
    fetchOrderById(widget.id);
    getListProducts();
    selectedValueP = '';
    lista = fetchOrderById(widget.id);
  }

  List categoryItemList = [];

  Future getListProducts() async {
    var url = "https://geruza-doces-api-final.herokuapp.com/product/list";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryItemList = jsonData;
      });
    }
  }

  Future<void> _refresh() async {
    var newList =
        await Future.delayed(const Duration(seconds: 1), () => fetchOrderById);
    setState(() {
      lista = newList.call(widget.id);
    });
  }

  final dropdownState = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Future.delayed(
            const Duration(seconds: 2),
            () => Fluttertoast.showToast(
                  backgroundColor: const Color(0xFFFFC02A),
                  msg: 'Por favor, finalize o pedido antes de voltar!',
                ));

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Adicionando produtos'),
        ),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            reverse: true,
            child: FutureBuilder<OrderController>(
              future: fetchOrderById(widget.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  OrderController? teste = snapshot.data;
                  if (teste!.listProduct!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Center(
                            child: Container(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Container(
                                width: 400,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF002D60),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ),
                                  color: Colors.grey[200],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('Sem produtos cadastrados',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        )),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.dangerous_outlined,
                                        color: Colors.red,
                                        size: 30.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(children: [
                                Flexible(
                                  flex: 6,
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, bottom: 25.0),
                                      child: DropdownButtonFormField(
                                        key: dropdownState,
                                        decoration: const InputDecoration(
                                          icon:
                                              Icon(Icons.add_business_rounded),
                                          labelText: 'Produto',
                                        ),
                                        isExpanded: true,
                                        items: categoryItemList.map((category) {
                                          return DropdownMenuItem(
                                              value: category['name_product'],
                                              child: Text(
                                                  category['name_product']));
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedValueP = value.toString();
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Por favor, escolha o produto';
                                          }
                                          return null;
                                        },
                                      )),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: TextFormField(
                                      controller: amountController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
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
                                      textCapitalization:
                                          TextCapitalization.sentences,
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
                                      textCapitalization:
                                          TextCapitalization.sentences,
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
                              Row(children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.green)),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final ListModel listProduct =
                                          await createListProduct();
                                      amountController.clear();
                                      fillingController.clear();
                                      commentsController.clear();
                                      dropdownState.currentState!
                                          .didChange(null);
                                      setState(() {
                                        _listProduct = listProduct;
                                      });
                                    }
                                  },
                                  child: const Text('Adicionar ao carrinho'),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate() &&
                                        teste.listProduct!.isNotEmpty) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else {
                                      Fluttertoast.showToast(
                                        backgroundColor:
                                            const Color(0xFFFFC02A),
                                        msg: 'Adicionar algum produto!',
                                      );
                                    }
                                  },
                                  child: const Text('Fazer pedido'),
                                ),
                              ])
                            ],
                          ),
                        )),
                      ),
                    );
                  } else {
                    return Form(
                        key: _formKey,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                ListView.builder(
                                    //scrollDirection: Axis.vertical,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        snapshot.data!.listProduct?.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        horizontalTitleGap: 0,
                                        leading: const Icon(
                                            Icons.add_business_rounded),
                                        title: Text(
                                            'Produto: ${snapshot.data!.listProduct![index].nameProduct}'),
                                        subtitle: Text(
                                            'Quantidade: ${snapshot.data!.listProduct![index].amount}\nRecheio: ${snapshot.data!.listProduct![index].filling}\nObservações: ${snapshot.data!.listProduct![index].comments}\nValor: R\$ ${snapshot.data!.listProduct![index].value}'),
                                        onTap: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text('Alerta'),
                                            content: const Text(
                                                'Quer alterar ou excluir produto?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditListProduct(
                                                                id: snapshot
                                                                    .data!
                                                                    .listProduct![
                                                                        index]
                                                                    .id!
                                                                    .toInt(),
                                                                option: false)),
                                                  );
                                                },
                                                child: const Text(
                                                    'Alterar produto'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  deleteProduct(snapshot.data!
                                                      .listProduct![index].id!
                                                      .toInt());
                                                  //updateOrder(listOrders.id!.toInt());
                                                  // Navigator.pushReplacement(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (BuildContext
                                                  //                 context) =>
                                                  //             widget));
                                                  Navigator.pop(context);
                                                  _refresh();
                                                },
                                                child: const Text(
                                                    'Excluir produto'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                Text('Valor total: R\$ ${snapshot.data!.sum}',
                                    style: const TextStyle(fontSize: 20)),
                                Row(children: [
                                  Flexible(
                                    flex: 6,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, bottom: 25.0),
                                        child: DropdownButtonFormField(
                                          key: dropdownState,
                                          decoration: const InputDecoration(
                                            icon: Icon(
                                                Icons.add_business_rounded),
                                            labelText: 'Produto',
                                          ),
                                          isExpanded: true,
                                          items:
                                              categoryItemList.map((category) {
                                            return DropdownMenuItem(
                                                value: category['name_product'],
                                                child: Text(
                                                    category['name_product']));
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedValueP = value.toString();
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Por favor, escolha o produto';
                                            }
                                            return null;
                                          },
                                        )),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: TextFormField(
                                        controller: amountController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
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
                                        textCapitalization:
                                            TextCapitalization.sentences,
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
                                        textCapitalization:
                                            TextCapitalization.sentences,
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
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.green)),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          final ListModel listProduct =
                                              await createListProduct();
                                          amountController.clear();
                                          fillingController.clear();
                                          commentsController.clear();
                                          dropdownState.currentState!
                                              .didChange(null);
                                          setState(() {
                                            _listProduct = listProduct;
                                          });
                                        }
                                      },
                                      child:
                                          const Text('Adicionar ao carrinho'),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    ViewOrder(id: widget.id)));
                                      },
                                      child: const Text('Finalizar pedido'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
                  }
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro ao carregar os produtos'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )),
      ),
    );
  }
}
