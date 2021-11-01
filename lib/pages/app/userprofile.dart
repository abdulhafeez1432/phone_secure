import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_secure/http/connection.dart';
import 'package:phone_secure/model/user.dart';
import 'package:phone_secure/model/userdetails.dart';
import 'package:phone_secure/model/userprofiles.dart';
import 'package:phone_secure/services/sputils.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneNumberControler = new TextEditingController();
  final TextEditingController _addressControler = new TextEditingController();
  final TextEditingController _stateControler = new TextEditingController();


  late Future<UserProfiles> futureProfile;
  late Future<UserDetails> futureUser;

  List<String> stateList = ['Abai', 'Adamawa']; // Option 2

  List<String> genderList = ['Male', 'Female'];
  late File _image;
  final picker = ImagePicker();

  String? phoneNumber, gender, passport, address, state;


  @override
  void initState() {
    super.initState();

    futureProfile = getUserProfile();
    futureUser = getUser();

  }




  Future choiceImage() async {
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage!.path);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User Profile Example'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<UserProfiles>(
          future: futureProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(snapshot.data!.address.toString()),
                    TextField(
                      controller: _genderController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Title',
                      ),
                    ),

                    Text(snapshot.data!.phoneNumber.toString()),
                    TextField(
                      controller: _phoneNumberControler,
                      decoration: const InputDecoration(
                        hintText: 'Enter Phone Number',
                      ),
                    ),


                    Text(snapshot.data!.passport.toString()),
                    TextField(
                      controller: _phoneNumberControler,
                      decoration: const InputDecoration(
                        hintText: 'Enter Phone Number',
                      ),
                    ),


                    Text(snapshot.data!.gender.toString()),
                    DropdownButton(
                      hint: const Text(
                          'Please choose a gender'), // Not necessary for Option 1
                      value: gender,
                      onChanged: (newValue) {
                        setState(() {
                          gender = newValue.toString();
                        });
                      },
                      items: genderList.map((gender) {
                        return DropdownMenuItem(
                          child: new Text(gender),
                          value: gender,
                        );
                      }).toList(),
                    ),





                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          futureProfile = updateProfile('Adewale', 1);
                        });
                      },
                      child: const Text('Update Data'),
                    ),
                  ],

                );
                print(snapshot.data!.address);
                print(snapshot.data!);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

}


