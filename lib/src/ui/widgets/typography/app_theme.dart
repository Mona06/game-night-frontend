import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class MaterialTheme {
  const MaterialTheme();

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,

      // Primary
      primary: Color(0xff012840),
      // Deep blue
      surfaceTint: Color(0xff012840),
      // Matches primary
      onPrimary: Color(0xffffffff),
      // White for contrast
      primaryContainer: Color(0xffdff9fa),
      // Light blue
      onPrimaryContainer: Color(0xff001A29),
      // Dark blue for contrast

      // Secondary
      secondary: Color(0xff3C0F59),
      // Rich purple
      onSecondary: Color(0xffffffff),
      // White for contrast
      secondaryContainer: Color(0xffdff9fa),
      // Light blue (same as primary container)
      onSecondaryContainer: Color(0xff1E2540),
      // Darker blue-gray for text/icons

      // Tertiary
      tertiary: Color(0xff287D7D),
      // Cool teal
      onTertiary: Color(0xffffffff),
      // White for contrast
      tertiaryContainer: Color(0xffBEEB9F),
      // Light green
      onTertiaryContainer: Color(0xff1A3823),
      // Dark green for contrast

      // Error
      error: Color(0xff904a43),
      onError: Color(0xffffffff),
      // Deep brown for contrast
      errorContainer: Color(0xffFADCD2),
      // Light pinkish background
      onErrorContainer: Color(0xff3b0907),
      // Dark red-brown for text/icons

      // Background
      background: Color(0xffF7F9FA),
      // Soft off-white
      onBackground: Color(0xff012840),
      // Deep blue for text/icons

      // Surface
      surface: Color(0xffF7F9FA),
      // Matches background
      onSurface: Color(0xff012840),
      // Deep blue for contrast
      surfaceVariant: Color(0xffE0E3E5),
      // Neutral grayish tone
      onSurfaceVariant: Color(0xff43484A),
      // Dark gray for text/icons

      // Outline
      outline: Color(0xff70777B),
      // Muted grayish tone
      outlineVariant: Color(0xffC1C6C8),
      // Subtle lighter gray

      // Shadows and scrim
      shadow: Color(0xff000000),
      // Black for shadows
      scrim: Color(0xff000000),
      // Black for overlays

      // Inverse
      inverseSurface: Color(0xff002033),
      // Dark blue
      inverseOnSurface: Color(0xffE2EBF2),
      // Soft white for contrast
      inversePrimary: Color(0xffADD5F7),
      // Light blue for inverse primary

      // Fixed colors
      primaryFixed: Color(0xffADD5F7),
      // Light blue
      onPrimaryFixed: Color(0xff001A29),
      // Dark blue
      primaryFixedDim: Color(0xff7DBBE8),
      // Slightly darker light blue
      onPrimaryFixedVariant: Color(0xff012840),
      // Deep blue

      secondaryFixed: Color(0xffADD5F7),
      // Matches secondary container
      onSecondaryFixed: Color(0xff1E2540),
      // Dark blue-gray
      secondaryFixedDim: Color(0xff7DBBE8),
      // Dimmed blue tone
      onSecondaryFixedVariant: Color(0xff3C0F59),
      // Rich purple

      tertiaryFixed: Color(0xffBEEB9F),
      // Light green
      onTertiaryFixed: Color(0xff1A3823),
      // Dark green
      tertiaryFixedDim: Color(0xff8BD476),
      // Slightly dimmed light green
      onTertiaryFixedVariant: Color(0xff287D7D),
      // Cool teal

      // Surface tones
      surfaceDim: Color(0xffDDE1E3),
      // Light neutral gray
      surfaceBright: Color(0xffF7F9FA),
      // Bright off-white
      surfaceContainerLowest: Color(0xffffffff),
      // Pure white for lowest surfaces
      surfaceContainerLow: Color(0xffF4F6F7),
      // Slightly darker off-white
      surfaceContainer: Color(0xffEEF1F3),
      // Subtle light tone
      surfaceContainerHigh: Color(0xffE8EBED),
      // Slightly darker tone for high containers
      surfaceContainerHighest:
          Color(0xffE2E5E7), // Darkest neutral tone for containers
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff483a71),
      surfaceTint: Color(0xff64558f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff7b6ba7),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff454054),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff787187),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff5f3745),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff966776),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff6e302a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffaa6058),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffdf7ff),
      onBackground: Color(0xff1d1b20),
      surface: Color(0xfffdf7ff),
      onSurface: Color(0xff1d1b20),
      surfaceVariant: Color(0xffe6e0ec),
      onSurfaceVariant: Color(0xff45414a),
      outline: Color(0xff615d67),
      outlineVariant: Color(0xff7d7983),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inverseOnSurface: Color(0xfff5eff7),
      inversePrimary: Color(0xffcfbdfe),
      primaryFixed: Color(0xff7b6ba7),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff62538c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff787187),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff5f596e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff966776),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff7b4f5e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffded8e0),
      surfaceBright: Color(0xfffdf7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f2fa),
      surfaceContainer: Color(0xfff2ecf4),
      surfaceContainerHigh: Color(0xffece6ee),
      surfaceContainerHighest: Color(0xffe6e1e9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff27174e),
      surfaceTint: Color(0xff64558f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff483a71),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff241f32),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff454054),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff391724),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5f3745),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff44100c),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff6e302a),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffdf7ff),
      onBackground: Color(0xff1d1b20),
      surface: Color(0xfffdf7ff),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xffe6e0ec),
      onSurfaceVariant: Color(0xff25232b),
      outline: Color(0xff45414a),
      outlineVariant: Color(0xff45414a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inverseOnSurface: Color(0xffffffff),
      inversePrimary: Color(0xfff1e8ff),
      primaryFixed: Color(0xff483a71),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff312359),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff454054),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2f2a3d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff5f3745),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff45212f),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffded8e0),
      surfaceBright: Color(0xfffdf7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f2fa),
      surfaceContainer: Color(0xfff2ecf4),
      surfaceContainerHigh: Color(0xffece6ee),
      surfaceContainerHighest: Color(0xffe6e1e9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: TextTheme(
          // For large display headers (e.g., app titles)
          displayLarge: GoogleFonts.comfortaa(
            fontSize: 34,
            fontWeight: FontWeight.w100,
            letterSpacing: -1.5,
            color: Color(0xFFFFFFFF), // Primary text color
          ),
          // For slightly smaller large headers
          displayMedium: GoogleFonts.nunitoSans(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Color(0xFF212121), // Primary text color
          ),
          // For medium-large display text (e.g., section titles)
          displaySmall: GoogleFonts.nunitoSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
            color: Color(0xFF212121), // Primary text color
          ),
          // Large headline (e.g., section headers)
          headlineLarge: GoogleFonts.nunitoSans(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
            color: Color(0xFF212121), // Primary text color
          ),
          // Medium headline (e.g., card titles)
          headlineMedium: GoogleFonts.nunitoSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: Color(0xFF212121), // Primary text color
          ),
          // Small headline (e.g., captions or subtitles)
          headlineSmall: GoogleFonts.nunitoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
            color: Color(0xFF212121), // Primary text color
          ),
          // Subtitle for primary content (e.g., main body of text)
          bodyLarge: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.5,
            color: Color(0xFF212121), // Primary text color
          ),
          // Regular body text (e.g., paragraph text)
          bodyMedium: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.25,
            color: Color(0xFF757575), // Secondary text color
          ),
          // Small body text (e.g., captions, legal disclaimers)
          bodySmall: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.4,
            color: Color(0xFF757575), // Secondary text color
          ),
          // Button text (e.g., labels on buttons)
          labelLarge: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.25,
            color: Color(0xFFFFFFFF), // White text on buttons
          ),
          // Medium label (e.g., small button labels)
          labelMedium: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: Color(0xFFFFFFFF), // White text on buttons
          ),
          // Small label (e.g., tag text)
          labelSmall: GoogleFonts.roboto(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: Color(0xFF212121), // Primary text color
          ),
        ).apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  /// Custom accent Color
  static const accentColor = ExtendedColor(
    seed: Color(0xff00bcd4),
    value: Color(0xff00bcd4),
    light: ColorFamily(
      color: Color(0xff006876),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffa1efff),
      onColorContainer: Color(0xff001f25),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff006876),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffa1efff),
      onColorContainer: Color(0xff001f25),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff006876),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffa1efff),
      onColorContainer: Color(0xff001f25),
    ),
    dark: ColorFamily(
      color: Color(0xff83d3e3),
      onColor: Color(0xff00363e),
      colorContainer: Color(0xff004e59),
      onColorContainer: Color(0xffa1efff),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xff83d3e3),
      onColor: Color(0xff00363e),
      colorContainer: Color(0xff004e59),
      onColorContainer: Color(0xffa1efff),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xff83d3e3),
      onColor: Color(0xff00363e),
      colorContainer: Color(0xff004e59),
      onColorContainer: Color(0xffa1efff),
    ),
  );

  List<ExtendedColor> get extendedColors => [
        accentColor,
      ];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
