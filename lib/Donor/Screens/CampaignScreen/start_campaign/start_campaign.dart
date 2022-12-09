import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:give_alil_bit_new/Utils/CheckConnection.dart';
import 'package:give_alil_bit_new/Utils/bottom_nav.dart';
import 'package:give_alil_bit_new/Utils/colors.dart';
import 'package:give_alil_bit_new/Utils/messages.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Utils/url.dart';
import '../../../../Widgets/button.dart';
import '../../../../Widgets/form_field.dart';

class StartCampaign extends StatefulWidget {
  const StartCampaign({Key? key}) : super(key: key);

  @override
  State<StartCampaign> createState() => _StartCampaignState();
}

class _StartCampaignState extends State<StartCampaign> {
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  TextEditingController auctionController = TextEditingController();
  TextEditingController tellStoryController = TextEditingController();

  File? image;

  String fieldHint = "Pick a category";
  String selectedDate = "Type date";

  // XFile? imageFile;

  bool requireTitle = false;
  bool requireLocation = false;
  bool requireGoal = false;
  bool requireCategory = false;
  bool requireAuction = false;
  bool requireEndDate = false;
  bool requireImage = false;
  bool requireTellStory = false;

  bool checkConnection = false;
  bool error = false;

  bool firstLoader = false;
  bool loader = false;

