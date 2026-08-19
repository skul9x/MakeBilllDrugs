import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../core/theme.dart';
import '../models/drug_info.dart';
import '../models/drug_item.dart';
import '../services/dialog_service.dart';
import '../services/dialog_service_impl.dart';
import '../services/drug_parser.dart';
import '../services/excel_service.dart';
import 'widgets/glass_card.dart';
import 'widgets/quantity_selector.dart';
import 'widgets/toast_overlay.dart';

class SelectNextRowIntent extends Intent {
  const SelectNextRowIntent();
}

class SelectPreviousRowIntent extends Intent {
  const SelectPreviousRowIntent();
}

enum InputMode { smartImport, manualInput }
enum MobileViewTab { input, table }

class DashboardPage extends StatefulWidget {
  final DialogService? dialogService;
  final DrugParser? drugParser;

  const DashboardPage({super.key, this.dialogService, this.drugParser});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DialogService _dialogService;
  late final DrugParser _drugParser;
  final ExcelService _excelService = ExcelService();

  final TextEditingController _urlController = TextEditingController();
  final FocusNode _urlFocusNode = FocusNode();

  InputMode _inputMode = InputMode.smartImport;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _quyCachController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _brandFocusNode = FocusNode();
  final FocusNode _quyCachFocusNode = FocusNode();

  List<DrugItem> _items = [];
  int _inputQuantity = 1;
  bool _isLoading = false;
  int _selectedRowIndex = -1;

  @override
  void initState() {
    super.initState();
    _dialogService = widget.dialogService ?? DialogServiceImpl();
    _drugParser = widget.drugParser ?? DrugParser();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _urlFocusNode.dispose();
    _nameController.dispose();
    _brandController.dispose();
    _quyCachController.dispose();
    _nameFocusNode.dispose();
    _brandFocusNode.dispose();
    _quyCachFocusNode.dispose();
    super.dispose();
  }

  void _addDrugManually() {
    final name = _nameController.text.trim();
    final brand = _brandController.text.trim();
    final quyCach = _quyCachController.text.trim();

    if (name.isEmpty) {
      ToastOverlay.show(context, 'Tên thuốc không được để trống', type: ToastType.warning);
      return;
    }

    int existingIdx = DrugItem.findDuplicateIndex(
      _items,
      name: name,
      brand: brand,
      quyCach: quyCach,
    );

    setState(() {
      if (existingIdx != -1) {
        final existing = _items[existingIdx];
        _items[existingIdx] = DrugItem(
          stt: existing.stt,
          name: existing.name,
          brand: existing.brand,
          quyCach: existing.quyCach,
          quantity: existing.quantity + _inputQuantity,
        );
      } else {
        _items.add(
          DrugItem(
            stt: _items.length + 1,
            name: name,
            brand: brand.isEmpty ? 'N/A' : brand,
            quyCach: quyCach.isEmpty ? 'N/A' : quyCach,
            quantity: _inputQuantity,
          ),
        );
      }
      _nameController.clear();
      _brandController.clear();
      _quyCachController.clear();
      _inputQuantity = 1;
    });

    _reindexItems();
    if (mounted) {
      ToastOverlay.show(context, 'Added "$name" successfully!', type: ToastType.success);
    }
  }

