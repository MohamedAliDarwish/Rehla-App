import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';

class AppMainButton extends StatelessWidget {
  final String txt;
  final void Function() onPressed;
  final Color? backgroundColor;
  final Color? txtColor;
  final Widget? item;

  const AppMainButton({
    super.key,
    required this.txt,
    this.backgroundColor,
    this.txtColor,
    required this.onPressed,
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        onPressed: onPressed,
        child: Text(txt, style: TextStyle(color: txtColor ?? Colors.white)),
      ),
    );
  }
}
