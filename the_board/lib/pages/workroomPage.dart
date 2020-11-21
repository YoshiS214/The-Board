import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class WorkroomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This is material app inside AppTabBar
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/chatList',
      routes: <String, WidgetBuilder>{
        // Route to list of chats (work rooms)
        '/chatList': (BuildContext context) => WorkRoomList(),
        // Route to search chat
        '/searchChat': (BuildContext context) => GestureDetector(
              child: SearchChat(),
              onTap: () => FocusScope.of(context)
                  .unfocus(), // Hide keyboard when tap other parts
            ),
        // Route to chat page
        '/chat': (BuildContext context) => GestureDetector(
              child: ChatPage(),
              onTap: () => FocusScope.of(context)
                  .unfocus(), // Hide keyboard when tap other parts
            ),
      },
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            // Animation of transition which moves right to left
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
    );
  }
}

//==========================================================================
// Class for workroom list to show all workrooms
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

  static Widget workroomTile(List room, BuildContext context) {
    IconData classIcon;
    // Check if it is class or not
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
                  // Icon of workroom
                  child: Icon(classIcon),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: Colors.transparent,
                        // Show room name
                        child: Text(
                          room[1],
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        // Show the last chat in this chat group
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
                Expanded(
                  child: Container(),
                ),
                Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      // Show date of the last chat
                      child: Text(room[2], textAlign: TextAlign.right),
                    ),
                    Icon(Icons.chevron_right)
                  ],
                )
              ],
            ),
          ),
          onTap: () => {
                // When tapped, hide keyboard and navigate to chat
                FocusScope.of(context).unfocus(),
                Navigator.of(context).pushNamed('/chat', arguments: room)
              }),
    );
  }

  static List<Widget> workroomList(BuildContext context, List workrooms) {
    // This create a list of all workroom tiles
    List<Widget> list = [];
    Container line = Container(
      height: 0,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Theme.of(context).dividerColor, width: 2.0))),
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
      // Bottom part which shows the list of workroom
      Positioned(
        top: 50,
        left: 0,
        right: 0,
        bottom: 0,
        child: ListView(
          children: workroomList(context, workrooms),
          physics: const AlwaysScrollableScrollPhysics(),
        ),
      ),
      // Top part whcih shows the search bar
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: 50,
        child: Container(
          decoration:
              BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: Colors.grey[400],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
                  child: Row(
                    children: [
                      // Search icon
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Icon(
                          Icons.search,
                        ),
                      ),
                      // Textfield to search
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/searchChat', arguments: workrooms);
              },
            ),
          ),
        ),
      )
    ]);
  }
}

//==========================================================================
// Class for search chat
class SearchChat extends StatefulWidget {
  @override
  SearchChatState createState() => SearchChatState();
}

class SearchChatState extends State<SearchChat> {
  final _controller = TextEditingController();
  // List of rooms whose names match with user input
  List possibleRooms = [];

