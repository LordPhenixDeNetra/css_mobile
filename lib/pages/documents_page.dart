import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  // Données simulées des documents
  final List<Map<String, dynamic>> _documents = [
    {
      'nom': 'Relevé de cotisations 2023',
      'type': 'PDF',
      'taille': '245 KB',
      'dateCreation': '15/12/2023',
      'categorie': 'Cotisations',
      'icon': Icons.receipt_long,
      'color': Colors.blue,
    },
    {
      'nom': 'Attestation d\'affiliation',
      'type': 'PDF',
      'taille': '156 KB',
      'dateCreation': '01/01/2023',
      'categorie': 'Attestations',
      'icon': Icons.verified,
      'color': Colors.green,
    },
    {
      'nom': 'Certificat médical',
      'type': 'PDF',
      'taille': '89 KB',
      'dateCreation': '20/11/2023',
      'categorie': 'Médical',
      'icon': Icons.medical_services,
      'color': Colors.red,
    },
    {
      'nom': 'Justificatif de paiement Nov 2023',
      'type': 'PDF',
      'taille': '67 KB',
      'dateCreation': '30/11/2023',
      'categorie': 'Paiements',
      'icon': Icons.payment,
      'color': Colors.orange,
    },
    {
      'nom': 'Formulaire de demande pension',
      'type': 'PDF',
      'taille': '234 KB',
      'dateCreation': '05/10/2023',
      'categorie': 'Formulaires',
      'icon': Icons.description,
      'color': Colors.purple,
    },
  ];

  String _selectedCategory = 'Tous';
  final List<String> _categories = [
    'Tous',
    'Cotisations',
    'Attestations',
    'Médical',
    'Paiements',
    'Formulaires',
  ];

  List<Map<String, dynamic>> get _filteredDocuments {
    if (_selectedCategory == 'Tous') {
      return _documents;
    }
    return _documents
        .where((doc) => doc['categorie'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Documents'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () {
              _showUploadDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres par catégorie
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: Colors.blue.shade100,
                  ),
                );
              },
            ),
          ),

          // Statistiques
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StatItem(
                      label: 'Total documents',
                      value: '${_documents.length}',
                      icon: Icons.folder,
                      color: Colors.blue,
                    ),
                    StatItem(
                      label: 'Catégories',
                      value: '${_categories.length - 1}',
                      icon: Icons.category,
                      color: Colors.green,
                    ),
                    StatItem(
                      label: 'Taille totale',
                      value: _calculateTotalSize(),
                      icon: Icons.storage,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Liste des documents
          Expanded(
            child: _filteredDocuments.isEmpty
                ? EmptyState(
                    icon: Icons.folder_open,
                    title: 'Aucun document dans cette catégorie',
                    subtitle: 'Utilisez le bouton + pour ajouter des documents',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredDocuments.length,
                    itemBuilder: (context, index) {
                      final document = _filteredDocuments[index];
                      return DocumentCard(
                        document: document,
                        onActionSelected: _handleDocumentAction,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }



  String _calculateTotalSize() {
    // Simulation du calcul de la taille totale
    return '791 KB';
  }

  void _handleDocumentAction(String action, Map<String, dynamic> document) {
    switch (action) {
      case 'view':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ouverture de ${document['nom']}'),
          ),
        );
        break;
      case 'download':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Téléchargement de ${document['nom']}'),
          ),
        );
        break;
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Partage de ${document['nom']}'),
          ),
        );
        break;
      case 'delete':
        _showDeleteDialog(document);
        break;
    }
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter un document'),
          content: const Text(
            'Sélectionnez le type de document que vous souhaitez ajouter.',
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité d\'upload à venir'),
                  ),
                );
              },
              child: const Text('Choisir un fichier'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer le document'),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer "${document['nom']}" ?\n\n'
            'Cette action est irréversible.',
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
                setState(() {
                  _documents.remove(document);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${document['nom']} supprimé'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}