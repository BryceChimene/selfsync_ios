import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Feed'),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 29, 26, 49),
        centerTitle: true,
        toolbarHeight: 40,
      ),
      bottomNavigationBar: BottomNavBar(indexNum: 2),
      body: Container(
        color: const Color.fromARGB(255, 29, 26, 49),
      ),
    );
  }
}
