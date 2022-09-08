import 'package:flutter/material.dart';

class Showpage extends StatefulWidget {
  Showpage({Key? key, this.image}) : super(key: key);
  String? image;
  @override
  State<Showpage> createState() => _ShowpageState();
}

class _ShowpageState extends State<Showpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Image.network(
          "${widget.image}",
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
