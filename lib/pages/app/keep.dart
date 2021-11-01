import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_secure/http/connection.dart';
import 'package:phone_secure/model/user.dart';
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
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  late Future<UserProfiles> futureProfile;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  List<String> stateList = ['Abia', 'Adamawa']; // Option 2

  List<String> genderList = ['Male', 'Female'];

  String? phoneNumber, gender, passport, address, state;

  File? _imageFile;
  dynamic _pickImageError;
  bool isVideo = false;

  String? _retrieveDataError;
  @override
  void initState() {
    super.initState();

    futureProfile = getUserProfile();
  }

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
      //int userId = SPUtil.getInt('loggedId');
      int userId = 7;
      String selectedGender = genderList[0] == gender ? "1" : "2";
      String selectedState = stateList[0] == state ? "1" : "2";
      List<int> imageBytes = _imageFile!.readAsBytesSync();
      String base64Image = base64.encode(imageBytes);
      UserProfilesRequestModel userProfiles = UserProfilesRequestModel(
          phoneNumber: phoneNumber,
          address: address,
          gender: selectedGender,
          state: selectedState,
          passport: base64Image);
      UserProfiles userProfile =
      await updateProfile(, userId.toString());
      print(userProfile.address);
    } catch (e) {
      String error = 'Something went wrong';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                print(snapshot.data!.address);
                print(snapshot.data!);
                return Stack(
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                      child: Form(
                        key: formKey,
                        child: ListView(
                          //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                          children: [
                            TextFormField(
                              // every time we type on the field if it return a string the field shows that string as a error if it is null then everything is fine
                              validator: requiredValidator,
                              // this will ve triggered when we call [formKey.currentState!.save()]
                              onSaved: (value) => phoneNumber = value,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.green))),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              validator: requiredValidator,
                              onSaved: (value) => address = value,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  labelText: 'ADDRESS',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.green))),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: DropdownButton(
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
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: DropdownButton(
                                hint: Text(
                                    'Please choose a state'), // Not necessary for Option 1
                                value: state,
                                onChanged: (newValue) {
                                  setState(() {
                                    state = newValue.toString();
                                  });
                                },
                                items: stateList.map((state) {
                                  return DropdownMenuItem(
                                    child: new Text(state),
                                    value: state,
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                _onImageButtonPressed();
                              },
                              child: Container(
                                child: Center(child: Text("Pick a Image"),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0, right: 40.0, left: 40.0),
                              child: _imageFile == null
                                  ? const Center(child: Text('No Image Selected'))
                                  : Image.file(_imageFile!),
                            ),
                            SizedBox(height: 40),
                            ElevatedButton(
                                onPressed: submit,
                                child: Text('Update User Details')),
                          ],
                        ),
                      ),
                    ),
                    if (isLoading) _buildLoading()
                  ],
                );
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


  Future _onImageButtonPressed() async {
    var pickedImage = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedImage!.path);
    });
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

// void _showPicker(context) {
//   showModalBottomSheet(
//       context: context,
//       builder: (BuildContext bc) {
//         return SafeArea(
//           child: Container(
//             child: new Wrap(
//               children: <Widget>[
//                 new ListTile(
//                     leading: new Icon(Icons.photo_library),
//                     title: new Text(
//                       'Photo Library',
//                     ),
//                     onTap: () {
//                       _imgFromGallery(context);
//                       Navigator.of(context).pop();
//                     }),
//                 new ListTile(
//                   leading: new Icon(Icons.photo_camera),
//                   title: new Text(
//                     'Camera',

//                   ),
//                   onTap: () {
//                     _imgFromCamera(context);
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       });
// }

// _imgFromCamera(BuildContext context) async {
//   final picker = ImagePicker();

//   final pickedFile =
//       await picker.getImage(source: ImageSource.camera, imageQuality: 50);
//   if (pickedFile != null) {
//     _image = pickedFile.path;
//   } else {
//     print('No image selected.');
//   }
// }

// _imgFromGallery(BuildContext context) async {
//   final picker = ImagePicker();

//   final pickedFile =
//       await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
//   if (pickedFile != null) {
//     _image = pickedFile.path;
//   } else {
//     print('No image selected.');
//   }
// }
}

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);


