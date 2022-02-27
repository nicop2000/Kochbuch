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
import 'common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  RecipeService.instance.prefs = preferences;
  RecipeService.instance.loadRecipes();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RuntimeState())],
      child:const  MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
 const MyApp({Key? key}) : super(key: key);

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
      home: AppScaffold()
    );
  }
}

class AppScaffold extends StatelessWidget {
  AppScaffold({Key? key}) : super(key: key);
  final List<Widget> _tabs = [
    const CookbookList(),
    const ImportScreen(),
    const SettingsScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.book), label: AppLocalizations.of(context)!.bottom_bar_item_title_rezepte), //TODO
            BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.square_arrow_down),
                label: AppLocalizations.of(context)!.bottom_bar_item_title_import),
            BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.settings), label: AppLocalizations.of(context)!.bottom_bar_item_title_einstellungen),
          ],
        ),
        tabBuilder: (BuildContext context, index) {
          return _tabs[index];
        });
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
