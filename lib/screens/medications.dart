import 'package:flutter/material.dart';

class Medication {
  String name;
  String dosage;
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? medicationTime;
  bool needsRefill;

  Medication(
      {required this.name,
      required this.dosage,
      this.startDate,
      this.endDate,
      this.medicationTime,
      this.needsRefill = false});
}

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  _MedicationsScreenState createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  List<Medication> medications = [
    /*Medication(
      name: 'Aspirin',
      dosage: '100mg',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 7)),
      medicationTime: TimeOfDay.now(),
    ),
    Medication(
      name: 'Ibuprofen',
      dosage: '200mg',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 14)),
      medicationTime: TimeOfDay.now(),
    ),*/
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: medications.length,
        itemBuilder: (context, index) {
          return MedicationCard(
            medication: medications[index],
            onEdit: () {
              _editMedication(index);
            },
            onDelete: () {
              _deleteMedication(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addMedication();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addMedication() {
    setState(() {
      medications.add(Medication(
        name: 'New Medication',
        dosage: '',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
        medicationTime: TimeOfDay.now(),
      ));
    });
  }

  void _editMedication(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Medication editedMedication = medications[index];
        return AlertDialog(
          title: const Text('Edit Medication'),
          content: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Medication Name'),
                onChanged: (value) {
                  editedMedication.name = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Dosage'),
                onChanged: (value) {
                  editedMedication.dosage = value;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Start Date'),
                      subtitle: Text(
                        editedMedication.startDate?.toString() ?? 'Select Date',
                      ),
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate:
                              editedMedication.startDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            editedMedication.startDate = selectedDate;
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('End Date'),
                      subtitle: Text(
                        editedMedication.endDate?.toString() ?? 'Select Date',
                      ),
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: editedMedication.endDate ??
                              DateTime.now().add(const Duration(days: 7)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            editedMedication.endDate = selectedDate;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              ListTile(
                title: const Text('Medication Time'),
                subtitle: Text(
                  editedMedication.medicationTime?.format(context) ??
                      'Select Time',
                ),
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime:
                        editedMedication.medicationTime ?? TimeOfDay.now(),
                  );

                  if (selectedTime != null) {
                    setState(() {
                      editedMedication.medicationTime = selectedTime;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  medications[index] = editedMedication;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMedication(int index) {
    setState(() {
      medications.removeAt(index);
    });
  }
}

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(medication.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dosage: ${medication.dosage}'),
            Text('Start Date: ${medication.startDate?.toString()}'),
            Text('End Date: ${medication.endDate?.toString()}'),
            Text(
                'Medication Time: ${medication.medicationTime?.format(context)}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}