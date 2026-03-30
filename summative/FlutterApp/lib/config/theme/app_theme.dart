import 'package:flutter/material.dart';

/// Design tokens mirroring outside-web's Tailwind config exactly.
///
/// Primary:  #d06224  (burnt orange — main-color)
/// Accent:   #f2c463  (light golden — main-color-light)
/// Dark:     #623205  (deep brown  — main-color-dark)
/// Text:     #111111  (text-color-black)
/// Surface:  #f3f3f3 / stone-50 variants
class AppTheme {
  AppTheme._();

  // ── Brand palette (matches outside-web tailwind.config.js) ──────────────
  static const Color primary     = Color(0xFFD06224); // main-color
  static const Color primaryDark = Color(0xFF623205); // main-color-dark
  static const Color primaryLight= Color(0xFFF2C463); // main-color-light

  // ── Neutral/stone (matches Tailwind stone-* used in outside-web) ────────
  static const Color surface     = Color(0xFFF3F3F3); // stone-100 / #f3f3f3
  static const Color stone50     = Color(0xFFFAFAF9); // stone-50 card bg
  static const Color stone200    = Color(0xFFE7E5E4); // ring-stone-200
  static const Color cardBg      = Color(0xFFFFFFFF);

  // ── Text ────────────────────────────────────────────────────────────────
  static const Color textPrimary  = Color(0xFF111111); // text-color-black
  static const Color textSecondary= Color(0xFF6B7280); // gray-500

  // ── Semantic ────────────────────────────────────────────────────────────
  static const Color error   = Color(0xFFF44336);
  static const Color success = Color(0xFF4ADE80);
  static const Color divider = Color(0xFFE7E5E4); // stone-200

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: primaryLight,
          surface: surface,
          error: error,
        ),
        scaffoldBackgroundColor: surface,

        // ── AppBar — white with orange accent, matches outside-web header ──
        appBarTheme: AppBarTheme(
          backgroundColor: cardBg,
          foregroundColor: textPrimary,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.06),
          scrolledUnderElevation: 1,
          centerTitle: false,
          titleTextStyle: const TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          iconTheme: const IconThemeData(color: textPrimary),
        ),

        // ── Cards — stone-50 bg, rounded-3xl (24px), ring border ──────────
        cardTheme: CardThemeData(
          color: stone50,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: stone200, width: 1),
          ),
        ),

        // ── Inputs — rounded-lg (8px), focus ring in primary ──────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardBg,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: stone200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: stone200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: error, width: 2),
          ),
          labelStyle:
              const TextStyle(color: textSecondary, fontSize: 14),
          hintStyle: const TextStyle(
              color: Color(0xFFAAAAAA), fontSize: 14),
          prefixIconColor: textSecondary,
        ),

        // ── Primary button — rounded-full (pill), #d06224 ──────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            elevation: 0,
            shape: const StadiumBorder(),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // ── Outlined / ghost button ────────────────────────────────────────
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: textPrimary,
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: stone200),
            shape: const StadiumBorder(),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // ── FAB — pill / full-rounded ──────────────────────────────────────
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: StadiumBorder(),
          elevation: 2,
        ),

        // ── Switch ─────────────────────────────────────────────────────────
        switchTheme: SwitchThemeData(
          thumbColor:
              WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? primary : Colors.white),
          trackColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected)
                  ? primary.withValues(alpha: 0.35)
                  : stone200),
        ),

        // ── Chips ──────────────────────────────────────────────────────────
        chipTheme: ChipThemeData(
          backgroundColor: surface,
          selectedColor: primary.withValues(alpha: 0.12),
          labelStyle: const TextStyle(fontSize: 13),
          shape: const StadiumBorder(),
        ),

        dividerTheme:
            const DividerThemeData(color: stone200, thickness: 1),

        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -0.5,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: -0.3,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
          bodyMedium:
              TextStyle(fontSize: 14, color: textSecondary),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
      );
}
