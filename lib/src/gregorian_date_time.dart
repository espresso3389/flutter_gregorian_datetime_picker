import 'package:time_machine/time_machine.dart';

class LocalDateTime {
  LocalDateTime(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
    CalendarSystem? calenderSystem,
    Era? era,
  ])  : localDate = LocalDate(
          year,
          month,
          day,
          calenderSystem,
          era,
        ),
        time = Time(
          hours: hour,
          minutes: minute,
          seconds: second,
          milliseconds: millisecond,
          microseconds: microsecond,
        );

  LocalDateTime.fromLocalDate(this.localDate, {this.time = Time.zero});

  final LocalDate localDate;
  final Time time;

  int get year => localDate.year;
  int get month => localDate.monthOfYear;
  int get day => localDate.dayOfMonth;
  int get hour => time.hourOfDay;
  int get minute => time.minuteOfHour;
  int get second => time.secondOfMinute;
  int get millisecond => time.millisecondOfSecond;
  int get microsecond => time.microsecondOfSecond % 1000; // Correct?

  /// In accordance with ISO 8601
  /// a week starts with Monday, which has the value 1.
  int get weekday => localDate.dayOfWeek.value;

  /// FIXME: The library does not support time zone yet :(
  Duration get timeZoneOffset => Duration.zero;

  /// FIXME: The library does not support time zone yet :(
  String get timeZoneName => 'Unknown';

  /// FIXME: The library does not support UTC.
  bool get isUtc => false;

  Duration difference(LocalDateTime other) =>
      Period.differenceBetweenDates(localDate, other.localDate).toTime().toDuration +
      time.toDuration -
      other.time.toDuration;

  int compareTo(LocalDateTime other) {
    final dayComp = localDate.compareTo(other.localDate);
    if (dayComp != 0) return dayComp;
    return time.compareTo(other.time);
  }

  bool isAfter(LocalDateTime other) => compareTo(other) > 0;
  bool isBefore(LocalDateTime other) => compareTo(other) < 0;
  bool isAtSameMomentAs(LocalDateTime other) => compareTo(other) == 0;
  LocalDateTime add(Duration duration) {
    final t = time.add(Time.duration(duration));
    final days = t.inDays;
    return LocalDateTime.fromLocalDate(localDate.addDays(days), time: t.subtract(Time(days: days)));
  }

  factory LocalDateTime.now() {
    final n = DateTime.now();
    return LocalDateTime(
      n.year,
      n.month,
      n.day,
      n.hour,
      n.minute,
      n.second,
      n.millisecond,
      n.microsecond % 1000,
    );
  }

  factory LocalDateTime.utc(int year,
      [int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0]) {
    throw Exception('LocalDateTime.utc is not supported.');
  }

  @override
  String toString() {
    return '$localDate $time';
  }
}
