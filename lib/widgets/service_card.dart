import 'package:flutter/material.dart';

/// Widget réutilisable pour afficher une carte de service moderne
/// Utilisé dans la page d'accueil pour les différents services
class ServiceCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String route;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
    this.onTap,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: MouseRegion(
              onEnter: (_) => _onHover(true),
              onExit: (_) => _onHover(false),
              child: GestureDetector(
                onTapDown: (_) => _onHover(true),
                onTapUp: (_) => _onHover(false),
                onTapCancel: () => _onHover(false),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _isHovered
                          ? [
                              widget.color.withOpacity(0.8),
                              widget.color.withOpacity(0.6),
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
                    boxShadow: [
                      BoxShadow(
                        color: _isHovered
                            ? widget.color.withOpacity(0.4)
                            : isDark
                                ? Colors.black.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.2),
                        blurRadius: _isHovered ? 20 : 8,
                        offset: Offset(0, _isHovered ? 8 : 4),
                        spreadRadius: _isHovered ? 2 : 0,
                      ),
                    ],
                    border: Border.all(
                      color: _isHovered
                          ? widget.color.withOpacity(0.3)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: widget.onTap ?? () {
                        Navigator.pushNamed(context, widget.route);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icône avec animation de rotation
                            Transform.rotate(
                              angle: _rotationAnimation.value,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.color.withOpacity(0.2),
                                      widget.color.withOpacity(0.1),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.color.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    widget.icon,
                                    size: _isHovered ? 36 : 32,
                                    color: _isHovered
                                        ? Colors.white
                                        : widget.color,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Titre avec animation de couleur
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                fontSize: _isHovered ? 14 : 12,
                                fontWeight: FontWeight.w600,
                                color: _isHovered
                                    ? Colors.white
                                    : theme.textTheme.bodyLarge?.color,
                                letterSpacing: 0.5,
                              ),
                              child: Text(
                                widget.title,
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
            ),
          ),
        );
      },
    );
  }
}