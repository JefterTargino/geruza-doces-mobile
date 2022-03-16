import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/pages_add/add_list_product.dart';
import 'package:http/http.dart' as http;
import '../models/OrderController.dart';
import 'package:intl/intl.dart';
import '../masks/masks.dart';
import 'package:flutter/foundation.dart';

class AddOrder extends StatefulWidget {
  const AddOrder({Key? key}) : super(key: key);

  @override
  _AddOrderState createState() => _AddOrderState();
}

final TextEditingController nameController = TextEditingController();
final TextEditingController dateController = TextEditingController();
final TextEditingController timeController = TextEditingController();
final TextEditingController phoneController = TextEditingController();

class _AddOrderState extends State<AddOrder> {
  bool enableField = false;
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
          "phone": phoneController.text.toString().replaceAll(' ', ''),
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      Fluttertoast.showToast(
        backgroundColor: const Color(0xFF35bb70),
        msg: 'Pedido criado com sucesso!',
      );
      return OrderController.fromJson(jsonDecode(response.body));
    } else {
      Fluttertoast.showToast(
          backgroundColor: const Color(0xFFFFC02A),
          msg: 'Por favor, preencher novamente!');
      return createOrder();
    }
  }

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

  late OrderController _order;

  @override
  void initState() {
    super.initState();
    nameController.clear();
    dateController.clear();
    timeController.clear();
    phoneController.clear();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fazendo pedido'),
      ),
      body: SingleChildScrollView(
        child: Form(
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
                          // SizedBox(
                          //   width: 40,
                          //   child: IconButton(
                          //     padding: const EdgeInsets.only(left: 4.0),
                          //     alignment: Alignment.topLeft,
                          //     onPressed: () => _selectDate(context),
                          //     icon: const Icon(Icons.today),
                          //     color: enableField == false
                          //         ? const Color.fromARGB(255, 121, 119, 119)
                          //         : const Color.fromARGB(255, 255, 96, 90),
                          //   ),
                          // ),
                          Flexible(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextFormField(
                                controller: dateController,
                                inputFormatters: [maskDate],
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                    icon: IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        alignment: Alignment.topRight,
                                        onPressed: () => _selectDate(context),
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
                        ],
                      ),
                    ),
                  ]),
                  Row(children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: TextFormField(
                          controller: phoneController,
                          inputFormatters: [maskPhone],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: '84911223344',
                              icon: Icon(Icons.phone_android),
                              labelText: 'Celular'),
                          maxLength: 13,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite o numero do telefone';
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ViewListProduct(id: order.id!.toInt())),
                          );
                        }
                      },
                      child: const Text('Adicionar produtos'),
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
