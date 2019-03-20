import 'package:flutter/material.dart';

class Cardy extends StatelessWidget {
  //      __***variable declaration***__      //

  final Widget body;
  final Color color;
  final String title, subtitle, route;
  final bool justified, bottomTitle;
  final double height, width, titleSize;

  //constructor//
  Cardy({
    @required this.color,
    @required this.title,
    this.subtitle,
    this.justified = false,
    this.body,
    this.height = 100,
    this.width = 100,
    this.bottomTitle = false,
    this.titleSize = 30,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onLongPress: () => print("hello"),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: color.withOpacity(0.3),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: color,
        margin: EdgeInsets.all(10.0),
        elevation: 8.0,
        child: new BodyOfCardy(
          title: title.toUpperCase(),
          subtitle: subtitle,
          justified: justified,
          body: body,
          height: height,
          width: width,
          bottomTitle: bottomTitle,
          titleSize: this.titleSize,
        ),
      ),
    );
  }
}

//this block contains the body contents 0f the cards in home screen like title and subtitle

class BodyOfCardy extends StatelessWidget {
  BodyOfCardy(
      {Key key,
      @required this.title,
      this.titleSize = 30,
      this.subtitle,
      this.width = 100,
      this.height = 100,
      this.justified,
      this.body,
      this.bottomTitle = false})
      : super(key: key);

  final String title;
  final String subtitle;
  final bool justified;
  final bool bottomTitle;
  final Widget body;
  final double height, width, titleSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12.0,
          left: 15.0,
          right: 8.0,
          bottom: 8.0,
        ),
        child: Column(
          crossAxisAlignment: justified
              ? CrossAxisAlignment.center
              : (bottomTitle
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start),
          children: <Widget>[
            bottomTitle
                ? Container()
                : (title != ""
                    ? new CardTitle(
                        title: title,
                        titleSize: titleSize,
                      )
                    : Container()),
            Expanded(
              child: Container(),
            ),
            Center(child: body != null ? body : new Container()),
            Expanded(
              child: Container(),
            ),
            subtitle != null
                ? new CardSubtitle(subtitle: subtitle)
                : (bottomTitle
                    ? new CardTitle(
                        title: title,
                        titleSize: titleSize,
                      )
                    : new Container()),
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

  final String subtitle;

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
    this.titleSize,
  }) : super(key: key);

  final String title;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        title,
        // textScaleFactor: titleSize,
        //textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: titleSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
