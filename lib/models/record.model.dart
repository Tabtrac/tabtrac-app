class UserRecord {
  int id;
  String clientName;
  String? clientEmail;
  String? clientPhoneNumber;
  String status;
  String currency;
  String description;
  String amount;
  String paymentDate;
  String? datePaid;
  String createdDate;
  String updatedDate;
  int client;
  String user;

  UserRecord({
    required this.id,
    required this.clientName,
    this.clientEmail,
    this.clientPhoneNumber,
    required this.status,
    required this.currency,
    required this.description,
    required this.amount,
    required this.paymentDate,
    this.datePaid,
    required this.createdDate,
    required this.updatedDate,
    required this.client,
    required this.user,
  });

  factory UserRecord.fromJson(Map<String, dynamic> json) {
    return UserRecord(
      id: json['id'],
      clientName: json['client_name'],
      clientEmail: json['client_email'],
      clientPhoneNumber: json['client_phone_number'],
      status: json['status'],
      currency: json['currency'],
      description: json['description'],
      amount: json['amount'],
      paymentDate: json['payment_date'],
      datePaid: json['date_paid'],
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
      client: json['client'],
      user: json['user'],
    );
  }
}
