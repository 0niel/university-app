import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/domain/entities/employee.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class LectorSearchCard extends StatelessWidget {
  const LectorSearchCard({Key? key, required this.employee}) : super(key: key);

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      color: DarkThemeColors.background02,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            employee.name + ' ' + employee.secondName + ' ' + employee.lastName,
            style: DarkTextTheme.bodyBold,
          ),
          SizedBox(
            height: 30,
            child: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(0)),
              ),
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: employee.email));
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email адрес скопирован!')));
              },
              onPressed: () async {
                await launch("mailto:${employee.email}?subject=&body=");
              },
              child: Text(
                employee.email,
                style: DarkTextTheme.bodyRegular
                    .copyWith(color: DarkThemeColors.colorful02),
              ),
            ),
          ),
          // const SizedBox(height: 8),
          // Text(employee.post, style: DarkTextTheme.bodyRegular),
          // Text(employee.department, style: DarkTextTheme.bodyRegular),
        ],
      ),
    );
  }
}
