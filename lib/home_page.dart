import 'package:flutter/material.dart';
import 'package:hello_world/page_tabs/third_guide.dart';
import 'page_tabs/oders_tab.dart';
import 'page_tabs/products_tab.dart'; //

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: const Color.fromARGB(255, 255, 96, 90),
            title: Row(children: const <Widget>[
              // Image.network(
              //   'https://i.ibb.co/gttqNTq/Geriza-dpces.png',
              //   fit: BoxFit.contain,
              //   width: 100.0,
              //   height: 100.0,
              // ),
              Padding(
                padding: EdgeInsets.only(left: 65),
                child: Text('Geruza Doces'),
              )
            ]),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.topic_rounded),
                  text: 'Pedidos',
                ),
                Tab(
                  icon: Icon(Icons.add_business_rounded),
                  text: 'Produtos',
                ),
                Tab(
                  icon: Icon(Icons.brightness_5_sharp),
                  text: 'Dados',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              OdersTab(),
              ProductsTab(), // Segunda Aba
              ThirdGuide(), // Terceira Aba
            ],
          ),
          // floatingActionButton: FloatingActionButton(
          //   child: Icon(Icons.add),
          //   onPressed: () {setState(() {
          //               counter++;
          //             });},
          // ),
        ),
      ),
    );
  }
}
