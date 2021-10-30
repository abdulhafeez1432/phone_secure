
import 'package:flutter/material.dart';
import 'package:phone_secure/http/connection.dart';
import 'package:phone_secure/model/userprofiles.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneNumberControler = new TextEditingController();
  final TextEditingController _addressControler = new TextEditingController();
  final TextEditingController _stateControler = new TextEditingController();

  late Future<UserProfiles> futureProfile;



  @override
  void initState() {
    super.initState();

    futureProfile = getUserProfile();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User Profile Example'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<UserProfiles>(
          future: futureProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                print(snapshot.data!.address);
                print(snapshot.data!);
               return Text(snapshot.data!.address.toString());
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