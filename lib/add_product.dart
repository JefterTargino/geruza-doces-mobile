import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

var maskValue = MaskTextInputFormatter(
    mask: '##.##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrando pedido'),
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
                          decoration: const InputDecoration(
                              hintText: 'Bolo de chocolate',
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
                          decoration: const InputDecoration(
                              prefixText: 'R\$ ',
                              hintText: '35.00',
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
                          maxLines: 2,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              hintText: 'Bolo quadrado ou redondo',
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
                      child: const Text('Cadastrar pedido'),
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
