
import 'package:final_project_art_direct/miscellaneous/auth_service.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  final AuthService auth;
  const Provider({
    super.key,
    required super.child,
    required this.auth
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static Provider? of(BuildContext context) => 
    (context.dependOnInheritedWidgetOfExactType<Provider>());
}