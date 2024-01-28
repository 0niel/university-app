import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class BottomErrorInfo extends StatelessWidget {
  const BottomErrorInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.colorsOf(context).secondary,
              AppTheme.colorsOf(context).deactive,
              AppTheme.colorsOf(context).background01
            ],
            begin: const Alignment(-1, -1),
            end: const Alignment(-1, 1),
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: AppTheme.colorsOf(context).background01,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                  style: AppTextStyle.h5,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Разработчики, отвечающие за API ЛКС, отключили возможность производить аутентификацию и получать данные своего аккаунта. Пожалуйста, используйте lk.mirea.ru",
                  style: AppTextStyle.captionL.copyWith(color: AppTheme.colorsOf(context).deactive),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: double.infinity, height: 48),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(AppTheme.colorsOf(context).primary),
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
                      style: AppTextStyle.buttonS,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
