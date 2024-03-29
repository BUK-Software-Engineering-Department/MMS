class Medicine {
  int? id;
  String? title;
  String? note;
  String? dosage;
  int? isCompleted;
  String? date;
  String? startTime;
  //String? endTime;
  int? color;
  int? remind;
  String? repeat;
  

  Medicine({
    this.id,
    this.title,
    this.note,
    this.dosage,
    this.isCompleted,
    this.date,
    this.startTime,
    //this.endTime,
    this.color,
    this.remind,
    this.repeat,
  });

  Medicine.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    dosage = json['dosage'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    startTime = json['startTime'];
    //endTime = json['endTime'];
    color = json['color'];
    remind = json['remind'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['note'] = note;
    data['dosage'] = dosage;
    data['isCompleted'] = isCompleted;
    data['startTime'] = startTime;
    //data['endTime'] = endTime;
    data['color'] = color;
    data['remind'] = remind;
    data['repeat'] = repeat;
    return data;
  }
}
