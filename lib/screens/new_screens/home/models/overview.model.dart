class OverviewData {
  Debt debt;
  Credit credit;

  OverviewData({required this.debt, required this.credit});

  factory OverviewData.fromJson(Map<String, dynamic> json) {
    return OverviewData(
      debt: Debt.fromJson(json['debt']),
      credit: Credit.fromJson(json['credit']),
    );
  }
}

class Debt {
  Currency naira;
  Currency rands;
  Currency dollar;
  Currency cfa;

  Debt({required this.naira, required this.rands, required this.dollar, required this.cfa});

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      naira: Currency.fromJson(json['naira']),
      rands: Currency.fromJson(json['rands']),
      dollar: Currency.fromJson(json['dollar']),
      cfa: Currency.fromJson(json['cfa']),
    );
  }
}

class Credit {
  Currency naira;
  Currency rands;
  Currency dollar;
  Currency cfa;

  Credit({required this.naira, required this.rands, required this.dollar, required this.cfa});

  factory Credit.fromJson(Map<String, dynamic> json) {
    return Credit(
      naira: Currency.fromJson(json['naira']),
      rands: Currency.fromJson(json['rands']),
      dollar: Currency.fromJson(json['dollar']),
      cfa: Currency.fromJson(json['cfa']),
    );
  }
}

class Currency {
  String all;
  String due;
  String pending;

  Currency({required this.all, required this.due, required this.pending});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      all: json['all'].toString(),
      due: json['due'].toString(),
      pending: json['pending'].toString(),
    );
  }
}
