import 'package:flutter/material.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({Key? key}) : super(key: key);

  @override
  _ViewProductState createState() => _ViewProductState();
}

var maskValue = MaskTextInputFormatter(
    mask: '##.##',
    filter: {"#": RegExp(r'^(\d{1,3}(\\d{3})*|\d+)(\.\d{2})?$')},
    type: MaskAutoCompletionType.lazy);

class _ViewProductState extends State<ViewProduct> {
  bool enableField = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizando produto'),
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
                          initialValue: 'Bolo de chocolate',
                          enabled: enableField,
                          decoration: const InputDecoration(
                              icon: Icon(
                                Icons.add_business_rounded,
                              ),
                              labelText: 'Nome do produto'),
                          maxLength: 30,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite o nome do produto';
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
                              return 'Por favor, digite o valor do produto';
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
                          initialValue: 'Bolo quadrado ou redondo',
                          enabled: enableField,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.addchart),
                              labelText: 'Descrição'),
                          maxLength: 70,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite a descrição do produto';
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
                        },
                        child: enableField == false
                            ? const Text('Editar Produto')
                            : const Text('Salvar Produto'),
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
                                        const Text('Deseja excluir o produto?'),
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
                        child: const Text('Excluir produto'),
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
