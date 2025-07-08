import 'package:flutter/material.dart';
import '../../config/theme.dart';

enum TopSnackBarType {
  success,
  warning,
  error,
  info,
}

class TopSnackBar extends StatefulWidget {
  final String message;
  final TopSnackBarType type;
  final Duration duration;
  final VoidCallback? onTap;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const TopSnackBar({
    super.key,
    required this.message,
    this.type = TopSnackBarType.info,
    this.duration = const Duration(seconds: 3),
    this.onTap,
    this.icon,
    this.actionLabel,
    this.onActionPressed,
  });

  static void show(
    BuildContext context, {
    required String message,
    TopSnackBarType type = TopSnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => TopSnackBarOverlay(
        snackBar: TopSnackBar(
          message: message,
          type: type,
          duration: duration,
          onTap: onTap,
          icon: icon,
          actionLabel: actionLabel,
          onActionPressed: onActionPressed,
        ),
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);
  }

  @override
  State<TopSnackBar> createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<TopSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (widget.type) {
      case TopSnackBarType.success:
        return AppTheme.getSuccessColor(context);
      case TopSnackBarType.warning:
        return AppTheme.getWarningColor(context);
      case TopSnackBarType.error:
        return AppTheme.getErrorColor(context);
      case TopSnackBarType.info:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData _getDefaultIcon() {
    switch (widget.type) {
      case TopSnackBarType.success:
        return Icons.check_circle;
      case TopSnackBarType.warning:
        return Icons.warning;
      case TopSnackBarType.error:
        return Icons.error;
      case TopSnackBarType.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getBackgroundColor(context),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: widget.onTap,
              child: Row(
                children: [
                  Icon(
                    widget.icon ?? _getDefaultIcon(),
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (widget.actionLabel != null && widget.onActionPressed != null)
                    TextButton(
                      onPressed: widget.onActionPressed,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        widget.actionLabel!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TopSnackBarOverlay extends StatefulWidget {
  final TopSnackBar snackBar;
  final VoidCallback onDismiss;

  const TopSnackBarOverlay({
    super.key,
    required this.snackBar,
    required this.onDismiss,
  });

  @override
  State<TopSnackBarOverlay> createState() => _TopSnackBarOverlayState();
}

class _TopSnackBarOverlayState extends State<TopSnackBarOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start animation
    _animationController.forward();

    // Auto dismiss after duration
    Future.delayed(widget.snackBar.duration, () {
      _dismiss();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() async {
    if (mounted) {
      await _animationController.reverse();
      widget.onDismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getBackgroundColor(context),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  widget.snackBar.onTap?.call();
                  _dismiss();
                },
                child: Row(
                  children: [
                    Icon(
                      widget.snackBar.icon ?? _getDefaultIcon(),
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.snackBar.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (widget.snackBar.actionLabel != null && widget.snackBar.onActionPressed != null)
                      TextButton(
                        onPressed: () {
                          widget.snackBar.onActionPressed?.call();
                          _dismiss();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          widget.snackBar.actionLabel!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
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
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (widget.snackBar.type) {
      case TopSnackBarType.success:
        return AppTheme.getSuccessColor(context);
      case TopSnackBarType.warning:
        return AppTheme.getWarningColor(context);
      case TopSnackBarType.error:
        return AppTheme.getErrorColor(context);
      case TopSnackBarType.info:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData _getDefaultIcon() {
    switch (widget.snackBar.type) {
      case TopSnackBarType.success:
        return Icons.check_circle;
      case TopSnackBarType.warning:
        return Icons.warning;
      case TopSnackBarType.error:
        return Icons.error;
      case TopSnackBarType.info:
        return Icons.info;
    }
  }
} 