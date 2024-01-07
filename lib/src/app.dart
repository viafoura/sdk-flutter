import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sdk_flutter/src/auth/login/forgot_password_view.dart';
import 'package:sdk_flutter/src/auth/login/login_view.dart';
import 'package:sdk_flutter/src/auth/login/signup_view.dart';

import 'article/article_view.dart';
import 'article/article_list_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          restorationScopeId: 'app',

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case ArticleView.routeName:
                    return const ArticleView();
                  case LoginView.routeName:
                    return const LoginView();
                  case SignupView.routeName:
                    return const SignupView();
                  case ForgotPasswordView.routeName:
                    return const ForgotPasswordView();
                  case ArticleListView.routeName:
                  default:
                    return const ArticleListView();
                }
              },
            );
          },
        );
  }
}
