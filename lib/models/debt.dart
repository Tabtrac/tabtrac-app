class Debt {
  final String id;
  final String debtorName;
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
  final String user;

  Debt({
    required this.id,
    required this.debtorName,
    required this.status,
    required this.currency,
    required this.description,
    required this.amount,
    required this.paymentDate,
    this.depositedDate,
    this.datePaid,
    this.email,
    this.phoneNumber,
    required this.createdDate,
    required this.updatedDate,
    required this.user,
  });

  // CopyWith method for modifying individual properties
  Debt copyWith({
    String? id,
    String? debtorName,
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
    String? updatedDate,
    String? user,
  }) {
    return Debt(
      id: id ?? this.id,
      debtorName: debtorName ?? this.debtorName,
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
      user: user ?? this.user,
    );
  }

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      id: json['id'],
      debtorName: json['debtor_name'],
      status: json['status'],
      currency: json['currency'],
      description: json['description'],
      amount: json['amount'],
      paymentDate: json['payment_date'],
      depositedDate: json['deposited_date'],
      datePaid: json['date_paid'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      createdDate: json['created_date'],
      updatedDate: json['updated_date'],
      user: json['user'],
    );
  }
}
