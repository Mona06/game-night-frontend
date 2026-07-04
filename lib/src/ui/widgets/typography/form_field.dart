import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatefulWidget {
  final String fieldName;
  final String? labelText;
  final String hintText;
  final Icon? icon;
  final bool obscureText;
  final TextEditingController? controller;
  final String? errorText;
  final Function(String) onChanged;
  final VoidCallback? onTouched;
  final TextInputType? inputType;
  final Color? fillColor;

  const CustomFormField({
    super.key,
    required this.fieldName,
    this.labelText,
    required this.hintText,
    this.icon,
    this.obscureText = false,
    this.controller,
    this.errorText,
    required this.onChanged,
    this.onTouched,
    this.inputType,
    this.fillColor,
  });

  @override
  CustomFormFieldState createState() => CustomFormFieldState();
}

class CustomFormFieldState extends State<CustomFormField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      keyboardType: widget.inputType,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9@a-zA-Z.]")),
      ],
      controller: widget.controller,
      obscureText: widget.obscureText,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        errorText: widget.errorText,
        prefixIcon: widget.icon,
        labelText: widget.labelText,
        errorStyle:
            TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.error),
        hintText: widget.hintText,
        contentPadding: EdgeInsets.all(10),
        filled: true,
        fillColor: widget.fillColor ??
            Color(0xffdff9fa).withAlpha((255.0 * 0.6).round()),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: GradientOutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          width: 1,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.tertiary,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      onChanged: widget.onChanged,
      onTap: widget.onTouched,
    );
  }
}

class GradientOutlineInputBorder extends OutlineInputBorder {
  final Gradient gradient;
  final double width;

  const GradientOutlineInputBorder({
    required this.gradient,
    required this.width,
    super.borderSide = BorderSide.none,
    super.borderRadius,
    super.gapPadding,
  });

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(rect), paint);
  }
}
