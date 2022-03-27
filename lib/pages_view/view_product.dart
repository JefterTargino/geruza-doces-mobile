import 'package:flutter/material.dart';
import 'package:hello_world/home_page.dart';
import 'package:hello_world/models/ProductModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/masks/masks.dart';

class ViewProduct extends StatefulWidget {
  //const ViewProduct({Key? key}) : super(key: key);
  final int id;
  ViewProduct({
    required this.id,
  });
  @override
  _ViewProductState createState() => _ViewProductState();
}

//Get de um produto especifico
Future<ProductModel> fetchProductById(int id) async {
  final response = await http.get(
      Uri.parse('https://geruza-doces-api-final.herokuapp.com/product/$id'));
  if (response.statusCode == 200) {
    return ProductModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(Fluttertoast.showToast(
        backgroundColor: const Color(0xFFFFC02A), msg: response.body));
  }
}

final TextEditingController nameController = TextEditingController();
var valueController = TextEditingController();
final TextEditingController commentsController = TextEditingController();

//Update de um produto
Future<bool> updateProduct(int id) async {
  final response = await http.put(
      Uri.parse('https://geruza-doces-api-final.herokuapp.com/product/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "name_product": nameController.text,
        "value": valueController.text,
        "comments": commentsController.text,
      }));

  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    Fluttertoast.showToast(
      backgroundColor: const Color(0xFF35bb70),
      msg: 'Produto alterado com sucesso!',
    );
    return true;
  } else {
    Fluttertoast.showToast(
        backgroundColor: const Color(0xFFFFC02A), msg: 'Erro ao atualizar');
    return false;
  }
}

//Delete de um produto
Future<ProductModel> deleteProduct(int id) async {
  final response = await http.delete(
    Uri.parse('https://geruza-doces-api-final.herokuapp.com/product/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    Fluttertoast.showToast(
      backgroundColor: const Color(0xFF35bb70),
      msg: 'Produto excluido com sucesso!',
    );
    return ProductModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(Fluttertoast.showToast(
        backgroundColor: const Color(0xFFFFC02A), msg: response.body));
  }
}

class _ViewProductState extends State<ViewProduct> {
  @override
  void initState() {
    super.initState();
    fetchProductById(widget.id);
  }

  bool enableField = false;

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
                    const HomePage(indextTab: 1)));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Visualizando produto'),
        ),
        body: SingleChildScrollView(
            child: FutureBuilder<ProductModel>(
                future: fetchProductById(widget.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    nameController.text = '${snapshot.data!.nameProduct}';
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
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      keyboardType: TextInputType.name,
                                      controller: nameController,
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
                                      controller: valueController,
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
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      keyboardType: TextInputType.text,
                                      maxLines: 2,
                                      controller: commentsController,
                                      enabled: enableField,
                                      decoration: const InputDecoration(
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
                              Center(
                                  child: Row(
                                children: [
                                  enableField == false
                                      ? ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.green)),
                                          onPressed: () {
                                            setState(() {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                enableField = !enableField;
                                              }
                                            });
                                          },
                                          child: const Text('Editar pedido'))
                                      : ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.red)),
                                          onPressed: () {
                                            setState(() {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                updateProduct(widget.id);
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
                                                    'Deseja excluir o produto?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Não'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      deleteProduct(widget.id);
                                                      await Future.delayed(
                                                          const Duration(
                                                              seconds: 1),
                                                          () => Navigator.of(
                                                                  context)
                                                              .pop());
                                                      Navigator.of(context)
                                                          .pop();
                                                      // Navigator.of(context)
                                                      //     .pop();
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  const HomePage(
                                                                      indextTab:
                                                                          1)));
                                                    },
                                                    child: const Text('Sim'),
                                                  ),
                                                ],
                                              ),
                                            )
                                        : null,
                                    child: const Text('Excluir produto'),
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
                      child: Text('Erro ao visualizar o produto'),
                    );
                  }
                  return const SizedBox(
                    width: 420,
                    height: 700,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                })),
      ),
    );
  }
}
