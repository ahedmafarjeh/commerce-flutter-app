
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/checkout.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/provider/cart.dart';
import 'package:flutter_application_1/model/item.dart';
import 'package:flutter_application_1/pages/details_screen.dart';
import 'package:flutter_application_1/shared/appbar.dart';
import 'package:flutter_application_1/shared/colors.dart';
import 'package:flutter_application_1/shared/get_user_info_drawer.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // this Provider.of to make the data seen by all projects
    // or you can use provider consumer
    // but Provider.of is easier than provider consumer
    final cart = Provider.of<Cart>(context);
    // if i wanna get the login user info (image, email, name)
    //final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      drawer: Drawer(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  UserInforDrawer(),
                  ListTile(
                      title: Text("Home"),
                      leading: Icon(Icons.home),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      }),
                  ListTile(
                      title: Text("My products"),
                      leading: Icon(Icons.add_shopping_cart),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Checkout()));
                      }),
                  ListTile(
                      title: Text("About"),
                      leading: Icon(Icons.help_center),
                      onTap: () {}),
                  ListTile(
                      title: Text("My Profile"),
                      leading: Icon(Icons.person),
                      onTap: () {
                        Navigator.push(
                          context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                      }),
                  ListTile(
                      title: Text("Logout"),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        // after the above line, the app will return to
                        // stream builder (in main.dart) to decide whih page to open
                      }),
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 12),
                child: Text("Developed by Ahed Mafarjeh © 2024",
                    style: TextStyle(fontSize: 16)),
              )
            ]),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: appbarGreen,
        title: Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          ProductNumberandPrice(),
        ],
      ),
    
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 33),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return GridTile(
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Details(product: items[index])));
                    },
                    // use ClipRRect & Positioned
                    child: Stack(children: [
                      Positioned(
                        top: -3,
                        bottom: -9,
                        right: 0,
                        left: 0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(55),
                            child: Image.asset(items[index].imgPath)),
                      ),
                    ])),
                footer: GridTileBar(
                  // backgroundColor: Color.fromARGB(66, 73, 127, 110),
                  trailing: IconButton(
                      color: Color.fromARGB(255, 62, 94, 70),
                      onPressed: () {
                        cart.addProduct(items[index]);
                      },
                      icon: Icon(Icons.add)),

                  leading: Text("\$${items[index].price}"),

                  title: Text(
                    "",
                  ),
                ),
              );
            }),
      ),
    );
  }
}
