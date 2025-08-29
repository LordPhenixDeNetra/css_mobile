import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class PrestationsPage extends StatefulWidget {
  const PrestationsPage({super.key});

  @override
  State<PrestationsPage> createState() => _PrestationsPageState();
}

class _PrestationsPageState extends State<PrestationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Données simulées des prestations disponibles
  final List<Map<String, dynamic>> _prestationsDisponibles = [
    {
      'nom': 'Pension de retraite',
      'description': 'Pension versée à partir de 60 ans',
      'conditions': 'Minimum 15 ans de cotisations',
      'montantEstime': 150000,
      'eligible': false,
      'icon': Icons.elderly,
    },
    {
      'nom': 'Allocation familiale',
      'description': 'Aide pour les enfants à charge',
      'conditions': 'Enfants de moins de 21 ans',
      'montantEstime': 25000,
      'eligible': true,
      'icon': Icons.family_restroom,
    },
    {
      'nom': 'Indemnité maladie',
      'description': 'Remboursement des frais médicaux',
      'conditions': 'Justificatifs médicaux requis',
      'montantEstime': null,
      'eligible': true,
      'icon': Icons.medical_services,
    },
    {
      'nom': 'Capital décès',
      'description': 'Capital versé aux ayants droit',
      'conditions': 'En cas de décès de l\'assuré',
      'montantEstime': 500000,
      'eligible': true,
      'icon': Icons.security,
    },
  ];

  // Données simulées de l'historique des prestations
  final List<Map<String, dynamic>> _historiquePrestations = [
    {
      'type': 'Allocation familiale',
      'montant': 25000,
      'dateDemande': '01/11/2023',
      'dateVersement': '15/11/2023',
      'statut': 'Versé',
      'reference': 'AF-2023-001',
    },
    {
      'type': 'Indemnité maladie',
      'montant': 15000,
      'dateDemande': '15/10/2023',
      'dateVersement': '30/10/2023',
      'statut': 'Versé',
      'reference': 'IM-2023-002',
    },
    {
      'type': 'Allocation familiale',
      'montant': 25000,
      'dateDemande': '01/10/2023',
      'dateVersement': null,
      'statut': 'En cours',
      'reference': 'AF-2023-003',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Prestations'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Disponibles', icon: Icon(Icons.list)),
            Tab(text: 'Historique', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPrestationsDisponibles(),
          _buildHistoriquePrestations(),
        ],
      ),
    );
  }

  Widget _buildPrestationsDisponibles() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _prestationsDisponibles.length,
      itemBuilder: (context, index) {
        final prestation = _prestationsDisponibles[index];
        return _buildPrestationCard(prestation);
      },
    );
  }

  Widget _buildPrestationCard(Map<String, dynamic> prestation) {
    final bool eligible = prestation['eligible'];
    final Color cardColor = eligible ? Colors.green.shade50 : Colors.grey.shade50;
    final Color iconColor = eligible ? Colors.green : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  prestation['icon'],
                  size: 32,
                  color: iconColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prestation['nom'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        prestation['description'],
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (eligible)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                else
                  const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Conditions: ${prestation['conditions']}',
              style: const TextStyle(fontSize: 14),
            ),
            if (prestation['montantEstime'] != null) ...[
              const SizedBox(height: 8),
              Text(
                'Montant estimé: ${prestation['montantEstime']} FCFA',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: eligible
                    ? () {
                        _showDemandeDialog(prestation['nom']);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: eligible ? Colors.green : Colors.grey,
                ),
                child: Text(
                  eligible ? 'Faire une demande' : 'Non éligible',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoriquePrestations() {
    if (_historiquePrestations.isEmpty) {
      return EmptyState(
        icon: Icons.history,
        title: 'Aucune prestation dans l\'historique',
        subtitle: 'Vos prestations apparaîtront ici',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _historiquePrestations.length,
      itemBuilder: (context, index) {
        final prestation = _historiquePrestations[index];
        return PrestationCard(
          prestation: prestation,
        );
      },
    );
  }



  void _showDemandeDialog(String prestationNom) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Demande de $prestationNom'),
          content: const Text(
            'Voulez-vous faire une demande pour cette prestation ? '
            'Vous serez redirigé vers le formulaire de demande.',
          ),
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
                // TODO: Implémenter le formulaire de demande
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Demande de $prestationNom initiée'),
                  ),
                );
              },
              child: const Text('Continuer'),
            ),
          ],
        );
      },
    );
  }
}