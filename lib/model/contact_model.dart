class Contact{
  String name;
  String number;
  String type;

  Contact({ required this.name, required this.number , required this.type});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['number'] = this.number;
    data['category'] = this.type;
    return data;
  }
}