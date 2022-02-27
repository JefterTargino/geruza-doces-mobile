import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../models/OrderController.dart';
import 'package:intl/intl.dart';
import 'package:hello_world/masks/masks.dart';

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
      .get(Uri.parse('https://geruza-doces-api.herokuapp.com/order/$id'));
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

//Update de um pedido
Future<bool> updateOrder(int id) async {
  final response = await http.put(
      Uri.parse('https://geruza-doces-api.herokuapp.com/order/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "name_client": nameController.text,
        "delivery_date": dateController.text,
        "delivery_time": timeController.text,
        "name_product": productController.text,
        "amount": amountController.text,
        "filling": fillingController.text,
        "value": valueController.text,
        "comments": commentsController.text,
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
    Uri.parse('https://geruza-doces-api.herokuapp.com/order/$id'),
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
    //dateController.clear();
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
    //print(categoryItemList);
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                dateController.text = '${snapshot.data!.deliveryDate}';
              }
              timeController.text = '${snapshot.data!.deliveryTime}';
              //print('Valor selecionado: ${selectedValueP}');
              if (productController.text == null) {
                productController.text = '${snapshot.data!.nameProduct}';
              } else if (enableField == false) {
                productController.text = '${snapshot.data!.nameProduct}';
              }
              //print('Controller .text : ${productController.text}');
              //selectedValueP = productController.text;
              //print('Valor selecionado: ${selectedValueP}');
              amountController.text = '${snapshot.data!.amount}';
              fillingController.text = '${snapshot.data!.filling}';
              valueController.text = '${snapshot.data!.value}';
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
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextFormField(
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
                                SizedBox(
                                  width: 40,
                                  child: IconButton(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    alignment: Alignment.topLeft,
                                    onPressed: () => _selectDate(context),
                                    icon: const Icon(Icons.today),
                                    color: enableField == false
                                        ? const Color.fromARGB(
                                            255, 121, 119, 119)
                                        : const Color.fromARGB(
                                            255, 255, 96, 90),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: TextFormField(
                                      inputFormatters: [maskDate],
                                      keyboardType: TextInputType.datetime,
                                      controller: dateController,
                                      enabled: enableField,
                                      decoration: const InputDecoration(
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
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, bottom: 25.0),
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.add_business_rounded),
                                  labelText: 'Produto',
                                ),
                                isExpanded: true,
                                value: snapshot.data!.nameProduct,
                                items: categoryItemList.map((category) {
                                  return DropdownMenuItem(
                                      value: category['name_product'],
                                      child: Text(category['name_product']));
                                }).toList(),
                                onChanged: enableField == false
                                    ? null
                                    : (value) {
                                        setState(() {
                                          productController.text =
                                              value.toString();
                                          selectedValueP = value.toString();
                                        });
                                      },
                                validator: (value) {
                                  if (value == '-') {
                                    return 'Por favor, digite o produto';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: amountController,
                                enabled: enableField,
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
                                keyboardType: TextInputType.text,
                                controller: fillingController,
                                enabled: enableField,
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
                                inputFormatters: [maskValue],
                                keyboardType: TextInputType.number,
                                controller: valueController,
                                enabled: enableField,
                                decoration: const InputDecoration(
                                    prefixText: 'R\$ ',
                                    icon: Icon(Icons.monetization_on),
                                    labelText: 'Valor'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, digite o valor do pedido';
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
                                enabled: enableField,
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
                        Center(
                            child: Row(
                          children: [
                            enableField == false
                                ? ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.green)),
                                    onPressed: () {
                                      setState(() {
                                        if (_formKey.currentState!.validate()) {
                                          enableField = !enableField;
                                        }
                                      });
                                    },
                                    child: const Text('Editar pedido'))
                                : ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.red)),
                                    onPressed: () {
                                      setState(() {
                                        if (_formKey.currentState!.validate()) {
                                          updateOrder(widget.id);
                                          enableField = !enableField;
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
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
                                              onPressed: () {
                                                deleteOrder(widget.id);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
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
    );
  }
}
