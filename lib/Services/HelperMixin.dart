import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin HelperMixin {

  Widget textFormWidget({
    TextEditingController? controller,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    double? radius,
    bool? obscureText,
    FormFieldValidator? validator,
    TextInputType? keyboardType,
    VoidCallback? onTap,
    FocusNode? focusNode,
    List<TextInputFormatter>? inputFormatters,
    TextAlign? textAlign,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      validator: validator,
      keyboardType: keyboardType,
      onTap: onTap,
      textAlign: textAlign??TextAlign.start,
      inputFormatters: inputFormatters??[],
      focusNode: focusNode,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 10),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

extension MediaQueryExtension on BuildContext{
  Size get sizes=>MediaQuery.sizeOf(this);
}
