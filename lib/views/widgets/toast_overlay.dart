import 'dart:async';
import 'package:flutter/material.dart';

enum ToastType { success, warning, error }

class ToastOverlay {
  static void show(
    BuildContext context,
    String message, {
    ToastType type = ToastType.success,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => ToastWidget(
        message: message,
        type: type,
        onDismiss: () {
          overlayEntry.remove();
        },
        duration: duration,
      ),
    );

    overlayState.insert(overlayEntry);
  }
}

class ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;
  final Duration duration;

  const ToastWidget({
    super.key,
    required this.message,
    required this.type,
    required this.onDismiss,
    required this.duration,
  });

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();

    _timer = Timer(widget.duration, () {
      _dismiss();
    });
  }

  void _dismiss() async {
    if (mounted) {
      await _animationController.reverse();
      widget.onDismiss();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    IconData icon;
    Color iconColor;

    switch (widget.type) {
      case ToastType.success:
        bgColor = const Color(0xE610B981); // Emerald green with opacity
        icon = Icons.check_circle_outline;
        iconColor = Colors.white;
        break;
      case ToastType.warning:
        bgColor = const Color(0xE6F59E0B); // Amber warning
        icon = Icons.warning_amber_rounded;
        iconColor = Colors.white;
        break;
      case ToastType.error:
        bgColor = const Color(0xE6EF4444); // Red danger
        icon = Icons.error_outline_rounded;
        iconColor = Colors.white;
        break;
    }

    return Positioned(
      top: 50.0,
      left: 20.0,
      right: 20.0,
      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: iconColor),
                      const SizedBox(width: 12.0),
                      Flexible(
                        child: Text(
                          widget.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
