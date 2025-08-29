import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Données simulées de l'utilisateur
  final Map<String, String> _userInfo = {
    'nom': 'DIOP',
    'prenom': 'Amadou',
    'numeroAssure': '123456789',
    'dateNaissance': '15/03/1985',
    'lieuNaissance': 'Dakar',
    'telephone': '+221 77 123 45 67',
    'email': 'amadou.diop@email.com',
    'adresse': 'Parcelles Assainies, Dakar',
    'employeur': 'Ministère de la Santé',
    'poste': 'Infirmier',
    'dateEmbauche': '01/09/2010',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implémenter la modification du profil
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Modification du profil à venir'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Photo de profil
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${_userInfo['prenom']} ${_userInfo['nom']}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'N° Assuré: ${_userInfo['numeroAssure']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Informations personnelles
            SectionCard(
              title: 'Informations personnelles',
              children: [
                InfoRow(
                  label: 'Date de naissance',
                  value: _userInfo['dateNaissance']!,
                  labelWidth: 120,
                ),
                InfoRow(
                  label: 'Lieu de naissance',
                  value: _userInfo['lieuNaissance']!,
                  labelWidth: 120,
                ),
                InfoRow(
                  label: 'Téléphone',
                  value: _userInfo['telephone']!,
                  labelWidth: 120,
                ),
                InfoRow(
                  label: 'Email',
                  value: _userInfo['email']!,
                  labelWidth: 120,
                ),
                InfoRow(
                  label: 'Adresse',
                  value: _userInfo['adresse']!,
                  labelWidth: 120,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Informations professionnelles
            SectionCard(
              title: 'Informations professionnelles',
              children: [
                InfoRow(
                  label: 'Employeur',
                  value: _userInfo['employeur']!,
                  labelWidth: 120,
                ),
                InfoRow(
                  label: 'Poste',
                  value: _userInfo['poste']!,
                  labelWidth: 120,
                ),
                InfoRow(
                  label: 'Date d\'embauche',
                  value: _userInfo['dateEmbauche']!,
                  labelWidth: 120,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implémenter le changement de mot de passe
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Changement de mot de passe à venir'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.lock),
                  label: const Text('Changer le mot de passe'),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implémenter les paramètres
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Paramètres à venir'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Paramètres'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    _showLogoutDialog();
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Se déconnecter',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Se déconnecter'),
            ),
          ],
        );
      },
    );
  }
}