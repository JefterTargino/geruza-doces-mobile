import 'package:flutter/material.dart';

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
