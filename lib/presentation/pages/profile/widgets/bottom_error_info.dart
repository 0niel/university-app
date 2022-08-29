import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../theme.dart';

class BottomErrorInfo extends StatelessWidget {
  const BottomErrorInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DarkThemeColors.secondary,
            DarkThemeColors.deactive,
            DarkThemeColors.background01
          ],
          begin: Alignment(-1, -1),
          end: Alignment(-1, 1),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(
            color: DarkThemeColors.background01,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Image(
                  image: AssetImage('assets/images/Saly-39.png'),
                  height: 205.0,
                ),
              ),
              Text(
                "Профиль теперь недоступен",
                style: DarkTextTheme.h5,
              ),
              const SizedBox(height: 8),
              Text(
                "Разработчики, отвечающие за API ЛКС, отключили возможность производить аутентификацию и получать данные своего аккаунта. Пожалуйста, используйте lk.mirea.ru",
                style: DarkTextTheme.captionL
                    .copyWith(color: DarkThemeColors.deactive),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(
                    width: double.infinity, height: 48),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(DarkThemeColors.primary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Понятно!',
                    style: DarkTextTheme.buttonS,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