  Future pickImage(ImageSource source) async {
    try {
      final img = await ImagePicker().pickImage(source: source);
      if (img == null) return;
      final imagePermanent = File(img.path);
      print("Images Path"+img.path);
      print(imagePermanent);
      setState(() {
        // imageFile = img;
        image=imagePermanent;
        print ("Imaddd ${image?.absolute.path}");
        error = false;
      });
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  /*Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(image.path).copy(image.path);
  }*/

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2035))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        selectedDate = DateFormat('MMM d, yyyy').format(value);
        print(selectedDate);
      });
    });
  }

  formValidate() {
    if (titleController.text.trim().isEmpty) {
      setState(() {
        requireTitle = true;
      });
    } else if (locationController.text.trim().isEmpty) {
      setState(() {
        requireLocation = true;
      });
    } else if (goalController.text.trim().isEmpty) {
      setState(() {
        requireGoal = true;
      });
    } else if (auctionController.text.trim().isEmpty) {
      setState(() {
        requireAuction = true;
      });
    } else if (selectedDate == 'Type date') {
      setState(() {
        requireEndDate = true;
      });
    } else if (image == null) {
      setState(() {
        requireImage = true;
      });
    } else {
      print("Show dialog");
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: SizedBox(
              height: 200,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Publish Campaign",
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage("assets/icons/check.png"),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "John William",
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: kBlack,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "San Diego, CA",
                              style: GoogleFonts.montserrat(
                                  textStyle:
                                      TextStyle(color: kGrey, fontSize: 12)),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.topLeft,
                      height: 140,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kLightGrey),
                      child: TextFormField(
                        controller: tellStoryController,
                        cursorColor: kBrightYellow,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Tell us your story...",
                          hintStyle: GoogleFonts.montserrat(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        //textInput: TextInputType.multiline,
                        maxLines: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () {
                    checkData();
                  },
                  child: button(context, "Publish", false),
                ),
              )
            ],
          );
        }),
      );
    }
  }

  checkData() {
    if (tellStoryController.text.trim().isEmpty) {
      setState(() {
        requireTellStory = true;
      });
    } else {
      Navigator.pop(context);
      checkConnectivity();
    }
  }

  loadApi() async {
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
          http.MultipartRequest('POST', Uri.parse(startCampaignURL));

      var headers ={"Authorization":"Bearer $token"};


      request.fields['campaignTitle'] = titleController.text;
      request.fields['location'] = locationController.text;
      request.fields['campaignGoal'] = goalController.text;
      request.fields['raised'] = "0";
      request.fields['category_id'] = "1";
      request.fields['endDate'] = selectedDate;
     // request.fields['image'] = '/data/ddd';
      request.files.add(await http.MultipartFile.fromPath('image', '${image!.absolute.path}'));
      //request.files.add(http.MultipartFile.fromPath('image', '$image'));
      request.fields['auctionTitle'] = auctionController.text;
      request.fields['about'] = tellStoryController.text;

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

  checkConnectivity() async {
    if (await connection()) {
      setState(() {
        checkConnection = false;
      });
      loadApi();
    } else {
      setState(() {
        checkConnection = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: bottomNav(context, 1),
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
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
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
                            "assets/images/back.png",
                            height: MediaQuery.of(context).size.height * 0.02,
                            width: MediaQuery.of(context).size.width * 0.035,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Start a campaign",
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      )),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16), color: kWhite),
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02,
                        horizontal: MediaQuery.of(context).size.width * 0.025),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Campaign title',
                          style: GoogleFonts.montserrat(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        formFields(
                          titleController,
                          "Title",
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Text('Location',
                            style: GoogleFonts.montserrat(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        formFields(
                          locationController,
                          "Location",
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Text('Campaign Goal',
                            style: GoogleFonts.montserrat(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        formFields(
                          goalController,
                          "Amount needed",
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      goalController.text = "100";
                                    });
                                  },
                                  child: startCampaignText("\$100")),
                            ),
                            Expanded(
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      goalController.text = "200";
                                    });
                                  },
                                  child: startCampaignText("\$200")),
                            ),
                            Expanded(
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      goalController.text = "300";
                                    });
                                  },
                                  child: startCampaignText("\$300")),
                            ),
                            Expanded(
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      goalController.text = "400";
                                    });
                                  },
                                  child: startCampaignText("\$400")),
                            ),
                          ],
                        ),
                        /* SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Text('Category',
                            style: GoogleFonts.montserrat(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Container(
                          // height: 50,

                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.02,
                            //vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: loginField,
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: [
                              DropdownMenuItem(
                                value: "Pick a category",
                                child: Text(fieldHint,
                                    style: GoogleFonts.montserrat()),
                              ),
                              const DropdownMenuItem(
                                value: "Web",
                                child: Text("Web"),
                              ),
                              const DropdownMenuItem(
                                value: "App",
                                child: Text("App"),
                              ),
                              const DropdownMenuItem(
                                value: "Desktop",
                                child: Text("Desktop"),
                              ),
                            ],
                            hint: Text(fieldHint,
                                style: GoogleFonts.montserrat()),
                            borderRadius: BorderRadius.circular(12),
                            elevation: 0,
                            onChanged: (value) {
                              setState(() {
                                fieldHint = value!;
                              });
                            },
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12), color: kWhite),
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02,
                        horizontal: MediaQuery.of(context).size.width * 0.025),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Auction Title",
                          style: GoogleFonts.montserrat(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        formFields(auctionController, "Title"),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Text(
                          "End Date",
                          style: GoogleFonts.montserrat(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Container(
                          //height: 50,
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.025,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: loginField,
                          ),
                          child: InkWell(
                            onTap: () {
                              _showDatePicker();
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedDate,
                                    style: GoogleFonts.montserrat(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.date_range_rounded,
                                  color: kColor,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        Text(
                          "Upload Image",
                          style: GoogleFonts.montserrat(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: loginField),
                          child: image == null
                              ? SizedBox(
                                  child: InkWell(
                                    onTap: () {
                                      pickImage(ImageSource.gallery);
                                    },
                                    child: Icon(
                                      Icons.image_rounded,
                                      color: kColor,
                                      size: 50,
                                    ),
                                  ),
                                )
                              : Stack(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          image!,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )),
                                    Positioned(
                                      left: 8,
                                      top: 8,
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              image = null;
                                            });
                                          },
                                          child: Icon(
                                            Icons.cancel_outlined,
                                            size: 30,
                                            color: kColor,
                                          )),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  InkWell(
                    onTap: () {
                      print("clicked");
                      formValidate();
                    },
                    child: button(context, "Start Campaign", false),
                  ),
                ],
              ),
            ),
    ));
  }

  Widget startCampaignText(String txt) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: kLightYellow),
      child: Text(
        txt,
        style:
            GoogleFonts.montserrat(textStyle: TextStyle(color: kBrightYellow)),
      ),
    );
  }
}
