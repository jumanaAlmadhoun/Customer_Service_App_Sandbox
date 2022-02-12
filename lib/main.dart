import 'package:customer_service_app/Helpers/layout_constants.dart';
import 'package:customer_service_app/Layouts/Login_Page/login_page.dart';
import 'package:customer_service_app/Localization/demo_localization.dart';
import 'package:customer_service_app/Routes/custom_router.dart';
import 'package:customer_service_app/Routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'Localization/localization_constants.dart';
import 'Services/login_provider.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static void setLocale(BuildContext context, Locale? locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  void setLocale(Locale? locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LoginHandeler()),
      ],
      child: MaterialApp(
        title: 'Customer Service App',
        theme: ThemeData(
            canvasColor: BACK_GROUND_COLOR,
            iconTheme: const IconThemeData(color: ICON_COLOR),
            appBarTheme: const AppBarTheme(
              backgroundColor: APP_BAR_COLOR,
              centerTitle: true,
              titleTextStyle: TextStyle(
                  color: APP_BAR_TEXT_COLOR,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            )),
        locale: _locale,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'SA'),
        ],
        localizationsDelegates: const [
          DemoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        localeResolutionCallback: (
          Locale? deviceLocale,
          Iterable<Locale> supportedLocales,
        ) {
          for (var locale in supportedLocales) {
            if (locale.languageCode == deviceLocale!.languageCode) {
              return deviceLocale;
            }
          }
          return supportedLocales.first;
        },
        initialRoute: loginRoute,
        onGenerateRoute: CustomRouter.allRoutes,
      ),
    );
  }
}
