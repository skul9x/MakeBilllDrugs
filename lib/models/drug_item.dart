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


  static int _compareVietnameseStrings(String strA, String strB) {
    final a = strA.trim().toLowerCase();
    final b = strB.trim().toLowerCase();
    if (a == b) return 0;

    // Vietnamese alphabet ordering table
    const vietnameseAlphabet = [
      'a', 'à', 'ả', 'ã', 'á', 'ạ',
      'ă', 'ằ', 'ẳ', 'ẵ', 'ắ', 'ặ',
      'â', 'ầ', 'ẩ', 'ẫ', 'ấ', 'ậ',
      'b',
      'c',
      'd',
      'đ',
      'e', 'è', 'ẻ', 'ẽ', 'é', 'ẹ',
      'ê', 'ề', 'ể', 'ễ', 'ế', 'ệ',
      'f',
      'g',
      'h',
      'i', 'ì', 'ỉ', 'ĩ', 'í', 'ị',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o', 'ò', 'ỏ', 'õ', 'ó', 'ọ',
      'ô', 'ồ', 'ổ', 'ỗ', 'ố', 'ộ',
      'ơ', 'ờ', 'ở', 'ỡ', 'ớ', 'ợ',
      'p',
      'q',
      'r',
      's',
      't',
      'u', 'ù', 'ủ', 'ũ', 'ú', 'ụ',
      'ư', 'ừ', 'ử', 'ữ', 'ứ', 'ự',
      'v',
      'w',
      'x',
      'y', 'ỳ', 'ỷ', 'ỹ', 'ý', 'ỵ',
      'z'
    ];

    final runesA = a.runes.toList();
    final runesB = b.runes.toList();
    final minLen = runesA.length < runesB.length ? runesA.length : runesB.length;

    for (int i = 0; i < minLen; i++) {
      final charA = String.fromCharCode(runesA[i]);
      final charB = String.fromCharCode(runesB[i]);

      if (charA != charB) {
        final indexA = vietnameseAlphabet.indexOf(charA);
        final indexB = vietnameseAlphabet.indexOf(charB);

        if (indexA != -1 && indexB != -1) {
          if (indexA != indexB) return indexA.compareTo(indexB);
        } else if (indexA != -1) {
          return -1; // Vietnamese known char comes before unknown
        } else if (indexB != -1) {
          return 1;
        } else {
          final comp = charA.compareTo(charB);
          if (comp != 0) return comp;
        }
      }
    }

    return runesA.length.compareTo(runesB.length);
  }

  // Comparator for sorting DrugItems alphabetically (A-Z)
  static int compareByName(DrugItem a, DrugItem b) {
    final nameComp = _compareVietnameseStrings(a.name, b.name);
    if (nameComp != 0) return nameComp;

    final brandComp = _compareVietnameseStrings(a.brand, b.brand);
    if (brandComp != 0) return brandComp;

    return _compareVietnameseStrings(a.quyCach, b.quyCach);
  }

  // Sort list of DrugItems alphabetically and reassign sequential STT (1, 2, 3...)
  static List<DrugItem> sortAndReindex(List<DrugItem> items) {
    final sorted = List<DrugItem>.from(items);
    sorted.sort(compareByName);
    return List<DrugItem>.generate(
      sorted.length,
      (index) {
        final item = sorted[index];
        return DrugItem(
          stt: index + 1,
          name: item.name,
          brand: item.brand,
          quyCach: item.quyCach,
          quantity: item.quantity,
        );
      },
    );
  }

  @override
  String toString() {
    return 'DrugItem(stt: $stt, name: $name, brand: $brand, quyCach: $quyCach, quantity: $quantity)';
  }
}
