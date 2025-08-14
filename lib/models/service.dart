class Service {
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final double price;
  final String duration;
  final String iconName;
  final List<String> includes;
  final String imageUrl;
  final bool isPopular;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.price,
    required this.duration,
    required this.iconName,
    required this.includes,
    required this.imageUrl,
    this.isPopular = false,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'].toString(),
      name: json['title']['rendered'] ?? '',
      description: json['content']['rendered'] ?? '',
      shortDescription: json['excerpt']['rendered'] ?? '',
      price: double.tryParse(json['acf']?['price']?.toString() ?? '0') ?? 0.0,
      duration: json['acf']?['duration'] ?? '',
      iconName: json['acf']?['icon'] ?? 'build',
      includes: List<String>.from(json['acf']?['includes'] ?? []),
      imageUrl: json['featured_media_url'] ?? '',
      isPopular: json['acf']?['is_popular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'shortDescription': shortDescription,
      'price': price,
      'duration': duration,
      'iconName': iconName,
      'includes': includes,
      'imageUrl': imageUrl,
      'isPopular': isPopular,
    };
  }

  // Static data based on the website content
  static List<Service> getDefaultServices() {
    return [
      Service(
        id: '1',
        name: 'Rénovation',
        shortDescription: 'Remise à neuf complète de vos jantes avec traitement anti-corrosion',
        description: 'Service de rénovation complète incluant décapage, traitement anti-corrosion, peinture haute qualité et finition brillante.',
        price: 80.0,
        duration: '3-5 jours',
        iconName: 'build',
        includes: [
          'Décapage complet',
          'Traitement anti-corrosion',
          'Peinture haute qualité',
          'Finition brillante'
        ],
        imageUrl: 'https://images.unsplash.com/photo-1607228531191-b931a086cdea',
      ),
      Service(
        id: '2',
        name: 'Personnalisation',
        shortDescription: 'Couleurs et finitions sur mesure selon vos goûts et votre style',
        description: 'Service de personnalisation avec choix illimité de couleurs, finitions mates ou brillantes, effets métallisés et design personnalisé.',
        price: 120.0,
        duration: '4-6 jours',
        iconName: 'palette',
        includes: [
          'Choix de couleurs illimité',
          'Finitions mates ou brillantes',
          'Effets métallisés',
          'Design personnalisé'
        ],
        imageUrl: 'https://images.unsplash.com/photo-1607228531191-b931a086cdea',
        isPopular: true,
      ),
      Service(
        id: '3',
        name: 'Tribofinition',
        shortDescription: 'Finition haute qualité par tribofinition pour un rendu exceptionnel',
        description: 'Technique professionnelle de tribofinition offrant finition miroir, résistance maximale et brillance durable.',
        price: 150.0,
        duration: '5-7 jours',
        iconName: 'auto_awesome',
        includes: [
          'Finition miroir',
          'Résistance maximale',
          'Brillance durable',
          'Technique professionnelle'
        ],
        imageUrl: 'https://images.unsplash.com/photo-1607228531191-b931a086cdea',
      ),
      Service(
        id: '4',
        name: 'Soudure',
        shortDescription: 'Réparation professionnelle des fissures et déformations',
        description: 'Service de réparation incluant soudure TIG/MIG, réparation de fissures, redressage et test d\'étanchéité.',
        price: 60.0,
        duration: '2-4 jours',
        iconName: 'construction',
        includes: [
          'Soudure TIG/MIG',
          'Réparation fissures',
          'Redressage jantes',
          'Test étanchéité'
        ],
        imageUrl: 'https://images.unsplash.com/photo-1607228531191-b931a086cdea',
      ),
      Service(
        id: '5',
        name: 'Décapage',
        shortDescription: 'Nettoyage en profondeur pour éliminer toute trace d\'oxydation',
        description: 'Service de décapage complet incluant décapage chimique, sablage délicat, nettoyage ultrasonique et préparation de surface.',
        price: 40.0,
        duration: '1-2 jours',
        iconName: 'cleaning_services',
        includes: [
          'Décapage chimique',
          'Sablage délicat',
          'Nettoyage ultrasonique',
          'Préparation surface'
        ],
        imageUrl: 'https://images.unsplash.com/photo-1607228531191-b931a086cdea',
      ),
      Service(
        id: '6',
        name: 'Hydrographie',
        shortDescription: 'Motifs et textures uniques appliqués par immersion',
        description: 'Technique d\'hydrographie permettant d\'appliquer des motifs carbone, textures bois, effets camouflage et designs exclusifs.',
        price: 200.0,
        duration: '6-8 jours',
        iconName: 'water',
        includes: [
          'Motifs carbone',
          'Textures bois',
          'Effets camouflage',
          'Designs exclusifs'
        ],
        imageUrl: 'https://images.unsplash.com/photo-1607228531191-b931a086cdea',
      ),
    ];
  }
}
