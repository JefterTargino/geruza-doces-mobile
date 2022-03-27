class FinancialModel {
  num? valueReceived;
  num? valueNotReceived;
  num? yearNotReceived;
  num? monthNotReceived;
  num? dayNotReceived;
  num? yearReceived;
  num? monthReceived;
  num? dayReceived;

  FinancialModel(
      {this.valueReceived,
      this.valueNotReceived,
      this.yearNotReceived,
      this.monthNotReceived,
      this.dayNotReceived,
      this.yearReceived,
      this.monthReceived,
      this.dayReceived});

  FinancialModel.fromJson(Map<String, dynamic> json) {
    valueReceived = json['value_received'];
    valueNotReceived = json['value_notReceived'];
    yearNotReceived = json['year_notReceived'];
    monthNotReceived = json['month_notReceived'];
    dayNotReceived = json['day_notReceived'];
    yearReceived = json['year_Received'];
    monthReceived = json['month_Received'];
    dayReceived = json['day_Received'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value_received'] = this.valueReceived;
    data['value_notReceived'] = this.valueNotReceived;
    data['year_notReceived'] = this.yearNotReceived;
    data['month_notReceived'] = this.monthNotReceived;
    data['day_notReceived'] = this.dayNotReceived;
    data['year_Received'] = this.yearReceived;
    data['month_Received'] = this.monthReceived;
    data['day_Received'] = this.dayReceived;
    return data;
  }
}
