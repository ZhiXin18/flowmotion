import 'package:flowmotion/screens/homeScreen.dart';
import 'package:flowmotion/screens/loginScreen.dart';
import 'package:flowmotion/screens/profileScreen.dart';
import 'package:flowmotion/screens/registerScreen.dart';
import 'package:flowmotion/widgets/splashScreen.dart';
import 'package:flowmotion_api/flowmotion_api.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure the Flutter framework is initialized before running
  final routeApi = FlowmotionApi().getRoutingApi();
  LatLng _initialCenter = LatLng(1.2878, 103.8666);
  LatLng _initialDestination = LatLng(1.3656412, 103.8726954);

  final routePostRequest = RoutePostRequest((b) => b
    ..src.update((srcBuilder) => srcBuilder
      ..kind = RoutePostRequestSrcKindEnum.location //state that location lat long is provided
      ..location.update((locationBuilder) => locationBuilder
        ..latitude = _initialCenter.latitude // Set the latitude
        ..longitude = _initialCenter.longitude // Set the longitude
      )
    )
    ..dest.update((destBuilder) => destBuilder
      ..kind = RoutePostRequestDestKindEnum.location //state that location lat long is provided
      ..location.update((locationBuilder) => locationBuilder
        ..latitude = _initialDestination.latitude // Set the destination latitude
        ..longitude = _initialDestination.longitude // Set the destination longitude
      )
    )
  );

  try {
    final response = await routeApi.routePost(routePostRequest: routePostRequest);
    print(routePostRequest);
    print("/////////////////////////");
    print(response);
  } catch (e) {
    print('Exception when calling RoutingApi->routePost: $e\n');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/register': (context) => RegisterScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/profile': (context) => ProfileScreen(),
        }
    );
  }
}

