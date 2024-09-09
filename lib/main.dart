import 'package:flutter/material.dart';
import 'package:diteventsapp/screens/create_event_form.dart';
import 'package:diteventsapp/screens/home.dart';
import 'package:diteventsapp/screens/loading.dart';
import 'package:diteventsapp/screens/login.dart';
import 'package:diteventsapp/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateProvider<bool>((ref) => false);
void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => AppState();
}

class AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    final dark = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textTheme: TextTheme(
          //change all text color depending on dark mode
          bodyLarge: TextStyle(color: dark ? Colors.white : Colors.black),
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.transparent,
            brightness: dark ? Brightness.dark : Brightness.light),
      ),
      home: const Loading(),
      //navigatorObservers: [NavigationHistoryObserver()],
      routes: {
        '/home': (context) => const Home(),
        '/login': (context) => const Login(),
        '/logout': (context) => const Logout(),
        '/event.form': (context) => const CreateEventForm(
              title: 'Create Event',
            ),
        '/notifications': (context) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Notifications",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red[900],
              ),
              body: const Center(
                child: Text(
                  "You have no notifications",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
        '/history': (context) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  "History",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red[900],
              ),
              body: const Center(
                child: Text(
                  "No History Recorded",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
        '/settings': (context) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Settings",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red[900],
              ),
              body: const Center(
                child: Text(
                  "Settings",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
      },
    );
  }
}

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    logout();
    return const Login();
  }
}
