class DrugInfo {
  final String name;
  final String brand;
  final String quyCach;

  DrugInfo({
    required this.name,
    required this.brand,
    required this.quyCach,
  });

  @override
  String toString() {
    return 'DrugInfo(name: $name, brand: $brand, quyCach: $quyCach)';
  }
}
