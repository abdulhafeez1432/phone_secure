
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:phone_secure/model/phonedetails.dart';

class PhoneDetails extends StatelessWidget {

  final PhoneDetail phone;


  const PhoneDetails({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text(phone.imei.toString())),
      ),
    );
  }
}
