import 'package:chat/config/logger.dart';
import 'package:chat/presentation/home/home_page.dart';
import 'package:chat/presentation/welcome/welcome_page.dart';
import 'package:chat/providers/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final GlobalKey<ScaffoldState> mainPageKey = GlobalKey<ScaffoldState>();

class MainPage extends HookConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authUserStreamProvider);
    final authStateNotifier = ref.watch(authStateNotifierProvider.notifier);

    return authUser.when(
      data: (user) {
        if (user != null) {
          authStateNotifier.addUser(authUser: user);
        }
        logger.i('⚡ Auth: $user');

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushAndRemoveUntil<void>(
            MaterialPageRoute(
              builder: (context) =>
                  user == null ? const WelcomePage() : HomePage(),
            ),
            (route) => false,
          );
        });
        return Container();
      },
      error: (e, s) => Center(
        child: Text(e.toString()),
      ),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
