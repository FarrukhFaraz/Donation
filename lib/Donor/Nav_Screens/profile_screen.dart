import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:give_alil_bit_new/Utils/offline_ui.dart';
import 'package:give_alil_bit_new/Utils/url.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/navigator.dart';
import '../../taxt_reciept.dart';
import '../Authorization/login_screen.dart';
import '../Screens/Notification/notification_screen.dart';
import '../Screens/Profile/about_screen.dart';
import '../Screens/Profile/contact_support_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loader = false;
  bool logOutLoader = false;
  bool checkConnection = false;

  bool choseImage = false;
  File? image;

  var img;
  var name;

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      getData();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loader = true;
    });
    var token = prefs.get('token');
    try {
      http.Response response = await http.get(Uri.parse(userProfileURL),
          headers: {"Authorization": "Bearer $token"});

      Map jsonData = jsonDecode(response.body);
      if (jsonData['statusCode'] == 200) {
        setState(() {
          loader = false;
          name = jsonData['data']['name'];
          img = jsonData['data']['image'];
        });
        print("$img\n$name");
      } else {
        setState(() {
          loader = false;
        });
        showSnackMessage(context, "Something went wrong!\nTry again later");
      }
    } catch (e) {
      print("Network Exception");
      showSnackMessage(context, "Network Failed");
      setState(() {
        loader = false;
        checkConnection = true;
      });
    }
  }

  logOut() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, StateSetter setState) {
          return AlertDialog(
            title: const Text("Logout"),
            content: logOutLoader
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.09,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator())
                : const Text("Are you sure to logout"),
            actions: [
              logOutLoader
                  ? const Text("")
                  : TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: kBlue,
                            borderRadius: BorderRadius.circular(6)),
                        width: MediaQuery.of(context).size.width * 0.18,
                        child: Text(
                          "No",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kWhite,
                              fontSize: 16),
                        ),
                      ),
                    ),
              logOutLoader
                  ? const Text("")
                  : TextButton(
                      onPressed: () async {
                        setState(() {
                          logOutLoader = true;
                        });
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        await prefs.clear();
                        Timer.periodic(const Duration(seconds: 4), (t) {
                          t.cancel();
                          Navigator.pop(context);
                          showSnackMessage(context, "Logout successfully");
                          navigateReplace(context, const LoginScreen());
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: kBlue,
                            borderRadius: BorderRadius.circular(6)),
                        width: MediaQuery.of(context).size.width * 0.18,
                        child: Text(
                          "Yes",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kWhite,
                              fontSize: 16),
                        ),
                      ),
                    )
            ],
          );
        },
      ),
    );
  }

  Future pickImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) return;
      final imagePermanent = File(img.path);
      print("Images Path" + img.path);
      print(imagePermanent);
      setState(() {
        // imageFile = img;
        image = imagePermanent;
        print("Imaddd ${image?.absolute.path}");
        choseImage = true;
      });
      submitImageData();
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  submitImageData() async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    var token = prefs.getString('token');
    print(image);

    print("id:$id\ntoken:$token");

    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(uploadImageURL));

      var headers = {"Authorization": "Bearer $token"};

      request.fields['id'] = id.toString();
      request.files.add(await http.MultipartFile.fromPath(
          'image', '${image!.absolute.path}'));

      request.headers.addAll(headers);
      request.send().then((response) {
        print(response.toString());
        print(response.statusCode.toString());
        if (response.statusCode == 200) {
          print("Uploaded");
          setState(() {
            loader = false;
          });
          showSnackMessage(context, "successfull");
        } else {
          setState(() {
            loader = false;
          });
          print("Not uploaded");
          showSnackMessage(context, "Something went wrong!");
        }
      });
    } catch (e) {
      print(e);
      setState(() {
        loader = false;
      });
      print("SomeThing went wront");
      showSnackMessage(context, "Something went wrong!");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      loader = true;
    });
    checkConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return checkConnection
        ? OfflineUI(function: checkConnectivity)
        : SafeArea(
            child: Scaffold(
            backgroundColor: bgColor,
            body: loader
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Profile",
                                style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )),
                            InkWell(
                              onTap: () {
                                navigatePush(
                                    context, const NotificationScreen());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: kWhite,
                                ),
                                // height: MediaQuery.of(context).size.height * 0.045,
                                //  width: MediaQuery.of(context).size.width * 0.09,
                                padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.015,
                                ),
                                child: Image.asset(
                                  "assets/images/notification.png",
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                  width:
                                      MediaQuery.of(context).size.width * 0.035,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          //height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: kWhite),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.04),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    pickImage();
                                  },
                                  child: choseImage
                                      ? CircleAvatar(
                                          radius: 50,
                                          backgroundImage: FileImage(image!),
                                        )
                                      : img != null
                                          ? CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                  img),
                                            )
                                          : const CircleAvatar(
                                              radius: 50,
                                              backgroundImage: AssetImage(
                                                  "assets/images/placeholder.png"),
                                            )),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              Text(
                                "$name",
                                style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              InkWell(
                                onTap: () {
                                  navigatePush(context, const AboutScreen());
                                },
                                child: Text(
                                  "View Profile",
                                  style: GoogleFonts.montserrat(
                                      textStyle:
                                          TextStyle(color: kBrightYellow)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.06),
                          width: MediaQuery.of(context).size.width,
                          //height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: kWhite,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: (){
                                  navigatePush(context, const AboutScreen());
                                },
                                child: Text(
                                  "Account",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: kBrightYellow, fontSize: 16)),
                                ),
                              ),
                              const Divider(),
                              const SizedBox(height: 4),
                              InkWell(
                                onTap: () {
                                  navigatePush(context, const ContactSupport());
                                },
                                child: Text(
                                  "Contact support",
                                  style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(fontSize: 16)),
                                ),
                              ),
                              const Divider(),
                              const SizedBox(height: 4),
                              InkWell(
                                onTap: (){
                                  navigatePush(context, const TextReciept());
                                },
                                child: Text("Tax receipts",
                                    style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(fontSize: 16),
                                    )),
                              ),
                              const Divider(),
                              const SizedBox(height: 4),
                              InkWell(
                                onTap: () {
                                  logOut();
                                },
                                child: Text("Log out",
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: kLightRed, fontSize: 16),
                                    )),
                              ),
                              const Divider(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ));
  }
}
