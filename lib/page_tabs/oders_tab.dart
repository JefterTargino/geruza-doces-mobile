import 'package:flutter/material.dart';
import 'package:hello_world/models/ListModel.dart';
import 'dart:async';
import 'package:hello_world/pages_view/view_order.dart';
import 'package:intl/intl.dart';
import '../pages_add/add_order.dart';
import 'package:http/http.dart' as http; //
import '../models/OrderController.dart'; //
import 'dart:convert'; //
import 'package:fluttertoast/fluttertoast.dart'; //

class OdersTab extends StatefulWidget {
  const OdersTab({Key? key}) : super(key: key);

  @override
  _OdersTabState createState() => _OdersTabState();
}

final deliveredController = ValueNotifier<bool>(false);

Future<bool> updateOrder(int id) async {
  final response = await http.put(
      Uri.parse('https://geruza-doces-api-final.herokuapp.com/order/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"order_delivered": deliveredController.value}));
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 202) {
    Fluttertoast.showToast(
      backgroundColor: const Color(0xFF35bb70),
      msg: 'Pedido entregue com sucesso!',
    );
    return true;
  } else {
    Fluttertoast.showToast(
        backgroundColor: const Color(0xFFFFC02A),
        msg: 'Erro ao entregar pedido!');
    return false;
  }
}

class _OdersTabState extends State<OdersTab> {
  bool enableField = false;

  bool expandedTile = false;
  @override
  void initState() {
    super.initState();
    futureOrder = getOrder();
    deliveredController.value;
    getListProducts();
  }

  late Future<List<OrderController>> futureOrder;

  Future<List<OrderController>> getOrder() async {
    final response = await http
        .get((Uri.parse('https://geruza-doces-api-final.herokuapp.com/order')));
    if (response.statusCode == 200) {
      final listOrder = (json.decode(response.body) as List)
          .map((e) => OrderController.fromJson(e))
          .toList();
      return listOrder;
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> _refresh() async {
    var newList =
        await Future.delayed(const Duration(seconds: 1), () => getOrder);
    setState(() {
      futureOrder = newList.call();
    });
  }

//Get de um pedido especifico
  Future<OrderController> fetch(int id) async {
    final response = await http.get(
        Uri.parse('https://geruza-doces-api-final.herokuapp.com/order/$id'));
    if (response.statusCode == 200) {
      final teste = OrderController.fromJson(jsonDecode(response.body));
      // print de todos os fetch print(teste.listProduct!.map((e) => e.toJson()));
      return teste;
    } else {
      _refresh();
      return fetch(id);
      //throw Exception(Fluttertoast.showToast(
      //   backgroundColor: const Color(0xFFFFC02A), msg: response.body));
    }
  }

  List categoryItemList = [];

  Future getListProducts() async {
    var url = "https://geruza-doces-api-final.herokuapp.com/product/list";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryItemList = jsonData;
      });
    }
    //print(categoryItemList);
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
                                deliveredController.value = false;
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
                                            color: const Color(0xFF002D60),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                          color: Colors.grey[200],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
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
                                          child: RefreshIndicator(
                                        onRefresh: _refresh,
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
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: ExpansionTile(
                                                    onExpansionChanged:
                                                        (bool expanded) {
                                                      setState(() {
                                                        // fetch(listOrders.id!
                                                        //     .toInt());
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
                                                                ? const Icon(
                                                                    Icons
                                                                        .thumb_down,
                                                                    color: Colors
                                                                        .red,
                                                                    size: 40)
                                                                : const Icon(
                                                                    Icons
                                                                        .thumb_up,
                                                                    color: Colors
                                                                        .green,
                                                                    size: 40,
                                                                  ),
                                                            backgroundColor: enableField ==
                                                                    listOrders
                                                                        .orderDelivered
                                                                ? const Color
                                                                        .fromARGB(
                                                                    57,
                                                                    214,
                                                                    10,
                                                                    10)
                                                                : const Color
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
                                                              'Pedido para ${DateFormat.yMd('pt_BR').format(DateTime.tryParse(listOrders.deliveryDate.toString())!)} às ${listOrders.deliveryTime}'),
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
                                                                      builder: (context) => ViewOrder(
                                                                          id: listOrders
                                                                              .id!
                                                                              .toInt())),
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
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          96,
                                                                          90),
                                                                    )),
                                                                onPressed: () => listOrders
                                                                            .orderDelivered ==
                                                                        true
                                                                    ? Fluttertoast
                                                                        .showToast(
                                                                        backgroundColor:
                                                                            const Color(0xFFFFC02A),
                                                                        msg:
                                                                            'Pedido já foi entregue!',
                                                                      )
                                                                    : showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext context) =>
                                                                                AlertDialog(
                                                                          title:
                                                                              const Text('Alerta'),
                                                                          content:
                                                                              const Text('Pedido entregue?'),
                                                                          actions: <
                                                                              Widget>[
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text('Não'),
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  deliveredController.value = true;
                                                                                });
                                                                                updateOrder(listOrders.id!.toInt());
                                                                                Navigator.pop(context);
                                                                                _refresh();
                                                                              },
                                                                              child: const Text('Sim'),
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
                                                      FutureBuilder<
                                                              OrderController>(
                                                          future: expandedTile ==
                                                                  true
                                                              ? fetch(listOrders
                                                                  .id!
                                                                  .toInt())
                                                              : null,
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              return Column(
                                                                children: [
                                                                  ListView
                                                                      .separated(
                                                                          physics:
                                                                              const NeverScrollableScrollPhysics(),
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount: snapshot
                                                                              .data!
                                                                              .listProduct!
                                                                              .length,
                                                                          separatorBuilder: (BuildContext context, int index) =>
                                                                              Divider(),
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            return ListTile(
                                                                              style: ListTileStyle.drawer,
                                                                              enabled: enableField,
                                                                              contentPadding: const EdgeInsets.only(left: 5.0),
                                                                              horizontalTitleGap: 0,
                                                                              //leading:
                                                                              //    const Icon(Icons.add_business_rounded),
                                                                              title: Text(
                                                                                '  Produto: ${snapshot.data!.listProduct![index].nameProduct}',
                                                                                style: const TextStyle(color: Colors.black),
                                                                              ),
                                                                              subtitle: Text('  Quantidade: ${snapshot.data!.listProduct![index].amount}', style: const TextStyle(color: Colors.black)),
                                                                            );
                                                                          }),
                                                                  const Text(
                                                                      'Valor total:',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                        'R\$ ${snapshot.data!.sum ?? '0.00'}'),
                                                                  ),
                                                                ],
                                                              );
                                                            } else if (snapshot
                                                                .hasError) {
                                                              return const Center(
                                                                child: Text(
                                                                    'Erro ao visualizar o pedido'),
                                                              );
                                                            }
                                                            return const SizedBox(
                                                              width: 100,
                                                              height: 100,
                                                              child: Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              ),
                                                            );
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
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
                                return const Center(
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
        SizedBox(
          width: 400,
          height: 580,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    categoryItemList.isEmpty
                        ? Fluttertoast.showToast(
                            backgroundColor: const Color(0xFFFFC02A),
                            msg: 'Sem produtos cadastrados!',
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddOrder()),
                          );
                  },
                ),
              ]),
        ),
      ]);
}
