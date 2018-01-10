import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:async';

void main() => runApp(new CardsDemo());

List cards = ['Card A', 'Card B', 'Card C', 'Card D'];

class CustomCardItem extends StatefulWidget {
  final String card;
  CustomCardItem({this.card});
  @override
  CustomCardItemState createState() => new CustomCardItemState(
        card: card,
      );
}

class CustomCardItemState extends State<CustomCardItem>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> sliderPosition;
  final String card;
  CustomCardItemState({this.card});
  initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    sliderPosition = new Tween<Offset>(
      begin: Offset.zero,
      end: new Offset(1.0, 0.0),
    )
        .animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));
  }

  onSwipe(details) {
    setState(() {
      _controller.forward();
      new Timer(const Duration(milliseconds: 1000), () {
        cards.removeLast();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle descriptionStyle = theme.textTheme.subhead;
    return new SafeArea(
      top: false,
      bottom: false,
      child: new SlideTransition(
        position: sliderPosition,
        child: new GestureDetector(
          onHorizontalDragEnd: onSwipe,
          child: new Container(
            padding: const EdgeInsets.all(8.0),
            height: 280.0,
            child: new Card(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new SizedBox(
                    height: 184.0,
                    child: new Stack(
                      children: <Widget>[
                        new Positioned.fill(
                          child: new Image.network(
                              'https://avatars3.githubusercontent.com/u/14101776?v=4'),
                        ),
                      ],
                    ),
                  ),
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                      child: new DefaultTextStyle(
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: descriptionStyle,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: new Text(
                                card,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardsDemo extends StatefulWidget {
  @override
  CardsDemoState createState() => new CardsDemoState();
}

class CardsDemoState extends State<CardsDemo> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(title: const Text('Card Swipe Animation')),
            body: new Stack(
                children: cards.map((String card) {
              return new Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: new CustomCardItem(
                    card: card,
                  ));
            }).toList())));
  }
}