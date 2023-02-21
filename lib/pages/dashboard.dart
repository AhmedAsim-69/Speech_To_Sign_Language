import 'package:flutter/material.dart';

import 'package:stsl/pages/speech_page.dart';
import 'package:stsl/pages/text_page.dart';

bool isRec = false;
bool isPlay = false;
bool isSpeech = false;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final editingController = TextEditingController();

  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      const SpeechPage(
        title: 'Speech Page',
      ),
      const TextPage(
        title: 'Text Page',
      ),
    ];
    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 247, 249),
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_voice_rounded, size: 28),
            label: 'Speech',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields, size: 28),
            label: 'Text',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: onItemTapped,
      ),
    );
  }
}
