import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:smarthome/views/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key});
  @override
  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  int _currentIndex = 0;
  late Stream<QuerySnapshot> _accountsStream;
  late User _currentUser;
  @override
  void initState() {
    super.initState();
    _getCurrentUser();

    _accountsStream =
        FirebaseFirestore.instance.collection('accounts').snapshots();
  }

  Future<void> _getCurrentUser() async {
    User? user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Color.fromRGBO(30, 53, 71, 1.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            PhysicalModel(
              elevation: 8.0,
              color: const Color.fromRGBO(26, 42, 57, 1.0),
              borderRadius: BorderRadius.circular(15),
              clipBehavior: Clip.hardEdge,
              child: Expanded(
                flex: 2,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.account_box_rounded,
                                size: 125,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      Expanded(
                        flex: 1,
                        child: IndexedStack(
                          index: _currentIndex,
                          children: [
                            Text(
                              'Tên: ${_currentUser.displayName}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text('Email: ${_currentUser.email}'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                            Icon(Icons.assignment_sharp, color: Colors.white),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          "Đổi mật khẩu",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                            fixedSize: MaterialStatePropertyAll(Size.fromWidth(
                                MediaQuery.of(context).size.width * 0.4)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromRGBO(5, 40, 75, 1.0))),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.assignment_ind_rounded,
                            color: Colors.white),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          "Đổi nick name",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                            fixedSize: MaterialStatePropertyAll(Size.fromWidth(
                                MediaQuery.of(context).size.width * 0.4)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromRGBO(5, 40, 75, 1.0))),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.directions_run_rounded,
                            color: Colors.red),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Text(
                          "Đăng xuất",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                            fixedSize: MaterialStatePropertyAll(Size.fromWidth(
                                MediaQuery.of(context).size.width * 0.4)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.red)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
