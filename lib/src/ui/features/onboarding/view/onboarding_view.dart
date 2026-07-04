import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ioc/flutter_ioc.dart';
import 'package:language_picker/languages.dart';
import 'package:party_planner/src/core/services/preference_service.dart';
import 'package:party_planner/src/ui/widgets/attendance_section.dart';
import 'package:party_planner/src/ui/widgets/bio_section.dart';
import 'package:party_planner/src/ui/widgets/discord_tag_section.dart';
import 'package:party_planner/src/ui/widgets/game_section.dart';
import 'package:party_planner/src/ui/widgets/location_section.dart';
import 'package:party_planner/src/ui/widgets/phone_number_section.dart';

import '../../../widgets/display_name_section.dart';
import '../../../widgets/input_date_picker.dart';
import '../../../../ui/widgets/role_section.dart';
import '../../../../ui/widgets/snackbar.dart';
import '../../../widgets/typography/btn.dart';
import '../../../widgets/typography/styled_dropdown.dart';
import '../../../../core/services/user_service.dart';
import '../../event_form/widgets/custom_chip.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => OnboardingCubit(
        userService: Ioc.container.get<UserService>(),
        preferencesService: Ioc.container.get<PreferencesService>(),
      ),
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listenWhen: (OnboardingState previous, OnboardingState current) {
          return previous.onboardingStatus != current.onboardingStatus;
        },
        listener: (BuildContext context, OnboardingState state) {
          final OnboardingCubit cubit = context.read<OnboardingCubit>();
          if (state.onboardingStatus == OnboardingStatus.onboarded) {
            AppSnackBar.show(
              message: 'Onboarding complete successfully',
              type: SnackBarType.success,
            );
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state.onboardingStatus == OnboardingStatus.failed) {
            AppSnackBar.show(
              message: 'Onboarding submission failed',
              type: SnackBarType.error,
            );
          } else if (state.onboardingStatus == OnboardingStatus.invalid) {
            AppSnackBar.show(
              message: 'Please fill in all required personal information',
              type: SnackBarType.error,
            );
          }

          cubit.resetStatus();
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    OnboardingView(
                      title: 'Personal Information',
                      description: 'Tell us more about yourself',
                      content: _buildPersonalInfoPage(context, state),
                      currentPage: _currentPage,
                      pageController: _pageController,
                    ),
                    OnboardingView(
                      title: 'Contact Information',
                      description: '',
                      content: _buildContactFieldsPage(context, state),
                      currentPage: _currentPage,
                      pageController: _pageController,
                    ),
                    OnboardingView(
                      title: 'Preferences',
                      description: '',
                      content: _buildPreferencesPage(
                        context,
                        state,
                      ),
                      currentPage: _currentPage,
                      pageController: _pageController,
                    ),
                  ],
                ),
                if (state.onboardingStatus == OnboardingStatus.submitting)
                  CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDisplayNameField(BuildContext context) {
    return DisplayNameSection(
      onChanged: context.read<OnboardingCubit>().updateDisplayName,
    );
  }

  Widget _buildDiscordTagField(BuildContext context) {
    return DiscordTagSection(
      onChanged: context.read<OnboardingCubit>().updateDiscordTag,
    );
  }

  Widget _buildPhoneNumberPicker(BuildContext context) {
    return PhoneNumberSection(
      onChanged: context.read<OnboardingCubit>().updatePhoneNumber,
    );
  }

  Widget _buildBirthdateSelector(BuildContext context, OnboardingState state) {
    return CustomDatePickerFormField(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime(2030),
      initialDate: state.birthday,
      cubit: context.read<OnboardingCubit>(),
    );
  }

  Widget _buildBioField(BuildContext context) {
    return BioSection(onChanged: context.read<OnboardingCubit>().updateBio);
  }

  Widget _buildLocationFields(BuildContext context) {
    return LocationSectionField(
      onCityChanged: context.read<OnboardingCubit>().updateCity,
      onCountryChanged: context.read<OnboardingCubit>().updateCountry,
    );
  }

  Widget _buildLanguageSelector(BuildContext context, OnboardingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyledDropdown<Language>(
          labelText: 'Languages',
          icon: Icon(
            Icons.language_outlined,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
          items: Languages.defaultLanguages,
          value: null,
          hint: 'Select language',
          onChanged: (Language? language) {
            if (language != null) {
              _handleLanguageSelection(context, state, language);
            }
          },
          itemBuilder: (Language language) => Text(
            language.name,
            style: TextStyle(
              fontSize: 14,
              color: state.languages.contains(language.name)
                  ? Colors.grey
                  : Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select the languages you speak fluently',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }

  void _handleLanguageSelection(
    BuildContext context,
    OnboardingState state,
    Language language,
  ) {
    if (!state.languages.contains(language.name)) {
      final updatedLanguages = List<String>.from(state.languages)
        ..add(language.name);
      context.read<OnboardingCubit>().updateLanguages(updatedLanguages);
    }
  }

  Widget _buildLanguagesList(BuildContext context, OnboardingState state) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: state.languages.map((language) {
        return SurfaceVariantBadge(
          label: language,
          onDelete: () {
            final updatedLanguages =
                state.languages.where((t) => t != language).toList();
            context.read<OnboardingCubit>().updateLanguages(updatedLanguages);
          },
        );
      }).toList(),
    );
  }

  Widget _buildPreferencesPage(BuildContext context, OnboardingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GamesSection(
          selectedGames: state.ttrpgs ?? [],
          onGamesUpdated: (updatedGames) {
            context.read<OnboardingCubit>().updateGamesList(updatedGames);
          },
        ),
        const SizedBox(height: 16),
        RoleSection(
          role: state.rolePreference?.name ?? '',
          onChanged: (value) {
            context.read<OnboardingCubit>().updateRolePreference(value!);
          },
        ),
        const SizedBox(height: 16),
        AttendanceSection(
          text: 'Select your attendance',
          attendancePreference: state.attendancePreference?.name ?? '',
          onChanged: (value) {
            context.read<OnboardingCubit>().updateAttendancePreference(value!);
          },
        ),
      ],
    );
  }

  Widget _buildContactFieldsPage(context, state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDiscordTagField(context),
        const SizedBox(height: 16),
        _buildPhoneNumberPicker(context),
      ],
    );
  }

  Widget _buildPersonalInfoPage(BuildContext context, OnboardingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDisplayNameField(context),
        const SizedBox(height: 16),
        _buildBirthdateSelector(context, state),
        const SizedBox(height: 16),
        _buildBioField(context),
        const SizedBox(height: 16),
        _buildLocationFields(context),
        const SizedBox(height: 16),
        _buildLanguageSelector(context, state),
        const SizedBox(height: 8),
        _buildLanguagesList(context, state),
      ],
    );
  }
}

class OnboardingView extends StatelessWidget {
  final String title;
  final String description;
  final Widget content;
  final int currentPage;
  final PageController pageController;

  const OnboardingView({
    super.key,
    required this.content,
    required this.title,
    required this.description,
    required this.currentPage,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description, style: Theme.of(context).textTheme.displaySmall),
          SizedBox(
            height: 8.0,
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 18.0),
          ),
          SizedBox(
            height: 16.0,
          ),
          content,
          const SizedBox(height: 30),
          Positioned(
            top: 5,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentPage > 0)
                        TextBtn(
                          text: Text(
                            "BACK",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          onPressed: () {
                            pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        )
                      else
                        const SizedBox(width: 80),
                      GradientPrimaryBtn(
                        text: Text(
                          currentPage == 2 ? "GET STARTED" : "NEXT",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        onPressed: () {
                          if (currentPage == 2) {
                            context.read<OnboardingCubit>().submitOnboarding();
                          } else {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
