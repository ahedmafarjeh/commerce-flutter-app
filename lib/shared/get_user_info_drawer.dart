import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class UserInforDrawer extends StatefulWidget {
  @override
  State<UserInforDrawer> createState() => _UserInforDrawerState();
}

class _UserInforDrawerState extends State<UserInforDrawer> {
  final credential = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('userss');

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('userss');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(credential!.uid).get(),
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
          return UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/imgs/Mountains.jpg"),
                    fit: BoxFit.cover),
              ),
              accountEmail: Text(data["email"]),
              accountName: Text(data["username"]),
              currentAccountPictureSize: Size.square(80),
              currentAccountPicture: CircleAvatar(
            radius: 80,
            backgroundImage: NetworkImage(data["imglink"]),
          ));
        }

        return Text("loading");
      },
    );
  }
}
