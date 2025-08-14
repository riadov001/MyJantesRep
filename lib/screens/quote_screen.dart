import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/services_provider.dart';
import '../providers/reservation_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_widget.dart';
import '../config/theme.dart';
import '../utils/validators.dart';
import '../models/service.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleMakeController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleYearController = TextEditingController();
  final _wheelSizeController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  Service? _selectedService;
  List<String> _imageUrls = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
    _wheelSizeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Demander un devis'),
      body: Consumer2<ServicesProvider, ReservationProvider>(
        builder: (context, servicesProvider, reservationProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIntroSection(),
                  const SizedBox(height: 24),
                  _buildServiceSelection(servicesProvider),
                  const SizedBox(height: 24),
                  _buildVehicleInformation(),
                  const SizedBox(height: 24),
                  _buildWheelSize(),
                  const SizedBox(height: 24),
                  _buildDescriptionSection(),
                  const SizedBox(height: 24),
                  _buildImageUpload(),
                  const SizedBox(height: 32),
                  _buildSubmitButton(reservationProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIntroSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.request_quote,
              size: 48,
              color: AppTheme.primaryRed,
            ),
            const SizedBox(height: 12),
            Text(
              'Demande de devis gratuit',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Remplissez ce formulaire et recevez votre devis personnalisé sous 24h',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSelection(ServicesProvider servicesProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service souhaité *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (servicesProvider.isLoading)
          const LoadingWidget()
        else if (servicesProvider.services.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Aucun service disponible',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
        else
          ...servicesProvider.services.map((service) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Card(
              child: RadioListTile<Service>(
                value: service,
                groupValue: _selectedService,
                onChanged: (Service? value) {
                  setState(() {
                    _selectedService = value;
                  });
                },
                title: Text(service.name),
                subtitle: Text(
                  '${service.shortDescription}\nÀ partir de ${service.price.toInt()}€ • ${service.duration}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedService == service 
                        ? AppTheme.primaryRed 
                        : AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getIconData(service.iconName),
                    color: _selectedService == service 
                        ? Colors.white 
                        : AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                activeColor: AppTheme.primaryRed,
              ),
            ),
          )).toList(),
      ],
    );
  }

  Widget _buildVehicleInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations du véhicule *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _vehicleMakeController,
                label: 'Marque',
                hint: 'BMW, Audi, Mercedes...',
                validator: Validators.required,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                controller: _vehicleModelController,
                label: 'Modèle',
                hint: 'X3, A4, C-Class...',
                validator: Validators.required,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _vehicleYearController,
          label: 'Année',
          hint: '2020',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'L\'année est requise';
            }
            final year = int.tryParse(value);
            if (year == null || year < 1980 || year > DateTime.now().year + 1) {
              return 'Année invalide';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildWheelSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Taille des jantes *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Exemple: 17", 18", 19", 20"...',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _wheelSizeController,
          label: 'Taille',
          hint: '18"',
          validator: Validators.required,
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description de vos besoins *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Décrivez l\'état actuel de vos jantes, vos attentes, le type de finition souhaitée...',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _descriptionController,
          label: 'Description détaillée',
          hint: 'Décrivez l\'état de vos jantes, le type de travail souhaité...',
          maxLines: 5,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La description est requise';
            }
            if (value.length < 20) {
              return 'Veuillez fournir plus de détails (minimum 20 caractères)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos de vos jantes *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ajoutez au moins 2 photos pour nous permettre d\'évaluer précisément le travail à effectuer',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        if (_imageUrls.isNotEmpty) ...[
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageUrls.length + 1,
              itemBuilder: (context, index) {
                if (index == _imageUrls.length) {
                  return _buildAddImageButton();
                }
                return _buildImagePreview(index);
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_imageUrls.length} photo(s) ajoutée(s)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.primaryRed,
            ),
          ),
        ] else ...[
          _buildAddImageButton(),
          const SizedBox(height: 8),
          Text(
            'Aucune photo ajoutée',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.orange,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAddImageButton() {
    return Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.only(right: 8),
      child: Card(
        child: InkWell(
          onTap: _pickImage,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo,
                color: AppTheme.primaryRed,
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                'Ajouter\nune photo',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(int index) {
    return Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              _imageUrls[index],
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 120,
                  color: AppTheme.lightGray,
                  child: const Icon(Icons.error),
                );
              },
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(ReservationProvider reservationProvider) {
    return Column(
      children: [
        if (reservationProvider.error != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reservationProvider.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Envoyer la demande de devis',
            icon: Icons.send,
            onPressed: _canSubmit() && !_isLoading
                ? () => _submitQuote(reservationProvider)
                : null,
            isLoading: _isLoading,
            isSecondary: false,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Vous recevrez votre devis personnalisé sous 24h',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  bool _canSubmit() {
    return _selectedService != null &&
           _vehicleMakeController.text.isNotEmpty &&
           _vehicleModelController.text.isNotEmpty &&
           _vehicleYearController.text.isNotEmpty &&
           _wheelSizeController.text.isNotEmpty &&
           _descriptionController.text.isNotEmpty &&
           _imageUrls.length >= 2;
  }

  Future<void> _pickImage() async {
    if (_imageUrls.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 5 photos autorisées'),
          backgroundColor: AppTheme.primaryRed,
        ),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      // In a real app, you would upload the image to a server
      // For now, we'll simulate adding the image URL
      setState(() {
        _imageUrls.add('https://example.com/quote_image_${_imageUrls.length}.jpg');
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageUrls.removeAt(index);
    });
  }

  Future<void> _submitQuote(ReservationProvider reservationProvider) async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageUrls.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez ajouter au moins 2 photos'),
          backgroundColor: AppTheme.primaryRed,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await reservationProvider.createQuote(
      serviceId: _selectedService!.id,
      vehicleMake: _vehicleMakeController.text,
      vehicleModel: _vehicleModelController.text,
      vehicleYear: _vehicleYearController.text,
      wheelSize: _wheelSizeController.text,
      description: _descriptionController.text,
      imageUrls: _imageUrls,
    );

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Demande de devis envoyée avec succès !'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/quotes-history');
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'build':
        return Icons.build;
      case 'palette':
        return Icons.palette;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'construction':
        return Icons.construction;
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'water':
        return Icons.water;
      default:
        return Icons.build;
    }
  }
}