  Widget _buildSmartImportFields() {
    return Column(
      key: const ValueKey('smartImport'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const ValueKey('urlField'),
          controller: _urlController,
          focusNode: _urlFocusNode,
          style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
          decoration: InputDecoration(
            hintText: 'Enter URL or HTML path',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: GlassTheme.primaryNeon, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          ),
          onSubmitted: (_) => _fetchAndAddDrug(),
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Quantity',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
            QuantitySelector(
              key: const ValueKey('smartImportQuantity'),
              value: _inputQuantity,
              onChanged: (val) {
                setState(() {
                  _inputQuantity = val;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            key: const ValueKey('fetchAddButton'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(color: GlassTheme.primaryNeon),
              ),
            ).copyWith(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return GlassTheme.primaryNeon.withValues(alpha: 0.15);
              }),
            ),
            onPressed: _isLoading ? null : _fetchAndAddDrug,
            child: _isLoading
                ? const SpinKitThreeBounce(
                    color: GlassTheme.primaryNeon,
                    size: 20.0,
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Fetch & Add',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildManualInputFields() {
    return Column(
      key: const ValueKey('manualInput'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const ValueKey('nameField'),
          controller: _nameController,
          focusNode: _nameFocusNode,
          style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
          decoration: InputDecoration(
            hintText: 'Tên thuốc',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: GlassTheme.primaryNeon, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          ),
        ),
        const SizedBox(height: 12.0),
        TextField(
          key: const ValueKey('brandField'),
          controller: _brandController,
          focusNode: _brandFocusNode,
          style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
          decoration: InputDecoration(
            hintText: 'Thương hiệu',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: GlassTheme.primaryNeon, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          ),
        ),
        const SizedBox(height: 12.0),
        TextField(
          key: const ValueKey('quyCachField'),
          controller: _quyCachController,
          focusNode: _quyCachFocusNode,
          style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
          decoration: InputDecoration(
            hintText: 'Quy cách',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: GlassTheme.primaryNeon, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          ),
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Quantity',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
            QuantitySelector(
              key: const ValueKey('manualInputQuantity'),
              value: _inputQuantity,
              onChanged: (val) {
                setState(() {
                  _inputQuantity = val;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            key: const ValueKey('addManuallyButton'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(color: GlassTheme.primaryNeon),
              ),
            ).copyWith(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return GlassTheme.primaryNeon.withValues(alpha: 0.15);
              }),
            ),
            onPressed: _addDrugManually,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 18),
                SizedBox(width: 8),
                Text(
                  'Add Manually',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _reindexItems() {
    setState(() {
      _items = DrugItem.sortAndReindex(_items);
    });
  }

  Future<void> _fetchAndAddDrug() async {
    final source = _urlController.text.trim();
    if (source.isEmpty) {
      ToastOverlay.show(context, 'Please enter a valid URL or path', type: ToastType.warning);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch and extract drug information
      final DrugInfo drugInfo = await _drugParser.fetchAndParse(source);

      // Check if item already exists
      int existingIdx = _items.indexWhere((item) =>
          item.name.toLowerCase() == drugInfo.name.toLowerCase() &&
          item.brand.toLowerCase() == drugInfo.brand.toLowerCase() &&
          item.quyCach.toLowerCase() == drugInfo.quyCach.toLowerCase());

      setState(() {
        if (existingIdx != -1) {
          final existing = _items[existingIdx];
          _items[existingIdx] = DrugItem(
            stt: existing.stt,
            name: existing.name,
            brand: existing.brand,
            quyCach: existing.quyCach,
            quantity: existing.quantity + _inputQuantity,
          );
        } else {
          _items.add(
            DrugItem(
              stt: _items.length + 1,
              name: drugInfo.name,
              brand: drugInfo.brand,
              quyCach: drugInfo.quyCach,
              quantity: _inputQuantity,
            ),
          );
        }
        _urlController.clear();
        _inputQuantity = 1;
      });

      _reindexItems();
      if (mounted) {
        ToastOverlay.show(context, 'Added "${drugInfo.name}" successfully!', type: ToastType.success);
      }
    } catch (e) {
      if (mounted) {
        ToastOverlay.show(context, 'Error: ${e.toString()}', type: ToastType.error);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _importFromExcel() async {
    try {
      final path = await _dialogService.selectImportPath();
      if (path == null) {
        if (mounted) {
          ToastOverlay.show(context, 'Import cancelled', type: ToastType.warning);
        }
        return;
      }

      final imported = await _excelService.importExcel(path);
      setState(() {
        _items = imported;
      });
      _reindexItems();

      if (mounted) {
        ToastOverlay.show(context, 'Imported ${imported.length} items successfully!', type: ToastType.success);
      }
    } catch (e) {
      if (mounted) {
        ToastOverlay.show(context, 'Import failed: ${e.toString()}', type: ToastType.error);
      }
    }
  }

  Future<void> _exportToExcel() async {
    if (_items.isEmpty) {
      ToastOverlay.show(context, 'No items to export', type: ToastType.warning);
      return;
    }

    try {
      final path = await _dialogService.selectSavePath();
      if (path == null) {
        if (mounted) {
          ToastOverlay.show(context, 'Export cancelled', type: ToastType.warning);
        }
        return;
      }

      await _excelService.generateExcel(_items, path);
      if (mounted) {
        ToastOverlay.show(context, 'Exported to Excel successfully!', type: ToastType.success);
      }
    } catch (e) {
      if (mounted) {
        ToastOverlay.show(context, 'Export failed: ${e.toString()}', type: ToastType.error);
      }
    }
  }

  void _clearAll() {
    if (_items.isEmpty) return;
    setState(() {
      _items.clear();
      _selectedRowIndex = -1;
    });
    ToastOverlay.show(context, 'Cleared all items', type: ToastType.success);
  }

  void _updateQuantity(int index, int newQty) {
    if (newQty < 1) return;
    setState(() {
      final old = _items[index];
      _items[index] = DrugItem(
        stt: old.stt,
        name: old.name,
        brand: old.brand,
        quyCach: old.quyCach,
        quantity: newQty,
      );
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      if (_selectedRowIndex >= _items.length) {
        _selectedRowIndex = _items.length - 1;
      }
    });
    _reindexItems();
    ToastOverlay.show(context, 'Item removed', type: ToastType.success);
  }

  int get _totalProductUnits {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  MobileViewTab _mobileViewTab = MobileViewTab.input;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlassTheme.bgDark,
      body: FocusableActionDetector(
        autofocus: true,
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.arrowDown): const SelectNextRowIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowUp): const SelectPreviousRowIntent(),
        },
        actions: {
          SelectNextRowIntent: CallbackAction<SelectNextRowIntent>(
            onInvoke: (intent) {
              if (_items.isNotEmpty) {
                setState(() {
                  _selectedRowIndex = (_selectedRowIndex + 1) % _items.length;
                });
              }
              return null;
            },
          ),
          SelectPreviousRowIntent: CallbackAction<SelectPreviousRowIntent>(
            onInvoke: (intent) {
              if (_items.isNotEmpty) {
                setState(() {
                  _selectedRowIndex = _selectedRowIndex <= 0 ? _items.length - 1 : _selectedRowIndex - 1;
                });
              }
              return null;
            },
          ),
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F172A),
                Color(0xFF1E293B),
              ],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool isMobile = constraints.maxWidth < 768;

                return Padding(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      _buildHeader(isMobile),
                      SizedBox(height: isMobile ? 12.0 : 20.0),

                      // Mobile Tab Switcher (Visible only on compact screens)
                      if (isMobile) ...[
                        _buildMobileTabSwitcher(),
                        const SizedBox(height: 14.0),
                      ],

                      // Content Area
                      Expanded(
                        child: isMobile
                            ? _buildMobileContent()
                            : _buildDesktopContent(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tạo bill thuốc',
                style: isMobile
                    ? GlassTheme.headerStyle.copyWith(fontSize: 22)
                    : GlassTheme.headerStyle,
              ),
              const SizedBox(height: 4.0),
              Text(
                'Premium Glassmorphism Manager',
                style: isMobile
                    ? GlassTheme.subHeaderStyle.copyWith(fontSize: 12)
                    : GlassTheme.subHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12.0),
        // Stats Badges
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatBadge('Rows', '${_items.length}', isMobile),
            SizedBox(width: isMobile ? 8.0 : 12.0),
            _buildStatBadge('Units', '$_totalProductUnits', isMobile),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileTabSwitcher() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              key: const ValueKey('mobileTabInput'),
              onTap: () {
                setState(() {
                  _mobileViewTab = MobileViewTab.input;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: _mobileViewTab == MobileViewTab.input
                      ? GlassTheme.primaryNeon.withValues(alpha: 0.18)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                  border: _mobileViewTab == MobileViewTab.input
                      ? Border.all(color: GlassTheme.primaryNeon, width: 1.5)
                      : Border.all(color: Colors.transparent, width: 1.5),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_note,
                        size: 16,
                        color: _mobileViewTab == MobileViewTab.input ? GlassTheme.primaryNeon : Colors.white60,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Nhập liệu',
                          style: TextStyle(
                            color: _mobileViewTab == MobileViewTab.input ? Colors.white : Colors.white60,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              key: const ValueKey('mobileTabTable'),
              onTap: () {
                setState(() {
                  _mobileViewTab = MobileViewTab.table;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: _mobileViewTab == MobileViewTab.table
                      ? GlassTheme.primaryNeon.withValues(alpha: 0.18)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                  border: _mobileViewTab == MobileViewTab.table
                      ? Border.all(color: GlassTheme.primaryNeon, width: 1.5)
                      : Border.all(color: Colors.transparent, width: 1.5),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.table_chart_outlined,
                        size: 16,
                        color: _mobileViewTab == MobileViewTab.table ? GlassTheme.primaryNeon : Colors.white60,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Bảng thuốc (${_items.length})',
                          style: TextStyle(
                            color: _mobileViewTab == MobileViewTab.table ? Colors.white : Colors.white60,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Panel: Input Section
        SizedBox(
          width: 320,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildInputFormCard(),
                const SizedBox(height: 20),
                _buildActionButtonsCard(),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24.0),

        // Right Panel: Table View
        Expanded(
          child: _buildTableCard(isMobile: false),
        ),
      ],
    );
  }

  Widget _buildMobileContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: _mobileViewTab == MobileViewTab.input
          ? SingleChildScrollView(
              key: const ValueKey('mobileInputView'),
              child: Column(
                children: [
                  _buildInputFormCard(),
                  const SizedBox(height: 16),
                  _buildActionButtonsCard(),
                ],
              ),
            )
          : _buildTableCard(isMobile: true),
    );
  }

  Widget _buildInputFormCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Drug Source',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Outfit',
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    key: const ValueKey('tabSmartImport'),
                    onTap: () {
                      setState(() {
                        _inputMode = InputMode.smartImport;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _inputMode == InputMode.smartImport
                            ? GlassTheme.primaryNeon.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(11),
                        border: _inputMode == InputMode.smartImport
                            ? Border.all(color: GlassTheme.primaryNeon, width: 1.5)
                            : Border.all(color: Colors.transparent, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          'Smart Import',
                          style: TextStyle(
                            color: _inputMode == InputMode.smartImport ? Colors.white : Colors.white60,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    key: const ValueKey('tabManualInput'),
                    onTap: () {
                      setState(() {
                        _inputMode = InputMode.manualInput;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _inputMode == InputMode.manualInput
                            ? GlassTheme.primaryNeon.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(11),
                        border: _inputMode == InputMode.manualInput
                            ? Border.all(color: GlassTheme.primaryNeon, width: 1.5)
                            : Border.all(color: Colors.transparent, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          'Manual Input',
                          style: TextStyle(
                            color: _inputMode == InputMode.manualInput ? Colors.white : Colors.white60,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _inputMode == InputMode.smartImport
                ? _buildSmartImportFields()
                : _buildManualInputFields(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsCard() {
    return GlassCard(
      child: Column(
        children: [
          _buildActionButton(
            label: 'Import Excel',
            icon: Icons.file_upload_outlined,
            color: GlassTheme.secondaryNeon,
            onPressed: _importFromExcel,
          ),
          const SizedBox(height: 12.0),
          _buildActionButton(
            label: 'Export Excel',
            icon: Icons.file_download_outlined,
            color: GlassTheme.primaryNeon,
            onPressed: _exportToExcel,
          ),
          const SizedBox(height: 12.0),
          _buildActionButton(
            label: 'Clear All',
            icon: Icons.delete_sweep_outlined,
            color: GlassTheme.dangerNeon,
            onPressed: _clearAll,
          ),
        ],
      ),
    );
  }

  Widget _buildTableCard({required bool isMobile}) {
    const double tableMinWidth = 560.0;

    Widget tableHeader = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text('STT', style: GlassTheme.tableHeaderStyle)),
          Expanded(flex: 3, child: Text('Tên thuốc', style: GlassTheme.tableHeaderStyle)),
          Expanded(flex: 2, child: Text('Thương hiệu', style: GlassTheme.tableHeaderStyle)),
          Expanded(flex: 2, child: Text('Quy cách', style: GlassTheme.tableHeaderStyle)),
          SizedBox(width: 120, child: Text('Số lượng', style: GlassTheme.tableHeaderStyle)),
          const SizedBox(width: 40), // For remove action
        ],
      ),
    );

    Widget tableBody = _items.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'No drug items parsed yet.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontFamily: 'Inter',
                  fontSize: 15,
                ),
              ),
            ),
          )
        : ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              final isSelected = _selectedRowIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRowIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? GlassTheme.primaryNeon.withValues(alpha: 0.1)
                        : index % 2 == 0
                            ? Colors.white.withValues(alpha: 0.02)
                            : Colors.transparent,
                    border: Border(
                      bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                  ),
                  child: Row(
                    children: [
                      // STT
                      SizedBox(
                        width: 40,
                        child: Text(
                          '${item.stt}',
                          style: GlassTheme.tableBodyStyle.copyWith(
                            color: isSelected ? GlassTheme.primaryNeon : Colors.white70,
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ),
                        ),
                      ),
                      // Name
                      Expanded(
                        flex: 3,
                        child: Text(
                          item.name,
                          style: GlassTheme.tableBodyStyle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Brand
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.brand,
                          style: GlassTheme.tableBodyStyle,
                        ),
                      ),
                      // Quy Cach
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.quyCach,
                          style: GlassTheme.tableBodyStyle,
                        ),
                      ),
                      // Quantity Selector
                      SizedBox(
                        width: 120,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: QuantitySelector(
                            value: item.quantity,
                            onChanged: (newQty) => _updateQuantity(index, newQty),
                          ),
                        ),
                      ),
                      // Remove action
                      SizedBox(
                        width: 40,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: GlassTheme.dangerNeon, size: 18),
                          onPressed: () => _removeItem(index),
                          tooltip: 'Remove Row',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

    return GlassCard(
      padding: EdgeInsets.zero,
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: tableMinWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          tableHeader,
                          Expanded(child: tableBody),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                tableHeader,
                Expanded(child: tableBody),
              ],
            ),
    );
  }

  Widget _buildStatBadge(String label, String value, [bool isMobile = false]) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10.0 : 16.0,
        vertical: isMobile ? 6.0 : 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white70,
              fontSize: isMobile ? 11 : 12,
              fontFamily: 'Inter',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: GlassTheme.primaryNeon,
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 11 : 12,
              fontFamily: 'Outfit',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: color,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: color.withValues(alpha: 0.5)),
          ),
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            return color.withValues(alpha: 0.05);
          }),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Outfit',
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
