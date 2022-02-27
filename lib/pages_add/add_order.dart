import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
final TextEditingController productController = TextEditingController();
final TextEditingController amountController = TextEditingController();
final TextEditingController fillingController = TextEditingController();
var valueController = TextEditingController();
final TextEditingController commentsController = TextEditingController();

class _AddOrderState extends State<AddOrder> {
  late String selectedValueP;
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
          "name_product": selectedValueP,
          "amount": int.parse(amountController.text),
          "filling": fillingController.text,
          "value": double.parse(valueController.text),
          "comments": commentsController.text,
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
    productController.clear();
    amountController.clear();
    fillingController.clear();
    valueController.clear();
    commentsController.clear();
    getListProducts();
    selectedValueP = '';
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
                          SizedBox(
                            width: 40,
                            child: IconButton(
                              padding: const EdgeInsets.only(left: 4.0),
                              alignment: Alignment.topLeft,
                              onPressed: () => _selectDate(context),
                              icon: const Icon(Icons.today),
                              color: enableField == false
                                  ? const Color.fromARGB(255, 121, 119, 119)
                                  : const Color.fromARGB(255, 255, 96, 90),
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextFormField(
                                onTap: () {
                                  setState(() {
                                    enableField = !enableField;
                                  });
                                },
                                controller: dateController,
                                inputFormatters: [maskDate],
                                keyboardType: TextInputType.datetime,
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
                            flex: 4,
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
                      flex: 6,
                      child: Padding(
                          padding:
                              const EdgeInsets.only(left: 5.0, bottom: 25.0),
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.add_business_rounded),
                              labelText: 'Produto',
                            ),
                            isExpanded: true,
                            items: categoryItemList.map((category) {
                              return DropdownMenuItem(
                                  value: category['name_product'],
                                  child: Text(category['name_product']));
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
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
