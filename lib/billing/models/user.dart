class UserModel {
  final int sid;
  final String contactName;
  final String phone;
  final String email;
  final int businessOwnerSid;
  final String businessOwnerName;

  UserModel({
    this.sid,
    this.contactName,
    this.phone,
    this.email,
    this.businessOwnerSid,
    this.businessOwnerName,
  });

  UserModel.fromJson(Map json)
      : sid = json['Sid'],
        contactName = json['ContactName'],
        phone = json['Phone'],
        email = json['Email'],
        businessOwnerSid = json['BusinessOwnerSid'],
        businessOwnerName = json['BusinessOwnerName'];
}
