import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/domain/entities/employee.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:app_ui/app_ui.dart';

class LectorSearchCard extends StatelessWidget {
  const LectorSearchCard({super.key, required this.employee});

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      color: Theme.of(context).extension<AppColors>()!.background02,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '${employee.name} ${employee.secondName} ${employee.lastName}',
            style: AppTextStyle.bodyBold,
          ),
          SizedBox(
            height: 30,
            child: TextButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
              ),
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: employee.email));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email адрес скопирован!')));
              },
              onPressed: () {
                launchUrlString("mailto:${employee.email}?subject=&body=");
              },
              child: Text(
                employee.email,
                style: AppTextStyle.bodyRegular.copyWith(color: Theme.of(context).extension<AppColors>()!.colorful02),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(employee.institute, style: AppTextStyle.bodyRegular),
          Text(employee.department, style: AppTextStyle.bodyRegular),
        ],
      ),
    );
  }
}
