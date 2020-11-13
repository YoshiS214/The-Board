import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

class WorkroomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => WorkRoomList(),
        '/chat': (BuildContext context) => ChatPage(),
      },
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
    );
  }
}

class WorkRoomList extends StatelessWidget {
  final List workrooms = [
    [
      true,
      "UFM.5",
      "5.00PM",
      "Can someone send the link to the Jamboard from the lesson?",
      [
        ["Felix Waller", "1:24 PM", "Ah - thanks for the explanation!"],
        ["Charlie Benello", "1:04 PM", "https://www.cl.cam.ac.uk"]
      ]
    ],
    [
      true,
      "UCO.2",
      "1.34PM",
      "Can someone send the link to the Jamboard from the lesson?",
      [
        ["Felix Waller", "1:24 PM", "Ah - thanks for the explanation!"],
        ["Felix Waller", "1:24 PM", "Ah - thanks for the explanation!"]
      ]
    ],
    [
      false,
      "Upper Eighth",
      "Yesterday",
      "Can someone send the link to the Jamboard from the lesson?",
      [
        ["Felix Waller", "1:24 PM", "Ah - thanks for the explanation!"],
        ["Felix Waller", "1:24 PM", "Ah - thanks for the explanation!"]
      ]
    ],
  ];

  Widget workroomTile(List room, BuildContext context) {
    IconData classIcon;
    if (room[0]) {
      classIcon = Icons.book;
    } else {
      classIcon = Icons.sports_cricket;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
          child: Container(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                  child: Icon(classIcon),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        child: Text(
                          room[1],
                          style: TextStyle(
                              fontWeight: FontWeight.bold), // Room name
                          textAlign: TextAlign.left,
                          maxLines: 1,
                        ),
                      ),
                      Material(
                        child: Text(
                          room[3],
                          maxLines: 2,
                          style:
                              TextStyle(color: Colors.grey[700]), // Last chat
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Material(
                      child: Text(room[2], textAlign: TextAlign.right), // Date
                    ),
                    Icon(Icons.chevron_right)
                  ],
                )
              ],
            ),
          ),
          onTap: () =>
              {Navigator.of(context).pushNamed('/chat', arguments: room)}),
    );
  }

  List<Widget> workroomList(BuildContext context) {
    List<Widget> list = [];
    Container line = Container(
      height: 0,
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: Colors.grey))),
    );
    list.add(line);
    for (List x in workrooms) {
      list.add(workroomTile(x, context));
      list.add(line);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        child: ListView(
          children: workroomList(context),
          physics: const AlwaysScrollableScrollPhysics(),
        ),
        top: 50,
        left: 0,
        right: 0,
        bottom: 0,
      ),
      Positioned(
        // Search bar
        top: 0,
        left: 0,
        right: 0,
        height: 50,
        child: Container(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    ]);
  }
}

class ChatPage extends StatelessWidget {
  final TextEditingController _textEditingController =
      new TextEditingController();

  String myAccount = "Charlie Benello";

  String _text = '';

  @override
  void initState() {
    _textEditingController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
  }

  void _handleText(String e) {
    _text = e;
  }

  void _printLatestValue() {
    print("入力状況: ${_textEditingController.text}");
  }

  void _submission(String e) {
    print(_textEditingController.text);
    _textEditingController.clear();
    _text = '';
  }

  Widget chatTile(List chat) {
    var padding;
    var radiusL;
    var radiusR;
    var accountIcon;
    if (chat[0] == myAccount) {
      accountIcon = Container();
      radiusL = Radius.circular(16);
      radiusR = Radius.circular(0);
      padding = EdgeInsets.fromLTRB(16.0, 8.0, 0, 8.0);
    } else {
      accountIcon = Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
        child: Icon(Icons.account_circle), //Account icon
      );
      radiusR = Radius.circular(16);
      radiusL = Radius.circular(0);
      padding = EdgeInsets.fromLTRB(0, 8.0, 16.0, 8.0);
    }

    return Padding(
        padding: padding,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: radiusR,
              bottomRight: radiusR,
              topLeft: radiusL,
              bottomLeft: radiusL,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                accountIcon,
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Material(
                            child: Text(
                              chat[0],
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                            ),
                          ), // Name
                          Material(
                              child: Text(
                            chat[1],
                            maxLines: 1,
                          )), // Date
                        ],
                      ),
                      Material(child: Text(chat[2])) // Main text
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context).settings.arguments;
    final ScrollController _scrollController = ScrollController();
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: 'Work Rooms',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        middle: new Text(args[1]),
        trailing: IconButton(icon: Icon(Icons.error_outline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(children: [
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(color: Colors.grey[400])),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  reverse: true,
                  controller: _scrollController,
                  itemCount: args[4].length,
                  itemBuilder: (BuildContext context, int index) {
                    return chatTile(args[4][index]);
                  },
                ),
              ),
            ]),
          ),
          Container(
            height: 50,
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(icon: Icon(Icons.add), onPressed: null),
                  IconButton(icon: Icon(Icons.photo), onPressed: null),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
                        child: Material(
                          child: TextField(
                            controller: _textEditingController,
                            onChanged: _handleText,
                            onSubmitted: _submission,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(color: Colors.black),
                            minLines: 1,
                            maxLines: null,
                            maxLength: null,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.send), onPressed: null),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
