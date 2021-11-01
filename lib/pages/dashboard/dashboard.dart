import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phone_secure/constant/text.dart';
import 'package:phone_secure/http/connection.dart';
import 'package:phone_secure/model/phonedetails.dart';
import 'package:phone_secure/model/user.dart';
import 'package:phone_secure/pages/app/addphone.dart';
import 'package:phone_secure/pages/app/phonedetail.dart';
import 'package:phone_secure/pages/app/userprofile.dart';
import 'package:phone_secure/pages/widget/search.dart';
import 'package:phone_secure/services/sputils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<PhoneDetail>? phoneDetails;

  Future<List<PhoneDetail>> getDataList() async {
    return phoneDetails = await getPhone();
  }

  @override
  void initState() {
    super.initState();
    getDataList();
  }

  Widget build(BuildContext context) {
    void toUpdateDetails() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => UserProfile()));
    }

    String userString = SPUtil.getString("user");
    print(userString);

    String userName = '';
    String email = '';

    if (userString != '' && userString != null) {
      Map<String, dynamic> json = jsonDecode(userString);
      User user = User.fromJson(json);
      userName = user.username.toUpperCase();
      email = user.email.toUpperCase();
      print("user details in drawer..........");
      print(user.username);
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        //appBar: topAppBar,
        body: Column(
          children: [
            _headerbuildPadding(userName),
            SizedBox(height: 20.0),
            SearchWidget(),
            SizedBox(height: 20.0),

            _buildFutureBuilder(context),
          ],
        ),
        bottomNavigationBar: buildBottomBar(context),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Padding _headerbuildPadding(String userName) {
    return Padding(
      padding: const EdgeInsets.only(left:25.0, top: 20.0, right: 25.0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Hi, ${userName}!", style: TextStyle(color: Colors.white70, fontSize: 30.0, fontWeight: FontWeight.bold),),
              Row(
                children: <Widget>[
                  Text("WELCOME TO", style: TextStyle(color: Colors.white),),
                  SizedBox(width: 5.0,),
                  Text("SECURE NOW APP", style: TextStyle(color: Colors.red),),
                  SizedBox(width: 5.0,),

                ],
              ),
            ],
          ),

        ],
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    void toAddPhone() {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddPhone()));
    }
    return FloatingActionButton.extended(
      onPressed: () {toAddPhone();},
      icon: Icon(Icons.save),
      label: Text("Add Phone"),
      backgroundColor: Colors.red,
    );
  }

  Widget _buildFutureBuilder(BuildContext context) {

    void onTapPhone(PhoneDetail phone) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PhoneDetails(phone: phone)));
    }

    return FutureBuilder(
        future: getDataList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                        padding: EdgeInsets.all(10),
                        child: Text("LIST OF YOUR PHONE", textAlign: TextAlign.center, style: kNonActiveTabStyle )),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                    padding: EdgeInsets.all(10),

                    child: ListView.builder(

                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: phoneDetails!.length.toInt(),
                      itemBuilder: (context, index) {
                        return phoneDetails! == null
                            ? Container(
                          child: Center(child: Text("No Data")),
                        )
                            : Container(

                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            leading: Container(
                              padding: EdgeInsets.only(right: 12.0),
                              decoration: new BoxDecoration(
                                  border: new Border(
                                      right: new BorderSide(width: 1.0, color: Colors.white24))),
                              child: Icon(Icons.autorenew, color: Colors.white),
                            ),  title: Text(
                            phoneDetails![index].imei.toString(),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                            subtitle: Row(
                              children:[
                                Icon(Icons.linear_scale, color: Colors.yellowAccent),
                                Text(" Intermediate", style: TextStyle(color: Colors.white))
                              ],
                            ),
                            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
                            onTap: (){onTapPhone(phoneDetails![index]);},),


                        );
                      },),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }
}

final topAppBar = AppBar(
  elevation: 0.1,
  backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
  centerTitle: true,
  title: Text("Phone Secure"),
  actions: <Widget>[
    IconButton(
      icon: Icon(Icons.list),
      onPressed: () {},
    )
  ],
);

Widget buildBottomBar(BuildContext context) {
  return BottomAppBar(
    color: Color.fromRGBO(58, 66, 86, 1.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.blur_on, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.hotel, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.account_box, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserProfile()));
          },
        )
      ],
    ),
  );
}