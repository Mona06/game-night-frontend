import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ioc/flutter_ioc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:party_planner/src/core/services/preference_service.dart';
import 'package:party_planner/src/core/services/user_service.dart';
import 'package:party_planner/src/ui/widgets/typography/btn.dart';
import 'package:shimmer/shimmer.dart';
import '../../../widgets/typography/text_field.dart';
import '../../event_form/widgets/custom_chip.dart';
import '../../notifications/view/notifications_tab.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import 'settings/account_settings_view.dart';

class ProfileView extends StatelessWidget {
  final int? userId;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker picker = ImagePicker();

  ProfileView({
    super.key,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        Ioc.container.get<UserService>(),
        Ioc.container.get<PreferencesService>(),
      )..loadProfile(userId: userId),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Profile',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              actions: [
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state.isOwnProfile) {
                      return Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.notifications_outlined),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NotificationsView(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.settings_outlined),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccountSettingsView(),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return SizedBox();
                  },
                ),
              ],
            ),
            body: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(context, state),
                      SizedBox(height: 24),
                      _buildBioSection(context, state),
                      SizedBox(height: 24),
                      _buildLanguagesSection(context, state),
                      SizedBox(height: 24),
                      _buildGamesPlayedSection(context, state),
                      SizedBox(height: 24),
                      _buildAttendanceStats(context, state),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguagesSection(BuildContext context, ProfileState state) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Languages',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontSize: 18),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.languages.map((language) {
                return Tooltip(
                  message: 'Language: $language',
                  child: SurfaceVariantBadge(
                    label: language,
                    prefixIcon: Icons.language_outlined,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileState state) {
    return Row(
      children: [
        Stack(
          children: <Widget>[
            Container(
              width: 118,
              height: 118,
              decoration: BoxDecoration(
                image: _getProfileImage(state.profileImageBase64),
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            if (state.isOwnProfile)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                    onPressed: () => _showImagePickerBottomSheet(context),
                    padding: EdgeInsets.all(8),
                    constraints: BoxConstraints(
                      minHeight: 36,
                      minWidth: 36,
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    state.displayName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(width: 8),
                  if (state.discordTag.isNotEmpty)
                    Tooltip(
                      message: 'Discord Tag',
                      child: TertiaryBadge(
                        label: state.discordTag,
                        prefixIcon: Icons.discord_outlined,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.cake_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        state.birthdate,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  if (state.city != null)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          state.city!,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                  SizedBox(height: 4),
                  if (state.phoneNumber != null)
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          state.phoneNumber!,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 8),
              if (!state.isOwnProfile)
                TertiaryBtn(
                  onPressed: () =>
                      context.read<ProfileCubit>().toggleFriendship(),
                  text: Text(state.isFriend ? 'Remove Friend' : 'Add Friend'),
                ),
            ],
          ),
        ),
      ],
    );
  }

  DecorationImage? _getProfileImage(String base64String) {
    if (base64String.isEmpty) return null;

    try {
      final String pureBase64 = base64String.contains(',')
          ? base64String.split(',')[1]
          : base64String;

      return DecorationImage(
        image: MemoryImage(base64Decode(pureBase64)),
        fit: BoxFit.cover,
      );
    } catch (e) {
      print('Error decoding image: $e');
      return null;
    }
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return BlocProvider.value(
          value: profileCubit,
          child: Builder(
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Change Profile Picture',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.fontFamily,
                          ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildImagePickerOption(
                          context: context,
                          icon: Icons.photo_camera_outlined,
                          label: 'Camera',
                          onTap: () => _pickImage(context, ImageSource.camera),
                        ),
                        _buildImagePickerOption(
                          context: context,
                          icon: Icons.photo_library_outlined,
                          label: 'Gallery',
                          onTap: () => _pickImage(context, ImageSource.gallery),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildImagePickerOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: Theme.of(context).primaryColor),
          ),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (pickedFile != null) {
        if (context.mounted) {
          context.read<ProfileCubit>().updateProfileImage(pickedFile.path);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Widget _buildBioSection(BuildContext context, ProfileState state) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bio',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontSize: 18),
            ),
            SizedBox(height: 12),
            if (state.isOwnProfile)
              InkWell(
                onTap: () => _showBioEditDialog(context, state.bio),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          state.bio.isEmpty ? 'Add a bio...' : state.bio,
                          style: state.bio.isEmpty
                              ? TextStyle(color: Colors.grey[600])
                              : null,
                        ),
                      ),
                      Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
              )
            else
              Text(state.bio),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 16),
                SizedBox(width: 4),
                Text(
                  state.attendancePreference,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  width: 4,
                ),
                Text('preference'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBioEditShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showBioEditDialog(BuildContext context, String currentBio) {
    final profileCubit = context.read<ProfileCubit>();
    final TextEditingController controller =
        TextEditingController(text: currentBio);
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BlocProvider.value(
              value: profileCubit,
              child: Builder(
                builder: (context) {
                  return AlertDialog(
                    title: Text('Edit Bio'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLoading)
                          _buildBioEditShimmer()
                        else
                          GradientTextField(
                            controller: controller,
                            labelText: 'Bio',
                            hint: 'Tell us about yourself...',
                            maxLength: 500,
                            maxLines: 4,
                            onChanged: (string) {},
                          ),
                      ],
                    ),
                    actions: [
                      TextBtn(
                        onPressed: isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        text: Text('Cancel'),
                      ),
                      TextBtn(
                        onPressed: isLoading
                            ? null
                            : () async {
                                setState(() => isLoading = true);
                                try {
                                  context
                                      .read<ProfileCubit>()
                                      .updateBio(controller.text);
                                  context
                                      .read<ProfileCubit>()
                                      .submitBio(controller.text);
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                } catch (e) {
                                  setState(() => isLoading = false);
                                }
                              },
                        text: isLoading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text('Save'),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGamesPlayedSection(BuildContext context, ProfileState state) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Games Played',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontSize: 18),
            ),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Wrap(
                spacing: 8,
                runSpacing: 12,
                children: state.ttrpgs.map((game) {
                  return Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.1),
                            Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PrimaryBadge(
                              label: game,
                              prefixIcon: Icons.gamepad_outlined,
                            ),
                            SizedBox(width: 4),
                            SurfaceVariantBadge(
                              label: state.rolePreference!,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceStats(BuildContext context, ProfileState state) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance Stats',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontSize: 18),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total', state.attendanceStats.totalSessions),
                _buildStatItem(
                  'Present',
                  state.attendanceStats.presentSessions,
                ),
                _buildStatItem('Absent', state.attendanceStats.absentSessions),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }

  void navigateToUserProfile(BuildContext context, int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileView(userId: userId),
      ),
    );
  }
}
