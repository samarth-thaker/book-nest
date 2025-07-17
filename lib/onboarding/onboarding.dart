import 'package:booknest/onboarding/addBookTab.dart';
import 'package:booknest/onboarding/lendingTab.dart';
import 'package:booknest/onboarding/libraryTab.dart';
import 'package:booknest/onboarding/settingsTab.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _selectedIndex = 0;

  final List<String> _titles = ['Your Library', 'Add a Book', 'Lent Books'];

  final List<Widget> _screens = [
    LibraryTab(),
    AddBookTab(),
    //LentBooksScreen(),
    LendingTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsTab()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Book'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Lending'),
        ],
      ),
    );
  }
}
