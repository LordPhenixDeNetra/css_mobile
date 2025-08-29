import 'package:flutter/material.dart';

/// Widget réutilisable pour afficher une ligne d'information moderne
/// Utilisé dans les pages de profil et prestations
class InfoRow extends StatefulWidget {
  final String label;
  final String value;
  final double? labelWidth;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final IconData? icon;
  final Color? iconColor;
  final bool animated;
  final VoidCallback? onTap;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.labelWidth,
    this.labelStyle,
    this.valueStyle,
    this.padding,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.icon,
    this.iconColor,
    this.animated = true,
    this.onTap,
  });

  @override
  State<InfoRow> createState() => _InfoRowState();
}

class _InfoRowState extends State<InfoRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));

    if (widget.animated) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      gradient: _isHovered
                          ? LinearGradient(
                              colors: [
                                theme.primaryColor.withOpacity(0.05),
                                theme.primaryColor.withOpacity(0.02),
                              ],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isHovered
                            ? theme.primaryColor.withOpacity(0.2)
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
                      crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.start,
                      children: [
                        // Icône optionnelle
                        if (widget.icon != null) ...[
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: (widget.iconColor ?? theme.primaryColor).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              widget.icon!,
                              size: 16,
                              color: widget.iconColor ?? theme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        // Label
                        if (widget.labelWidth != null)
                          SizedBox(
                            width: widget.labelWidth,
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: widget.labelStyle ?? TextStyle(
                                fontWeight: FontWeight.w500,
                                color: _isHovered
                                    ? theme.primaryColor
                                    : (isDark ? Colors.grey[300] : Colors.grey[600]),
                                fontSize: 14,
                              ),
                              child: Text(widget.label),
                            ),
                          )
                        else
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: widget.labelStyle ?? TextStyle(
                              color: _isHovered
                                  ? theme.primaryColor
                                  : (isDark ? Colors.grey[300] : Colors.grey[600]),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            child: Text('${widget.label}:'),
                          ),
                        const SizedBox(width: 8),
                        // Valeur
                        if (widget.labelWidth != null)
                          Expanded(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: widget.valueStyle ?? TextStyle(
                                fontSize: 16,
                                fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                                color: _isHovered
                                    ? theme.primaryColor
                                    : (isDark ? Colors.white : Colors.black87),
                              ),
                              child: Text(widget.value),
                            ),
                          )
                        else
                          Expanded(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: widget.valueStyle ?? TextStyle(
                                fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                                fontSize: 16,
                                color: _isHovered
                                    ? theme.primaryColor
                                    : (isDark ? Colors.white : Colors.black87),
                              ),
                              child: Text(widget.value),
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
      },
    );
  }
}

/// Variante moderne pour les informations avec alignement à droite
class InfoRowSpaceBetween extends StatefulWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final EdgeInsetsGeometry? padding;
  final IconData? icon;
  final Color? iconColor;
  final bool animated;
  final VoidCallback? onTap;

  const InfoRowSpaceBetween({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.padding,
    this.icon,
    this.iconColor,
    this.animated = true,
    this.onTap,
  });

  @override
  State<InfoRowSpaceBetween> createState() => _InfoRowSpaceBetweenState();
}

class _InfoRowSpaceBetweenState extends State<InfoRowSpaceBetween>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));

    if (widget.animated) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      gradient: _isHovered
                          ? LinearGradient(
                              colors: [
                                theme.primaryColor.withOpacity(0.05),
                                theme.primaryColor.withOpacity(0.02),
                              ],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isHovered
                            ? theme.primaryColor.withOpacity(0.2)
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Label avec icône optionnelle
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: (widget.iconColor ?? theme.primaryColor).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  widget.icon!,
                                  size: 14,
                                  color: widget.iconColor ?? theme.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: widget.labelStyle ?? TextStyle(
                                color: _isHovered
                                    ? theme.primaryColor
                                    : (isDark ? Colors.grey[300] : Colors.grey[600]),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              child: Text('${widget.label}:'),
                            ),
                          ],
                        ),
                        // Valeur
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: widget.valueStyle ?? TextStyle(
                            fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 14,
                            color: _isHovered
                                ? theme.primaryColor
                                : (isDark ? Colors.white : Colors.black87),
                          ),
                          child: Text(widget.value),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}