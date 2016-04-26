import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() {
  runApp(
    new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue
      ),
      home: new ListPage()
    )
  );
}

Key _apple = new Key('apple');

const Duration kHeroTransitionDuration = const Duration(milliseconds: 600);

class HeroTransitionRoute extends MaterialPageRoute<Null> {
  HeroTransitionRoute({
    WidgetBuilder builder,
    RouteSettings settings: const RouteSettings()
  }) : super(builder: builder, settings: settings);

  // Cause the hero image to animate in under the toolbar
  @override
  void insertHeroOverlayEntry(OverlayEntry entry, Object tag, OverlayState state) {
    state.insert(entry, above: overlayEntries.first);
  }

  @override
  Duration get transitionDuration => kHeroTransitionDuration;

  // Don't shift the page up as we transition to it
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> forwardAnimation, Widget child) {
    return new FadeTransition(
      opacity: animation,
      child: child
    );
  }
}

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: [
        new Positioned(
          top: kToolBarHeight + ui.window.padding.top,
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: new Hero(
            tag: 'fruit',
            key: _apple,
            child: new Container(
              decoration: new BoxDecoration(
                backgroundColor: Colors.orange[500]
              ),
              child: new Center(
                child: new Text('This is some detail')
              )
            )
          )
        ),
        new Positioned(
          top: 0.0, right: 0.0, left: 0.0,
          child: new SizedBox(
            height: kToolBarHeight + ui.window.padding.top,
            child: new AppBar(
              title: new Text('Detail view'),
              leading:
                Navigator.canPop(context) ?
                new IconButton(
                  icon: Icons.arrow_back,
                  alignment: FractionalOffset.centerLeft,
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Back' // TODO(ianh): Figure out how to localize this string
                ) :
                null
            )
          )
        )
      ]);
  }
}

class ListPage extends StatefulWidget {
  ListPage({ Key key }) : super(key: key);

  @override
  _ListPageState createState() => new _ListPageState();
}

class _ListPageState extends State<ListPage> {

  void _onTap(BuildContext context, Key key) {
    Navigator.push(
      context,
      new HeroTransitionRoute(
        builder: (_) => new DetailPage(),
        settings: new RouteSettings(
          mostValuableKeys: new Set<Key>.from([key])
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('List view')
      ),
      body: new Block(
        children: [
          new ListItem(
            onTap: () => _onTap(context, _apple),
            title: new Hero(
              tag: 'fruit',
              key: _apple,
              child: new Container(
                decoration: new BoxDecoration(
                  backgroundColor: Colors.orange[500]
                ),
                child: new Text('element')
              )
            )
          )
        ]
      )
    );
  }
}
