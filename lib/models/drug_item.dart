class DrugItem {
  final int stt;
  final String name;
  final String brand;
  final String quyCach;
  final int quantity;

  DrugItem({
    required this.stt,
    required this.name,
    required this.brand,
    required this.quyCach,
    required this.quantity,
  });

  // Validate inputs for manual entry (throws ArgumentError if invalid)
  static void validateManualInput({
    required String name,
    required String brand,
    required String quyCach,
    required int quantity,
  }) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Drug name cannot be empty');
    }
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than zero');
    }
  }

  // Case-insensitive duplicate check helper
  static int findDuplicateIndex(
    List<DrugItem> list, {
    required String name,
    required String brand,
    required String quyCach,
  }) {
    final searchName = name.trim().toLowerCase();
    final searchBrand = brand.trim().toLowerCase();
    final searchQuyCach = quyCach.trim().toLowerCase();

    return list.indexWhere((item) =>
        item.name.trim().toLowerCase() == searchName &&
        item.brand.trim().toLowerCase() == searchBrand &&
        item.quyCach.trim().toLowerCase() == searchQuyCach);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DrugItem &&
        other.stt == stt &&
        other.name == name &&
        other.brand == brand &&
        other.quyCach == quyCach &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return Object.hash(stt, name, brand, quyCach, quantity);
  }

  @override
  String toString() {
    return 'DrugItem(stt: $stt, name: $name, brand: $brand, quyCach: $quyCach, quantity: $quantity)';
  }
}
