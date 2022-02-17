import 'package:flutter/material.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ViewOrder extends StatefulWidget {
  const ViewOrder({Key? key}) : super(key: key);

  @override
  _ViewOrderState createState() => _ViewOrderState();
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

class _ViewOrderState extends State<ViewOrder> {
  bool enableField = false;

  // Initial Selected Value
  String dropdownvalue = 'Bolo de Pasta';

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
        title: const Text('Visualizando pedido'),
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
                          keyboardType: TextInputType.name,
                          initialValue: 'Jefter Roberto Mota Targino',
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
                          Flexible(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TextFormField(
                                inputFormatters: [maskDate],
                                keyboardType: TextInputType.datetime,
                                initialValue: '15/02/2022',
                                enabled: enableField,
                                decoration: const InputDecoration(
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
                                initialValue: '15:00',
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
                          onChanged: enableField == false
                              ? null
                              : (String? newValue) {
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
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: '01',
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
                          initialValue: 'Chocolate com beijinho',
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
                          initialValue: '35.00',
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
                          keyboardType: TextInputType.text,
                          maxLines: 2,
                          initialValue:
                              'Cliente solicitou as plaquinhas do Flamengo Bicampeão Mundial',
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
                      //padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: enableField == false
                                ? MaterialStateProperty.all<Color>(Colors.green)
                                : MaterialStateProperty.all<Color>(Colors.red)),
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState!.validate()) {
                              enableField = !enableField;
                            }
                          });
                          //if (_formKey.currentState!.validate()) {}
                        },
                        child: enableField == false
                            ? const Text('Editar pedido')
                            : const Text('Salvar Pedido'),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 255, 176, 110))),
                        onPressed: enableField == false
                            ? () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Alerta'),
                                    content:
                                        const Text('Deseja cancelar o pedido?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Não'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // ignore: avoid_print
                                          print('Sim');
                                        },
                                        child: const Text('Sim'),
                                      ),
                                    ],
                                  ),
                                )
                            //{ if (_formKey.currentState!.validate()) {} }
                            : null,
                        child: const Text('Cancelar pedido'),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
