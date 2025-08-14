import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateUtils {
  // Date formatters
  static final DateFormat _dayMonthYearFormatter = DateFormat('dd/MM/yyyy');
  static final DateFormat _dayMonthFormatter = DateFormat('dd/MM');
  static final DateFormat _monthYearFormatter = DateFormat('MMMM yyyy', 'fr_FR');
  static final DateFormat _fullDateFormatter = DateFormat('EEEE dd MMMM yyyy', 'fr_FR');
  static final DateFormat _timeFormatter = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormatter = DateFormat('dd/MM/yyyy à HH:mm');
  static final DateFormat _shortDateTimeFormatter = DateFormat('dd/MM à HH:mm');
  static final DateFormat _isoFormatter = DateFormat('yyyy-MM-ddTHH:mm:ss');

  // Format date to dd/MM/yyyy
  static String formatDate(DateTime date) {
    return _dayMonthYearFormatter.format(date);
  }

  // Format date to dd/MM
  static String formatShortDate(DateTime date) {
    return _dayMonthFormatter.format(date);
  }

  // Format date to "janvier 2024"
  static String formatMonthYear(DateTime date) {
    return _monthYearFormatter.format(date);
  }

  // Format date to "lundi 15 janvier 2024"
  static String formatFullDate(DateTime date) {
    return _fullDateFormatter.format(date);
  }

  // Format time to HH:mm
  static String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return _timeFormatter.format(dateTime);
  }

  // Format DateTime to "dd/MM/yyyy à HH:mm"
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormatter.format(dateTime);
  }

  // Format DateTime to "dd/MM à HH:mm" (short version)
  static String formatShortDateTime(DateTime dateTime) {
    return _shortDateTimeFormatter.format(dateTime);
  }

  // Format relative time (e.g., "il y a 2 heures")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'hier';
      } else if (difference.inDays < 7) {
        return 'il y a ${difference.inDays} jours';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return weeks == 1 ? 'il y a 1 semaine' : 'il y a $weeks semaines';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return months == 1 ? 'il y a 1 mois' : 'il y a $months mois';
      } else {
        final years = (difference.inDays / 365).floor();
        return years == 1 ? 'il y a 1 an' : 'il y a $years ans';
      }
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 
          ? 'il y a 1 heure' 
          : 'il y a ${difference.inHours} heures';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 
          ? 'il y a 1 minute' 
          : 'il y a ${difference.inMinutes} minutes';
    } else {
      return 'à l\'instant';
    }
  }

  // Format time until (e.g., "dans 2 heures")
  static String formatTimeUntil(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      return formatRelativeTime(dateTime);
    }

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'demain';
      } else if (difference.inDays < 7) {
        return 'dans ${difference.inDays} jours';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return weeks == 1 ? 'dans 1 semaine' : 'dans $weeks semaines';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return months == 1 ? 'dans 1 mois' : 'dans $months mois';
      } else {
        final years = (difference.inDays / 365).floor();
        return years == 1 ? 'dans 1 an' : 'dans $years ans';
      }
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 
          ? 'dans 1 heure' 
          : 'dans ${difference.inHours} heures';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 
          ? 'dans 1 minute' 
          : 'dans ${difference.inMinutes} minutes';
    } else {
      return 'maintenant';
    }
  }

  // Parse date string (dd/MM/yyyy)
  static DateTime? parseDate(String dateString) {
    try {
      return _dayMonthYearFormatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Parse ISO date string
  static DateTime? parseIsoDate(String isoString) {
    try {
      return DateTime.parse(isoString);
    } catch (e) {
      return null;
    }
  }

  // Convert TimeOfDay to DateTime
  static DateTime timeOfDayToDateTime(TimeOfDay timeOfDay, {DateTime? date}) {
    final baseDate = date ?? DateTime.now();
    return DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  // Convert DateTime to TimeOfDay
  static TimeOfDay dateTimeToTimeOfDay(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  // Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }

  // Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }

  // Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  // Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  // Get end of week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    final daysToSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysToSunday)));
  }

  // Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  // Get end of month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  // Get days in month
  static int daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  // Check if year is leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0) && (year % 100 != 0 || year % 400 == 0);
  }

  // Get age from birth date
  static int getAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }

  // Check if date is weekend
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  // Get next business day (Monday-Friday)
  static DateTime nextBusinessDay(DateTime date) {
    DateTime nextDay = date.add(const Duration(days: 1));
    while (isWeekend(nextDay)) {
      nextDay = nextDay.add(const Duration(days: 1));
    }
    return nextDay;
  }

  // Get business days between two dates
  static int businessDaysBetween(DateTime start, DateTime end) {
    if (start.isAfter(end)) return 0;
    
    int businessDays = 0;
    DateTime current = start;
    
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      if (!isWeekend(current)) {
        businessDays++;
      }
      current = current.add(const Duration(days: 1));
    }
    
    return businessDays;
  }

  // Get french day name
  static String getFrenchDayName(int weekday) {
    const days = [
      'lundi',
      'mardi', 
      'mercredi',
      'jeudi',
      'vendredi',
      'samedi',
      'dimanche'
    ];
    return days[weekday - 1];
  }

  // Get french month name
  static String getFrenchMonthName(int month) {
    const months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre'
    ];
    return months[month - 1];
  }

  // Check if time is in business hours
  static bool isBusinessHours(TimeOfDay time) {
    return time.hour >= 8 && time.hour < 18;
  }

  // Get next available time slot
  static DateTime getNextAvailableSlot(DateTime dateTime, {Duration increment = const Duration(minutes: 30)}) {
    DateTime nextSlot = dateTime;
    
    // Round to next increment
    final minutesToAdd = increment.inMinutes - (nextSlot.minute % increment.inMinutes);
    if (minutesToAdd != increment.inMinutes) {
      nextSlot = nextSlot.add(Duration(minutes: minutesToAdd));
    }
    
    // Ensure it's in business hours
    final timeOfDay = TimeOfDay.fromDateTime(nextSlot);
    if (!isBusinessHours(timeOfDay)) {
      if (timeOfDay.hour < 8) {
        nextSlot = DateTime(nextSlot.year, nextSlot.month, nextSlot.day, 8, 0);
      } else {
        nextSlot = nextBusinessDay(nextSlot);
        nextSlot = DateTime(nextSlot.year, nextSlot.month, nextSlot.day, 8, 0);
      }
    }
    
    return nextSlot;
  }

  // Format duration (e.g., "2h 30min")
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}min';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}min';
    }
  }

  // Get time difference in a readable format
  static String getTimeDifference(DateTime start, DateTime end) {
    final difference = end.difference(start);
    return formatDuration(difference);
  }
}
