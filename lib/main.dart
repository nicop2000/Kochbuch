import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kochbuch/data/recipe_service.dart';
import 'package:kochbuch/domain/runtime_state.dart';
import 'package:kochbuch/presentation/cookbook_list.dart';
import 'package:kochbuch/presentation/import_screen.dart';
import 'package:kochbuch/presentation/settings_screen.dart';
import 'package:kochbuch/presentation/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  RecipeService.instance.prefs = preferences;
  RecipeService.instance.loadRecipes();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RuntimeState())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final List<Widget> _tabs = [
    const CookbookList(),
    ImportScreen(),
    SettingsScreen()
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance?.addObserver(this);
  // }
  //
  // @override
  // void dispose() {
  //   WidgetsBinding.instance?.removeObserver(this);
  //   super.dispose();
  // }
  //
  // @override
  // void didChangePlatformBrightness() {
  //   // final Brightness brightness =
  //   //     WidgetsBinding.instance?.window.platformBrightness;
  //   //inform listeners and rebuild widget tree
  // }

  @override
  Widget build(BuildContext context) {
    context.read<RuntimeState>().init();
    //Buttons extra einfärben

    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: c1L,
          textTheme: cText(c1L)),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: c1D,
          textTheme: cText(c1D)
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de'),
        Locale('en'),
      ],
      home: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.book), label: 'Rezepte'), //TODO
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.square_arrow_down),
                  label: 'Import'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.settings), label: 'Einstellungen'),
            ],
          ),
          tabBuilder: (BuildContext context, index) {
            return _tabs[index];
          }),
    );
  }
}


/*
colorScheme: ColorScheme(
          brightness: Brightness.light,
          background: Colors.red,
          onBackground: Colors.white,
          primary: Colors.amber,
          //AppBar und Buttons
          primaryVariant: Colors.black38,
          onPrimary: Colors.green,
          //auf Primary
          secondary: Colors.blue,
          secondaryVariant: Colors.brown,
          onSecondary: Colors.limeAccent,
          error: Colors.purple,
          onError: Colors.pink,
          surface: Colors.teal,
          onSurface: Colors.orange,
        ),
 */
