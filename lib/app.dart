import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/colors.dart';
import 'models/game_state.dart';
import 'screens/start_screen.dart';
import 'screens/game_screen.dart';
import 'screens/game_over_screen.dart';
import 'services/game_engine.dart';

/// Root application widget — sets up the theme and injects the GameEngine
class NeonSynapseApp extends StatelessWidget {
  const NeonSynapseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameEngine(),
      child: MaterialApp(
        title: 'NEON_SYNAPSE v1.0',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: NeonColors.background,
          colorScheme: const ColorScheme.dark(
            surface: NeonColors.surface,
            primary: NeonColors.primary,
            secondary: NeonColors.secondaryPink,
            tertiary: NeonColors.tertiary,
          ),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: const FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.linux: const FadeUpwardsPageTransitionsBuilder(),
            },
          ),
        ),
        home: const _GameRouter(),
      ),
    );
  }
}

/// Reactive router that switches screens based on GameEngine phase
class _GameRouter extends StatelessWidget {
  const _GameRouter();

  @override
  Widget build(BuildContext context) {
    final engine = context.watch<GameEngine>();

    switch (engine.phase) {
      case GamePhase.start:
        return StartScreen(
          onPlay: () => engine.startGame(),
        );
      case GamePhase.playing:
      case GamePhase.paused:
        return const GameScreen();
      case GamePhase.gameOver:
        return GameOverScreen(
          onRestart: () => engine.restart(),
          onExit: () => engine.goToStart(),
        );
    }
  }
}
