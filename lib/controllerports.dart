class ControllerPorts {
  List<Port>? pixelports;
  List<Port>? serialports;
  List<Port>? virtualmatrixports;
  List<Port>? ledpanelmatrixports;

  ControllerPorts(
      {this.pixelports,
      this.serialports,
      this.virtualmatrixports,
      this.ledpanelmatrixports});

  ControllerPorts.fromJson(Map<String, dynamic> json) {
    if (json['pixelports'] != null) {
      pixelports = <Port>[];
      json['pixelports'].forEach((v) {
        pixelports!.add(Port.fromJson(v));
      });
    }
    if (json['serialports'] != null) {
      serialports = <Port>[];
      json['serialports'].forEach((v) {
        serialports!.add(Port.fromJson(v));
      });
    }
    if (json['virtualmatrixports'] != null) {
      virtualmatrixports = <Port>[];
      json['virtualmatrixports'].forEach((v) {
        virtualmatrixports!.add(Port.fromJson(v));
      });
    }
    if (json['ledpanelmatrixports'] != null) {
      ledpanelmatrixports = <Port>[];
      json['ledpanelmatrixports'].forEach((v) {
        ledpanelmatrixports!.add(Port.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pixelports != null) {
      data['pixelports'] = pixelports!.map((v) => v.toJson()).toList();
    }
    if (this.serialports != null) {
      data['serialports'] = serialports!.map((v) => v.toJson()).toList();
    }
    if (this.virtualmatrixports != null) {
      data['virtualmatrixports'] =
          virtualmatrixports!.map((v) => v.toJson()).toList();
    }
    if (this.ledpanelmatrixports != null) {
      data['ledpanelmatrixports'] =
          ledpanelmatrixports!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Port {
  int? port;
  int? startchannel;
  int? universe;
  int? universestartchannel;
  int? channels;
  int? pixels;
  List<Models>? models;

  Port(
      {this.port,
      this.startchannel,
      this.universe,
      this.universestartchannel,
      this.channels,
      this.pixels,
      this.models});

  Port.fromJson(Map<String, dynamic> json) {
    port = json['port'];
    startchannel = json['startchannel'];
    universe = json['universe'];
    universestartchannel = json['universestartchannel'];
    channels = json['channels'];
    pixels = json['pixels'];
    if (json['models'] != null) {
      models = <Models>[];
      json['models'].forEach((v) {
        models!.add(Models.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['port'] = port;
    data['startchannel'] = startchannel;
    data['universe'] = universe;
    data['universestartchannel'] = universestartchannel;
    data['channels'] = channels;
    data['pixels'] = pixels;
    if (models != null) {
      data['models'] = models!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Models {
  String? name;
  String? description;
  String? smartremote;
  int? startchannel;
  int? universe;
  int? universestartchannel;
  int? channels;
  int? pixels;

  Models(
      {this.name,
      this.description,
      this.smartremote,
      this.startchannel,
      this.universe,
      this.universestartchannel,
      this.channels,
      this.pixels});

  Models.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
        smartremote = json['smartremote'];
    startchannel = json['startchannel'];
    universe = json['universe'];
    universestartchannel = json['universestartchannel'];
    channels = json['channels'];
    pixels = json['pixels'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['smartremote'] = this.smartremote;
    data['startchannel'] = this.startchannel;
    data['universe'] = this.universe;
    data['universestartchannel'] = this.universestartchannel;
    data['channels'] = this.channels;
    data['pixels'] = this.pixels;
    return data;
  }
}