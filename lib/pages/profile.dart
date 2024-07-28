import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/colors.dart';
import 'package:flutter_application_1/shared/get_data_from_firebase.dart';
import 'package:flutter_application_1/shared/get_user_img.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show basename;

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final credential = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('userss');

  File? imgPath;
  String? imgName;
  uploadImage(ImageSource cam_or_galary) async {
    final pickedImg = await ImagePicker().pickImage(source: cam_or_galary);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
    Navigator.pop(context);
  }

  showmodel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(22),
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage(ImageSource.camera);
                  // Upload image to firebase storage
                  uploadImagetoFirebase();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Camera",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () async {
                  await uploadImage(ImageSource.gallery);
                  // Upload image to firebase storage
                  uploadImagetoFirebase();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Gallery",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  uploadImagetoFirebase() async {
    final storageRef = FirebaseStorage.instance.ref(imgName);
    await storageRef.putFile(imgPath!);
    // Get img url
    String url = await storageRef.getDownloadURL();
    users.doc(credential!.uid).update({
      "imglink": url,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarGreen,
        foregroundColor: Colors.white,
        title: Text(
          "Profile Page",
        ),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontSize: 17),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // To add circular border to the img
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(125, 78, 91, 110),
                ),
                child: Stack(children: [
                  imgPath == null
                      ? GetUserImg()
                      : ClipOval(
                          child: Image.file(
                            imgPath!,
                            width: 145,
                            height: 145,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Positioned(
                    bottom: -5,
                    right: -13,
                    child: IconButton(
                        onPressed: () {
                          showmodel();
                        },
                        icon: Icon(
                          Icons.add_a_photo,
                          size: 25,
                        )),
                  ),
                ]),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  "Info from firebase Auth",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email: ${credential!.email}",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Created Date: ${DateFormat.yMMMd().format(credential!.metadata.creationTime!)}",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Last Signed-in: ${DateFormat.yMMMd().format(credential!.metadata.lastSignInTime!)}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    credential!.delete();
                    // you can also delete doc of this user
                    //users.doc(credential!.uid).delete();
                    Navigator.pop(context); // to return to the login page
                  },
                  child: Text(
                    "Delete User",
                    style: TextStyle(fontSize: 20),
                  )),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  "Info from firebase firestore",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              GetUserInfo(documentId: credential!.uid),
            ],
          ),
        ),
      ),
    );
  }
}
