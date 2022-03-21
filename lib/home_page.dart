import 'package:flutter/material.dart';
import 'package:hello_world/page_tabs/third_guide.dart';
import 'page_tabs/oders_tab.dart';
import 'page_tabs/products_tab.dart'; //

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.indextTab}) : super(key: key);
  final int indextTab;

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
        initialIndex: widget.indextTab,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            backgroundColor: const Color.fromARGB(255, 255, 96, 90),
            title: Row(children: <Widget>[
              Image.network(
                'https://lh3.googleusercontent.com/fife/AAWUweV5LtNMG7fVKQjNxTbDEmSiUbWQ_kwQGnTdM7AWRfJpRZTD540PIS5iyhGGqyiox2OMjVOp0iw8J0EYJ-OVrR7lrpCw_vJwacu3oqh6xK7oAIJloaCif9qXTMIEi5rGV_vIcRSIM6kXUO5dNe1BnoJMMJYP-pQgvvgYddzVXykBVYgzO5rJwUWT-Kt-PmY6cGkGuLttY_Cf9ui9WT9lhywxBKgkTU-_8kro-ou_jqJOQfEt_gqMw9a0b7WF14m8rKGf9DWcGbEGQXp_M5OEJqEqwy_1b3hcA2eVg6QupHtyxrbr3X84oOq5U4O1mNvNkFoVGkxJJZ6wHpqg461qrZDyvYXLDnXU52SQWFF1_pjj2J1LT7z4KJ0xUB9beA9KXn6dKbfyzCE8unaxoXIau3mKTaD44pHeuZN4OT0HK5CDAsFgJe4MeWdctAhK739i6a-F29_BOPN38mdu-JDKhpaxAaateaGc8UrebHoNJHu4XF2eVD4YkHyaqw0ZpvkM1qo8p32xuxaG3WrZJghIKM8K3VdnH-NgYdXgD1t5g5KwukPNIkYpQgVzR83U0fj25a03k-mnkJc_0mkx2DoRc2_-187GPQTWM33Yyi34v9lTxyvH-x--vjNppj3uY0jb6s4drxB_gAvtuCW4LYNK-faBvDqCQu6FUvUxiev8L36of4koUdv21sYbwVm_0sqOjMRSNrykA7jfNc-3mU9bBsvwXhNDZjLPeQ=w1366-h667',
                fit: BoxFit.contain,
                width: 100.0,
                height: 100.0,
              ),
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
                  icon: Icon(Icons.bar_chart),
                  text: 'Estatisticas ',
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
