import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:party_planner/src/ui/widgets/typography/text_field.dart';

import '../features/onboarding/cubit/onboarding_cubit.dart';

class CustomDatePickerFormField extends FormField<DateTime> {
  CustomDatePickerFormField({
    super.key,
    required BuildContext context,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? initialDate,
    required OnboardingCubit cubit,
    String? labelText,
  }) : super(
          initialValue: initialDate,
          validator: (value) {
            if (value == null) {
              return 'Please enter your birthdate';
            }

            final now = DateTime.now();
            if (value.isAfter(now)) {
              return 'Birthdate cannot be in the future';
            }

            return null;
          },
          builder: (FormFieldState<DateTime> state) {
            final controller = TextEditingController(
              text: state.value != null
                  ? DateFormat('MM/dd/yyyy').format(state.value!)
                  : '',
            );

            return GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: state.value ?? DateTime(2000),
                  firstDate: firstDate,
                  lastDate: lastDate,
                  initialEntryMode: DatePickerEntryMode.inputOnly,
                );

                if (pickedDate != null) {
                  state.didChange(pickedDate);
                  cubit.updateBirthDate(pickedDate);
                  controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                }
              },
              child: AbsorbPointer(
                child: GradientTextField(
                  labelText: labelText ?? 'Date of birth',
                  hint: 'DD/MM/YYYY',
                  icon: Icon(
                    Icons.cake_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  errorText: state.errorText,
                  controller: controller,
                  inputType: TextInputType.datetime,
                  onChanged: (_) {},
                ),
              ),
            );
          },
        );
}
