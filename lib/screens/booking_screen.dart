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
import '../utils/date_utils.dart' as app_date;

class BookingScreen extends StatefulWidget {
  final String serviceId;

  const BookingScreen({
    super.key,
    required this.serviceId,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _vehicleInfoController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<String> _imageUrls = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    _vehicleInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Réserver un service'),
      body: Consumer2<ServicesProvider, ReservationProvider>(
        builder: (context, servicesProvider, reservationProvider, child) {
          final service = servicesProvider.getServiceById(widget.serviceId);

          if (service == null) {
            return _buildServiceNotFound();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildServiceSummary(service),
                  const SizedBox(height: 24),
                  _buildDateTimeSelection(),
                  const SizedBox(height: 24),
                  _buildVehicleInfo(),
                  const SizedBox(height: 24),
                  _buildNotesSection(),
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

  Widget _buildServiceSummary(service) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service sélectionné',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getIconData(service.iconName),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'À partir de ${service.price.toInt()}€ • ${service.duration}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date et heure souhaitées',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Card(
                child: InkWell(
                  onTap: _selectDate,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: AppTheme.primaryRed,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedDate != null
                              ? app_date.AppDateUtils.formatDate(_selectedDate!)
                              : 'Sélectionner une date',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                child: InkWell(
                  onTap: _selectedDate != null ? _selectTime : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: _selectedDate != null 
                              ? AppTheme.primaryRed 
                              : AppTheme.textSecondary,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedTime != null
                              ? app_date.AppDateUtils.formatTime(_selectedTime!)
                              : 'Sélectionner l\'heure',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _selectedDate != null 
                                ? null 
                                : AppTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_selectedDate != null && _selectedTime != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Rendez-vous prévu le ${app_date.AppDateUtils.formatDateTime(
                DateTime(
                  _selectedDate!.year,
                  _selectedDate!.month,
                  _selectedDate!.day,
                  _selectedTime!.hour,
                  _selectedTime!.minute,
                )
              )}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVehicleInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations du véhicule',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _vehicleInfoController,
          label: 'Marque, modèle, année (ex: BMW X3 2020)',
          hint: 'Entrez les informations de votre véhicule',
          maxLines: 2,
          validator: Validators.required,
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes additionnelles',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Décrivez l\'état de vos jantes, vos attentes ou toute information utile',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _notesController,
          label: 'Notes (optionnel)',
          hint: 'Décrivez l\'état de vos jantes, vos attentes...',
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos de vos jantes',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ajoutez des photos pour nous aider à mieux évaluer le travail nécessaire',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        if (_imageUrls.isNotEmpty) ...[
          SizedBox(
            height: 100,
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
        ] else
          _buildAddImageButton(),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return Container(
      width: 100,
      height: 100,
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
                size: 32,
              ),
              const SizedBox(height: 4),
              Text(
                'Ajouter',
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
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              _imageUrls[index],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: AppTheme.lightGray,
                  child: const Icon(Icons.error),
                );
              },
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
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
            text: 'Confirmer la réservation',
            icon: Icons.check,
            onPressed: _isLoading || 
                      _selectedDate == null || 
                      _selectedTime == null ||
                      _vehicleInfoController.text.isEmpty
                ? null
                : () => _submitBooking(reservationProvider),
            isLoading: _isLoading,
            isSecondary: false,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceNotFound() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Service introuvable',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Le service demandé n\'est pas disponible',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Retour aux services',
              icon: Icons.arrow_back,
              onPressed: () => context.go('/services'),
              isSecondary: false,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _selectedTime = null; // Reset time when date changes
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (time != null) {
      // Check if the selected time is within business hours
      if (time.hour >= 8 && time.hour < 18) {
        setState(() {
          _selectedTime = time;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner un horaire entre 8h et 18h'),
            backgroundColor: AppTheme.primaryRed,
          ),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      // In a real app, you would upload the image to a server
      // For now, we'll simulate adding the image URL
      setState(() {
        _imageUrls.add('https://example.com/image_${_imageUrls.length}.jpg');
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageUrls.removeAt(index);
    });
  }

  Future<void> _submitBooking(ReservationProvider reservationProvider) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final success = await reservationProvider.createReservation(
      serviceId: widget.serviceId,
      dateTime: dateTime,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      vehicleInfo: _vehicleInfoController.text,
      imageUrls: _imageUrls.isNotEmpty ? _imageUrls : null,
    );

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Réservation créée avec succès !'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/reservations');
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
