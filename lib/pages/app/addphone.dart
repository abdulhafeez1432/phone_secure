import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_secure/http/connection.dart';
import 'package:phone_secure/model/phonedetails.dart';
import 'package:phone_secure/model/userprofiles.dart';
import 'package:device_information/device_information.dart';
import 'package:unique_identifier/unique_identifier.dart';

class AddPhone extends StatefulWidget {
  const AddPhone({Key? key}) : super(key: key);

  @override
  _AddPhoneState createState() => _AddPhoneState();
}

class _AddPhoneState extends State<AddPhone> {
  String? phoneNumber;
  final ImagePicker _picker = ImagePicker();
  String _platformVersion = 'Unknown',
      _imeiNo = "",
      _modelName = "",
      _manufacturerName = "",
      _deviceName = "",
      _productName = "",
      _cpuType = "",
      _hardware = "";
  var _apiLevel;

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  File? receiptImage;
  File? meansOfId;
  dynamic _pickImageError;
  String? identifier;

  String? requiredValidator(String? text) {
    if (text?.isEmpty ?? true) return 'Required';
    return null;
  }

  List<String> colorList = ['Red', 'Yellow', 'Green'];
  String? color;

  void submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    try {
      //int userId = SPUtil.getInt('loggedId');
      int userId = 7;
      String selectedColor = color == colorList[0]
          ? "1"
          : color == colorList[1]
              ? "2"
              : "3";
        final bytes = receiptImage!.readAsBytesSync();
      String receiptImages = base64Encode(bytes);
       final meansOfIdbytes = meansOfId!.readAsBytesSync();
      String meansOfIdImages = base64Encode(meansOfIdbytes);
      AddPhoneNumberRequestModel requestModel = AddPhoneNumberRequestModel(
        phone: phoneNumber!,
        imei: identifier!,
        receipt: receiptImages,
        color: selectedColor,
        meansOfId: meansOfIdImages,
      );
      UserProfiles userProfile =
          await updateProfilePhoneNumber(requestModel, userId.toString());
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
  void initState() {
    super.initState();
    initPlatformState();
    initUniqueIdentifierState();
  }

  Future<void> initUniqueIdentifierState() async {
    try {
      identifier = (await UniqueIdentifier.serial)!;
    } on Exception {
      identifier = 'Failed to get Unique Identifier';
    }

    if (!mounted) return;

    setState(() {
      identifier = identifier;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    late String platformVersion,
        imeiNo = '',
        modelName = '',
        manufacturer = '',
        deviceName = '',
        productName = '',
        cpuType = '',
        hardware = '';
    var apiLevel;
    // Platform messages may fail,
    // so we use a try/catch PlatformException.
    try {
      platformVersion = await DeviceInformation.platformVersion;
      imeiNo = await DeviceInformation.deviceIMEINumber;
      modelName = await DeviceInformation.deviceModel;
      manufacturer = await DeviceInformation.deviceManufacturer;
      apiLevel = await DeviceInformation.apiLevel;
      deviceName = await DeviceInformation.deviceName;
      productName = await DeviceInformation.productName;
      cpuType = await DeviceInformation.cpuName;
      hardware = await DeviceInformation.hardware;
    } on Exception catch (e) {
      platformVersion = '${e}';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = "Running on :$platformVersion";
      _imeiNo = imeiNo;
      _modelName = modelName;
      _manufacturerName = manufacturer;
      _apiLevel = apiLevel;
      _deviceName = deviceName;
      _productName = productName;
      _cpuType = cpuType;
      _hardware = hardware;
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
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: DropdownButton(
                          hint: Text(
                              'Please choose a color'), // Not necessary for Option 1
                          value: color,
                          onChanged: (newValue) {
                            setState(() {
                              color = newValue.toString();
                            });
                          },
                          items: colorList.map((color) {
                            return DropdownMenuItem(
                              child: new Text(color),
                              value: color,
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          receiptImagePicker();
                          // try {
                          //   final pickedFile = await _picker.pickImage(
                          //     source: ImageSource.gallery,
                          //   );
                          //   setState(() {
                          //     receiptImage = pickedFile;
                          //   });
                          // } catch (e) {
                          //   setState(() {
                          //     _pickImageError = e;
                          //   });
                          // }
                        },
                        child: const Center(
                          child: Text("Pick a Image"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 15.0, right: 40.0, left: 40.0),
                        child: receiptImage == null
                            ? const Center(child: Text('No Image Selected'))
                            : Image.file(receiptImage!),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          meansOfIdImagePicker();
                          // try {
                          //   final pickedFile = await _picker.pickImage(
                          //     source: ImageSource.gallery,
                          //   );
                          //   setState(() {
                          //     meansOfId = pickedFile;
                          //   });
                          // } catch (e) {
                          //   setState(() {
                          //     _pickImageError = e;
                          //   });
                          // }
                        },
                        child: Container(
                          child: Center(
                            child: Text("Pick a Image"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 15.0, right: 40.0, left: 40.0),
                        child: meansOfId == null
                            ? const Center(child: Text('No Image Selected'))
                            : Image.file(meansOfId!),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                          onPressed: submit, child: Text('Add Phone Number')),
                    ],
                  ),
                ),
              ),
              if (isLoading) _buildLoading()
            ],
          )),
    );
  }

  Future meansOfIdImagePicker() async {
    var pickedImage = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      meansOfId = File(pickedImage!.path);
    });
  }

  Future receiptImagePicker() async {
    var pickedImage = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      receiptImage = File(pickedImage!.path);
    });
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
