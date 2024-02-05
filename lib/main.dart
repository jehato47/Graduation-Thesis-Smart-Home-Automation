import 'firebase_options.dart';
import 'provider/commands.dart';
import 'provider/notifications.dart';
import 'screens/firebase_screen.dart';
import 'screens/home/home_page.dart';
// import 'screens/home/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Commands(),
        ),
        ChangeNotifierProvider(
          create: (_) => NtProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        // darkTheme: ThemeData.dark(
        //   // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
        // themeMode: ThemeMode.dark,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
          useMaterial3: true,
        ),
        home: Scaffold(
          body: FutureBuilder(
              future: Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                if (snapshot.hasData) {
                  // return MainScreen();
                  Commands commands =
                      Provider.of<Commands>(context, listen: false);
                  NtProvider ntProvider =
                      Provider.of<NtProvider>(context, listen: false);

                  return FutureBuilder(
                      future: commands.getInitialData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return FirebaseScreen();
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          print(snapshot.error.toString());

                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        }
                        return HomePage();
                      });
                }

                return Container();
              }),
        ),
      ),
    );
  }
}
