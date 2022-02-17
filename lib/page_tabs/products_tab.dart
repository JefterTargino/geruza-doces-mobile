import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/home_controller.dart';
import 'package:hello_world/view_order.dart';
//import 'package:hello_world/home_controller.dart';

import '../add_order.dart';
import '../add_product.dart';
import '../view_product.dart';
import '../home_page.dart';

import 'package:http/http.dart' as http; //
import '../models/OrderController.dart'; //
import 'dart:convert'; //

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          child: Scrollbar(
        child: GridView.builder(
          itemCount: 21,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 5,
              shadowColor: const Color.fromARGB(255, 0, 0, 0),
              color: const Color.fromARGB(255, 238, 234, 234),
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
                        builder: (context) => const ViewProduct()),
                  );
                },
                child: //const Image(
                    //     image: NetworkImage(
                    //         'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                    //     color: const Color.fromRGBO(255, 255, 255, 0.5),
                    //     colorBlendMode: BlendMode.modulate)
                    Align(
                        alignment: Alignment.center,
                        child: Text('Bolo de chocolate $index',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                            ))),
              ),
            );
          },
        ),
      )),
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
                    MaterialPageRoute(builder: (context) => const AddProduct()),
                  );
                },
              ),
            ]),
      ),
    ]);
  }
}
