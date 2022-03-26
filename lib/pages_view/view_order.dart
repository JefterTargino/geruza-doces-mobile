import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/home_page.dart';
import 'package:hello_world/page_edit/edit_list_product.dart';
import 'package:hello_world/page_tabs/oders_tab.dart';
import 'package:http/http.dart' as http;
import '../../models/OrderController.dart';
import 'package:intl/intl.dart';
import 'package:hello_world/masks/masks.dart';

import '../pages_add/add_list_product.dart';

class ViewOrder extends StatefulWidget {
  //const ViewOrder({Key? key}) : super(key: key);
  final int id;
  ViewOrder({
    required this.id,
  });
  @override
  _ViewOrderState createState() => _ViewOrderState();
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

final TextEditingController nameController = TextEditingController();
final TextEditingController dateController = TextEditingController();
final TextEditingController timeController = TextEditingController();
final TextEditingController productController = TextEditingController();
var amountController = TextEditingController();
final TextEditingController fillingController = TextEditingController();
var valueController = TextEditingController();
final TextEditingController commentsController = TextEditingController();
final TextEditingController testeController = TextEditingController();
final TextEditingController phoneController = TextEditingController();

//Update de um pedido
Future<bool> updateOrder(int id) async {
  final response = await http.put(
      Uri.parse('https://geruza-doces-api-final.herokuapp.com/order/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "name_client": nameController.text,
        "delivery_date": dateController.text,
        "delivery_time": timeController.text,
        "phone": phoneController.text.toString().replaceAll(' ', ''),
        //"name_product": productController.text,
        //"amount": amountController.text,
        //"filling": fillingController.text,
        //"value": valueController.text,
        //"comments": commentsController.text,
      }));

  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    Fluttertoast.showToast(
      backgroundColor: const Color(0xFF35bb70),
      msg: 'Pedido alterado com sucesso!',
    );
    return true;
  } else {
    Fluttertoast.showToast(
        backgroundColor: const Color(0xFFFFC02A), msg: 'Erro ao atualizar');
    return false;
  }
}

//Delete de um pedido
Future<OrderController> deleteOrder(int id) async {
  final response = await http.delete(
    Uri.parse('https://geruza-doces-api-final.herokuapp.com/order/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    Fluttertoast.showToast(
      backgroundColor: const Color(0xFF35bb70),
      msg: 'Pedido cancelado com sucesso!',
    );
    return OrderController.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(Fluttertoast.showToast(
        backgroundColor: const Color(0xFFFFC02A), msg: response.body));
  }
}

