import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:stsl/pages/speech_page.dart';
import 'package:stsl/pages/text_page.dart';
import 'package:stsl/utils/theme_data.dart';

bool isRec = false;
bool isPause = false;
bool isPlay = false;
bool isSpeech = false;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final editingController = TextEditingController();
  bool _isDarkMode = true;

  int _selectedIndex = 0;
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

    return Consumer<ThemeNotifier>(builder: (context, theme, _) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue[400],
          title: (_selectedIndex == 0)
              ? const Text("Speech Page")
              : const Text("Text Page"),
        ),
        drawer: Drawer(
            child: ListView(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
              ),
              child: const Center(child: Text('Pakistan Sign Express')),
            ),
            SwitchListTile(
                title: const Text("Dark Mode"),
                value: _isDarkMode,
                onChanged: (value) {
                  _isDarkMode = value;
                  if (_isDarkMode) {
                    theme.setDarkMode();
                  } else {
                    (theme.setLightMode());
                  }
                }),
          ],
        )),
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
    });
  }
}
