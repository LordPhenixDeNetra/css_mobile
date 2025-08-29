import 'package:flutter/material.dart';
import 'info_row.dart';

/// Widget réutilisable pour afficher une carte avec statut
/// Utilisé dans les pages de cotisations et prestations
class StatusCard extends StatefulWidget {
  final String title;
  final String status;
  final Color statusColor;
  final IconData statusIcon;
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const StatusCard({
    super.key,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.statusIcon,
    required this.children,
    this.margin,
    this.padding,
    this.onTap,
  });

  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Transform.scale(
              scale: _isHovered ? _scaleAnimation.value : 1.0,
              child: Transform.rotate(
                angle: _isHovered ? _rotationAnimation.value : 0.0,
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHovered = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHovered = false;
                    });
                  },
                  child: GestureDetector(
                    onTap: widget.onTap,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: widget.margin ?? const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _isHovered
                              ? [
                                  isDark
                                      ? Colors.grey[800]!
                                      : Colors.white,
                                  isDark
                                      ? Colors.grey[700]!
                                      : Colors.grey[50]!,
                                ]
                              : [
                                  isDark
                                      ? Colors.grey[850]!
                                      : Colors.white,
                                  isDark
                                      ? Colors.grey[800]!
                                      : Colors.grey[25]!,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: _isHovered
                                ? (isDark ? Colors.black54 : Colors.black12)
                                : (isDark ? Colors.black38 : Colors.black.withOpacity(0.08)),
                            blurRadius: _isHovered ? 15 : 8,
                            offset: Offset(0, _isHovered ? 8 : 4),
                          ),
                        ],
                        border: Border.all(
                          color: _isHovered
                              ? widget.statusColor.withOpacity(0.4)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            // Effet de brillance en arrière-plan
                            if (_isHovered)
                              Positioned(
                                top: -50,
                                right: -50,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: [
                                        widget.statusColor.withOpacity(0.1),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: widget.padding ?? const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // En-tête avec titre et statut
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: AnimatedDefaultTextStyle(
                                          duration: const Duration(milliseconds: 200),
                                          style: theme.textTheme.titleLarge!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: _isHovered
                                                ? widget.statusColor
                                                : theme.colorScheme.onSurface,
                                          ),
                                          child: Text(widget.title),
                                        ),
                                      ),
                                      // Badge de statut animé
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              widget.statusColor.withOpacity(0.2),
                                              widget.statusColor.withOpacity(0.1),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: widget.statusColor.withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AnimatedRotation(
                                              turns: _isHovered ? 0.1 : 0.0,
                                              duration: const Duration(milliseconds: 200),
                                              child: Icon(
                                                widget.statusIcon,
                                                color: widget.statusColor,
                                                size: 18,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            AnimatedDefaultTextStyle(
                                              duration: const Duration(milliseconds: 200),
                                              style: TextStyle(
                                                color: widget.statusColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                              child: Text(widget.status),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Contenu avec animation d'apparition
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: 1.0,
                                    child: Column(
                                      children: widget.children.map((child) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 4),
                                          child: child,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
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

/// Widget spécialisé pour les cartes de cotisations
class CotisationCard extends StatelessWidget {
  final Map<String, dynamic> cotisation;
  final VoidCallback? onTap;

  const CotisationCard({
    super.key,
    required this.cotisation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPaid = cotisation['statut'] == 'Payé';
    final Color statusColor = isPaid ? Colors.green : Colors.orange;
    final IconData statusIcon = isPaid ? Icons.check_circle : Icons.pending;

    return StatusCard(
      title: cotisation['mois'],
      status: cotisation['statut'],
      statusColor: statusColor,
      statusIcon: statusIcon,
      onTap: onTap,
      children: [
        InfoRowSpaceBetween(
          label: 'Montant',
          value: '${cotisation['montant']} FCFA',
          valueStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        InfoRowSpaceBetween(
          label: 'Employeur',
          value: cotisation['employeur'],
          valueStyle: const TextStyle(
            fontSize: 14,
          ),
        ),
        if (cotisation['datePaiement'] != null) ...[          const SizedBox(height: 4),          InfoRowSpaceBetween(            label: 'Date de paiement',            value: cotisation['datePaiement'] ?? 'Non définie',            valueStyle: const TextStyle(              fontSize: 14,            ),          ),        ],
      ],
    );
  }
}

/// Widget spécialisé pour les cartes de prestations
class PrestationCard extends StatelessWidget {
  final Map<String, dynamic> prestation;
  final VoidCallback? onTap;
  final bool isHistorique;

  const PrestationCard({
    super.key,
    required this.prestation,
    this.onTap,
    this.isHistorique = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isVerse = prestation['statut'] == 'Versé';
    final Color statusColor = isVerse ? Colors.green : Colors.orange;
    final IconData statusIcon = isVerse ? Icons.check_circle : Icons.pending;

    return StatusCard(
      title: prestation['type'],
      status: prestation['statut'],
      statusColor: statusColor,
      statusIcon: statusIcon,
      onTap: onTap,
      children: [
        InfoRowSpaceBetween(
          label: 'Référence',
          value: prestation['reference'],
        ),
        InfoRowSpaceBetween(
          label: 'Montant',
          value: '${prestation['montant']} FCFA',
        ),
        InfoRowSpaceBetween(
          label: 'Date de demande',
          value: prestation['dateDemande'],
        ),
        if (prestation['dateVersement'] != null)
          InfoRowSpaceBetween(
            label: 'Date de versement',
            value: prestation['dateVersement'] ?? 'Non définie',
          ),
      ],
    );
  }
}