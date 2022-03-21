class ResumeModel {
  String? year;
  String? month;
  String? day;
  String? yearDelivered;
  String? monthDelivered;
  String? dayDelivered;
  String? delivered;
  String? notDelivered;

  ResumeModel(
      {this.year,
      this.month,
      this.day,
      this.yearDelivered,
      this.monthDelivered,
      this.dayDelivered,
      this.delivered,
      this.notDelivered});

  ResumeModel.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
    day = json['day'];
    yearDelivered = json['year_delivered'];
    monthDelivered = json['month_delivered'];
    dayDelivered = json['day_delivered'];
    delivered = json['delivered'];
    notDelivered = json['not_delivered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    data['year_delivered'] = this.yearDelivered;
    data['month_delivered'] = this.monthDelivered;
    data['day_delivered'] = this.dayDelivered;
    data['delivered'] = this.delivered;
    data['not_delivered'] = this.notDelivered;
    return data;
  }
}
