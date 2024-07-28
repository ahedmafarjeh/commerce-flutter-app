
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/shared/colors.dart';
import 'package:flutter_application_1/shared/constants.dart';
import 'package:flutter_application_1/shared/snackbar.dart';
import 'dart:io';
import 'package:path/path.dart' show basename;
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // to check if the input is valid
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();
  final job = TextEditingController();
  final age = TextEditingController();
  bool isLoading = false;
  bool isVisible = false;
  String? imgName;
  redgister() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      // Upload image to firebase storage
      final storageRef = FirebaseStorage.instance.ref(imgName);
      await storageRef.putFile(imgPath!);
      // Get img url
      String img_link = await storageRef.getDownloadURL();
      // after create the account (email and password)
      // i will save the user data on the database
      CollectionReference users =
          FirebaseFirestore.instance.collection('userss');

      users
          .doc(credential.user!.uid) // the name of doc is userid
          .set({
            "imglink":img_link,
            "username": username.text,
            "age": age.text,
            "job": job.text,
            "email": email.text,
            "pass": password.text,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, "The password provided is too weak");
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'The account already exists for that email.');
      } else {
        showSnackBar(context, "ERROR! Please try again later");
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  bool hasMin8Characters = false;
  bool hasDigits = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;
  bool hasUppercase = false;

  checkPassword(String pass) {
    hasMin8Characters = false;
    hasDigits = false;
    hasLowercase = false;
    hasSpecialCharacters = false;
    hasUppercase = false;
    setState(() {
      if (pass.contains(RegExp(r'.{8,}'))) {
        hasMin8Characters = true;
      }
      if (pass.contains(RegExp(r'[0-9]'))) {
        hasDigits = true;
      }
      if (pass.contains(RegExp(r'[A-Z]'))) {
        hasUppercase = true;
      }
      if (pass.contains(RegExp(r'[a-z]'))) {
        hasLowercase = true;
      }
      if (pass.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hasSpecialCharacters = true;
      }
    });
  }

  // to get image path
  File? imgPath;

  uploadImage(ImageSource cam_or_galary) async {
    final pickedImg = await ImagePicker().pickImage(source: cam_or_galary);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          // to dive uniqe name to the image
          imgName = "$random$imgName";
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
  }

  // ask user to use galary or camer to take photo
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
                  Navigator.pop(context);
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
                onTap: () {
                  uploadImage(ImageSource.gallery);
                  Navigator.pop(context);
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

  // must use statefull to use dispose()
  @override
  void dispose() {
    
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarGreen,
        title: Text(
          "Register",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
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
                          ? CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                  AssetImage("assets/imgs/avatar.png"),
                            )
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
                  TextField(
                    controller: username,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: myTextFieldDecoration.copyWith(
                        hintText: "Enter Your Username: ",
                        suffixIcon: Icon(Icons.person)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: age,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: myTextFieldDecoration.copyWith(
                        hintText: "Your Age: ",
                        suffixIcon: Icon(Icons.timelapse)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: job,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: myTextFieldDecoration.copyWith(
                        hintText: "Your Job: ", suffixIcon: Icon(Icons.work)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (value) {
                      // value: it is the input text value
                      return value!.contains(RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                          ? null
                          : "Enter a valid email";
                    },
                    // to check/validate the input automaticlly
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    decoration: myTextFieldDecoration.copyWith(
                        suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.email),
                    )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      checkPassword(value);
                    },
                    validator: (value) {
                      // value: it is the input text value
                      return value!.length < 8
                          ? "Please enter password more than 8 char"
                          : null;
                    },
                    // to check/validate the input automaticlly
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: password,
                    keyboardType: TextInputType.text,
                    obscureText: isVisible ? false : true,
                    // copyWith: used to use the same code (copy) with
                    // capability to change specific attribute
                    decoration: myTextFieldDecoration.copyWith(
                        hintText: "Enter Your Password: ",
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            icon: isVisible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                hasMin8Characters ? Colors.green : Colors.white,
                            border: Border.all(color: Colors.black)),
                        child: Icon(
                          Icons.check,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text("At least 8 characters"),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasDigits ? Colors.green : Colors.white,
                            border: Border.all(color: Colors.black)),
                        child: Icon(
                          Icons.check,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text("At least 1 number"),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasUppercase ? Colors.green : Colors.white,
                            border: Border.all(color: Colors.black)),
                        child: Icon(
                          Icons.check,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text("Has Uppercase"),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasLowercase ? Colors.green : Colors.white,
                            border: Border.all(color: Colors.black)),
                        child: Icon(
                          Icons.check,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text("Has Lowercase"),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasSpecialCharacters
                                ? Colors.green
                                : Colors.white,
                            border: Border.all(color: Colors.black)),
                        child: Icon(
                          Icons.check,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text("Has Special Character"),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // send user data to firebase just if the inputs (email & pass)
                      // is valid
                      if (_formKey.currentState!.validate() && imgName != null && imgPath != null) {
                        await redgister(); // wait for regesitration then go to login page
                        if (!mounted) {
                          return; // it is prefer to do it after wait
                        }
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      } else {
                        showSnackBar(context, "the input is invalid or there is no image");
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(BTNgreen),
                      padding: WidgetStateProperty.all(EdgeInsets.all(12)),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Register",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 22),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
