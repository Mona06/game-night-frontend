import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/splash_screen_cubit.dart';
import '../cubit/splash_screen_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenWidgetState createState() => SplashScreenWidgetState();
}

class SplashScreenWidgetState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Define the animations
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashScreenCubit()..splash(),
      child: BlocListener<SplashScreenCubit, SplashScreenState>(
        listenWhen: (previous, current) => previous.state != current.state,
        listener: (context, state) {
          if (state.state == SplashAction.splash) {
            // Start the animation when splash state is emitted
            _animationController.forward();
          } else {
            // Stop the animation (resetting to initial state) when other states are emitted
            _animationController.reverse();
          }

          if (state.state != SplashAction.splash) {
            switch (state.state) {
              case SplashAction.introduction:
                Navigator.of(context).pushNamed('/introduction');
                break;
              case SplashAction.unauthenticated:
                Navigator.of(context).pushNamed('/login');
                break;
              case SplashAction.onboarding:
                Navigator.of(context).pushNamed('/onboarding');
                break;
              case SplashAction.authenticated:
                Navigator.of(context).pushNamed('/home');
                break;
              case SplashAction.splash: // Do nothing
                break;
            }
          }
        },
        child: BlocBuilder<SplashScreenCubit, SplashScreenState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _opacityAnimation.value,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 48.0),
                              child: Image.asset(
                                'assets/logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if (state.showLoader) ...[
                      const SizedBox(height: 32),
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
