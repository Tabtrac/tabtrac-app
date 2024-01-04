class Liability {
  final String id;
  final String creditorName;
  final String status;
  final String currency;
  final String description;
  final String amount;
  final String paymentDate;
  final String? depositedDate;
  final String? datePaid;
  final String? email;
  final String? phoneNumber;
  final String createdDate;
  final String updatedDate;
  final bool? offlineData;
  final String user;

  Liability({
    required this.id,
    required this.creditorName,
    required this.status,
    required this.currency,
    required this.description,
    required this.amount,
    required this.paymentDate,
    this.depositedDate,
    this.datePaid,
    this.email,
    this.phoneNumber,
    this.offlineData,
    required this.createdDate,
    required this.updatedDate,
    required this.user,
  });

  // CopyWith method for modifying individual properties
  Liability copyWith({
    String? id,
    String? creditorName,
    String? status,
    String? currency,
    String? description,
    String? amount,
    String? paymentDate,
    String? depositedDate,
    String? datePaid,
    String? email,
    String? phoneNumber,
    String? createdDate,
    bool? offlineData,
    String? updatedDate,
    String? user,
  }) {
    return Liability(
      id: id ?? this.id,
      creditorName: creditorName ?? this.creditorName,
      status: status ?? this.status,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      depositedDate: depositedDate ?? this.depositedDate,
      datePaid: datePaid ?? this.datePaid,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      offlineData: offlineData ?? this.offlineData,
      user: user ?? this.user,
    );
  }

  factory Liability.fromJson(Map<String, dynamic> json) {
    return Liability(
      id: json['id'],
      creditorName: json['creditor_name'],
      status: json['status'],
      currency: json['currency'],
      description: json['description'],
      amount: json['amount'],
      paymentDate: json['payment_date'],
      depositedDate: json['deposited_date'],
      datePaid: json['date_paid'],
      email: json['email'],
      offlineData: json['offline_data'],
      phoneNumber: json['phone_number'],
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
      user: json['user'],
    );
  }
}
