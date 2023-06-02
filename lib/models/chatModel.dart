class ModalClass {
  static final List<Item> items = [
    Item(
        id: 1,
        name: "user 1",
        desc: "message",
        lastseen: '11:10',
        image: "images/man2.png"),
    Item(
        id: 2,
        name: "user 2",
        desc: "message",
        lastseen: '13:00',
        image: "images/woman2.png"),
    Item(
        id: 3,
        name: "user 3",
        desc: "message",
        lastseen: '16:40',
        image: "images/woman3.png"),
    Item(
        id: 4,
        name: "user 4",
        desc: "message",
        lastseen: '10:29',
        image: "images/man1.png"),
    Item(
        id: 5,
        name: "user 5",
        desc: "message",
        lastseen: '15:18',
        image: "images/woman.png"),
    Item(
        id: 6,
        name: "user 6",
        desc: "message",
        lastseen: '18:20',
        image: "images/man.png"),
    Item(
        id: 7,
        name: "user 7",
        desc: "message",
        lastseen: '19:10',
        image: "images/woman1.png"),
  ];
}

class Item {
  final int id;
  final String name;
  final String desc;
  final String lastseen;
  final String image;

  Item(
      {required this.id,
      required this.name,
      required this.desc,
      required this.lastseen,
      required this.image});
}
