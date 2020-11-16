import 'package:flutter/material.dart';
import 'package:the_board/pages/streamPage.dart';
import 'package:the_board/pages/workroomPage.dart';

class AppTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.white.withOpacity(0.3),
            unselectedLabelStyle: TextStyle(fontSize: 12.0),
            labelStyle: TextStyle(fontSize: 16.0),
            indicatorColor: Colors.white,
            indicatorWeight: 2.0,
            tabs: [
              Tab(
                child: Text('Work Rooms'),
              ),
              Tab(
                child: Text('Streams'),
              ),
              Tab(
                child: Text('Acount'),
              ),
            ],
          ),
          title: Text('The Board'),
        ),
        body: TabBarView(
          children: [
            WorkroomPage(),
            StreamPage(),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
