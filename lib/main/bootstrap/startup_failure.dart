part of 'bootstrap.dart';

class _StartupFailure extends StatelessWidget {
  const _StartupFailure({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.light.canvas,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Приложение не смогло запуститься',
                  textAlign: TextAlign.center,
                  style: AppText.title.copyWith(color: AppColors.light.ink),
                ),
                const SizedBox(height: 8),
                Text(
                  '$error',
                  textAlign: TextAlign.center,
                  style: AppText.subtext.copyWith(color: AppColors.light.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
