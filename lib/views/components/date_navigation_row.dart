import 'package:flutter/material.dart';

/// A widget that displays a row for navigating dates.
///
/// It shows left/right arrows, the formatted date, and an inline "go to today"
/// control (a lightning icon followed by "Today") if the current date is not today.
/// Tapping on the date opens the date picker.
class DateNavigationRow extends StatelessWidget {
  final String dateString;
  final bool isToday;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onPickDate;
  final VoidCallback onGoToToday;

  /// Constructs a [DateNavigationRow].
  const DateNavigationRow({
    Key? key,
    required this.dateString,
    required this.isToday,
    required this.onPrevious,
    required this.onNext,
    required this.onPickDate,
    required this.onGoToToday,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left, size: 32),
            onPressed: onPrevious,
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: onPickDate,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dateString,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (!isToday)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextButton.icon(
                          onPressed: onGoToToday,
                          icon: const Icon(
                            Icons.flash_on,
                            size: 16,
                            color: Colors.black54,
                          ),
                          label: const Text(
                            "Today",
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right, size: 32),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
