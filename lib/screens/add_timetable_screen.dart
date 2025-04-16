import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timetable_provider.dart';
import '../models/timetable.dart';

class AddTimetableScreen extends StatefulWidget {
  final Timetable? timetable;

  const AddTimetableScreen({super.key, this.timetable});

  @override
  _AddTimetableScreenState createState() => _AddTimetableScreenState();
}

class _AddTimetableScreenState extends State<AddTimetableScreen> {
  final _formKey = GlobalKey<FormState>();
  String _subject = '';
  String _startTime = '';
  String _endTime = '';
  String _day = 'Monday';
  String _location = '';
  String _notes = '';

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.timetable != null) {
      _subject = widget.timetable!.subject;
      _startTime = widget.timetable!.startTime;
      _endTime = widget.timetable!.endTime;
      _day = widget.timetable!.day;
      _location = widget.timetable!.location;
      _notes = widget.timetable!.notes;
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6366F1), // Indigo accent
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6366F1),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final formattedTime = picked.format(context);
        if (isStart) {
          _startTime = formattedTime;
        } else {
          _endTime = formattedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final timetableProvider = Provider.of<TimetableProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FF), // Same cool-toned backdrop
      appBar: AppBar(
        title: Text(
          widget.timetable == null ? 'Add Timetable' : 'Edit Timetable',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 28,
            color: Color(0xFF0F172A),
            letterSpacing: 1.0,
            shadows: [
              Shadow(
                blurRadius: 8.0,
                color: Colors.black12,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.9),
                Colors.blue.shade50.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(
                initialValue: _subject,
                label: 'Subject',
                onSaved: (value) => _subject = value!,
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a subject' : null,
              ),
              _buildDropdownField(),
              _buildTextFormField(
                label: 'Start Time',
                readOnly: true,
                controller: TextEditingController(text: _startTime),
                onTap: () => _selectTime(context, true),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please select a start time' : null,
              ),
              _buildTextFormField(
                label: 'End Time',
                readOnly: true,
                controller: TextEditingController(text: _endTime),
                onTap: () => _selectTime(context, false),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please select an end time' : null,
              ),
              _buildTextFormField(
                initialValue: _location,
                label: 'Location',
                onSaved: (value) => _location = value ?? '',
              ),
              _buildTextFormField(
                initialValue: _notes,
                label: 'Notes',
                maxLines: 3,
                onSaved: (value) => _notes = value ?? '',
              ),
              const SizedBox(height: 20),
              _buildSubmitButton(timetableProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    String? initialValue,
    required String label,
    int maxLines = 1,
    bool readOnly = false,
    TextEditingController? controller,
    void Function(String?)? onSaved,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: AnimatedCard(
        index: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.85),
                Colors.blue.shade50.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: TextFormField(
            initialValue: initialValue,
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(18.0),
            ),
            maxLines: maxLines,
            readOnly: readOnly,
            onTap: onTap,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w600,
            ),
            validator: validator,
            onSaved: onSaved,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: AnimatedCard(
        index: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.85),
                Colors.blue.shade50.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: _day,
            decoration: const InputDecoration(
              labelText: 'Day',
              labelStyle: TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(18.0),
            ),
            items: _days.map((String day) {
              return DropdownMenuItem<String>(
                value: day,
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _day = value!;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(TimetableProvider timetableProvider) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(30.0),
          onTap: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final timetable = Timetable(
                id: widget.timetable?.id,
                subject: _subject,
                startTime: _startTime,
                endTime: _endTime,
                day: _day,
                location: _location,
                notes: _notes,
              );
              if (widget.timetable == null) {
                timetableProvider.addTimetable(timetable);
              } else {
                timetableProvider.updateTimetable(timetable);
              }
              Navigator.pop(context);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.timetable == null ? 'Add' : 'Update',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Reusing AnimatedCard from HomeScreen for consistency
class AnimatedCard extends StatelessWidget {
  final Widget child;
  final int index;

  const AnimatedCard({super.key, required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 150)),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(50 * (1 - value), 0),
            child: Transform.scale(
              scale: 0.85 + (0.15 * value),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}