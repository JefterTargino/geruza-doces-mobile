import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/models/ProductModel.dart';
import 'package:hello_world/pages_view/view_product.dart';
import 'package:http/http.dart' as http;
import '../masks/masks.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

final TextEditingController nameProductController = TextEditingController();
var valueController = TextEditingController();
final TextEditingController commentsController = TextEditingController();

Future<ProductModel> createProduct() async {
  final response = await http.post(
      (Uri.parse('https://geruza-doces-api-final.herokuapp.com/product/')),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "name_product": nameProductController.text,
        "value": double.parse(valueController.text),
        "comments": commentsController.text,
      }));
  if (response.statusCode == 200 || response.statusCode == 201) {
    Fluttertoast.showToast(
      backgroundColor: const Color(0xFF35bb70),
      msg: 'Produto cadastrado com sucesso!',
    );
    return ProductModel.fromJson(jsonDecode(response.body));
  } else {
    Fluttertoast.showToast(
        backgroundColor: const Color(0xFFFFC02A),
        msg: 'Por favor, preencher novamente!');
    return createProduct();
  }
}

class _AddProductState extends State<AddProduct> {
  late ProductModel _product;

  @override
  void initState() {
    super.initState();
    nameProductController.clear();
    valueController.clear();
    commentsController.clear();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrando produto'),
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
                          textCapitalization: TextCapitalization.sentences,
                          controller: nameProductController,
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
                          textCapitalization: TextCapitalization.sentences,
                          controller: commentsController,
                          maxLines: 2,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              hintText: 'Bolo quadrado ou redondo',
                              icon: Icon(Icons.addchart),
                              labelText: 'Descrição'),
                          maxLength: 70,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Por favor, digite a descrição do produto';
                          //   }
                          //   return null;
                          // },
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
                          //       content: Text('Produto sendo cadastrado')),
                          // );
                          final ProductModel product = await createProduct();
                          setState(() {
                            _product = product;
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ViewProduct(id: product.id!.toInt())),
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
