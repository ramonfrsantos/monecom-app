import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:monecom/screens/base_screen.dart';
import 'package:monecom/stores/cadastro_store.dart';
import 'package:splashscreen/splashscreen.dart';

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
  GetIt.I.registerSingleton(CadastroStore());
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
      home: SplashScreen(
        useLoader: false,
        seconds: 5,
        routeName: "/",
        navigateAfterSeconds: BaseScreen(),
        title: Text(
          'Mon&Com',
          style: TextStyle(
            color: shrinePurple900,
            fontSize: 60,
            fontFamily: 'UniSans-Heavy',
          ),
        ),
        //imageBackground: AssetImage('assets/images/cardFundo.png'), //bg
        //image: Image.network('https://i.imgur.com/TyCSG9A.png'), //logo
        backgroundColor: shrineBlack400,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 40.0,
        onClick: () => print(""),
        loaderColor: Colors.white,
      ),
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
        headline: base.headline.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: defaultLetterSpacing,
        ),
        title: base.title.copyWith(
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: defaultLetterSpacing,
        ),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
        body2: base.body2.copyWith(
          fontWeight: FontWeight.w900,
          fontSize: 16,
          letterSpacing: defaultLetterSpacing,
        ),
        body1: base.body1.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: defaultLetterSpacing,
        ),
        subhead: base.subhead.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: defaultLetterSpacing,
        ),
        display1: base.display1.copyWith(
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
