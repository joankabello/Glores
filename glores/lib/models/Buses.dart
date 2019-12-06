class Buses {
  String imageUrl;
  String name;
  String address;
  int price;

  Buses({
    this.imageUrl,
    this.name,
    this.address,
    this.price,
  });
}

final List<Buses> buses = [
  Buses(
    imageUrl: 'assets/images/room1.jpg',
    name: 'Hotel Hilton',
    address: '404 Great St',
    price: 175,
  ),
  Buses(
    imageUrl: 'assets/images/hotel0.jpg',
    name: 'Mak Hotel',
    address: '404 Great St',
    price: 300,
  ),
  Buses(
    imageUrl: 'assets/images/hotel2.jpg',
    name: 'Nari Hotel',
    address: '404 Great St',
    price: 240,
  ),
];
