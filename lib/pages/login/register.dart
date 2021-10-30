import 'package:flutter/material.dart';
import 'package:phone_secure/pages/dashboard/dashboard.dart';
import 'package:phone_secure/pages/login/login.dart';

import '../../model/user.dart';
import '../../services/auth_service.dart';


class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? username, email, password, first_name, last_name;

  bool isLoading = false;

  String? requiredValidator(String? text) {
    if (text?.isEmpty ?? true) return 'Required';
    return null;
  }

  String? emailValidator(String? text) {
    if (text?.isEmpty ?? true) return 'Required';

    final emailRegex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!emailRegex.hasMatch(text!)) {
      return 'Enter a valid email';
    }

    return null;
  }

  void submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    User user = User.register(
      username: username!,
      password: password,
      email: email!,
      first_name: first_name!,
      last_name: last_name!,

    );

    setState(() {
      isLoading = true;
    });

    try {
      //This local variable is not used. It needs to removed or make it as todo if it is required in future.
      User newUser = await AuthService().register(user);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginPage()),
            (_) => false,
      );
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

  @override
  Widget build(BuildContext context) {

    void toSignin() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => LoginPage()));
    }

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,

        body: Stack(
          children: [

            Padding(
              padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 70.0, 0.0, 0.0),
                    child: Text('Thanks for',
                        style: TextStyle(
                            fontSize: 50.0, color: Colors.red, fontWeight: FontWeight.bold)),
                  ),


                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 140.0, 0.0, 0.0),
                    child: Text('Trusting Us.',
                        style: TextStyle(
                            fontSize: 60.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 230.0, left: 20.0, right: 20.0),
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
                      SizedBox(height: 10),
                      TextFormField(
                        validator: emailValidator,
                        onSaved: (value) => email = value,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            labelText: 'EMAIL',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 10),
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
                      SizedBox(height: 10),
                      TextFormField(
                        // every time we type on the field if it return a string the field shows that string as a error if it is null then everything is fine
                        validator: requiredValidator,
                        // this will ve triggered when we call [formKey.currentState!.save()]
                        onSaved: (value) => first_name = value,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            labelText: 'SURNAME(FIRST NAME)',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        // every time we type on the field if it return a string the field shows that string as a error if it is null then everything is fine
                        validator: requiredValidator,
                        // this will ve triggered when we call [formKey.currentState!.save()]
                        onSaved: (value) => last_name = value,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            labelText: 'OTHER NAMES',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(onPressed: submit, child: Text('Register')),
                      TextButton(onPressed: toSignin, child: Text('Click here, I already has Accout With you'))
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading) _buildLoading()
          ],
        ),
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
