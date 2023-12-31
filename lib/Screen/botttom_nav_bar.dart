import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detection/API/apiscreen.dart';
import 'package:detection/Screen/Login.dart';
import 'package:detection/Screen/RatingPage.dart';
import 'package:detection/Screen/crystal.dart';
import 'package:detection/Screen/currentLocation.dart';
import 'package:detection/Screen/home.dart';
import 'package:detection/Screen/homepage.dart';
import 'package:detection/Screen/pagination.dart';
import 'package:detection/Screen/profile.dart';
import 'package:detection/Screen/status.dart';
import 'package:detection/Screen/vedio.dart';
import 'package:path/path.dart';
import 'package:fade_scroll_app_bar/fade_scroll_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bottom_Nav_Bar extends StatefulWidget {
  const Bottom_Nav_Bar({Key? key}) : super(key: key);

  @override
  State<Bottom_Nav_Bar> createState() => _Bottom_Nav_BarState();
}

class _Bottom_Nav_BarState extends State<Bottom_Nav_Bar> {
  var image;
  dynamic name;
  dynamic url;
  dynamic emaill;
  var check = false;
  var auth, user;
  Map<String, dynamic> data = {
    'image':
        'https://365webresources.com/wp-content/uploads/2016/09/FREE-PROFILE-AVATARS.png',
  };

  Future<void> fetchDocumentFromFirestore() async {
    try {
      final auth = FirebaseAuth.instance.currentUser;
      final email = auth!.email;
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Access the document data
        setState(() {
          data = documentSnapshot.data() as Map<String, dynamic>;

          url = data['url'];
          name = data['username'];
          emaill = data['email'];
          check = true;
        });

        //print("data = ");
        //print(image);
      } else {
        // Handle case when the document doesn't exist
        //print('Document does not exist');
      }
    } catch (e) {
      // Handle any errors that occurred during document retrieval
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Perform any additional logout operations or navigations
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool("login", false);
    } catch (e) {
      print('Error occurred during logout: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDocumentFromFirestore();
    auth = FirebaseAuth.instance;
    user = auth.currentUser;
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fade Scroll App Bar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: FadeScrollAppBar(
            scrollController: _scrollController,
            appBarLeading: const Icon(Icons.motorcycle),
            appBarTitle: const Text('Helmet Detection App'),
            appBarForegroundColor: Colors.black,
            pinned: true,
            fadeOffset: 120,
            expandedHeight: 250,
            backgroundColor: Colors.white,
            fadeWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: data['image'] != null
                      ? CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage('${data['image']}'),
                        )
                      : Container(
                          child: const CircularProgressIndicator(),
                        ),
                ),
              ],
            ),
            bottomWidgetHeight: 40,
            bottomWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(
                  label: Text("$name",
                      style: const TextStyle(color: Colors.white)),
                  backgroundColor: Colors.blue,
                  side: const BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                const SizedBox(width: 10),
                Chip(
                  label: Text(
                    "$emaill",
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue,
                  side: const BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ],
            ),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Status()));
                        },
                        child: const CardWithIcon(
                          icon: Icons.home,
                          label: 'Home',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomePage()));
                        },
                        child: const CardWithIcon(
                          icon: Icons.search,
                          label: 'Helmet Detect',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Location()));
                        },
                        child: const CardWithIcon(
                          icon: Icons.location_on,
                          label: 'Location',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Video()));
                        },
                        child: const CardWithIcon(
                          icon: Icons.video_collection_rounded,
                          label: 'Video',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RatingPage()));
                        },
                        child: const CardWithIcon(
                          icon: Icons.star_rate_outlined,
                          label: 'Rate Our App',
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Crystal()));
                        },
                        child: const CardWithIcon(
                          icon: Icons.description_outlined,
                          label: 'crystal Report',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _logout();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const Login()), // Replace with your desired route
                            (Route<dynamic> route) =>
                                false, // Remove all previous routes from the stack
                          );
                        },
                        child: const CardWithIcon(
                          icon: Icons.logout_rounded,
                          label: 'Log Out',
                        ),
                      ),
                    ),
                    //const SizedBox(width: 16.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const APIscreen()));
                        },
                        child: const CardWithIcon(
                          icon: Icons.sunny,
                          label: 'Weather',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const Login();
    }
  }
}

class CardWithIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const CardWithIcon({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 100.0,
            color: Colors.blue,
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
