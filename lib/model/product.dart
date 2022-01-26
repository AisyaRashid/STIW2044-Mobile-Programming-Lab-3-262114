class Product {
  String? prid;
  String? prname;
  String? prprice;
  String? prdesc;
  


  Product(
      {required this.prid,
      required this.prname,
      required this.prprice,
      required this.prdesc,
 });

  Product.fromJson(Map<String, dynamic> json) {
    prid = json['prid'];
    prname = json['prname'];
    prprice = json['prprice'];
    prdesc = json['prdesc'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prid'] = prid;
    data['prname'] = prname;
    data['prprice'] = prprice;
    data['prdesc'] = prdesc;
    

    return data;
  }
}