
import 'package:flutter/material.dart';
import 'package:phone_secure/pages/dashboard/dashboard.dart';
import 'package:phone_secure/pages/login/register.dart';
import 'package:phone_secure/services/sputils.dart';

import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? username, password;

  bool isLoading = false;

  String? requiredValidator(String? text) {
    if (text?.isEmpty ?? true) return 'Required';
    return null;
  }

  void submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    try {
      String token = await AuthService().login(
        username: username!,
        password: password!,
      );
      await SPUtil.getInstance();
      print("adding token to sp ${token}");
      SPUtil.putString('token', token);
      SPUtil.putString('userName', username!);

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => DashBoard()));
    } catch (e) {
      String error = 'Something went wrong';
      if (e is RegisterError) {
        /// handle the custom error from the api
        error = 'some registration error';
      }

      ScaffoldMessenger.of(scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(error)));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void toRegister() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,

      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: Text('Secure',
                      style: TextStyle(
                          fontSize: 80.0, color: Colors.red, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                  child: Text('Your Phone',
                      style: TextStyle(
                          fontSize: 80.0, fontWeight: FontWeight.bold)),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(250.0, 250.0, 0.0, 0.0),
                  child: Text('.',
                      style: TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 400.0, left: 20.0, right: 20.0),
            child: Form(
              key: formKey,
              child: Center(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  children: [

                    TextFormField(
                      // every time we type on the field if it return a string the field shows that string as a error if it is null then everything is fine
                      validator: requiredValidator,
                      // this will ve triggered when we call [formKey.currentState!.save()]
                      onSaved: (value) => username = value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          labelText: 'USERNAME',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: requiredValidator,
                      onSaved: (value) => password = value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(onPressed: submit, child: Text('Login')),
                    TextButton(onPressed: toRegister, child: Text('Register Now'))
                  ],
                ),
              ),
            ),
          ),
          if (isLoading) _buildLoading()
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
