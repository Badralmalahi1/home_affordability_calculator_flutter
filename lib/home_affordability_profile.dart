import 'dart:convert';
import 'dart:math';

class HomeAffordabilityProfile {
  final double income;
  final double debt;
  final double downPayment;
  final String zipCode;

  HomeAffordabilityProfile({
    required this.income,
    required this.debt,
    required this.downPayment,
    required this.zipCode,
  });

  double _calculatePriceFromDTI(double dtiRatio) {
    final maxMonthlyPayment = (income * dtiRatio) - debt;
    if (maxMonthlyPayment <= 0) return 0;

    const annualInterestRate = 0.06;
    const loanTermMonths = 30 * 12;
    final monthlyRate = annualInterestRate / 12;

    final loanAmount = (maxMonthlyPayment * (pow(1 + monthlyRate, loanTermMonths) - 1)) /
        (monthlyRate * pow(1 + monthlyRate, loanTermMonths));

    return loanAmount + downPayment;
  }

  double get conservativePrice => _calculatePriceFromDTI(0.36);
  double get flexiblePrice => _calculatePriceFromDTI(0.45);

  Map<String, dynamic> toJson() => {
        'income': income,
        'debt': debt,
        'downPayment': downPayment,
        'zipCode': zipCode,
      };

  factory HomeAffordabilityProfile.fromJson(Map<String, dynamic> json) {
    return HomeAffordabilityProfile(
      income: json['income'],
      debt: json['debt'],
      downPayment: json['downPayment'],
      zipCode: json['zipCode'],
    );
  }
}
