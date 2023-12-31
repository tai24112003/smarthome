import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class QL_TaiKhoan extends StatefulWidget {
  const QL_TaiKhoan({super.key});

  @override
  State<QL_TaiKhoan> createState() => _QL_TaiKhoanState();
}

class _QL_TaiKhoanState extends State<QL_TaiKhoan> {
  String userId = "";
  late String displayName = "";
  late String email = "";
  @override
  void initState() {
    super.initState();
    // Lấy thông tin người dùng hiện tại một lần
    loadUserData();
  }

  Future<void> loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        var userData = snapshot.data()!;
        setState(() {
          displayName = userData['displayName'] ?? 'Không có tên hiển thị';
          email = userData['email'] ?? 'Không có email';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //_configureFirebaseMessaging();
    return DefaultTabController(
      length: 2, // Số lượng TabBar
      child: Scaffold(
        backgroundColor: Color.fromRGBO(30, 53, 71, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(26, 42, 57, 1),
          title: Text('Profile'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'User Info',
              ),
              Tab(
                text: 'User manage',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 220,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(26, 42, 57, 1),
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Tên: $displayName',
                            style: TextStyle(color: Colors.white)),
                        Text('Email: $email',
                            style: TextStyle(color: Colors.white)),
                      ],
                    )),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      child: Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          height: 35,
                          padding: EdgeInsets.only(top: 8.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromRGBO(26, 42, 57, 1),
                          ),
                          child: Text(
                            "Change Your Password",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      child: Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          height: 35,
                          padding: EdgeInsets.only(top: 8.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromRGBO(26, 42, 57, 1),
                          ),
                          child: Text(
                            "Change Your Name",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ],
                )
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Đã xảy ra lỗi');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('Không có người dùng');
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    String displayName = document['displayName'];
                    String email = document['email'];
                    return Card(
                      color: Color.fromRGBO(30, 53, 71, 1),
                      child: ListTile(
                          title: Text(displayName,
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text(email,
                              style: TextStyle(color: Colors.white)),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.white,
                            onPressed: () {
                              deleteUser(email);
                            },
                          )),
                    );
                  },
                );
              },
            )
            // SingleChildScrollView(
            //   child: Column(children: [
            //     SizedBox(
            //       height: 20,
            //     ),
            //     Container(
            //       padding: EdgeInsets.all(20),
            //       child: Column(
            //         children: [
            //           Row(children: [
            //             Expanded(
            //               child: Container(
            //                 decoration: BoxDecoration(
            //                     color: Color.fromRGBO(24, 44, 64, 1),
            //                     borderRadius: BorderRadius.only(
            //                         topLeft: Radius.circular(5),
            //                         topRight: Radius.circular(5))),
            //                 child: Text(
            //                   "Member",
            //                   textAlign: TextAlign.center,
            //                   style: TextStyle(
            //                       color: Colors.white,
            //                       fontWeight: FontWeight.bold,
            //                       fontSize: 20),
            //                 ),
            //               ),
            //             ),
            //           ]),
            //           Container(
            //               decoration: BoxDecoration(
            //                   color: Color.fromRGBO(26, 42, 57, 1),
            //                   borderRadius: BorderRadius.circular(5)),
            //               padding: EdgeInsets.all(20),
            //               child: )
            //         ],
            //       ),
            //     )
            //   ]),
            // ),
            // Nội dung Tab 2
          ],
        ),
      ),
    );
  }

  void deleteUser(String email) async {
    try {
      // Lấy thông tin người dùng dựa trên email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Lấy ID của người dùng
        String userId = querySnapshot.docs.first.id;

        // Xóa người dùng khỏi Firebase Authentication
        await FirebaseAuth.instance.currentUser?.delete();

        // Xóa người dùng khỏi Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .delete();

        print('Người dùng đã bị xóa');
      } else {
        print('Không tìm thấy người dùng với email $email');
      }
    } catch (e) {
      print('Lỗi xóa người dùng: $e');
    }
  }

  String getUserDisplayName(String userId) {
    String displayName = '';
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        displayName = doc.data()!['displayName'];
      }
    });
    return displayName;
  }

  // void deleteUser(String userId) {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId)
  //       .delete()
  //       .then((value) {
  //     print('Người dùng đã bị xóa');
  //   }).catchError((error) {
  //     print('Lỗi xóa người dùng: $error');
  //   });
  // }

  // void _configureFirebaseMessaging() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     // Xử lý thông báo nhận được khi ứng dụng đang chạy
  //     String title = message.notification?.title ?? "";
  //     String body = message.notification?.body ?? "";
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(title),
  //           content: Text(body),
  //           actions: [
  //             TextButton(
  //               child: Text("Từ chối"),
  //               onPressed: () {
  //                 // Xử lý khi từ chối tài khoản
  //                 Navigator.of(context).pop();
  //                 sendResponse(false);
  //               },
  //             ),
  //             TextButton(
  //               child: Text("Chấp nhận"),
  //               onPressed: () {
  //                 // Xử lý khi chấp nhận tài khoản
  //                 Navigator.of(context).pop();
  //                 sendResponse(true);
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   });

  //   FirebaseMessaging.onBackgroundMessage((message) {
  //     // Xử lý thông báo nhận được khi ứng dụng đang chạy trong nền
  //     // Trả về một Future để đảm bảo xử lý kết thúc trước khi ứng dụng bị hủy bỏ
  //     return Future.value();
  //   });
  // }

  // void sendResponse(bool accepted) {
  //   // Xử lý gửi phản hồi đến người dùng
  //   if (accepted) {
  //     // Nếu tài khoản được chấp nhận, thực hiện các hành động liên quan
  //     print('Tài khoản đã được chấp nhận.');
  //   } else {
  //     // Nếu tài khoản bị từ chối, thực hiện các hành động liên quan
  //     print('Tài khoản đã bị từ chối.');
  //   }
  // }
}
