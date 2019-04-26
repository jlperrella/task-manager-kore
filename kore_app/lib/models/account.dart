import 'package:kore_app/models/task.dart';

class Account {
  int id;
  String accountName;
  DateTime dateCreated;
  DateTime dateModified;
  int status;
  String description;
  int createdBy;
  int modifiedBy;
  double percentage;

  Account({
    this.id,
    this.accountName, 
    this.dateCreated,
    this.dateModified,
    this.status,
    this.description,
    this.createdBy,
    this.modifiedBy,
    this.percentage
  });

  factory Account.fromJson(Map<String, dynamic> json ) {
    return new Account(
        id: json['is'] as int,
        accountName: json['accountName'] as String,
        dateCreated: json['dateCreated'] as DateTime,
        dateModified: json['dateModified'] as DateTime,
        status: json['status'] as int,
        description: json['description'] as String,
        createdBy: json['createdBy'] as int,
        modifiedBy: json['modifiedBy'] as int,
    );
  }
}