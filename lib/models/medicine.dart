class Medicine {
  int? id;
  String? title;
  String? note;
  String? dosage;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  Medicine(
      {this.id,
      this.title,
      this.note,
      this.dosage,
      this.isCompleted,
      this.date,
      this.startTime,
      this.endTime,
      this.color,
      this.remind,
      this.repeat});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'dosage': dosage,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'remind': remind,
      'repeat': repeat,
    };
  }

  Medicine.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    dosage = json['dosage'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    color = json['color'];
    remind = json['remind'];
    repeat = json['repeat'];
  }
}
