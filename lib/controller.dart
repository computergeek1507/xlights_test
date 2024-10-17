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
  bool? autolayout;
  bool? active;

  bool? canvisualise;
  Controllercap? controllercap;

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
    this.autolayout,
    this.managed,
    this.canvisualise,
    this.active,
    this.controllercap
    });

  Controller.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['desc'];
    type = json['type'];
    address = json['ip'];
    vendor = json['vendor'];
    model = json['model'];
    variant = json['variant'];
    protocol = json['protocol'];
    startchannel = json['startchannel'];
    channels = json['channels'];
    autolayout = json['autolayout'];
    managed = json['managed'];
    active = json['active'];
    canvisualise = json['canvisualise'];
    controllercap = json['controllercap'] != null
        ? new Controllercap.fromJson(json['controllercap'])
        : null;
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

class Controllercap {
  int? pixelports;
  int? serialports;
  bool? supportspanels;
  bool? supportsvirtualmatrix;
  int? smartremotecount;
  List<String>? smartremotetypes;
  List<String>? pixelprotocols;
  List<String>? serialprotocols;

  Controllercap(
      {this.pixelports,
      this.serialports,
      this.supportspanels,
      this.supportsvirtualmatrix,
      this.smartremotecount,
      this.smartremotetypes,
      this.pixelprotocols,
      this.serialprotocols});

  Controllercap.fromJson(Map<String, dynamic> json) {
    pixelports = json['pixelports'];
    serialports = json['serialports'];
    supportspanels = json['supportspanels'];
    supportsvirtualmatrix = json['supportsvirtualmatrix'];
    smartremotecount = json['smartremotecount'];
    smartremotetypes = json['smartremotetypes'].cast<String>();
    pixelprotocols = json['pixelprotocols'].cast<String>();
    serialprotocols = json['serialprotocols'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pixelports'] = this.pixelports;
    data['serialports'] = this.serialports;
    data['supportspanels'] = this.supportspanels;
    data['supportsvirtualmatrix'] = this.supportsvirtualmatrix;
    data['smartremotecount'] = this.smartremotecount;
    data['smartremotetypes'] = this.smartremotetypes;
    data['pixelprotocols'] = this.pixelprotocols;
    data['serialprotocols'] = this.serialprotocols;
    return data;
  }
  }