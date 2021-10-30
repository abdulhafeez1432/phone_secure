class PhoneDetail {
  int? id;
  Phone? phone;
  String? color;
  Store? store;
  String? imei;
  String? receipt;
  String? meansOfId;
  String? bvn;

  PhoneDetail(
      {
        required this.id,
        required this.phone,
        required this.color,
        required this.store,
        required this.imei,
        required this.receipt,
        required this.meansOfId,
        required this.bvn
      });





  PhoneDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = (json['phone'] != null ? new Phone.fromJson(json['phone']) : null)!;
    color = json['color'];
    store = (json['store'] != null ? new Store.fromJson(json['store']) : null)!;
    imei = json['imei'];
    receipt = json['receipt'];
    meansOfId = json['means_of_id'];
    bvn = json['bvn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.phone != null) {
      data['phone'] = this.phone!.toJson();
    }
    data['color'] = this.color;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    data['imei'] = this.imei;
    data['receipt'] = this.receipt;
    data['means_of_id'] = this.meansOfId;
    data['bvn'] = this.bvn;
    return data;
  }
}

class Phone {
  int? id;
  Brand? brand;
  String? name;

  Phone({required this.id, required this.brand, required this.name});

  Phone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brand = (json['brand'] != null ? new Brand.fromJson(json['brand']) : null)!;
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.brand != null) {
      data['brand'] = this.brand!.toJson();
    }
    data['name'] = this.name;
    return data;
  }
}

class Brand {
  int? id;
  String? name;

  Brand({required this.id, required this.name});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Store {
  String? name;
  String? address;

  Store({required this.name, required this.address});

  Store.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    return data;
  }
}


