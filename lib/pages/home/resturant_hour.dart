import 'package:flutter/material.dart';

class RestaurantHoursWidget extends StatelessWidget {
  // Function to check if the restaurant is open based on current time
  bool isRestaurantOpen() {
    final currentTime = DateTime.now();
    final openTime =
        TimeOfDay(hour: 10, minute: 0); // Replace with actual open time
    final closeTime =
        TimeOfDay(hour: 20, minute: 0); // Replace with actual close time

    final currentDateTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      openTime.hour,
      openTime.minute,
    );

    final openingDateTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      closeTime.hour,
      closeTime.minute,
    );

    return currentTime.isAfter(currentDateTime) &&
        currentTime.isBefore(openingDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isRestaurantOpen() ? Colors.amber : Colors.red,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Text(
          isRestaurantOpen() ? 'مفتوح' : 'مغلق',
          style: TextStyle(
              fontFamily: 'Al-Jazeera',
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.white),
        ),
      ),
    );
  }
}
