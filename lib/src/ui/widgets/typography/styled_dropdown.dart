import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class StyledDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String hint;
  final void Function(T?)? onChanged;
  final Widget Function(T) itemBuilder;
  final String? labelText;
  final Color? fillColor;
  final Widget? icon;

  const StyledDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.hint,
    required this.onChanged,
    required this.itemBuilder,
    this.labelText,
    this.fillColor,
    this.icon,
  });

  @override
  StyledDropdownState<T> createState() => StyledDropdownState<T>();
}

class StyledDropdownState<T> extends State<StyledDropdown<T>> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isFocused
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.outline,
              width: 1,
            ),
            gradient: _isFocused
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.tertiary,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: widget.fillColor ?? Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(6),
            ),
            margin: const EdgeInsets.all(2),
            child: DropdownButton2<T>(
              value: widget.value,
              hint: Row(
                children: [
                  if (widget.icon != null) widget.icon!,
                  const SizedBox(width: 12),
                  Text(
                    widget.hint,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              isExpanded: true,
              style: Theme.of(context).textTheme.bodyMedium,
              onChanged: widget.onChanged,
              items: widget.items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: widget.itemBuilder(item),
                );
              }).toList(),
              buttonStyleData: const ButtonStyleData(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color:
                      widget.fillColor ?? Theme.of(context).colorScheme.surface,
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
              focusNode: _focusNode,
            ),
          ),
        ),
        if (widget.labelText != null)
          Positioned(
            left: 16,
            top: -5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              color: widget.fillColor ?? Theme.of(context).colorScheme.surface,
              child: Text(
                widget.labelText!,
                style: TextStyle(
                  color: _isFocused
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
