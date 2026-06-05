import 'package:flutter_test/flutter_test.dart';
import 'package:drugs_maker/models/drug_item.dart';

void main() {
  group('Manual Input Unit Tests', () {
    test('DrugItem can be instantiated and properties are correct', () {
      final item = DrugItem(
        stt: 1,
        name: 'Paracetamol',
        brand: 'An Thiên',
        quyCach: 'Hộp 10 vỉ x 10 viên',
        quantity: 5,
      );

      expect(item.stt, equals(1));
      expect(item.name, equals('Paracetamol'));
      expect(item.brand, equals('An Thiên'));
      expect(item.quyCach, equals('Hộp 10 vỉ x 10 viên'));
      expect(item.quantity, equals(5));
    });

    test('DrugItem equality and hashCode work correctly', () {
      final item1 = DrugItem(
        stt: 1,
        name: 'Paracetamol',
        brand: 'An Thiên',
        quyCach: 'Hộp',
        quantity: 5,
      );
      final item2 = DrugItem(
        stt: 1,
        name: 'Paracetamol',
        brand: 'An Thiên',
        quyCach: 'Hộp',
        quantity: 5,
      );
      final item3 = DrugItem(
        stt: 2,
        name: 'Paracetamol',
        brand: 'An Thiên',
        quyCach: 'Hộp',
        quantity: 5,
      );

      expect(item1, equals(item2));
      expect(item1.hashCode, equals(item2.hashCode));
      expect(item1, isNot(equals(item3)));
    });

    test('Validation throws error on empty or whitespace-only drug name', () {
      expect(
        () => DrugItem.validateManualInput(
          name: '',
          brand: 'Brand',
          quyCach: 'Box',
          quantity: 5,
        ),
        throwsArgumentError,
      );

      expect(
        () => DrugItem.validateManualInput(
          name: '   ',
          brand: 'Brand',
          quyCach: 'Box',
          quantity: 5,
        ),
        throwsArgumentError,
      );
    });

    test('Validation throws error on zero or negative quantity', () {
      expect(
        () => DrugItem.validateManualInput(
          name: 'Paracetamol',
          brand: 'Brand',
          quyCach: 'Box',
          quantity: 0,
        ),
        throwsArgumentError,
      );

      expect(
        () => DrugItem.validateManualInput(
          name: 'Paracetamol',
          brand: 'Brand',
          quyCach: 'Box',
          quantity: -3,
        ),
        throwsArgumentError,
      );
    });

    test('Validation passes with valid inputs', () {
      expect(
        () => DrugItem.validateManualInput(
          name: 'Paracetamol',
          brand: 'Brand',
          quyCach: 'Box',
          quantity: 5,
        ),
        returnsNormally,
      );
    });

    test('findDuplicateIndex performs case-insensitive detection', () {
      final items = [
        DrugItem(stt: 1, name: 'Paracetamol 500mg', brand: 'An Thiên', quyCach: 'Hộp 10 vỉ', quantity: 5),
        DrugItem(stt: 2, name: 'Ibuprofen', brand: 'Mekophar', quyCach: 'Chai 100 viên', quantity: 10),
      ];

      // Exact match
      int idx = DrugItem.findDuplicateIndex(
        items,
        name: 'Paracetamol 500mg',
        brand: 'An Thiên',
        quyCach: 'Hộp 10 vỉ',
      );
      expect(idx, equals(0));

      // Case mismatch
      idx = DrugItem.findDuplicateIndex(
        items,
        name: 'paracetamol 500MG',
        brand: 'an thiên',
        quyCach: 'hộp 10 vỉ',
      );
      expect(idx, equals(0));

      // Whitespace variations
      idx = DrugItem.findDuplicateIndex(
        items,
        name: '  Paracetamol 500mg  ',
        brand: '  An Thiên  ',
        quyCach: '  Hộp 10 vỉ  ',
      );
      expect(idx, equals(0));

      // Non-match
      idx = DrugItem.findDuplicateIndex(
        items,
        name: 'Paracetamol 500mg',
        brand: 'An Thiên',
        quyCach: 'Hộp 5 vỉ',
      );
      expect(idx, equals(-1));
    });

    test('Quantity accumulation logic works correctly', () {
      final items = [
        DrugItem(stt: 1, name: 'Paracetamol', brand: 'An Thiên', quyCach: 'Hộp 10 vỉ', quantity: 5),
      ];

      final name = 'PARACETAMOL';
      final brand = 'an thiên';
      final quyCach = 'hộp 10 vỉ';
      final inputQty = 3;

      final existingIdx = DrugItem.findDuplicateIndex(items, name: name, brand: brand, quyCach: quyCach);
      expect(existingIdx, equals(0));

      if (existingIdx != -1) {
        final existing = items[existingIdx];
        items[existingIdx] = DrugItem(
          stt: existing.stt,
          name: existing.name,
          brand: existing.brand,
          quyCach: existing.quyCach,
          quantity: existing.quantity + inputQty,
        );
      }

      expect(items[0].quantity, equals(8));
    });
  });
}