class _ViewOrderState extends State<ViewOrder> {
  bool enableField = false;
  late String selectedValueP;
  late Future lista;
  late DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      //print(selectedDate.toLocal());
      setState(() {
        selectedDate = picked;
        dateController.text =
            DateFormat.yMd('pt_BR').format(selectedDate).toString();
        //print('TEste : ${dateController.text}');
      });
      //print(selectedDate);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrderById(widget.id);
    getListProducts();
    selectedValueP = '';
    productController.clear();
    lista = fetchOrderById(widget.id);
    //dateController.clear();
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
    //print(categoryItemList);
  }

  Future<void> _refresh() async {
    var newList =
        await Future.delayed(const Duration(seconds: 1), () => fetchOrderById);
    setState(() {
      lista = newList.call(widget.id);
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    const HomePage(indextTab: 0)));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Visualizando pedido'),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<OrderController>(
            future: fetchOrderById(widget.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                nameController.text = '${snapshot.data!.nameClient}';
                if (enableField == false) {
                  DateTime? dateConvert =
                      DateTime.tryParse(snapshot.data!.deliveryDate.toString());
                  dateController.text =
                      DateFormat.yMd('pt_BR').format(dateConvert!).toString();
                }
                timeController.text = '${snapshot.data!.deliveryTime}';
                phoneController.text = '${snapshot.data!.phone}';
                //print('Valor selecionado: ${selectedValueP}');
                // if (productController.text == null) {
                //   productController.text = '${snapshot.data!.nameProduct}';
                // } else if (enableField == false) {
                //   productController.text = '${snapshot.data!.nameProduct}';
                // }
                //print('Controller .text : ${productController.text}');
                //selectedValueP = productController.text;
                //print('Valor selecionado: ${selectedValueP}');
                // amountController.text = '${snapshot.data!.amount}';
                // fillingController.text = '${snapshot.data!.filling}';
                // valueController.text = '${snapshot.data!.value}';
                // commentsController.text = '${snapshot.data!.comments}';
                return Form(
                  key: _formKey,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          const Text(
                            'Dados do cliente',
                            style: TextStyle(fontSize: 20),
                          ),
                          Row(children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.name,
                                  controller: nameController,
                                  enabled: enableField,
                                  decoration: const InputDecoration(
                                      icon: Icon(
                                        Icons.person,
                                      ),
                                      labelText: 'Nome do cliente'),
                                  maxLength: 30,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite o nome do cliente';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ]),
                          Row(children: [
                            Flexible(
                              child: Row(
                                children: [
                                  // SizedBox(
                                  //   width: 40,
                                  //   child: IconButton(
                                  //     padding: const EdgeInsets.only(left: 4.0),
                                  //     alignment: Alignment.topLeft,
                                  //     onPressed: enableField == false
                                  //         ? null
                                  //         : () => _selectDate(context),
                                  //     //onPressed: () => _selectDate(context),
                                  //     icon: const Icon(Icons.today),
                                  //     color: const Color.fromARGB(
                                  //         255, 121, 119, 119),
                                  //     // color: enableField == false
                                  //     //     ? const Color.fromARGB(
                                  //     //         255, 121, 119, 119)
                                  //     //     : const Color.fromARGB(
                                  //     //         255, 255, 96, 90),
                                  //   ),
                                  // ),
                                  Flexible(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: TextFormField(
                                        inputFormatters: [maskDate],
                                        keyboardType: TextInputType.datetime,
                                        controller: dateController,
                                        enabled: enableField,
                                        decoration: InputDecoration(
                                            icon: IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                alignment: Alignment.topRight,
                                                onPressed: enableField == false
                                                    ? null
                                                    : () =>
                                                        _selectDate(context),
                                                icon: const Icon(Icons.today)),
                                            hintText: 'dd/mm/aaaa',
                                            labelText: 'Data de entrega'),
                                        maxLength: 10,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, digite a data de entrega';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 1.0),
                                      child: TextFormField(
                                        inputFormatters: [maskTime],
                                        keyboardType: TextInputType.number,
                                        controller: timeController,
                                        enabled: enableField,
                                        decoration: const InputDecoration(
                                            icon: Icon(Icons.access_alarm),
                                            labelText: 'Horário de entrega'),
                                        maxLength: 5,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, digite a hora de entrega';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          Row(children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: TextFormField(
                                  enabled: enableField,
                                  controller: phoneController,
                                  inputFormatters: [maskPhone],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      hintText: '84911223344',
                                      icon: Icon(Icons.phone_android),
                                      labelText: 'Celular'),
                                  maxLength: 13,
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Por favor, digite o numero do telefone';
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ),
                            ),
                          ]),
                          const Text(
                            'Relação de produtos',
                            style: TextStyle(fontSize: 20),
                          ),
                          ListView.builder(
                              //scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.listProduct?.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  enabled: enableField,
                                  contentPadding:
                                      const EdgeInsets.only(left: 5.0),
                                  horizontalTitleGap: 0,
                                  leading:
                                      const Icon(Icons.add_business_rounded),
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
                                            //Navigator.pop(context);
                                            print(snapshot
                                                .data!
                                                .listProduct![index]
                                                .nameProduct);
                                            // print(categoryItemList.any(
                                            //     (element) =>
                                            //         element['name_product'] ==
                                            //         snapshot
                                            //             .data!
                                            //             .listProduct![index]
                                            //             .nameProduct));

                                            //categoryItemList.isEmpty
                                            categoryItemList.any((element) =>
                                                    element['name_product'] ==
                                                    snapshot
                                                        .data!
                                                        .listProduct![index]
                                                        .nameProduct)
                                                ? Navigator.push(
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
                                                              option: true,
                                                            )),
                                                  )
                                                : Fluttertoast.showToast(
                                                    backgroundColor:
                                                        const Color(0xFFFFC02A),
                                                    msg:
                                                        'Produto não cadastrado, não possível alterar!',
                                                  );
                                          },
                                          child: const Text('Alterar produto'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteProduct(snapshot
                                                .data!.listProduct![index].id!
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
                                          child: const Text('Excluir produto'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          Text(
                              'Valor total: R\$ ${snapshot.data!.sum ?? '0.00'}',
                              style: const TextStyle(fontSize: 20)),
                          enableField == false
                              ? const Text('')
                              : IconButton(
                                  color: Colors.blue,
                                  alignment: Alignment.center,
                                  iconSize: 30,
                                  //padding: const EdgeInsets.only(left: 10.0),
                                  onPressed: () async {
                                    categoryItemList.isEmpty
                                        ? Fluttertoast.showToast(
                                            backgroundColor:
                                                const Color(0xFFFFC02A),
                                            msg: 'Sem produtos cadastrados!',
                                          )
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewListProduct(
                                                        id: snapshot.data!.id!
                                                            .toInt())),
                                          );
                                    //if (_formKey.currentState!
                                    //    .validate()) {
                                    //  final ListModel listProduct =
                                    //      await createListProduct();
                                    //  setState(() {
                                    //    _listProduct = listProduct;
                                    //  });
                                    // }
                                  },
                                  icon: const Icon(Icons.add_circle)),
                          Center(
                              child: Row(
                            children: [
                              enableField == false
                                  ? ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.green)),
                                      onPressed:
                                          snapshot.data!.orderDelivered == false
                                              ? () {
                                                  setState(() {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      enableField =
                                                          !enableField;
                                                    }
                                                  });
                                                }
                                              : null,
                                      child: const Text('Editar pedido'))
                                  : ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.red)),
                                      onPressed: () {
                                        setState(() {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            updateOrder(widget.id);
                                            enableField = !enableField;
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        widget));
                                          }
                                        });
                                      },
                                      child: const Text('Salvar Pedido'),
                                    ),
                              const Spacer(),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                255, 255, 176, 110))),
                                onPressed: enableField == false
                                    ? () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text('Alerta'),
                                            content: const Text(
                                                'Deseja cancelar o pedido?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Não'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  deleteOrder(widget.id);
                                                  //Navigator.pop(context);
                                                  //Navigator.pop(context);
                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 1),
                                                      () =>
                                                          Navigator.of(context)
                                                              .pop());
                                                  Navigator.of(context).pop();
                                                  //Navigator.of(context).pop();
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              const HomePage(
                                                                  indextTab:
                                                                      0)));
                                                },
                                                child: const Text('Sim'),
                                              ),
                                            ],
                                          ),
                                        )
                                    : null,
                                child: const Text('Cancelar pedido'),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Erro ao visualizar o pedido'),
                );
              }
              return const SizedBox(
                width: 420,
                height: 700,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
