// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/checkout.dart';
import 'package:flutter_application_1/provider/cart.dart';
import 'package:provider/provider.dart';

class ProductNumberandPrice extends StatelessWidget {
  const ProductNumberandPrice({super.key});

  @override
  Widget build(BuildContext context) {
          final cart = Provider.of<Cart>(context);

    return Row(
              children: [
                Stack(children: [
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Text(
                        "${cart.itemCount}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Checkout()));
                    },
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    "\$ ${cart.price}",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              ],
            );
  }
}