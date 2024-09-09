import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diteventsapp/main.dart';
import 'package:diteventsapp/models/api_response.dart';
import 'package:diteventsapp/models/user.dart';
import 'package:diteventsapp/screens/event_screen.dart';
import 'package:diteventsapp/screens/profile_screen.dart';
import 'package:diteventsapp/services/user_services.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  User? user;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  var selectedTab = 0;

  //call get user data and store in a variable
  Future<void> getUser() async {
    ApiResponse response = await getUserData();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = ref.watch(themeProvider);
    Widget currentPage = const EventScreen();
    selectedTab == 0
        ? currentPage = const EventScreen()
        : selectedTab == 1
            ? currentPage = Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Upcoming events",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: const Color.fromARGB(255, 29, 20, 123),
                ),
                body: const Center(
                  child: Text(
                    "Still under Development",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              )
            : currentPage = Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Category",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Color.fromARGB(255, 29, 20, 123),
                ),
                body: const Center(
                  child: Text(
                    "Still under Development",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              );
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.red[900],
        backgroundColor: Color.fromARGB(255, 4, 152, 132),
        actions: <Widget>[
          PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: dark ? Colors.black : Colors.white,
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text("Welcome ${user?.username}"),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          Text("Logout")
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications,
                            color: Colors.red,
                          ),
                          Text("Notifications")
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 4,
                      child: Row(
                        children: [
                          Icon(
                            Icons.history_rounded,
                            color: Colors.red,
                          ),
                          Text("History")
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 5,
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings,
                            color: Colors.red,
                          ),
                          Text("Settings")
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 6,
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.red,
                          ),
                          Text("Profile")
                        ],
                      ),
                    ),
                  ],
              onSelected: (value) {
                if (value == 1) {
                  Navigator.of(context).pushNamed('/event.form');
                } else if (value == 2) {
                  Navigator.pushNamed(context, '/logout');
                } else if (value == 3) {
                  Navigator.pushNamed(context, '/notifications');
                } else if (value == 4) {
                  Navigator.pushNamed(context, '/history');
                } else if (value == 5) {
                  Navigator.pushNamed(context, '/settings');
                } else if (value == 6) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        user: user ?? User(),
                      ),
                    ),
                  );
                }
              })
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 30,
              child: Image.asset('assets/icons/upcoming events.png'),
            ),
            Switch(
              value: dark,
              onChanged: (state) =>
                  ref.read(themeProvider.notifier).update((state) => !state),
              activeColor: Colors.black,
              activeTrackColor: Colors.black12,
              inactiveThumbColor: Colors.transparent,
              inactiveTrackColor: Colors.white10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedTab,
          onTap: (index) {
            setState(() {
              selectedTab = index;
            });
          },
          backgroundColor: Color.fromARGB(255, 4, 152, 132),
          selectedItemColor: Colors.red[500],
          unselectedItemColor: Colors.red[50],
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Upcoming events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Category',
            )
          ]),
      body: currentPage,
    );
  }
}

// class Service extends StatelessWidget {
//   const Service({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final List<String> services = ['Events', 'Printatone', 'Freebies'];
//     return ListView.builder(
//       itemCount: services.length,
//       itemBuilder: (context, index) {
//         return Card(
//             elevation: 4,
//             child: SizedBox(
//               height: 190,
//               child: Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: Card(
//                   elevation: 7,
//                   color: Colors.brown[100],
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       image: const DecorationImage(
//                         image: AssetImage('assets/icons/upcoming events.png'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(6.0),
//                           child: Center(
//                               child: Container(
//                             color: Colors.brown[100],
//                             child: Padding(
//                               padding: const EdgeInsets.all(5.0),
//                               child: Text(
//                                 services[index],
//                                 style:
//                                     Theme.of(context).textTheme.headlineMedium,
//                               ),
//                             ),
//                           )),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(5.0),
//                           child: Center(
//                               child: Container(
//                             color: Colors.brown[100],
//                             child: Padding(
//                               padding: const EdgeInsets.all(5.0),
//                               child: Text(
//                                 "Description goes here",
//                                 style:
//                                     Theme.of(context).textTheme.headlineSmall,
//                               ),
//                             ),
//                           )),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ));
//       },
//     );
//   }
// }
