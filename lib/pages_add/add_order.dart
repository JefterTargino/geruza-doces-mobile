import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/home_controller.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter/services.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:select_form_field/select_form_field.dart';

import '../models/OrderController.dart';

class AddOrder extends StatefulWidget {
  const AddOrder({Key? key}) : super(key: key);

  @override
  _AddOrderState createState() => _AddOrderState();
}

var maskDate = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

var maskTime = MaskTextInputFormatter(
    mask: '##:##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

var maskValue = MaskTextInputFormatter(
    mask: '##.##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

//
final TextEditingController nameController = TextEditingController();
final TextEditingController dateController = TextEditingController();
final TextEditingController timeController = TextEditingController();
final TextEditingController productController = TextEditingController();
var amountController = TextEditingController();
final TextEditingController fillingController = TextEditingController();
var valueController = TextEditingController();
final TextEditingController commentsController = TextEditingController();
//

Future<OrderController> createOrder() async {
  final response = await http.post(
      (Uri.parse('https://geruza-doces-api.herokuapp.com/order/')),
      headers: {
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
  if (response.statusCode == 200 || response.statusCode == 201) {
    Fluttertoast.showToast(
      backgroundColor: Color(0xFF35bb70),
      msg: 'Pedido criado com sucesso!',
    );
    return OrderController.fromJson(jsonDecode(response.body));
  } else {
    Fluttertoast.showToast(
        backgroundColor: Color(0xFFFFC02A),
        msg: 'Por favor, preencher novamente!');
    return createOrder();
    // throw Exception();
  }
}

class _AddOrderState extends State<AddOrder> {
  late OrderController _order;

  @override
  void initState() {
    super.initState();
    nameController.clear();
    dateController.clear();
    timeController.clear();
    productController.clear();
    amountController.clear();
    fillingController.clear();
    valueController.clear();
    commentsController.clear();
  }

  final List<Map<String, dynamic>> _items = [
    {
      'value': '-',
      'label': '-',
    },
    {
      'value': 'Bolo de Pasta',
      'label': 'Bolo de Pasta',
    },
    {
      'value': 'Brigadeiro',
      'label': 'Brigadeiro',
    },
    {
      'value': 'Beijinho',
      'label': 'Beijinho',
    },
    {
      'value': 'Trufas',
      'label': 'Trufas',
    },
  ];

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color.fromARGB(255, 255, 96, 90),
        title: const Text('Fazendo pedido'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              //color: Color.fromARGB(100, 255, 176, 110),
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                              hintText: 'Jennyffer Roberta',
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
                          Flexible(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextFormField(
                                controller: dateController,
                                inputFormatters: [maskDate],
                                keyboardType: TextInputType.datetime,
                                decoration: const InputDecoration(
                                    hintText: 'dd/mm/aaaa',
                                    icon: Icon(Icons.today),
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
                                controller: timeController,
                                inputFormatters: [maskTime],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: '15:00',
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
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, bottom: 25.0),
                        child: SelectFormField(
                          type: SelectFormFieldType.dropdown,
                          icon: Icon(Icons.add_business_rounded),
                          labelText: 'Produto',
                          controller: productController,
                          items: _items,
                          onChanged: (String newValue) {
                            newValue = productController.text;
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
                          controller: fillingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              hintText: 'Chocolate com beijinho',
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
                          controller: valueController,
                          inputFormatters: [maskValue],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              prefixText: 'R\$ ',
                              hintText: '35.00',
                              icon: Icon(Icons.monetization_on),
                              labelText: 'Valor'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite o valor do pedido';
                            }
                            return null;
                          },
                          //maxLength: 10,
                        ),
                      ),
                    ),
                  ]),
                  Row(children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: TextFormField(
                          controller: commentsController,
                          maxLines: 2,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              hintText: 'Observações',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //       content: Text('Pedido sendo criado')),
                          // );
                          final OrderController order = await createOrder();
                          setState(() {
                            _order = order;
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Fazer pedido'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
