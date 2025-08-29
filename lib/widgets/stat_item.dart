import 'package:flutter/material.dart';

/// Widget réutilisable pour afficher un élément de statistique moderne
/// Utilisé dans les pages de documents et cotisations
class StatItem extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final double? iconSize;
  final double? valueSize;
  final double? labelSize;
  final bool animated;
  final VoidCallback? onTap;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.iconSize = 24,
    this.valueSize = 16,
    this.labelSize = 12,
    this.animated = true,
    this.onTap,
  });

  @override
  State<StatItem> createState() => _StatItemState();
}

class _StatItemState extends State<StatItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _isHovered
                            ? [
                                widget.color.withOpacity(0.1),
                                widget.color.withOpacity(0.05),
                              ]
                            : [
                                Colors.transparent,
                                Colors.transparent,
                              ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isHovered
                            ? widget.color.withOpacity(0.3)
                            : Colors.transparent,
                        width: 1,
                      ),
                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color: widget.color.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icône avec animation de rotation
                        Transform.rotate(
                          angle: _rotationAnimation.value * 0.1,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  widget.color.withOpacity(0.8),
                                  widget.color.withOpacity(0.6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.color.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.icon,
                              size: widget.iconSize,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Valeur avec animation
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: widget.valueSize,
                            fontWeight: FontWeight.bold,
                            color: _isHovered
                                ? widget.color
                                : (isDark ? Colors.white : Colors.black87),
                            letterSpacing: 0.5,
                          ),
                          child: Text(widget.value),
                        ),
                        const SizedBox(height: 4),
                        // Label avec animation
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: widget.labelSize,
                            color: _isHovered
                                ? widget.color.withOpacity(0.8)
                                : Colors.grey,
                            fontWeight: _isHovered ? FontWeight.w500 : FontWeight.normal,
                          ),
                          child: Text(
                            widget.label,
                            textAlign: TextAlign.center,
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

/// Widget réutilisable pour afficher un élément de résumé moderne plus grand
/// Utilisé dans la page des cotisations
class SummaryItem extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool animated;
  final VoidCallback? onTap;

  const SummaryItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.animated = true,
    this.onTap,
  });

  @override
  State<SummaryItem> createState() => _SummaryItemState();
}

class _SummaryItemState extends State<SummaryItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
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
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _isHovered
                            ? [
                                widget.color.withOpacity(0.15),
                                widget.color.withOpacity(0.08),
                              ]
                            : isDark
                                ? [
                                    const Color(0xFF2D2D2D),
                                    const Color(0xFF1A1A1A),
                                  ]
                                : [
                                    Colors.white,
                                    const Color(0xFFF8F9FA),
                                  ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isHovered
                            ? widget.color.withOpacity(0.4)
                            : (isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.1)),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _isHovered
                              ? widget.color.withOpacity(0.3)
                              : (isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1)),
                          blurRadius: _isHovered ? 20 : 10,
                          offset: const Offset(0, 8),
                          spreadRadius: _isHovered ? 2 : 0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icône avec animation de pulsation
                        Transform.scale(
                          scale: _isHovered ? _pulseAnimation.value : 1.0,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  widget.color,
                                  widget.color.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.color.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.icon,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Valeur avec animation
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            fontSize: _isHovered ? 20 : 18,
                            fontWeight: FontWeight.bold,
                            color: _isHovered
                                ? widget.color
                                : (isDark ? Colors.white : Colors.black87),
                            letterSpacing: 1.0,
                          ),
                          child: Text(
                            widget.value,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Label avec animation
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            fontSize: _isHovered ? 14 : 12,
                            color: _isHovered
                                ? widget.color.withOpacity(0.8)
                                : Colors.grey,
                            fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
                            letterSpacing: 0.5,
                          ),
                          child: Text(
                            widget.label,
                            textAlign: TextAlign.center,
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