import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/pages/auth/sign_in/sign_in_page.dart';
import 'package:to_do_list/pages/auth/sign_up/sign_up_page.dart';
import 'package:to_do_list/pages/detail_task/detail_task_page.dart';
import 'package:to_do_list/pages/home/home_page.dart';
import 'package:to_do_list/pages/new_task/new_task_page.dart';
import 'package:to_do_list/pages/splash/splash_page.dart';
import 'package:to_do_list/pages/welcome/welcome_page.dart';
import 'package:to_do_list/routing/app_routes.dart';

class RouteGenerator {
  static RouteGenerator? _instance;

  RouteGenerator._();

  factory RouteGenerator() {
    _instance ??= RouteGenerator._();
    return _instance!;
  }

  Route<dynamic> onGenerateRoute(RouteSettings setting) {
    final uri = Uri.parse(setting.name!);
    GetPageRoute page({required Widget child}) {
      return GetPageRoute(
          settings: setting, page: () => child, transition: Transition.fadeIn);
    }

    switch (setting.name) {
      case AppRoutes.SPLASH:
        return page(child: SplashPage.instance());
      case AppRoutes.WELCOME:
        return page(child: WelcomePage.instance());
      case AppRoutes.HOME:
        return page(child: HomePage.instance());
      case AppRoutes.SIGN_IN:
        return page(child: SignInPage.instance());
      case AppRoutes.SIGN_UP:
        return page(child: SignUpPage.instance());
      case AppRoutes.NEW_TASK:
        return page(child: NewTaskPage.instance());
      case AppRoutes.DETAIL_TASK:
        return page(child: DetailTaskPage.instance());
      default:
        throw RouteException("Route not found");
    }
  }
}

class RouteException implements Exception {
  final String message;

  const RouteException(this.message);
}
