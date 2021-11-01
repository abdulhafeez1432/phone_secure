class AllPhoneResponseModel {
  final int id;
  final Brand brand;
  final String name;

  AllPhoneResponseModel({required this.id, required this.brand, required this.name});

 factory AllPhoneResponseModel.fromJson(Map<String, dynamic> json) {
   return AllPhoneResponseModel(
    id : json['id'] as int,
    brand : Brand.fromJson(json['brand']),
    name : json['name'] as String
   );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.brand != null) {
      data['brand'] = this.brand.toJson();
    }
    data['name'] = this.name;
    return data;
  }
}

class Brand {
  final int id;
  final String name;

  Brand({required this.id, required this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
    id :  json['id'] as int,
    name : json['name'] as String
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}