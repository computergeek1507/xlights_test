class Controller {
  String? name;
  String? description;
  String? type;
  String? address;
  String? vendor;
  String? model;
  String? variant;
  String? protocol;
  int? startchannel;
  int? channels;
  bool? managed;
  bool? active;

  Controller({
    this.name,
    this.description,
    this.type,
    this.address,
    this.vendor,
    this.model,
    this.variant,
    this.protocol,
    this.startchannel,
    this.channels,
    this.managed,
    this.active,
  });

  Controller.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['desc'];
    type = json['type'];
    address = json['ip'];
    vendor= json['vendor'];
    model= json['model'];
    variant= json['variant'];
    protocol= json['protocol'];
   startchannel= json['startchannel'];
    channels= json['channels'];
    managed= json['managed'];
    active= json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ip'] = address;
    data['name'] = name;
    data['type'] = type;
    data['protocol'] = protocol;
    return data;
  }
}