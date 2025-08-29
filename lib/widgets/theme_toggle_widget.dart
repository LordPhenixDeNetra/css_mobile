import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme_config.dart';

class ThemeToggleWidget extends StatelessWidget {
  final bool showLabel;
  final IconData? lightIcon;
  final IconData? darkIcon;
  
  const ThemeToggleWidget({
    super.key,
    this.showLabel = true,
    this.lightIcon,
    this.darkIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLabel) ...[
              Text(
                themeProvider.isDarkMode ? 'Sombre' : 'Clair',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 8),
            ],
            Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: AppTheme.lightOrange,
              inactiveThumbColor: AppTheme.primaryOrange,
            ),
            const SizedBox(width: 8),
            Icon(
              themeProvider.isDarkMode 
                  ? (darkIcon ?? Icons.dark_mode)
                  : (lightIcon ?? Icons.light_mode),
              color: themeProvider.isDarkMode 
                  ? AppTheme.lightOrange 
                  : AppTheme.primaryOrange,
            ),
          ],
        );
      },
    );
  }
}

// Widget bouton simple pour le basculement de thème
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return IconButton(
          onPressed: () {
            themeProvider.toggleTheme();
          },
          icon: Icon(
            themeProvider.isDarkMode 
                ? Icons.light_mode 
                : Icons.dark_mode,
            color: isDark ? Colors.white : Colors.black87,
          ),
          tooltip: themeProvider.isDarkMode 
              ? 'Passer au thème clair' 
              : 'Passer au thème sombre',
        );
      },
    );
  }
}

// Widget de sélection de thème avec menu déroulant
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return PopupMenuButton<bool>(
          icon: Icon(
            themeProvider.isDarkMode 
                ? Icons.dark_mode 
                : Icons.light_mode,
          ),
          onSelected: (bool isDark) {
            themeProvider.setTheme(isDark);
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<bool>(
              value: false,
              child: Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    color: !themeProvider.isDarkMode 
                        ? AppTheme.primaryOrange 
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Thème clair',
                    style: TextStyle(
                      fontWeight: !themeProvider.isDarkMode 
                          ? FontWeight.bold 
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem<bool>(
              value: true,
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode,
                    color: themeProvider.isDarkMode 
                        ? AppTheme.lightOrange 
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Thème sombre',
                    style: TextStyle(
                      fontWeight: themeProvider.isDarkMode 
                          ? FontWeight.bold 
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}