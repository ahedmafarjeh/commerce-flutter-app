import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';


class GetUserInfo extends StatefulWidget {
  final String documentId;

  const GetUserInfo({super.key, required this.documentId});

  @override
  State<GetUserInfo> createState() => _GetUserInfoState();
}

class _GetUserInfoState extends State<GetUserInfo> {
  final dialogUsernameController = TextEditingController();
  final credential = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('userss');
  displayDialog(Map data, dynamic mykey) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          child: Container(
            padding: EdgeInsets.all(22),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                    controller: dialogUsernameController,
                    maxLength: 20,
                    decoration:
                        InputDecoration(hintText: "  ${data[mykey]}    ")),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          users
                              .doc(credential!.uid)
                              .update({mykey: dialogUsernameController.text});

                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(fontSize: 17),
                        )),
                    TextButton(
                        onPressed: () {
                          
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 17),
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('userss');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Username : ${data['username']}",
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(children: [
                        IconButton(
                            onPressed: () {
                              displayDialog(data, 'username');
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                users
                                    .doc(credential!.uid)
                                    .update({"username": FieldValue.delete()});
                              });
                            },
                            icon: Icon(Icons.delete)),
                      ])
                    ]),
                SizedBox(
                  height: 11,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Email : ${data['email']}",
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(children: [
                        IconButton(
                            onPressed: () {
                              displayDialog(data, "email");
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                users
                                    .doc(credential!.uid)
                                    .update({"email": FieldValue.delete()});
                              });
                            },
                            icon: Icon(Icons.delete)),
                      ])
                    ]),
                SizedBox(
                  height: 11,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Password: ${data['pass']}",
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(children: [
                        IconButton(
                            onPressed: () {
                              displayDialog(data, "pass");
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                users
                                    .doc(credential!.uid)
                                    .update({"pass": FieldValue.delete()});
                              });
                            },
                            icon: Icon(Icons.delete)),
                      ])
                    ]),
                SizedBox(
                  height: 11,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Age: ${data['age']}",
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(children: [
                        IconButton(
                            onPressed: () {
                              displayDialog(data, "age");
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                users
                                    .doc(credential!.uid)
                                    .update({"age": FieldValue.delete()});
                              });
                            },
                            icon: Icon(Icons.delete)),
                      ])
                    ]),
                SizedBox(
                  height: 11,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Job: ${data['job']}",
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(children: [
                        IconButton(
                            onPressed: () {
                              displayDialog(data, "job");
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                users
                                    .doc(credential!.uid)
                                    .update({"job": FieldValue.delete()});
                              });
                            },
                            icon: Icon(Icons.delete)),
                      ])
                    ]),
                TextButton(
                    onPressed: () {
                      setState(() {
                        users.doc(credential!.uid).delete();
                      });
                    },
                    child: Center(
                        child: Text(
                      "Delete Data",
                      style: TextStyle(fontSize: 20),
                    )))
              ],
            ),
          );
        }

        return Text("loading");
      },
    );
  }
}
