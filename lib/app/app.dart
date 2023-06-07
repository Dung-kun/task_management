import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/pages/splash/splash_page.dart';
import 'package:to_do_list/util/extension/dimens.dart';

import '/pages/welcome/welcome_page.dart';
import '/routing/app_routes.dart';
import '/routing/route_generator.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      onGenerateRoute: RouteGenerator().onGenerateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'AvenirNextRoundedPro',
      ),
      home: LinkApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LinkApp extends StatefulWidget {
  const LinkApp({Key? key}) : super(key: key);

  @override
  State<LinkApp> createState() => _LinkAppState();
}

class _LinkAppState extends State<LinkApp> {


  @override
  void initState() {
    print("Hello em 5");
    super.initState();

    // initDynamicLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: WelcomePage.instance(),
    );
  }
}
