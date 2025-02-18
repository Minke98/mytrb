import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MainLayout extends StatelessWidget {
  final Widget body;
  Widget? floatingActionButton;
  final String? appbarTitle;
  bool? resizeToAvoidBottomInset;
  VoidCallback? onPressed;

  MainLayout({
    Key? key,
    required this.body,
    this.appbarTitle,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: generateAppbar(context),
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
    );
  }

  generateAppbar(ctx) {
    final NavigatorState? navigator = Navigator.maybeOf(ctx);
    if (appbarTitle == null || appbarTitle!.isEmpty) {
      return AppBar(
        toolbarHeight: 0,
      );
    } else {
      return AppBar(
        backgroundColor: Theme.of(ctx).colorScheme.background,
        leading: navigator!.canPop()
            ? IconButton(
                color: Colors.black,
                icon: const Icon(Icons.arrow_back),
                onPressed: onPressed ??
                    () {
                      navigator.pop(ctx);
                    },
              )
            : null,
        centerTitle: true,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            appbarTitle!,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
}
