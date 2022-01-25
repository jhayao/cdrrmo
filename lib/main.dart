import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicare/pages/home/accident_page.dart';
import 'package:medicare/pages/home/event_page.dart';
import 'package:medicare/pages/home/home_page.dart';
import 'package:medicare/pages/home/profile_page.dart';
import 'package:medicare/pages/wrapper.dart';
import 'package:medicare/services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:medicare/models/userModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
late String userType;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseMessaging.instance.getToken();
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _counter = 0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
    CollectionReference reference = FirebaseFirestore.instance.collection('accident');

    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        // Do something with change
        print("Accident:" + change.doc['name']);
        print("USER TYPE $userType");
        if(userType == "admin")
          showNotification(change.doc['name'],change.doc['latitude'],change.doc['longitude'],change.doc['type']);
      });
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage ? message) {
      if (message != null) {
        Navigator.pushNamed(context, '/profile',
            arguments: ProfilePage());
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message){
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;

        return flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    //   Navigator.pushNamed(context, '/profile',
    //       arguments: ProfilePage());
    // });
    Navigator.pushNamed(context, '/profile');
  });
  }






  void showNotification(String name,String lat,String long,String type) {
    flutterLocalNotificationsPlugin.show(
        0,
        "New $type Accident",
        "$name Reported a new Accident at $lat,$long",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name, channel.description,
                importance: Importance.max,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }
  void _getdata() async {
    User user = FirebaseAuth.instance.currentUser!;

    FirebaseFirestore.instance
        .collection('userDetails')
        .doc(user.uid)
        .snapshots()
        .listen((userData) {
      // print("USERDATA" + userData['userType']);
      setState(() {
        userType = userData['userType'];
        print("USER ${userData['userType']}");
      });
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<userModel?>.value(
        initialData: null,
        value: AuthService().user,
       catchError: (User,userModel) => null,
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: Wrapper(),
          initialRoute: '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            //HomePage(), Accidents(), Events(), ProfilePage()
            '/': (context) => const Wrapper(),
            // When navigating to the "/second" route, build the SecondScreen widget.
            '/home': (context) =>  HomePage(),
            '/accident': (context) => Accidents(),
            '/event': (context) =>  Events(),
            '/profile': (context) =>  ProfilePage(),
          },
      ),
    );
  }
}
