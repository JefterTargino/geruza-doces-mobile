import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/home_controller.dart';
import 'package:hello_world/view_order.dart';
//import 'package:hello_world/home_controller.dart';

import '../pages_add/add_order.dart';
import '../pages_add/add_product.dart';
import '../view_product.dart';
import '../home_page.dart';

import 'package:http/http.dart' as http; //
import '../models/ProductModel.dart';
import 'dart:convert'; //

class ProductsTab extends StatefulWidget {
  const ProductsTab({Key? key}) : super(key: key);

  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
  @override
  void initState() {
    super.initState();
    futureProduct = getProduct();
  }

  late Future<List<ProductModel>> futureProduct;

  Future<List<ProductModel>> getProduct() async {
    final response = await http
        .get((Uri.parse('https://geruza-doces-api.herokuapp.com/product')));
    if (response.statusCode == 200) {
      final listProduct = (json.decode(response.body) as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return listProduct;
    } else {
      throw Exception(response.body);
    }
  }

  @override
  Widget build(BuildContext context) => Stack(children: <Widget>[
        Container(
            child: Scrollbar(
                child: FutureBuilder<List<ProductModel>>(
                    future: futureProduct,
                    builder:
                        (context, AsyncSnapshot<List<ProductModel>> snapshot) {
                      if (snapshot.hasData) {
                        List<ProductModel>? listProducts = snapshot.data;
                        if (listProducts!.length == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                            ),
                            child: Center(
                              child: Container(
                                width: 200,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFF002D60),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ),
                                  color: Colors.grey[200],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Sem Produtos',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        )),
                                    Icon(
                                      Icons.dangerous_outlined,
                                      color: Colors.red,
                                      size: 30.0,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            children: listProducts
                                .map(
                                  (ProductModel listProducts) => Card(
                                    elevation: 5,
                                    shadowColor:
                                        const Color.fromARGB(255, 0, 0, 0),
                                    color: const Color.fromARGB(
                                        255, 238, 234, 234),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ViewProduct()),
                                        );
                                      },
                                      child: //const Image(
                                          //     image: NetworkImage(
                                          //         'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                                          //     color: const Color.fromRGBO(255, 255, 255, 0.5),
                                          //     colorBlendMode: BlendMode.modulate)
                                          Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                  '${listProducts.nameProduct}',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                  ))),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        } //else
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Erro ao carregar os pedidos'),
                          //Text('${snapshot.error}');
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }))),
        Container(
          width: 400,
          height: 600,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddProduct()),
                    );
                  },
                ),
              ]),
        ),
      ]);
}
