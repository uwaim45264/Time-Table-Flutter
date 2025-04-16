import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timetable_provider.dart';
import 'add_timetable_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedDay = 'Monday';
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  // Show confirmation dialog for edit or delete actions
  Future<bool?> _showConfirmationDialog({
    required BuildContext context,
    required String action,
    required String subject,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        elevation: 8,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.9),
                Colors.blue.shade50.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.0),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$action Timetable',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to $action "${subject}"?',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDialogButton(
                    label: 'Cancel',
                    color: Colors.grey.shade400,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  _buildDialogButton(
                    label: 'Confirm',
                    color: action == 'Edit'
                        ? const Color(0xFF6366F1)
                        : const Color(0xFFF43F5E),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timetableProvider = Provider.of<TimetableProvider>(context);
    final filteredTimetables = timetableProvider.timetables
        .where((t) => t.day == _selectedDay)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FF), // Cool-toned backdrop
      appBar: AppBar(
        title: const Text(
          'Timetable',
          style: TextStyle(
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
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _days.map((day) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: ChoiceChip(
                        label: Text(
                          day,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: _selectedDay == day
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: _selectedDay == day
                                ? Colors.white
                                : const Color(0xFF334155),
                          ),
                        ),
                        selected: _selectedDay == day,
                        selectedColor: const Color(0xFF6366F1), // Indigo accent
                        backgroundColor: Colors.white.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0,
                        ),
                        elevation: _selectedDay == day ? 6 : 2,
                        pressElevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedDay = day;
                            });
                          }
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: AnimatedListView(
              children: List.generate(filteredTimetables.length, (index) {
                final timetable = filteredTimetables[index];
                final notesPreview = timetable.notes.length > 20
                    ? '${timetable.notes.substring(0, 20)}...'
                    : timetable.notes;
                return AnimatedCard(
                  index: index,
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
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
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            timetable.subject,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: 0.5,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: const Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${timetable.startTime} - ${timetable.endTime}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF64748B),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: const Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Location: ${timetable.location.isEmpty ? "Not set" : timetable.location}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF64748B),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: const Icon(
                                      Icons.note_outlined,
                                      size: 14,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Notes: ${notesPreview.isEmpty ? "None" : notesPreview}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF64748B),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildActionButton(
                                icon: Icons.edit,
                                color: const Color(0xFF6366F1),
                                onPressed: () async {
                                  final confirmed = await _showConfirmationDialog(
                                    context: context,
                                    action: 'Edit',
                                    subject: timetable.subject,
                                  );
                                  if (confirmed == true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddTimetableScreen(timetable: timetable),
                                      ),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(width: 8),
                              _buildActionButton(
                                icon: Icons.delete_outline,
                                color: const Color(0xFFF43F5E),
                                onPressed: () async {
                                  final confirmed = await _showConfirmationDialog(
                                    context: context,
                                    action: 'Delete',
                                    subject: timetable.subject,
                                  );
                                  if (confirmed == true) {
                                    timetableProvider.deleteTimetable(timetable.id!);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTimetableScreen()),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom AnimatedListView for smooth transitions
class AnimatedListView extends StatelessWidget {
  final List<Widget> children;

  const AnimatedListView({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16.0, bottom: 100.0),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
    );
  }
}

// Custom AnimatedCard for advanced animations
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