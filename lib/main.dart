import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyDCEtYX2QUTLCw87LoDRqncBp93WCQ_zD8',
          appId: '1:660263908681:android:b927a393d1754ade1e1698',
          messagingSenderId: '660263908681',
          projectId: 'finalexam-46a2f',
          storageBucket: 'finalexam-46a2f.appspot.com'
      ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection('Users').snapshots();

  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String name = ' ';

  Future<void> addUser() {
    return users
        .add({
          'name': name,
        })
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add the user"));
  }

  Future<void> updateUser(String id, String newName) async {
    await users
        .doc(id)
        .update({'name': newName})
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add the user"));
  }

  Future<void> deleteUser(String id) async {
    await users
        .doc(id)
        .delete()
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add the user"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FireStore Demo'),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter user Name',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter your password',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(6.0)))),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      addUser();
                    },
                    child: Text(' Add Userser')),
                SizedBox(
                  height: 20.0,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: _userStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text(' Something Went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading');
                      }
                      return ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          String docId = document.id;
                          return ListTile(
                            title: Text(data['name']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          String newName = '';
                                          return AlertDialog(
                                            title: Text('Edit User'),
                                            content: TextField(
                                              onChanged: (value) {
                                                newName = value;
                                              },
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    updateUser(docId, newName);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Update'))
                                            ],
                                          );
                                        });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    deleteUser(docId);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }),
              ],
            )),
      ),
    );
  }
}