  void textChanged(String e, List workrooms) {
    setState(() {
      possibleRooms = [];
      for (var x in workrooms) {
        // Case doesn't matter
        if (x[1].toString().toLowerCase().contains(e.toLowerCase())) {
          possibleRooms.add(x);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Argument (list about chat) from the navigator
    final List args = ModalRoute.of(context).settings.arguments;

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        // Button to go back to workroom list
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        middle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              color: Colors.grey[400],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
              child: Row(
                children: [
                  // Search icon
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Icon(
                      Icons.search,
                    ),
                  ),
                  // Textfield to search
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (text) {
                        textChanged(text, args);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // Main listview for possible workrooms
      child: ListView(
        children: WorkRoomList.workroomList(context, possibleRooms),
        physics: const AlwaysScrollableScrollPhysics(),
      ),
    );
  }
}

//==========================================================================
// Class for chat page
class ChatPage extends StatefulWidget {
  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  final imagePicker = ImagePicker();

  // Uploading file & picture
  Widget uploadingFile;

  String myAccount = "Charlie Benello";

  // Text entered
  String _text = '';

  // Dealing with text input
  void _handleText(String e) {
    setState(() {
      _text = e;
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  // Dealing with camera input
  Future getImageFromCamera() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      uploadingFile = Image.file(File(pickedFile.path));
    });
  }

  // Dealing with photo input
  Future getImageFromGallery() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      uploadingFile = Image.file(File(pickedFile.path));
    });
  }

  // Control the height of input part
  double textfieldHeight() {
    if (_text == '' && uploadingFile == null) {
      return 50;
    } else if (uploadingFile != null) {
      return MediaQuery.of(context).size.height / 2;
    } else {
      return MediaQuery.of(context).size.height / 4;
    }
  }

  // Tile for each chat
  Widget chatTile(List chat, BuildContext context) {
    var padding;
    var radiusL;
    var radiusR;
    var accountIcon;
    var cardColor;
    var textColor;

    if (chat[0] == myAccount) {
      // If chat is mine,
      //    no account icon,
      //    aligned right,
      //    left edges are rounded
      //    tile is accent color
      //    text is accent text theme
      accountIcon = Container();
      radiusL = Radius.circular(16);
      radiusR = Radius.circular(0);
      padding = EdgeInsets.fromLTRB(16.0, 8.0, 0, 8.0);
      cardColor = Theme.of(context).accentColor;
      textColor = Theme.of(context).accentTextTheme.bodyText1.color;
    } else {
      // If chat is mine,
      //    has account icon,
      //    aligned left,
      //    right edges are rounded
      //    tile is card color
      //    text is text theme
      accountIcon = Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
        child: Icon(
          Icons.account_circle,
          color: Theme.of(context).iconTheme.color,
        ), //Account icon
      );
      radiusR = Radius.circular(16);
      radiusL = Radius.circular(0);
      padding = EdgeInsets.fromLTRB(0, 8.0, 16.0, 8.0);
      cardColor = Theme.of(context).cardColor;
      textColor = Theme.of(context).textTheme.bodyText1.color;
    }

    return Padding(
        padding: padding,
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
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
                // Account icon
                accountIcon,
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Show person's name made the chat
                          Material(
                            color: Colors.transparent,
                            child: Text(
                              chat[0],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          // Show data that the chat was posted
                          Material(
                              color: Colors.transparent,
                              child: Text(
                                chat[1],
                                style: TextStyle(color: textColor),
                                maxLines: 1,
                              )),
                        ],
                      ),
                      // Show main text
                      Material(
                        color: Colors.transparent,
                        child: Text(
                          chat[2],
                          style: TextStyle(color: textColor),
                        ),
                      )
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
    // Argument (list about chat) from the navigator
    final List args = ModalRoute.of(context).settings.arguments;
    // Controller for listview.builder
    final ScrollController _scrollController = ScrollController();
    // Actions when report button is pressed
    final actions = ["Report this group", "Leave this group"];

    ObstructingPreferredSizeWidget bar;

    if (MediaQuery.of(context).viewInsets.bottom != 0.0 &&
        MediaQuery.of(context).orientation == Orientation.landscape) {
      bar = null;
    } else {
      bar = CupertinoNavigationBar(
          // Button to go back to workroom list
          leading: CupertinoNavigationBarBackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          middle: new Text(args[1]),
          // Button to report
          trailing: PopupMenuButton(
            icon: Icon(Icons.error_outline),
            onSelected: (String value) => {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Material(child: Text(value)),
                      content: Material(
                          child: Text(
                              "Would you like to ${value.toLowerCase()}?")),
                      actions: [
                        FlatButton(
                            onPressed: () => Navigator.pop(context),
                            child: Material(
                              child: Text("No"),
                            )),
                        FlatButton(
                            // Function should be set here to report or leave this chat group
                            onPressed: null,
                            child: Material(child: Text("Yes"))),
                      ],
                    );
                  })
            },
            itemBuilder: ((BuildContext context) {
              return actions.map((String s) {
                return PopupMenuItem(
                  child: Material(child: Text(s)),
                  value: s,
                );
              }).toList();
            }),
          ));
    }

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: bar,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Stack(children: [
              // Background of chat page (Could be set by user to some pictures?)
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(color: Colors.grey[400])),
              // Flow of chats
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
                  // Number of chats
                  itemCount: args[4].length,
                  itemBuilder: (BuildContext context, int index) {
                    return chatTile(args[4][index], context);
                  },
                ),
              ),
            ]),
          ),
          // Input part
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: textfieldHeight()),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1.0,
                    blurRadius: 10.0,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Icon button to add a file
                    SizedBox(
                      height: 34,
                      width: 34,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: IconButton(
                          icon: Icon(Icons.add),
                          iconSize: 34,
                          onPressed: null,
                        ),
                      ),
                    ),
                    // Icon button to take a photo
                    SizedBox(
                      height: 34,
                      width: 34,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: IconButton(
                          icon: Icon(Icons.photo_camera),
                          iconSize: 34,
                          onPressed: getImageFromCamera,
                        ),
                      ),
                    ),
                    // Icon button to add a photo
                    SizedBox(
                      height: 34,
                      width: 34,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: IconButton(
                          icon: Icon(Icons.photo),
                          iconSize: 34,
                          onPressed: getImageFromGallery,
                        ),
                      ),
                    ),
                    // User input bar
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(splashColor: Colors.transparent),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Scrollbar(
                                    isAlwaysShown: false,
                                    child: SingleChildScrollView(
                                      // If uploading file has not selected, show textfield otherwise show the file
                                      child: uploadingFile == null
                                          ? TextField(
                                              controller:
                                                  _textEditingController,
                                              onChanged: _handleText,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              keyboardType:
                                                  TextInputType.multiline,
                                              autocorrect: true,
                                              autofocus: false,
                                              // No limit of words number and lines
                                              maxLines: null,
                                              maxLength: null,
                                              obscureText: false,
                                              textAlign: TextAlign.left,
                                              textAlignVertical:
                                                  TextAlignVertical.top,
                                            )
                                          : uploadingFile,
                                    ),
                                  ),
                                ),
                                _text != "" || uploadingFile != null
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.black26,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (uploadingFile != null) {
                                              uploadingFile = null;
                                            } else {
                                              _textEditingController.clear();
                                              _text = "";
                                            }
                                          });
                                        },
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Icon button to send a chat
                    SizedBox(
                      height: 34,
                      width: 34,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: IconButton(
                          icon: Icon(Icons.send),
                          iconSize: 34,
                          onPressed: () => {
                            setState(() {
                              _text = "";
                              _textEditingController.clear();
                              uploadingFile = null;
                              FocusScope.of(context).unfocus();
                            })
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
