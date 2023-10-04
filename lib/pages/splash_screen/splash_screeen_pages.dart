import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/auth.dart';

class SplashScreens extends StatefulWidget {
  @override
  _SplashScreensState createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _navigateToAuthPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkShowSplashScreens();
  }

  Future<void> _checkShowSplashScreens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showSplashScreens = prefs.getBool('showSplashScreens') ?? true;

    if (showSplashScreens) {
      prefs.setBool('showSplashScreens', false);
    } else {
      // Navigate to AuthPage
      _navigateToAuthPage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "أهلًا  وسهلا  بكم",
          bodyWidget: Column(
            children: [
              _buildAnimatedLottie('assets/lottie/animation_lkyld16z.json'),
              const SizedBox(height: 20),
              _buildAnimatedText("قائمة بالعديد من الوجبات"),
            ],
          ),
        ),
        PageViewModel(
          title: "تصفح",
          bodyWidget: Column(
            children: [
              _buildAnimatedLottie('assets/lottie/animation_lkyl32yx.json'),
              const SizedBox(height: 20),
              _buildAnimatedText("جد ما ترغب به بسرعه"),
            ],
          ),
        ),
        PageViewModel(
          title: "إطلب وجبتك",
          bodyWidget: Column(
            children: [
              _buildAnimatedLottie('assets/lottie/animation_lkyl9z10.json'),
              const SizedBox(height: 20),
              _buildAnimatedText("إطلب وجبتك الان وانت في مكانك"),
              const SizedBox(height: 50),
              // _buildStartButton(context),
            ],
          ),
        ),
      ],
      onDone: () {
        _navigateToAuthPage(context);
      },
      onSkip: () {
        _navigateToAuthPage(context);
      },
      showSkipButton: true,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Colors.grey,
        activeColor: Colors.amber,
        activeSize: const Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  Widget _buildAnimatedLottie(String assetPath) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      child: AnimatedPositioned(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        top: 0,
        left: 0,
        right: 0,
        child: Lottie.asset(
          assetPath,
          height: 250,
        ),
      ),
    );
  }

  Widget _buildAnimatedText(String text) {
    return AnimatedTextKit(
      animatedTexts: [
        TyperAnimatedText(
          text,
          textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Al-Jazeera'),
          speed: const Duration(milliseconds: 100),
        ),
      ],
      totalRepeatCount: 1,
      pause: const Duration(milliseconds: 1000),
      displayFullTextOnTap: true,
    );
  }
}
