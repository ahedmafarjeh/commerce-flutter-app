
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/provider/cart.dart';
import 'package:flutter_application_1/shared/appbar.dart';
import 'package:flutter_application_1/shared/colors.dart';
import 'package:provider/provider.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      drawer: Drawer(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/imgs/Mountains.jpg"),
                          fit: BoxFit.cover),
                    ),
                    accountEmail: Text("ahedmafarjeh10@gmail.com"),
                    accountName: Text("Ahed Mafajreh"),
                    currentAccountPictureSize: Size.square(80),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage("assets/imgs/osman.jpg"),
                    ),
                  ),
                  ListTile(
                      title: Text("Home"),
                      leading: Icon(Icons.home),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Home()));
                      }),
                  ListTile(
                      title: Text("My products"),
                      leading: Icon(Icons.add_shopping_cart),
                      onTap: () {}),
                  ListTile(
                      title: Text("About"),
                      leading: Icon(Icons.help_center),
                      onTap: () {}),
                  ListTile(
                      title: Text("Logout"),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () {}),
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
          "Checkout",
          style: TextStyle(color: Colors.white),
        ),
        actions: const [
          ProductNumberandPrice(),
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 500,
          child: ListView.builder(
            itemCount: cart.consumerCart.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  subtitle: Text(
                      "${cart.consumerCart[index].price} - ${cart.consumerCart[index].location}"),
                  leading: CircleAvatar(
                    backgroundImage:
                        AssetImage(cart.consumerCart[index].imgPath),
                  ),
                  title: Text(cart.consumerCart[index].name),
                  trailing: IconButton(
                      onPressed: () {
                        cart.deleteProduct(cart.consumerCart[index]);
                      },
                      icon: Icon(Icons.remove)),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 110,),
        ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(BTNpink),
            padding: WidgetStateProperty.all(EdgeInsets.all(12)),
            shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
          child: Text(
            "Pay \$${cart.price}",
            style: TextStyle(fontSize: 19,color: Colors.white),
          ),
        ),
      ]),
    );
  }
}
