import 'package:flutter/material.dart';
class Alert extends StatefulWidget {
  @override
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("No assignemnts yet"),
    );
  }
}