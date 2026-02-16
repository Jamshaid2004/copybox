import 'package:copybox/src/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/global/navigator_key.dart';

class SplashScreenViewModel extends ChangeNotifier {
  /* -------------------------------------------------------------------------- */
  /*                                  Variables                                 */
  /* -------------------------------------------------------------------------- */

  /* -------------------------------------------------------------------------- */
  /*                                   Methods                                  */
  /* -------------------------------------------------------------------------- */

  /// Starts the timer and navigates to the next screen
  void startTimerAndNavigate() async {
    await Future.delayed(Duration(seconds: 2), () {
      // Navigate to the home screen
      navigatorKey.currentContext?.go(AppRoutes.home);
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                                 Properties                                 */
  /* -------------------------------------------------------------------------- */

  static SplashScreenViewModel getInstance([listen = false]) {
    return Provider.of<SplashScreenViewModel>(
       navigatorKey.currentContext!,
       listen: listen,
    );
  }
}
