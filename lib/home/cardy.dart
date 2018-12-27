import 'package:flutter/material.dart';

class Cardy extends StatelessWidget {
  //
  Widget body;
  Color color;

  String title, subtitle;
  bool justified = false;

  //constructor

  Cardy({
    @required this.color,
    @required this.title,
    this.subtitle,
    this.justified = false,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => print("hello"),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: color,
        margin: EdgeInsets.all(10.0),
        elevation: 10.0,
        child: new BodyOfCardy(
          title: title.toUpperCase(),
          subtitle: subtitle,
          justified: justified,
          body: body,
        ),
      ),
    );
  }
}

//this block contains the body contents 0f the cards in home screen like title and subtitle

class BodyOfCardy extends StatelessWidget {
  BodyOfCardy({
    Key key,
    @required this.title,
    this.subtitle,
    this.justified,
    this.body,
  }) : super(key: key);

  String title;
  String subtitle;
  bool justified;
  Widget body;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12.0,
          left: 15.0,
          right: 8.0,
          bottom: 8.0,
        ),
        child: Column(
          crossAxisAlignment:
              justified ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: <Widget>[
            title != "" ? new CardTitle(title: title) : Container(),
            Expanded(
              child: Container(),
            ),
            Center(child: body != null ? body : new Container()),
            Expanded(
              child: Container(),
            ),
            subtitle != null
                ? new CardSubtitle(subtitle: subtitle)
                : new Container(),
          ],
        ),
      ),
    );
  }
}

//this is the code block that controls the properties of subtitle in the card if any

class CardSubtitle extends StatelessWidget {
  CardSubtitle({
    Key key,
    this.subtitle,
  }) : super(key: key);

  String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        subtitle,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

//here is the code for the title

class CardTitle extends StatelessWidget {
  CardTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
