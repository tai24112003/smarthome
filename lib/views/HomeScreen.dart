import 'package:flutter/material.dart';
import 'package:smarthome/components/BottomNav.dart';
import 'package:smarthome/components/HomeDetail.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(30, 53, 71, 1),
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromRGBO(30, 53, 71, 1.0),
          title: const Text('Welcome Home'),
          bottom: TabBar(
            unselectedLabelColor: const Color.fromRGBO(77, 101, 125, 1.0),
            labelColor: Colors.white,
            splashBorderRadius: BorderRadius.circular(50),
            indicator: BoxDecoration(
                border: Border.all(color: Colors.blue),
                color: Color.fromRGBO(26, 42, 57, 1),
                borderRadius: BorderRadius.circular(50)),
            tabs: const [
              Tab(
                text: 'Living Room',
              ),
              Tab(text: 'BedRoom'),
              Tab(text: 'Bath'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeScreen_Detail(),
            HomeScreen_Detail(),
            HomeScreen_Detail(),
          ],
        ),
        bottomNavigationBar: const BottomAppBarCustom(
          active: 0,
        ),
      ),
    );
  }
}
