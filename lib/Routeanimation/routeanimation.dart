import 'package:flutter/material.dart';

class Coustomroute<T> extends MaterialPageRoute<T> {
  Coustomroute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      alwaysIncludeSemantics: true,
      opacity: animation,
      child: child,
    );
  }
}

class CoustomPageroutebuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<dynamic> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    
    return FadeTransition(
      alwaysIncludeSemantics: true,
      opacity: animation,
      child: child,
    );
  }
}
