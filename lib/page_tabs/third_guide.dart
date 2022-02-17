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

class ThirdGuide extends StatelessWidget {
  const ThirdGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        const Text(
          "Terceira guia",
          style: TextStyle(),
        ),
        FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {},
        ),
      ]),
    );
  }
}
