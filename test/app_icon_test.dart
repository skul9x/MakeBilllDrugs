import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Icon Asset Presence & Cross-Platform Verification Tests', () {
    test('Master icon assets exist and are non-empty', () {
      final masterIcon = File('assets/icon/app_icon.png');
      final foregroundIcon = File('assets/icon/app_icon_foreground.png');
      final backgroundIcon = File('assets/icon/app_icon_background.png');

      expect(masterIcon.existsSync(), isTrue, reason: 'assets/icon/app_icon.png must exist');
      expect(masterIcon.lengthSync(), greaterThan(1000));

      expect(foregroundIcon.existsSync(), isTrue, reason: 'assets/icon/app_icon_foreground.png must exist');
      expect(foregroundIcon.lengthSync(), greaterThan(1000));

      expect(backgroundIcon.existsSync(), isTrue, reason: 'assets/icon/app_icon_background.png must exist');
      expect(backgroundIcon.lengthSync(), greaterThan(1000));
    });

    test('Android adaptive XML files exist', () {
      final anyDpiLauncher = File('android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml');
      final anyDpiRound = File('android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml');
      final bgDrawable = File('android/app/src/main/res/drawable/ic_launcher_background.xml');

      expect(anyDpiLauncher.existsSync(), isTrue);
      expect(anyDpiRound.existsSync(), isTrue);
      expect(bgDrawable.existsSync(), isTrue);
    });

    test('Android mipmap density icons exist for all buckets', () {
      final densities = ['mipmap-mdpi', 'mipmap-hdpi', 'mipmap-xhdpi', 'mipmap-xxhdpi', 'mipmap-xxxhdpi'];
      for (final density in densities) {
        final launcher = File('android/app/src/main/res/$density/ic_launcher.png');
        final launcherRound = File('android/app/src/main/res/$density/ic_launcher_round.png');
        final launcherFg = File('android/app/src/main/res/$density/ic_launcher_foreground.png');

        expect(launcher.existsSync(), isTrue, reason: '$density/ic_launcher.png should exist');
        expect(launcherRound.existsSync(), isTrue, reason: '$density/ic_launcher_round.png should exist');
        expect(launcherFg.existsSync(), isTrue, reason: '$density/ic_launcher_foreground.png should exist');
      }
    });

    test('Windows and Linux desktop icon assets exist', () {
      final winIco = File('windows/runner/resources/app_icon.ico');
      final linuxPng = File('linux/runner/resources/app_icon.png');

      expect(winIco.existsSync(), isTrue, reason: 'windows/runner/resources/app_icon.ico must exist');
      expect(winIco.lengthSync(), greaterThan(2000));

      expect(linuxPng.existsSync(), isTrue, reason: 'linux/runner/resources/app_icon.png must exist');
      expect(linuxPng.lengthSync(), greaterThan(1000));
    });
  });
}
