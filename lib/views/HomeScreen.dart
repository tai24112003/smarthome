import 'package:flutter/material.dart';
import 'package:smarthome/components/HomeDetail.dart';
import 'package:smarthome/models/room.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List lstroom= List.filled(0, Room(id: '', name: '', devices: List.filled(0, Device(id: '', type: '', description: ''))));
  _loadata(){
    setState(() {
      Room.getData().then((value) => {
        lstroom=Room.rooms
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: lstroom.length,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromRGBO(30, 53, 71, 1.0),
          title: const Text('Welcome Home'),
          bottom: TabBar(
            isScrollable: true,
            unselectedLabelColor:const Color.fromRGBO(77, 101, 125, 1.0),
            labelColor: Colors.white,
            splashBorderRadius: BorderRadius.circular(50),
            indicator: BoxDecoration(
              border: Border.all(color: Colors.blue),
              color:Color.fromRGBO(26, 42, 57, 1),
              borderRadius: BorderRadius.circular(50)
              
            ),
            tabs:  [
              ListView.builder(itemBuilder: (context, index) {
                return Tab(text: lstroom[index].name);
              },)
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeScreen_Detail(),
            HomeScreen_Detail(),
            HomeScreen_Detail(),
            HomeScreen_Detail(),
            HomeScreen_Detail(),
            HomeScreen_Detail(),
            HomeScreen_Detail(),
          ],
        ),
      ),
    );
  }
}
