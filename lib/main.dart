import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:monecom/screens/custom_splash_screen.dart';
import 'package:monecom/stores/signup_store.dart';

void main() async {
  setupLocators();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

void setupLocators() {
  GetIt.I.registerSingleton(SignUpStore());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon&Com',
      debugShowCheckedModeBanner: false,
      theme: _buildShrineTheme(),
      home: CustomSplashScreen(),
    );
  }
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: shrinePurple900);
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    colorScheme: _shrineColorScheme,
    accentColor: shrinePurple900,
    primaryColor: shrineBlack100,
    buttonColor: shrinePurple900,
    scaffoldBackgroundColor: shrineBlack400,
    cardColor: shrineBlack400,
    textSelectionColor: shrineBlack400,
    errorColor: shrineErrorRed,
    buttonTheme: const ButtonThemeData(
      colorScheme: _shrineColorScheme,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: _customIconTheme(base.iconTheme),
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline5: base.headline5.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: defaultLetterSpacing,
        ),
        headline6: base.headline6.copyWith(
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: defaultLetterSpacing,
        ),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
        bodyText1: base.bodyText1.copyWith(
          fontWeight: FontWeight.w900,
          fontSize: 16,
          letterSpacing: defaultLetterSpacing,
        ),
        bodyText2: base.bodyText2.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: defaultLetterSpacing,
        ),
        subtitle1: base.subtitle1.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: defaultLetterSpacing,
        ),
        headline4: base.headline4.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: defaultLetterSpacing,
        ),
        button: base.button.copyWith(
          fontWeight: FontWeight.w900,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
      )
      .apply(
        fontFamily: 'UniSans-Thin',
        displayColor: shrinePurple900,
        bodyColor: shrineSurfaceWhite,
      );
}

const ColorScheme _shrineColorScheme = ColorScheme(
  primary: shrinePurple900,
  primaryVariant: shrinePurple900,
  secondary: shrinePurple900,
  secondaryVariant: shrinePurple900,
  surface: shrineBlack400,
  background: shrineBlack400,
  error: shrineErrorRed,
  onPrimary: shrinePurple900,
  onSecondary: Colors.white,
  onSurface: shrinePurple900,
  onBackground: shrinePurple900,
  onError: shrineBlack400,
  brightness: Brightness.dark,
);

const Color shrineBlack100 = Color(0xFF2c2f33);
const Color shrineBlack400 = Color(0xFF23272a);

const Color shrinePurple900 = Color(0xFF7289da);

const Color shrineErrorRed = Colors.red;

const Color shrineSurfaceWhite = Color(0xFFe9e9e9);
const Color shrineBackgroundWhite = Colors.white;

const defaultLetterSpacing = 0.03;
