import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantitySelector extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;

  const QuantitySelector({
    Key? key,
    required this.value,
    required this.onChanged,
    this.min = 1,
  }) : super(key: key);

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant QuantitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      final currentParsed = int.tryParse(_controller.text);
      if (currentParsed != widget.value) {
        _controller.text = widget.value.toString();
      }
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _validateAndSubmit();
    }
  }

  void _validateAndSubmit() {
    final parsed = int.tryParse(_controller.text);
    if (parsed == null || parsed < widget.min) {
      _controller.text = widget.min.toString();
      widget.onChanged(widget.min);
    } else {
      _controller.text = parsed.toString();
      if (parsed != widget.value) {
        widget.onChanged(parsed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            key: const ValueKey('quantity_selector_decrement'),
            icon: Icons.remove,
            onPressed: widget.value > widget.min ? () => widget.onChanged(widget.value - 1) : null,
          ),
          Container(
            width: 48,
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: TextField(
              key: const ValueKey('quantity_selector_input'),
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                border: InputBorder.none,
              ),
              onChanged: (text) {
                final parsed = int.tryParse(text);
                if (parsed != null && parsed >= widget.min) {
                  widget.onChanged(parsed);
                }
              },
              onSubmitted: (_) => _validateAndSubmit(),
              onEditingComplete: () => _validateAndSubmit(),
            ),
          ),
          _buildButton(
            key: const ValueKey('quantity_selector_increment'),
            icon: Icons.add,
            onPressed: () => widget.onChanged(widget.value + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    Key? key,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return InkWell(
      key: key,
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: onPressed != null ? Colors.white70 : Colors.white24,
          size: 18,
        ),
      ),
    );
  }
}
