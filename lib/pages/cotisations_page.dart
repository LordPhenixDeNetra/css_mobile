import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class CotisationsPage extends StatefulWidget {
  const CotisationsPage({super.key});

  @override
  State<CotisationsPage> createState() => _CotisationsPageState();
}

class _CotisationsPageState extends State<CotisationsPage> {
  // Données simulées des cotisations
  final List<Map<String, dynamic>> _cotisations = [
    {
      'mois': 'Décembre 2023',
      'montant': 45000,
      'statut': 'Payé',
      'datePaiement': '15/12/2023',
      'employeur': 'Ministère de la Santé',
    },
    {
      'mois': 'Novembre 2023',
      'montant': 45000,
      'statut': 'Payé',
      'datePaiement': '15/11/2023',
      'employeur': 'Ministère de la Santé',
    },
    {
      'mois': 'Octobre 2023',
      'montant': 45000,
      'statut': 'Payé',
      'datePaiement': '15/10/2023',
      'employeur': 'Ministère de la Santé',
    },
    {
      'mois': 'Septembre 2023',
      'montant': 45000,
      'statut': 'En attente',
      'datePaiement': null,
      'employeur': 'Ministère de la Santé',
    },
    {
      'mois': 'Août 2023',
      'montant': 45000,
      'statut': 'Payé',
      'datePaiement': '15/08/2023',
      'employeur': 'Ministère de la Santé',
    },
  ];

  double get _totalCotisations {
    return _cotisations
        .where((c) => c['statut'] == 'Payé')
        .fold(0.0, (sum, c) => sum + c['montant']);
  }

  int get _cotisationsEnAttente {
    return _cotisations.where((c) => c['statut'] == 'En attente').length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Cotisations'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Implémenter le téléchargement du relevé
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Téléchargement du relevé à venir'),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Résumé des cotisations
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            child: Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Résumé des cotisations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SummaryItem(
                          label: 'Total cotisé',
                          value: '${_totalCotisations.toStringAsFixed(0)} FCFA',
                          icon: Icons.account_balance_wallet,
                          color: Colors.green,
                        ),
                        SummaryItem(
                          label: 'En attente',
                          value: '$_cotisationsEnAttente',
                          icon: Icons.pending,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Liste des cotisations
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _cotisations.length,
              itemBuilder: (context, index) {
                final cotisation = _cotisations[index];
                return CotisationCard(cotisation: cotisation);
              },
            ),
          ),
        ],
      ),
    );
  }


}