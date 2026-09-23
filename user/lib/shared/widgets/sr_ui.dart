import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SrColors {
  static const bg = Color(0xFF06111C);
  static const bg2 = Color(0xFF020B13);
  static const panel = Color(0xFF101E2D);
  static const panel2 = Color(0xFF0C1825);
  static const green = Color(0xFF08C756);
  static const green2 = Color(0xFF00A844);
  static const line = Color(0xFF1F3445);
  static const muted = Color(0xFF8EA0AD);
  static const amber = Color(0xFFFFB51F);
  static const red = Color(0xFFFF453A);
}

class SrScreen extends StatelessWidget {
  const SrScreen({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(18, 10, 18, 18),
    this.bottomNavigationBar,
  });

  final Widget child;
  final EdgeInsets padding;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: SrColors.bg,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.1,
            colors: [Color(0xFF082136), SrColors.bg2],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class SrTopBar extends StatelessWidget {
  const SrTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = true,
    this.trailing,
    this.actions,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final Widget? trailing;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          if (leading != null)
            leading!
          else if (showBack)
            SrIconButton(
              icon: LucideIcons.arrowLeft,
              onPressed: () => Navigator.maybePop(context),
            )
          else
            const SizedBox(width: 40), // Removed default hamburger
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: SrColors.muted, fontSize: 11),
                  ),
              ],
            ),
          ),
          if (actions != null) ...actions!,
          trailing ?? const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class SrIconButton extends StatelessWidget {
  const SrIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.filled = false,
    this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool filled;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      color: color ?? Colors.white,
      style: IconButton.styleFrom(
        backgroundColor: filled ? (color?.withValues(alpha: 0.1) ?? SrColors.panel) : Colors.transparent,
        fixedSize: const Size(40, 40),
      ),
    );
  }
}

class SrCard extends StatelessWidget {
  const SrCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.color,
    this.borderColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
          width: double.infinity,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? SrColors.panel.withValues(alpha: 0.86),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor ?? Colors.white.withValues(alpha: 0.04)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
    );
  }
}

class SrButton extends StatelessWidget {
  const SrButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.secondary = false,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool secondary;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final fg = secondary ? Colors.white : Colors.white;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: secondary ? Colors.transparent : SrColors.green,
          foregroundColor: fg,
          elevation: 0,
          side: secondary ? const BorderSide(color: SrColors.line) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
        child: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(label),
      ),
    );
  }
}

class SrInputTile extends StatelessWidget {
  const SrInputTile({
    super.key,
    required this.icon,
    required this.hint,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String hint;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SrCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 19),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hint,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class SrLocationRow extends StatelessWidget {
  const SrLocationRow({
    super.key,
    required this.label,
    required this.value,
    this.icon = LucideIcons.mapPin,
    this.color = SrColors.green,
    this.trailing,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: SrColors.muted, fontSize: 10)),
              const SizedBox(height: 4),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class SrStatusPill extends StatelessWidget {
  const SrStatusPill({super.key, required this.text, this.color = SrColors.green});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class SrBottomNav extends StatelessWidget {
  const SrBottomNav({super.key, required this.index, required this.onSelected});

  final int index;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = [
      (LucideIcons.home, 'Home'),
      (LucideIcons.package, 'Orders'),
      (LucideIcons.navigation, 'Track'),
      (LucideIcons.wallet, 'Wallet'),
      (LucideIcons.user, 'Profile'),
    ];
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: SrColors.bg2.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (i) {
          final selected = i == index;
          return Expanded(
            child: InkWell(
              onTap: () => onSelected(i),
              borderRadius: BorderRadius.circular(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    items[i].$1,
                    color: selected ? SrColors.green : Colors.white70,
                    size: 19,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[i].$2,
                    style: TextStyle(
                      color: selected ? SrColors.green : Colors.white70,
                      fontSize: 10,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class SrMapPreview extends StatelessWidget {
  const SrMapPreview({
    super.key,
    this.height = 150,
    this.showRider = false,
    this.full = false,
    this.riderPosition,
    this.destinationPosition,
  });

  final double height;
  final bool showRider;
  final bool full;
  final Offset? riderPosition;
  final Offset? destinationPosition;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(full ? 0 : 8),
      child: ColoredBox(
        color: const Color(0xFF0A1723),
        child: SizedBox(
          height: full ? null : height,
          width: double.infinity,
          child: CustomPaint(
            painter: _MapPainter(
              showRider: showRider,
              riderPosition: riderPosition,
              destinationPosition: destinationPosition,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({
    required this.showRider,
    this.riderPosition,
    this.destinationPosition,
  });

  final bool showRider;
  final Offset? riderPosition;
  final Offset? destinationPosition;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF1D3B50).withValues(alpha: 0.65)
      ..strokeWidth = 1;
    for (var i = -4; i < 12; i++) {
      final y = i * size.height / 8;
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 80), gridPaint);
      final x = i * size.width / 8;
      canvas.drawLine(Offset(x, 0), Offset(x - 100, size.height), gridPaint);
    }

    final routePaint = Paint()
      ..color = SrColors.green
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final route = Path()
      ..moveTo(size.width * .20, size.height * .74)
      ..lineTo(size.width * .30, size.height * .45)
      ..lineTo(size.width * .52, size.height * .54)
      ..lineTo(size.width * .67, size.height * .24)
      ..lineTo(size.width * .82, size.height * .20);
    canvas.drawPath(route, routePaint);

    void marker(Offset p, Color color, double r) {
      canvas.drawCircle(p, r + 4, Paint()..color = color.withValues(alpha: 0.18));
      canvas.drawCircle(p, r, Paint()..color = color);
      canvas.drawCircle(p, r * .45, Paint()..color = Colors.white);
    }

    final dest = destinationPosition ?? Offset(size.width * .82, size.height * .20);
    marker(Offset(size.width * .20, size.height * .74), SrColors.green, 8);
    marker(dest, SrColors.green, 10);

    if (showRider) {
      final pos = riderPosition ?? Offset(size.width * .52, size.height * .54);
      marker(pos, Colors.white, 7);
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) {
    return oldDelegate.showRider != showRider;
  }
}

class SrTimeline extends StatelessWidget {
  const SrTimeline({super.key, required this.items, required this.activeIndex});

  final List<(String, String)> items;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (i) {
        final done = i <= activeIndex;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(
                  done ? LucideIcons.checkCircle2 : LucideIcons.circle,
                  color: done ? SrColors.green : SrColors.line,
                  size: 18,
                ),
                if (i != items.length - 1)
                  Container(width: 2, height: 24, color: done ? SrColors.green : SrColors.line),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Text(items[i].$1, style: const TextStyle(fontSize: 13)),
              ),
            ),
            Text(items[i].$2, style: const TextStyle(color: SrColors.muted, fontSize: 11)),
          ],
        );
      }),
    );
  }
}

class SrMetric extends StatelessWidget {
  const SrMetric({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: SrColors.muted, fontSize: 11)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class SrAvatar extends StatelessWidget {
  const SrAvatar({super.key, this.size = 46, this.imageUrl});

  final double size;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl!.startsWith('http') || imageUrl!.startsWith('https')) {
        imageProvider = NetworkImage(imageUrl!);
      } else if (imageUrl!.startsWith('/') || imageUrl!.contains(':\\')) {
        imageProvider = FileImage(File(imageUrl!));
      }
    }

    if (imageProvider != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
          border: Border.all(color: SrColors.green.withValues(alpha: 0.2), width: 2),
        ),
      );
    }
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: SrColors.green.withValues(alpha: 0.16),
      child: Transform.rotate(
        angle: -math.pi / 16,
        child: Icon(LucideIcons.user, color: SrColors.green, size: size * .54),
      ),
    );
  }
}

class SrImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData placeholderIcon;

  const SrImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderIcon = LucideIcons.image,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    Widget image;
    if (imageUrl!.startsWith('http') || imageUrl!.startsWith('https')) {
      image = Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: SrColors.panel,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2, color: SrColors.green),
            ),
          );
        },
      );
    } else {
      final file = File(imageUrl!);
      if (file.existsSync()) {
        image = Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
        );
      } else {
        image = _buildPlaceholder();
      }
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: SrColors.panel,
        borderRadius: borderRadius,
      ),
      child: Icon(placeholderIcon, color: SrColors.muted, size: (width ?? 40) * 0.4),
    );
  }
}

class SrSuccessDialog extends StatefulWidget {
  const SrSuccessDialog({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonLabel = 'Continue',
    this.onContinue,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback? onContinue;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    String buttonLabel = 'Continue',
    VoidCallback? onContinue,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SrSuccessDialog(
        title: title,
        subtitle: subtitle,
        buttonLabel: buttonLabel,
        onContinue: onContinue,
      ),
    );
  }

  @override
  State<SrSuccessDialog> createState() => _SrSuccessDialogState();
}

class _SrSuccessDialogState extends State<SrSuccessDialog> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _checkController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeInOutExpo),
    );

    _scaleController.forward();
    _checkController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: SrColors.panel.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: SrColors.green.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: SrColors.green.withValues(alpha: 0.1),
                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: SrColors.green.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _checkAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(80, 80),
                        painter: _CheckPainter(_checkAnimation.value),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: SrColors.muted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SrButton(
                label: widget.buttonLabel,
                onPressed: () {
                  Navigator.pop(context);
                  widget.onContinue?.call();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double progress;

  _CheckPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = SrColors.green
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.25, size.height * 0.5);
    path.lineTo(size.width * 0.45, size.height * 0.7);
    path.lineTo(size.width * 0.75, size.height * 0.3);

    final pathMetrics = path.computeMetrics().last;
    final extractPath = pathMetrics.extractPath(0, pathMetrics.length * progress);

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class SrSwipeButton extends StatefulWidget {
  const SrSwipeButton({
    super.key,
    required this.label,
    required this.onSwipe,
    this.width = double.infinity,
  });

  final String label;
  final VoidCallback onSwipe;
  final double width;

  @override
  State<SrSwipeButton> createState() => _SrSwipeButtonState();
}

class _SrSwipeButtonState extends State<SrSwipeButton> {
  double _position = 0;
  bool _isFinished = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth - 8; // Accounting for margins
        
        return Container(
          width: widget.width,
          height: 64,
          decoration: BoxDecoration(
            color: SrColors.panel.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Stack(
            children: [
              Center(
                child: Opacity(
                  opacity: (1 - (_position / (maxWidth - 56))).clamp(0.2, 1.0),
                  child: Text(
                    widget.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: _position,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (_isFinished) return;
                    setState(() {
                      _position = (_position + details.delta.dx).clamp(0.0, maxWidth - 56);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_isFinished) return;
                      if (_position > (maxWidth - 56) * 0.8) {
                        setState(() {
                          _position = maxWidth - 56;
                          _isFinished = true;
                        });
                        // Visual feedback before trigger
                        Future.delayed(const Duration(milliseconds: 100), () {
                          widget.onSwipe();
                        });
                      } else {
                      setState(() {
                        _position = 0;
                      });
                    }
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: SrColors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: SrColors.green,
                          blurRadius: 15,
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                    child: const Icon(LucideIcons.chevronsRight, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
