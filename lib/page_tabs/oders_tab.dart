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
import '../models/OrderController.dart'; //
import 'dart:convert'; //

class OdersTab extends StatefulWidget {
  const OdersTab({Key? key}) : super(key: key);

  @override
  _OdersTabState createState() => _OdersTabState();
}

class _OdersTabState extends State<OdersTab> {
  bool enableField = false;

  bool expandedTile = false;
  @override
  void initState() {
    super.initState();
    futureOrder = getOrder();
  }

  late Future<List<OrderController>> futureOrder;

  Future<List<OrderController>> getOrder() async {
    //List<OrderController> listOrder = [];
    final response = await http
        .get((Uri.parse('https://geruza-doces-api.herokuapp.com/order')));
    if (response.statusCode == 200) {
      final listOrder = (json.decode(response.body) as List)
          .map((e) => OrderController.fromJson(e))
          .toList();
      return listOrder;
    } else {
      throw Exception(response.body);
    }
  }

  @override
  Widget build(BuildContext context) => Stack(children: <Widget>[
        Container(
          //color: Color.fromARGB(100, 255, 176, 110),
          child: Column(children: <Widget>[
            Expanded(
                child: Container(
                    child: Scrollbar(
                        child: FutureBuilder<List<OrderController>>(
                            future: futureOrder,
                            builder: (context,
                                AsyncSnapshot<List<OrderController>> snapshot) {
                              if (snapshot.hasData) {
                                List<OrderController>? listOrders =
                                    snapshot.data;
                                if (listOrders!.length == 0) {
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Sem Pedidos',
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
                                  return Column(
                                    children: [
                                      Expanded(
                                          child: ListView(
                                        children: listOrders
                                            .map(
                                              (OrderController listOrders) =>
                                                  Card(
                                                elevation: 5,
                                                shadowColor:
                                                    const Color.fromARGB(
                                                        255, 0, 0, 0),
                                                color: const Color.fromARGB(
                                                    255, 238, 234, 234),
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: ExpansionTile(
                                                  onExpansionChanged:
                                                      (bool expanded) {
                                                    setState(() {
                                                      expandedTile = expanded;
                                                    });
                                                  },
                                                  title: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      ListTile(
                                                        leading: CircleAvatar(
                                                          child: enableField ==
                                                                  listOrders
                                                                      .orderDelivered
                                                              ? Icon(
                                                                  Icons
                                                                      .thumb_down,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 40)
                                                              : Icon(
                                                                  Icons
                                                                      .thumb_up,
                                                                  color: Colors
                                                                      .green,
                                                                  size: 40,
                                                                ),
                                                          backgroundColor:
                                                              enableField ==
                                                                      listOrders
                                                                          .orderDelivered
                                                                  ? Color
                                                                      .fromARGB(
                                                                          57,
                                                                          214,
                                                                          10,
                                                                          10)
                                                                  : Color
                                                                      .fromARGB(
                                                                          58,
                                                                          10,
                                                                          214,
                                                                          78),
                                                          maxRadius: 30,
                                                        ),
                                                        //const Icon(Icons.album),
                                                        title: Text(
                                                            '${listOrders.nameClient}'),
                                                        subtitle: Text(
                                                            'Pedido para ${listOrders.deliveryDate} às ${listOrders.deliveryTime}'),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          TextButton(
                                                            style: TextButton
                                                                .styleFrom(
                                                              backgroundColor:
                                                                  const Color
                                                                          .fromARGB(
                                                                      100,
                                                                      255,
                                                                      176,
                                                                      110),
                                                            ),
                                                            child: const Text(
                                                                'Ver pedido',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          96,
                                                                          90),
                                                                )),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const ViewOrder()),
                                                              );
                                                            },
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                            .fromARGB(
                                                                        100,
                                                                        255,
                                                                        176,
                                                                        110),
                                                              ),
                                                              child: const Text(
                                                                  'Feito',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            96,
                                                                            90),
                                                                  )),
                                                              onPressed: () =>
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        AlertDialog(
                                                                      title: const Text(
                                                                          'Alerta'),
                                                                      content:
                                                                          const Text(
                                                                              'Pedido entregue?'),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text('Não'),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            // ignore: avoid_print
                                                                            print('Sim');
                                                                          },
                                                                          child:
                                                                              const Text('Sim'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )),
                                                          const SizedBox(
                                                              width: 8),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                              '${listOrders.amount}'),
                                                        ),
                                                        Text(
                                                            '${listOrders.nameProduct}'),
                                                      ],
                                                    ),
                                                    const Text('Observações:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        '${listOrders.comments}',
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ))
                                    ],
                                  );
                                }
                                // return ListView.builder(
                                //   itemCount: snapshot.data!.length,
                                //   itemBuilder: (context, index) {
                                //     //Aqui entra o conteudo

                                //     //Aqui termina o conteudo
                                //   },
                                // );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Erro ao carregar os pedidos'),
                                  //Text('${snapshot.error}');
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            })))),
          ]),
        ),
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
                      MaterialPageRoute(builder: (context) => const AddOrder()),
                    );
                  },
                ),
              ]),
        ),
      ]);
}