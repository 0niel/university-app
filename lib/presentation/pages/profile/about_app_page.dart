import 'package:flutter/material.dart';
import 'package:rtu_app_core/rtu_app_core.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.13),
          scrolledUnderElevation: 8,
          centerTitle: true,
          title: const NinjaText.bodyMedium(
            "О приложении",
            fontWeight: 600,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 22, bottom: 32, left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    NinjaText.bodyMedium(
                      "Open Source",
                      fontWeight: 700,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: NinjaText.bodyMedium(
                        "Это приложение и все относящиеся к нему сервисы являются 100% бесплатными и Open Source продуктами. Мы с огромным удовольствием примем ваши предложения и сообщения, а также рады любому вашему участию в проекте!",
                        fontWeight: 400,
                        height: 1.5,
                      ),
                    ),
                    NinjaText.bodyMedium(
                      "Связаться с нами вы можете с помощью Email",
                      fontWeight: 400,
                      height: 1.5,
                    ),
                    NinjaText.bodyMedium(
                      "contact@mirea.ninja",
                      color: NinjaConstant.secondary,
                      fontWeight: 400,
                      height: 1.5,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 16, left: 24, right: 24),
                    child: NinjaText.bodyMedium(
                      "Ссылки",
                      fontWeight: 700,
                    ),
                  ),
                  Divider(indent: 24, endIndent: 24),
                  SizedBox(height: 16),
                  NinjaTitledButton(
                    title: 'Наш телеграм',
                    text: 't.me/mirea_ninja_chat',
                    onPressed: () =>
                        launchUrl(Uri.parse('https://t.me/mirea_ninja_chat')),
                  ),
                  SizedBox(height: 16),
                  NinjaTitledButton(
                    title: 'GitHub Mirea Ninja',
                    text: 'github.com/mirea-ninja',
                    onPressed: () =>
                        launchUrl(Uri.parse('https://github.com/mirea-ninja')),
                  ),
                  SizedBox(height: 16),
                  NinjaTitledButton(
                    title: 'Группа в ВКонтакте',
                    text: 'vk.com/mirea_ninja',
                    onPressed: () =>
                        launchUrl(Uri.parse('https://vk.com/mirea.ninja')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
