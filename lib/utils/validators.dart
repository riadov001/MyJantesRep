import 'package:flutter/material.dart';

class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }

    // Simple email regex pattern
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }

    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }

    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }

    // Check for at least one letter
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une lettre';
    }

    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }

    return null;
  }

  // Strong password validation (optional)
  static String? strongPassword(String? value) {
    final basicValidation = password(value);
    if (basicValidation != null) return basicValidation;

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value!)) {
      return 'Le mot de passe doit contenir au moins une majuscule';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une minuscule';
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins un caractère spécial';
    }

    return null;
  }

  // Required field validation
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Ce champ'} est requis';
    }
    return null;
  }

  // Phone number validation (French format)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }

    // Remove spaces, dashes, dots, and parentheses
    final cleanedValue = value.replaceAll(RegExp(r'[\s\-\.\(\)]'), '');

    // French phone number patterns
    final mobileRegex = RegExp(r'^(\+33|0)[67]\d{8}$');
    final landlineRegex = RegExp(r'^(\+33|0)[1-5]\d{8}$');

    if (!mobileRegex.hasMatch(cleanedValue) && !landlineRegex.hasMatch(cleanedValue)) {
      return 'Veuillez entrer un numéro de téléphone français valide';
    }

    return null;
  }

  // Optional phone validation
  static String? optionalPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Allow empty for optional fields
    }
    return phone(value);
  }

  // Name validation
  static String? name(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Le nom'} est requis';
    }

    if (value.trim().length < 2) {
      return '${fieldName ?? 'Le nom'} doit contenir au moins 2 caractères';
    }

    // Check for invalid characters (numbers and special chars except spaces, hyphens, apostrophes)
    if (RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return '${fieldName ?? 'Le nom'} ne peut contenir que des lettres, espaces, traits d\'union et apostrophes';
    }

    return null;
  }

  // Vehicle year validation
  static String? vehicleYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'année est requise';
    }

    final year = int.tryParse(value);
    if (year == null) {
      return 'Veuillez entrer une année valide';
    }

    final currentYear = DateTime.now().year;
    if (year < 1980 || year > currentYear + 1) {
      return 'L\'année doit être comprise entre 1980 et ${currentYear + 1}';
    }

    return null;
  }

  // Wheel size validation
  static String? wheelSize(String? value) {
    if (value == null || value.isEmpty) {
      return 'La taille des jantes est requise';
    }

    // Remove quotes and spaces
    final cleanedValue = value.replaceAll(RegExp(r'["\s]'), '');
    
    // Extract numeric part
    final sizeMatch = RegExp(r'^(\d+)').firstMatch(cleanedValue);
    if (sizeMatch == null) {
      return 'Format invalide (ex: 17", 18")';
    }

    final size = int.tryParse(sizeMatch.group(1)!);
    if (size == null || size < 12 || size > 24) {
      return 'La taille doit être comprise entre 12" et 24"';
    }

    return null;
  }

  // Description validation with minimum length
  static String? description(String? value, {int minLength = 10}) {
    if (value == null || value.trim().isEmpty) {
      return 'La description est requise';
    }

    if (value.trim().length < minLength) {
      return 'La description doit contenir au moins $minLength caractères';
    }

    return null;
  }

  // Vehicle info validation
  static String? vehicleInfo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Les informations du véhicule sont requises';
    }

    // Should contain at least brand and model
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) {
      return 'Veuillez indiquer au moins la marque et le modèle';
    }

    return null;
  }

  // URL validation
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'URL est requise';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Veuillez entrer une URL valide';
    }

    return null;
  }

  // Confirm password validation
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'La confirmation du mot de passe est requise';
    }

    if (value != originalPassword) {
      return 'Les mots de passe ne correspondent pas';
    }

    return null;
  }

  // Numeric validation
  static String? numeric(String? value, {String? fieldName, double? min, double? max}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Ce champ'} est requis';
    }

    final numValue = double.tryParse(value);
    if (numValue == null) {
      return 'Veuillez entrer un nombre valide';
    }

    if (min != null && numValue < min) {
      return 'La valeur doit être supérieure ou égale à $min';
    }

    if (max != null && numValue > max) {
      return 'La valeur doit être inférieure ou égale à $max';
    }

    return null;
  }

  // Date validation
  static String? futureDate(DateTime? value) {
    if (value == null) {
      return 'La date est requise';
    }

    if (value.isBefore(DateTime.now())) {
      return 'La date doit être dans le futur';
    }

    return null;
  }

  // Business hours validation
  static String? businessHours(TimeOfDay? time) {
    if (time == null) {
      return 'L\'heure est requise';
    }

    // Business hours: 8:00 - 18:00
    const openHour = 8;
    const closeHour = 18;

    if (time.hour < openHour || time.hour >= closeHour) {
      return 'Veuillez sélectionner un horaire entre ${openHour}h et ${closeHour}h';
    }

    return null;
  }

  // File size validation (in bytes)
  static String? fileSize(int? sizeInBytes, {int maxSizeInMB = 5}) {
    if (sizeInBytes == null) {
      return 'La taille du fichier ne peut pas être déterminée';
    }

    final maxSizeInBytes = maxSizeInMB * 1024 * 1024;
    if (sizeInBytes > maxSizeInBytes) {
      return 'Le fichier ne doit pas dépasser ${maxSizeInMB}MB';
    }

    return null;
  }

  // Image validation
  static String? imageFile(String? fileName) {
    if (fileName == null || fileName.isEmpty) {
      return 'Veuillez sélectionner une image';
    }

    final allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
    final extension = fileName.toLowerCase().split('.').last;

    if (!allowedExtensions.contains(extension)) {
      return 'Format non supporté. Utilisez: ${allowedExtensions.join(', ')}';
    }

    return null;
  }

  // Combine multiple validators
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final result = validator();
      if (result != null) return result;
    }
    return null;
  }

  // Address validation
  static String? address(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L\'adresse est requise';
    }

    if (value.trim().length < 5) {
      return 'L\'adresse doit contenir au moins 5 caractères';
    }

    return null;
  }

  // Postal code validation (French)
  static String? postalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le code postal est requis';
    }

    final postalCodeRegex = RegExp(r'^[0-9]{5}$');
    if (!postalCodeRegex.hasMatch(value)) {
      return 'Le code postal doit contenir 5 chiffres';
    }

    return null;
  }

  // Optional field wrapper
  static String? optional(String? value, String? Function(String?) validator) {
    if (value == null || value.trim().isEmpty) {
      return null; // Allow empty for optional fields
    }
    return validator(value);
  }
}
