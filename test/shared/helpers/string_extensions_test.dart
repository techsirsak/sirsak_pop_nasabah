import 'package:flutter_test/flutter_test.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/string_extensions.dart';

void main() {
  group('DoubleX.formatWeight', () {
    const kgUnit = 'kg';
    const tonUnit = 'ton';

    test('returns kg for values less than 1000', () {
      expect(0.0.formatWeight(kgUnit, tonUnit), '0 kg');
      expect(1.0.formatWeight(kgUnit, tonUnit), '1 kg');
      expect(500.0.formatWeight(kgUnit, tonUnit), '500 kg');
      expect(999.0.formatWeight(kgUnit, tonUnit), '999 kg');
    });

    test('returns ton for values >= 1000 (whole number)', () {
      expect(1000.0.formatWeight(kgUnit, tonUnit), '1 ton');
      expect(2000.0.formatWeight(kgUnit, tonUnit), '2 ton');
      expect(10000.0.formatWeight(kgUnit, tonUnit), '10 ton');
    });

    test('returns ton with 1 decimal for non-whole ton values', () {
      expect(1500.0.formatWeight(kgUnit, tonUnit), '1.5 ton');
      expect(1234.0.formatWeight(kgUnit, tonUnit), '1.2 ton');
      expect(2750.0.formatWeight(kgUnit, tonUnit), '2.8 ton');
    });

    test('truncates to int for kg values', () {
      expect(500.7.formatWeight(kgUnit, tonUnit), '500 kg');
      expect(999.9.formatWeight(kgUnit, tonUnit), '999 kg');
    });

    test('works with CO2eq units', () {
      const kgCO2Unit = 'kg CO₂eq';
      const tonCO2Unit = 'ton CO₂eq';

      expect(500.0.formatWeight(kgCO2Unit, tonCO2Unit), '500 kg CO₂eq');
      expect(1500.0.formatWeight(kgCO2Unit, tonCO2Unit), '1.5 ton CO₂eq');
    });
  });
}
