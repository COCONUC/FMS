
import 'package:FMS/constants/color_constant.dart';
import 'package:FMS/features/auth_services.dart';
import 'package:FMS/providers/data_class.dart';
import 'package:FMS/router.dart';
import 'package:FMS/screens/widgets/auth_screen.dart';
import 'package:FMS/screens/customer_screens/nav_screen.dart';
import 'package:FMS/screens/staff_screens/staff_home_page.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
   // WidgetsFlutterBinding.ensureInitialized();
   // await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<DataClass>(create: (context) => DataClass()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => AppState();
}

class AppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState(){
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Computer Services',
      theme: ThemeData(
        scaffoldBackgroundColor: mBackgroundColor,
        colorScheme: const ColorScheme.light(
          primary: mSecondaryColor,
        ),
      ),

      onGenerateRoute: (settings) => generateRoute(settings),
      home: Provider.of<DataClass>(context).user.accessToken.isNotEmpty
          ? Provider.of<DataClass>(context).user.role == 'customer'
          ? const NavScreen()
          : const StaffHomePage() // Staff BottomBar
          : const AuthScreen(),

    );

  }

}
