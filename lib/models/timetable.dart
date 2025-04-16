class Timetable {
  final int? id;
  final String subject;
  final String startTime;
  final String endTime;
  final String day;
  final String location;
  final String notes;

  Timetable({
    this.id,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.day,
    required this.location,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'startTime': startTime,
      'endTime': endTime,
      'day': day,
      'location': location,
      'notes': notes,
    };
  }

  factory Timetable.fromMap(Map<String, dynamic> map) {
    return Timetable(
      id: map['id'],
      subject: map['subject'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      day: map['day'],
      location: map['location'],
      notes: map['notes'],
    );
  }
}