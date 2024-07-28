class Item {
  double price;
  String imgPath;
  String location;
  String name;
  Item(
      {required this.price,
      required this.imgPath,
      required this.name,
      this.location =
          "Main Branch" // default value for location so it is not required
      });
}

final List<Item> items = [
  Item(name: "Product 1",price: 12.99,imgPath: "assets/imgs/1.webp",location: "Flower Shop"),
  Item(name: "Product 2", price: 15.99, imgPath: "assets/imgs/2.webp"),
  Item(name: "Product 3", price: 18.99, imgPath: "assets/imgs/3.webp"),
  Item(name: "Product 4", price: 20.99, imgPath: "assets/imgs/4.webp"),
  Item(name: "Product 5", price: 25.99, imgPath: "assets/imgs/5.webp"),
  Item(name: "Product 6", price: 30.99, imgPath: "assets/imgs/6.webp"),
  Item(name: "Product 7", price: 35.99, imgPath: "assets/imgs/7.webp"),
  Item(name: "Product 8", price: 40.99, imgPath: "assets/imgs/8.webp"),
];
