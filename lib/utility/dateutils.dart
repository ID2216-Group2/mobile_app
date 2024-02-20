int compareTime(String timeA, String timeB) {
  // Convert time from "H:MM AM/PM" to 24-hour format "HH:MM" for easier comparison
  DateTime parseTime(String time) {
    final parts = time.split(' ');
    List<String> timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    if (parts[1] == 'PM' && hour != 12) {
      hour += 12;
    } else if (parts[1] == 'AM' && hour == 12) {
      hour = 0;
    }
    // Assuming all times are on the same day, the date part is arbitrary
    return DateTime(0, 0, 0, hour, minute);
  }

  final dateTimeA = parseTime(timeA);
  final dateTimeB = parseTime(timeB);

  return dateTimeA.compareTo(dateTimeB);
}

String getTodayDate() {
  DateTime now = DateTime.now();
  String year = now.year.toString();
  String month = now.month.toString().padLeft(2, '0');
  String day = now.day.toString().padLeft(2, '0');
  return "$year-$month-$day";
}