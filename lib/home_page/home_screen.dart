import 'package:flutter/material.dart';
import 'package:pixev/authentication/authentication_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: Text('Sign Out')),
      ),
    );
  }
}
