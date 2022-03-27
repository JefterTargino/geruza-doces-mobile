import 'package:flutter/material.dart';
import 'dart:async';
import '../models/FinancialModel.dart';
import '../pages_add/add_product.dart';
import '../pages_view/view_product.dart';
import 'package:http/http.dart' as http; //
import '../models/ResumeModel.dart';
import 'dart:convert'; //
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';

class ThirdGuide extends StatefulWidget {
  const ThirdGuide({Key? key}) : super(key: key);

  @override
  State<ThirdGuide> createState() => _ThirdGuideState();
}

class _ThirdGuideState extends State<ThirdGuide> {
  @override
  void initState() {
    super.initState();
    getResume();
  }

  //late Future<List<ResumeModel>> futureResume;

  Future<ResumeModel> getResume() async {
    final response = await http.get(
        (Uri.parse('https://geruza-doces-api-final.herokuapp.com/resume')));
    if (response.statusCode == 200) {
      return ResumeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<FinancialModel> getFinancial() async {
    final response = await http.get(
        (Uri.parse('https://geruza-doces-api-final.herokuapp.com/financial')));
    if (response.statusCode == 200) {
      return FinancialModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> _refresh() async {
    var newList =
        await Future.delayed(const Duration(seconds: 1), () => getResume);
    var newList2 =
        await Future.delayed(const Duration(seconds: 1), () => getFinancial);
    // setState(() {
    //   lista = newList.call();
    // });
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      FutureBuilder<ResumeModel>(
        future: getResume(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Map<String, double> dataMap = {
            //   "Pendentes": 3,
            //   "Entregues": 4,
            //   "Total": 7,
            // };
            //getResume();
            //  alternativa de gráfico    pie_chart:
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(children: [
                //Pedidos do dia
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 238, 234, 234),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: Column(children: [
                      const Text(
                        'Pedidos entregues no dia',
                        style: TextStyle(fontSize: 25),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircularPercentIndicator(
                          radius: 60.0,
                          animation: true,
                          animationDuration: 1200,
                          lineWidth: 20.0,
                          percent: double.parse(snapshot.data!.dayDelivered!) /
                              (double.parse(snapshot.data!.day!) +
                                  double.parse(snapshot.data!.dayDelivered!)),
                          center: Text(
                            '${(double.parse(snapshot.data!.dayDelivered!) / (double.parse(snapshot.data!.day!) + double.parse(snapshot.data!.dayDelivered!)) * 100).toStringAsFixed(2)} %',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.butt,
                          progressColor: const Color.fromARGB(255, 255, 96, 90),
                          //reverse: true,
                          // startAngle: 220,
                          // arcBackgroundColor: Colors.teal,
                          // arcType: ArcType.HALF,
                          footer: Text('${snapshot.data!.day} pedido pendente'),
                        ),
                      ),
                      ListTile(
                        //style: ListTileStyle.drawer,
                        //enabled: enableField,
                        contentPadding: const EdgeInsets.only(left: 5.0),
                        horizontalTitleGap: 0,
                        //leading:
                        //    const Icon(Icons.add_business_rounded),
                        title: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 255, 96, 90),
                                        border: Border.all(
                                            color: Colors.black, width: 1)),
                                    child: Center(
                                      child: Text(
                                        snapshot.data!.dayDelivered!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                                const Text(
                                  '  Entregues',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 182, 200, 201),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                82, 0, 0, 0))),
                                    child: Center(
                                      child: Text(
                                        (int.parse(snapshot.data!.day!) +
                                                int.parse(snapshot
                                                    .data!.dayDelivered!))
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                                const Text(
                                  '  Total',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ]),
                  ),
                ),
                // Pedidos do dia
                // Pedidos do mês
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 238, 234, 234),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: Column(children: [
                      const Text(
                        'Pedidos entregues no mês',
                        style: TextStyle(fontSize: 25),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircularPercentIndicator(
                          radius: 60.0,
                          animation: true,
                          animationDuration: 1200,
                          lineWidth: 20.0,
                          percent: double.parse(
                                  snapshot.data!.monthDelivered!) /
                              (double.parse(snapshot.data!.month!) +
                                  double.parse(snapshot.data!.monthDelivered!)),
                          center: Text(
                            '${(double.parse(snapshot.data!.monthDelivered!) / (double.parse(snapshot.data!.month!) + double.parse(snapshot.data!.monthDelivered!)) * 100).toStringAsFixed(2)} %',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.butt,
                          progressColor: const Color.fromARGB(255, 255, 96, 90),
                          footer:
                              Text('${snapshot.data!.month} pedido pendente'),
                        ),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 5.0),
                        horizontalTitleGap: 0,
                        title: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 255, 96, 90),
                                        border: Border.all(
                                            color: Colors.black, width: 1)),
                                    child: Center(
                                      child: Text(
                                        snapshot.data!.monthDelivered!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                                const Text(
                                  '  Entregues',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 182, 200, 201),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                82, 0, 0, 0))),
                                    child: Center(
                                      child: Text(
                                        (int.parse(snapshot.data!.month!) +
                                                int.parse(snapshot
                                                    .data!.monthDelivered!))
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                                const Text(
                                  '  Total',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ]),
                  ),
                ),
                // Pedidos do mês
                // Pedidos do ano
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 238, 234, 234),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: Column(children: [
                      const Text(
                        'Pedidos entregues no ano',
                        style: TextStyle(fontSize: 25),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircularPercentIndicator(
                          radius: 60.0,
                          animation: true,
                          animationDuration: 1200,
                          lineWidth: 20.0,
                          percent: double.parse(snapshot.data!.yearDelivered!) /
                              (double.parse(snapshot.data!.year!) +
                                  double.parse(snapshot.data!.yearDelivered!)),
                          center: Text(
                            '${(double.parse(snapshot.data!.yearDelivered!) / (double.parse(snapshot.data!.year!) + double.parse(snapshot.data!.yearDelivered!)) * 100).toStringAsFixed(2)} %',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.butt,
                          progressColor: const Color.fromARGB(255, 255, 96, 90),
                          footer:
                              Text('${snapshot.data!.year} pedido pendente'),
                        ),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 5.0),
                        horizontalTitleGap: 0,
                        title: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 255, 96, 90),
                                        border: Border.all(
                                            color: Colors.black, width: 1)),
                                    child: Center(
                                      child: Text(
                                        snapshot.data!.yearDelivered!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                                const Text(
                                  '  Entregues',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 182, 200, 201),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                82, 0, 0, 0))),
                                    child: Center(
                                      child: Text(
                                        (int.parse(snapshot.data!.year!) +
                                                int.parse(snapshot
                                                    .data!.yearDelivered!))
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                                const Text(
                                  '  Total',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ]),
                  ),
                ),
                // Pedidos do ano
                // Pedidos em geral
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 238, 234, 234),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: Column(children: [
                      const Text(
                        'Pedidos entregues em geral',
                        style: TextStyle(fontSize: 25),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircularPercentIndicator(
                          radius: 60.0,
                          animation: true,
                          animationDuration: 1200,
                          lineWidth: 20.0,
                          percent: double.parse(snapshot.data!.delivered!) /
                              (double.parse(snapshot.data!.notDelivered!) +
                                  double.parse(snapshot.data!.delivered!)),
                          center: Text(
                            '${(double.parse(snapshot.data!.delivered!) / (double.parse(snapshot.data!.notDelivered!) + double.parse(snapshot.data!.delivered!)) * 100).toStringAsFixed(2)} %',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.butt,
                          progressColor: const Color.fromARGB(255, 255, 96, 90),
                          footer: Text(
                              '${snapshot.data!.notDelivered} pedido pendente'),
                        ),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 5.0),
                        horizontalTitleGap: 0,
                        title: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 255, 96, 90),
                                        border: Border.all(
                                            color: Colors.black, width: 1)),
                                    child: Center(
                                      child: Text(
                                        snapshot.data!.delivered!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                                const Text(
                                  '  Entregues',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 182, 200, 201),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                82, 0, 0, 0))),
                                    child: Center(
                                      child: Text(
                                        (int.parse(snapshot
                                                    .data!.notDelivered!) +
                                                int.parse(
                                                    snapshot.data!.delivered!))
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                                const Text(
                                  '  Total',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ]),
                  ),
                )
                // Pedidos em geral
              ]),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao visualizar o resumo'),
            );
          }
          return const SizedBox(
            width: 420,
            height: 700,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      FutureBuilder<FinancialModel>(
          future: getFinancial(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              double percent1 = (snapshot.data!.dayReceived! /
                          (snapshot.data!.dayNotReceived! +
                              snapshot.data!.dayReceived!))
                      .isNaN
                  ? 0.0
                  : snapshot.data!.dayReceived! /
                      (snapshot.data!.dayNotReceived! +
                          snapshot.data!.dayReceived!);
              double percent2 = (snapshot.data!.monthReceived! /
                          (snapshot.data!.monthNotReceived! +
                              snapshot.data!.monthReceived!))
                      .isNaN
                  ? 0.0
                  : snapshot.data!.monthReceived! /
                      (snapshot.data!.monthNotReceived! +
                          snapshot.data!.monthReceived!);
              double percent3 = (snapshot.data!.yearReceived! /
                          (snapshot.data!.yearNotReceived! +
                              snapshot.data!.yearReceived!))
                      .isNaN
                  ? 0.0
                  : snapshot.data!.yearReceived! /
                      (snapshot.data!.yearNotReceived! +
                          snapshot.data!.yearReceived!);
              double percent4 = (snapshot.data!.valueReceived! /
                          (snapshot.data!.valueNotReceived! +
                              snapshot.data!.valueReceived!))
                      .isNaN
                  ? 0.0
                  : snapshot.data!.valueReceived! /
                      (snapshot.data!.valueNotReceived! +
                          snapshot.data!.valueReceived!);
              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  children: [
                    //Recebido no dia
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 238, 234, 234),
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: Column(children: [
                          const Text(
                            'Valor recebido no dia',
                            style: TextStyle(fontSize: 25),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: LinearPercentIndicator(
                              alignment: MainAxisAlignment.center,
                              width: MediaQuery.of(context).size.width - 180,
                              animation: true,
                              lineHeight: 25.0,
                              animationDuration: 2500,
                              percent: percent1,
                              center:
                                  Text('R\$ ${snapshot.data!.dayReceived!}'),
                              barRadius: const Radius.circular(10),
                              progressColor: Colors.green,
                              leading: const Text('R\$ 0.00'),
                              trailing: Text(
                                  'R\$ ${snapshot.data!.dayNotReceived! + snapshot.data!.dayReceived!}'),
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.only(left: 5.0),
                            horizontalTitleGap: 0,
                            title: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Valor a receber: R\$ ${(snapshot.data!.dayNotReceived! + snapshot.data!.dayReceived!) - snapshot.data!.dayReceived!}',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ]),
                      ),
                    ),
                    //Recebido no dia
                    //Recebido no mes
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 238, 234, 234),
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: Column(children: [
                          const Text(
                            'Valor recebido no mês',
                            style: TextStyle(fontSize: 25),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: LinearPercentIndicator(
                              alignment: MainAxisAlignment.center,
                              width: MediaQuery.of(context).size.width - 180,
                              animation: true,
                              lineHeight: 25.0,
                              animationDuration: 2500,
                              percent: percent2,
                              center:
                                  Text('R\$ ${snapshot.data!.monthReceived!}'),
                              barRadius: const Radius.circular(10),
                              progressColor: Colors.green,
                              leading: const Text('R\$ 0.00'),
                              trailing: Text(
                                  'R\$ ${snapshot.data!.monthNotReceived! + snapshot.data!.monthReceived!}'),
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.only(left: 5.0),
                            horizontalTitleGap: 0,
                            title: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Valor a receber: R\$ ${(snapshot.data!.monthNotReceived! + snapshot.data!.monthReceived!) - snapshot.data!.monthReceived!}',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ]),
                      ),
                    ),
                    //Recebido no mes
                    //Recebido no ano
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 238, 234, 234),
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: Column(children: [
                          const Text(
                            'Valor recebido no ano',
                            style: TextStyle(fontSize: 25),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: LinearPercentIndicator(
                              alignment: MainAxisAlignment.center,
                              width: MediaQuery.of(context).size.width - 180,
                              animation: true,
                              lineHeight: 25.0,
                              animationDuration: 2500,
                              percent: percent3,
                              center:
                                  Text('R\$ ${snapshot.data!.yearReceived!}'),
                              barRadius: const Radius.circular(10),
                              progressColor: Colors.green,
                              leading: const Text('R\$ 0.00'),
                              trailing: Text(
                                  'R\$ ${snapshot.data!.yearNotReceived! + snapshot.data!.yearReceived!}'),
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.only(left: 5.0),
                            horizontalTitleGap: 0,
                            title: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Valor a receber: R\$ ${(snapshot.data!.yearNotReceived! + snapshot.data!.yearReceived!) - snapshot.data!.yearReceived!}',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ]),
                      ),
                    ),
                    //Recebido no ano
                    //Recebido no em geral
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 238, 234, 234),
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: Column(children: [
                          const Text(
                            'Valor recebido no geral',
                            style: TextStyle(fontSize: 25),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: LinearPercentIndicator(
                              alignment: MainAxisAlignment.center,
                              width: MediaQuery.of(context).size.width - 180,
                              animation: true,
                              lineHeight: 25.0,
                              animationDuration: 2500,
                              percent: percent4,
                              center:
                                  Text('R\$ ${snapshot.data!.valueReceived!}'),
                              barRadius: const Radius.circular(10),
                              progressColor: Colors.green,
                              leading: const Text('R\$ 0.00'),
                              trailing: Text(
                                  'R\$ ${snapshot.data!.valueNotReceived! + snapshot.data!.valueReceived!}'),
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.only(left: 5.0),
                            horizontalTitleGap: 0,
                            title: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Valor a receber: R\$ ${(snapshot.data!.valueNotReceived! + snapshot.data!.valueReceived!) - snapshot.data!.valueReceived!}',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ]),
                      ),
                    ),
                    //Recebido no ano
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 238, 234, 234),
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: Column(children: [
                          const Text(
                            'Valores a receber',
                            style: TextStyle(fontSize: 25),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.only(left: 5.0),
                            horizontalTitleGap: 0,
                            title: Text(
                                'R\$ ${snapshot.data!.valueNotReceived}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 238, 234, 234),
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: Column(children: [
                          const Text(
                            'Valor recebido',
                            style: TextStyle(fontSize: 25),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.only(left: 5.0),
                            horizontalTitleGap: 0,
                            title: Text('R\$ ${snapshot.data!.valueReceived}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Erro ao visualizar o resumo financeiro'),
              );
            }
            return const SizedBox(
              width: 420,
              height: 700,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }),
    ];
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.topic_rounded),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Financeiro',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
