import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ioc/flutter_ioc.dart';
import 'package:party_planner/src/core/services/preference_service.dart';
import 'package:party_planner/src/core/services/user_service.dart';
import 'package:party_planner/src/ui/features/login_form/view/login_view.dart';
import 'package:party_planner/src/ui/widgets/dialog.dart';
import 'package:party_planner/src/ui/widgets/discord_tag_section.dart';
import 'package:party_planner/src/ui/widgets/display_name_section.dart';
import 'package:party_planner/src/ui/widgets/role_section.dart';
import 'package:party_planner/src/ui/widgets/typography/text_field.dart';
import '../../../../widgets/attendance_section.dart';
import '../../../../widgets/game_section.dart';
import '../../../../../ui/widgets/location_section.dart';
import '../../../../../ui/widgets/phone_number_section.dart';
import '../../../../../ui/widgets/snackbar.dart';
import '../../../../widgets/typography/btn.dart';
import '../../cubit/settings/account_settings_cubit.dart';
import '../../cubit/settings/account_settings_state.dart';

class AccountSettingsView extends StatelessWidget {
  AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountSettingsCubit(
        Ioc.container.get<UserService>(),
        Ioc.container.get<PreferencesService>(),
      )..loadSettings(),
      child: BlocConsumer<AccountSettingsCubit, AccountSettingsState>(
        listener: (BuildContext context, AccountSettingsState state) {
          if (state.hasLoggedOut) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginView(),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Profile Settings',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildSettingsForm(context, state),
          );
        },
      ),
    );
  }

  Widget _buildSettingsForm(BuildContext context, AccountSettingsState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPasswordSection(context, state),
          const SizedBox(height: 24),
          _buildContactSection(context, state),
          const SizedBox(height: 24),
          _buildLocationFields(context),
          const SizedBox(height: 24),
          Text(
            'Preferences',
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 18.0),
          ),
          const SizedBox(height: 8),
          _buildGameSection(context, state),
          const SizedBox(height: 24),
          _buildRoleSection(context, state),
          const SizedBox(height: 24),
          _buildAttendanceSection(context, state),
          const SizedBox(
            height: 24,
          ),
          _buildNotificationsSection(context, state),
          const SizedBox(height: 24),
          _buildDeleteProfileButton(context, state),
          const SizedBox(height: 24),
          _buildLogoutButton(context, state),
          const SizedBox(
            height: 24,
          ),
          _buildSaveButton(context, state),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AccountSettingsState state) {
    return TextBtn(
      icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.primary),
      text: Text("Logout"),
      onPressed: () async {
        context.read<AccountSettingsCubit>().logout();
      },
    );
  }

  Widget _buildLocationFields(BuildContext context) {
    return LocationSectionField(
      countryController: context.read<AccountSettingsCubit>().countryController,
      cityController: context.read<AccountSettingsCubit>().cityController,
      onCityChanged: context.read<AccountSettingsCubit>().updateCity,
      onCountryChanged: context.read<AccountSettingsCubit>().updateCountry,
    );
  }

  Widget _buildPasswordSection(
    BuildContext context,
    AccountSettingsState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Change Password',
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontSize: 18.0),
        ),
        const SizedBox(height: 8),
        GradientTextField(
          obscureText: true,
          maxLines: 1,
          fieldName: 'oldPassword',
          controller:
              context.read<AccountSettingsCubit>().oldPasswordController,
          hint: 'Old password..',
          errorText: context.read<AccountSettingsCubit>().getFieldError(
                'oldPassword',
                state.isOldPasswordValid,
                state.oldPassword,
              ),
          onChanged: (value) =>
              context.read<AccountSettingsCubit>().updateOldPassword(value),
          onTouched: () =>
              context.read<AccountSettingsCubit>().fieldTouched('oldPassword'),
        ),
        const SizedBox(height: 8),
        GradientTextField(
          obscureText: true,
          maxLines: 1,
          fieldName: 'newPassword',
          controller:
              context.read<AccountSettingsCubit>().newPasswordController,
          hint: 'New password..',
          errorText: context.read<AccountSettingsCubit>().getFieldError(
                'newPassword',
                state.isNewPasswordValid,
                state.newPassword,
              ),
          onChanged: (value) =>
              context.read<AccountSettingsCubit>().updateNewPassword(value),
          onTouched: () =>
              context.read<AccountSettingsCubit>().fieldTouched('newPassword'),
        ),
      ],
    );
  }

  Widget _buildContactSection(
    BuildContext context,
    AccountSettingsState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontSize: 18.0),
        ),
        const SizedBox(height: 8),
        DisplayNameSection(
          controller:
              context.read<AccountSettingsCubit>().displayNameController,
          onChanged: (value) =>
              context.read<AccountSettingsCubit>().updateDisplayName(value),
        ),
        const SizedBox(height: 16),
        PhoneNumberSection(
          controller:
              context.read<AccountSettingsCubit>().phoneNumberController,
          onChanged: context.read<AccountSettingsCubit>().updatePhoneNumber,
        ),
        const SizedBox(height: 16),
        DiscordTagSection(
          controller: context.read<AccountSettingsCubit>().discordTagController,
          onChanged: (value) =>
              context.read<AccountSettingsCubit>().updateDiscordTag(value),
        ),
      ],
    );
  }

  Widget _buildGameSection(
    BuildContext context,
    AccountSettingsState state,
  ) {
    return GamesSection(
      selectedGames: state.ttrpgs ?? [],
      onGamesUpdated: (updatedGames) {
        context.read<AccountSettingsCubit>().updateGamesList(updatedGames);
      },
    );
  }

  _buildRoleSection(
    BuildContext context,
    AccountSettingsState state,
  ) {
    return RoleSection(
      role: state.rolePreference?.name ?? '',
      onChanged: (value) {
        context.read<AccountSettingsCubit>().updateRolePreference(value!);
      },
    );
  }

  Widget _buildAttendanceSection(
    BuildContext context,
    AccountSettingsState state,
  ) {
    return AttendanceSection(
      text: 'Select your attendance',
      attendancePreference: state.attendancePreference?.name ?? '',
      onChanged: (value) {
        context.read<AccountSettingsCubit>().updateAttendancePreference(value!);
      },
    );
  }

  Widget _buildNotificationsSection(
    BuildContext context,
    AccountSettingsState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notifications',
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontSize: 18.0),
        ),
        SwitchListTile(
          title: const Text('Game session updates'),
          value: state.eventUpdates,
          onChanged: (value) =>
              context.read<AccountSettingsCubit>().updateEventUpdates(value),
        ),
        SwitchListTile(
          title: const Text('Game session reminders'),
          value: state.reminders,
          onChanged: (value) =>
              context.read<AccountSettingsCubit>().updateReminders(value),
        ),
      ],
    );
  }

  Widget _buildDeleteProfileButton(
    BuildContext context,
    AccountSettingsState state,
  ) {
    return TextBtn(
      text: Text("Delete profile"),
      onPressed: () async {
        bool? shouldDelete = await Dialogs.showProfileDeletionDialog(context);
        if (shouldDelete == true) {
          if (context.mounted) {
            context.read<AccountSettingsCubit>().deleteProfile();
          }
        }
      },
    );
  }

  Widget _buildSaveButton(BuildContext context, AccountSettingsState state) {
    return Center(
      child: SolidPrimaryBtn(
        text: Text(
          state.isSubmitting ? 'Saving...' : 'Save',
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
          textAlign: TextAlign.center,
        ),
        onPressed: state.isLoading || state.isSubmitting
            ? null
            : () async {
                try {
                  await context.read<AccountSettingsCubit>().submitForm();
                  AppSnackBar.show(
                    message: 'Settings saved successfully',
                    type: SnackBarType.success,
                  );
                } catch (e) {
                  AppSnackBar.show(
                    message: 'Failed to save settings',
                    type: SnackBarType.error,
                  );
                }
              },
      ),
    );
  }
}
