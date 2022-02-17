import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

class _AddOrderState extends State<AddOrder> {
  // Initial Selected Value
  String dropdownvalue = '-';

  // List of items in our dropdown menu
  var items = [
    '-',
    'Bolo de Glacê',
    'Bolo de Pasta',
    'Brigadeiro',
    'Beijinho',
    'Trufas',
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
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, bottom: 25.0),
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.add_business_rounded),
                            labelText: 'Produto',
                          ),
                          value: dropdownvalue,
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == '-') {
                              return 'Por favor, digite o produto';
                            }
                            return null;
                          },
                        ),
                        // TextFormField(
                        //   keyboardType: TextInputType.text,
                        //   decoration: const InputDecoration(
                        //       hintText: 'Bolo de Glacê',
                        //       icon: Icon(Icons.add_business_rounded),
                        //       labelText: 'Produto'),
                        //   maxLength: 30,
                        // ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: TextFormField(
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tudo validado')),
                          );
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
