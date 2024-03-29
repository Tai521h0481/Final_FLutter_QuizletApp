import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/achievements/achievement_screen.dart';
import 'package:shop_app/screens/achievements/components/achievement.dart';
import 'package:shop_app/screens/discover/discover_screen.dart';
import 'package:shop_app/screens/flashcard/components/congrats_screen.dart';
import 'package:shop_app/screens/flashcard/flashcard_screen.dart';
import 'package:shop_app/screens/flipcard/components/edit_topic.dart';
import 'package:shop_app/screens/flipcard/flipcard_screen.dart';
import 'package:shop_app/screens/folders/components/edit_folder.dart';
import 'package:shop_app/screens/folders/folders_screen.dart';
import 'package:shop_app/screens/folders/new_folder_screen.dart';
import 'package:shop_app/screens/library/library_screen.dart';
import 'package:shop_app/screens/profile/components/profile_change_password.dart';
import 'package:shop_app/screens/profile/profile_edit_screen.dart';
import 'package:shop_app/screens/quiz/quiz_page_screen.dart';
import 'package:shop_app/screens/studyset/studyset_screen.dart';

import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/init_screen.dart';
import 'screens/register_success/register_success_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/splash/splash_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  AchievementComponent.routeName: (context) => const AchievementComponent(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  ProfileEditScreen.routeName: (context) => const ProfileEditScreen(),
  RegisterSuccessScreen.routeName: (context) => const RegisterSuccessScreen(),
  ProfileChangePassword.routeName: (context) => const ProfileChangePassword(),
  FlipCardScreen.routeName: (context) => const FlipCardScreen(),
  FolderScreen.routeName: (context) => const FolderScreen(),
  LibraryScreen.routeName: (context) => const LibraryScreen(),
  AchievementScreen.routeName:(context) => const AchievementScreen(),
  DiscoverScreen.routeName:(context) => const DiscoverScreen(),
  StudySetScreen.routeName:(context) => StudySetScreen(),
  NewFolderScreen.routeName:(context) => NewFolderScreen(),
  EditTopic.routeName:(context) => EditTopic(),
  EditFolder.routeName:(context) => EditFolder(),
  FlashcardsView.routeName:(context) => FlashcardsView(),
  CongratsScreen.routeName:(context) => CongratsScreen(),
  QuizPage.routeName:(context) => QuizPage(),
};
