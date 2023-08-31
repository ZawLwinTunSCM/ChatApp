import 'package:chat/assets/assets.gen.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:chat/presentation/components/custom_app_bar.dart';
import 'package:chat/presentation/components/setting_button.dart';
import 'package:chat/presentation/main/main_page.dart';
import 'package:chat/presentation/profile/change_password.dart';
import 'package:chat/presentation/profile/edit_profile.dart';
import 'package:chat/providers/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final authStateNotifier = ref.watch(authStateNotifierProvider.notifier);
    final provider =
        ref.watch(authUserStreamProvider).value?.providerData.first.providerId;
    return Scaffold(
        appBar: CustomAppBar(
          title: Text(
            'Profile',
            style: commonTextStyle(size: 20),
          ),
        ),
        body: user.when(
          data: (user) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 38,
                  ),
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                      user!.profilePhoto,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    user.name,
                    style: commonTextStyle(size: 25, weight: FontWeight.w500),
                  ),
                  Text(
                    user.email,
                    style: commonTextStyle(size: 20, weight: FontWeight.w300),
                  ),
                  const SizedBox(height: 43),
                  settingButton(
                      icon: SvgPicture.asset(Assets.images.contactShare),
                      text: 'Share Your Contact'),
                  settingButton(
                    icon: SvgPicture.asset(Assets.images.edit),
                    text: 'Edit Profile',
                    onClick: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditProfilePage(user: user),
                      ));
                    },
                  ),
                  if (provider != null && provider.contains('password'))
                    settingButton(
                      icon: SvgPicture.asset(Assets.images.passwordEdit),
                      text: 'Change Password',
                      onClick: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage(),
                        ));
                      },
                    ),
                  settingButton(
                      icon: SvgPicture.asset(Assets.images.settings),
                      text: 'Settings'),
                  settingButton(
                      icon: SvgPicture.asset(Assets.images.security),
                      text: 'Security & Privacy'),
                  settingButton(
                      icon: SvgPicture.asset(Assets.images.document),
                      text: 'Terms & Policies'),
                  settingButton(
                      icon: SvgPicture.asset(Assets.images.report),
                      text: 'Report a Problem'),
                  settingButton(
                    icon: SvgPicture.asset(Assets.images.logout),
                    text: 'Logout',
                    onClick: () async {
                      await authStateNotifier.signOut();
                      Navigator.of(context).pushAndRemoveUntil<void>(
                        MaterialPageRoute(
                          builder: (context) => const MainPage(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            );
          },
          error: (e, s) => Center(
            child: Text(e.toString()),
          ),
          loading: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ));
  }
}
