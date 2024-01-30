import 'package:flutter/material.dart';
import 'package:mms/screens/signin.dart';
import 'package:mms/screens/Medscreens/medications.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediGuardian'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color.fromARGB(255, 28, 147, 245),
                    Color.fromARGB(255, 145, 32, 165)
                  ])),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              /*child: Column(
                children: <Widget>[
                  logoWidget('assets/images/logo.png'),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  )
                ],
              ),*/
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Dosage History'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignIn()));
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const Center(child: Text('Content for Tab 1')),
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const MedicationsScreen(),
              );
            },
          ),
          const Center(child: Text('Content for Tab 3')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Medication',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh_rounded),
            label: 'Refill',
          ),
        ],
        currentIndex: _tabController.index,
        onTap: (index) {
          // Switch to the corresponding tab when the bottom navigation item is tapped
          _tabController.animateTo(index);
        },
      ),
    );
  }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }
}
