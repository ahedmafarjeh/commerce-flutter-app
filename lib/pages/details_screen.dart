import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/item.dart';
import 'package:flutter_application_1/shared/appbar.dart';
import 'package:flutter_application_1/shared/colors.dart';

class Details extends StatefulWidget {
  final Item product;
  Details({super.key, required this.product});
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool show_more = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: appbarGreen,
        title: const Text(
          "Details",
          style: TextStyle(color: Colors.white),
        ),
        actions: const [
          ProductNumberandPrice(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(widget.product.imgPath),
            const SizedBox(
              height: 10,
            ),
            Text(
              "\$ ${widget.product.price}",
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 150, 150),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Text("New"),
                ),
                const SizedBox(
                  width: 25,
                ),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                const SizedBox(
                  width: 115,
                ),
                const Icon(Icons.location_on),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.product.location,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
                margin: const EdgeInsets.only(left: 5),
                alignment: Alignment.topLeft,
                child: const Text(
                  "Details:",
                  style: TextStyle(fontSize: 18),
                )),
            Text(
              "A flower, also known as a bloom or blossom, is the reproductive structure found in flowering plants (plants of the division Angiospermae). Flowers consist of a combination of vegetative organs – sepals that enclose and protect the developing flower, petals that attract pollinators, and reproductive organs that produce gametophytes, which in flowering plants produce gametes. The male gametophytes, which produce sperm, are enclosed within pollen grains produced in the anthers. The female gametophytes are contained within the ovules produced in the carpels.",
              style: const TextStyle(fontSize: 18),
              maxLines: show_more ? 5 : null,
              overflow: TextOverflow.fade,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  show_more = !show_more;
                });
              },
              child: Text(
                show_more ? "Show More" : "Show Less",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
