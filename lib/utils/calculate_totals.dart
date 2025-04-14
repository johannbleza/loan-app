import 'package:loan_app/models/payment.dart';

class CalculateTotals {
  double getTotalMonthlyPayments(List<Payment> paymentsData) {
    double total = 0;
    for (var payment in paymentsData) {
      total += payment.monthlyPayment;
    }

    return total;
  }

  double getTotalInterestPaid(List<Payment> paymentsData) {
    double total = 0;
    for (var payment in paymentsData) {
      total += payment.interestPaid;
    }

    return total;
  }

  double getTotalCapitalPayments(List<Payment> paymentsData) {
    double total = 0;
    for (var payment in paymentsData) {
      total += payment.capitalPayment;
    }

    return total;
  }

  double getTotalAgentShare(List<Payment> paymentsData) {
    double total = 0;
    for (var payment in paymentsData) {
      total += payment.agentShare;
    }

    return total;
  }

  double getRemainingInterestPaid(List<Payment> paymentsData) {
    double total = 0;
    for (var payment in paymentsData) {
      if (payment.remarks == "Due" || payment.remarks == "Overdue") {
        total += payment.interestPaid;
      }
    }
    return total;
  }

  double getRemainingCapitalPayments(List<Payment> paymentsData) {
    double total = 0;
    for (var payment in paymentsData) {
      if (payment.remarks == "Due" || payment.remarks == "Overdue") {
        total += payment.capitalPayment;
      }
    }
    return total;
  }

  double getTotalAmountTaken(List<Payment> paymentsData) {
    double total = 0;
    for (var payment in paymentsData) {
      total += payment.loanAmount!;
    }

    return total;
  }

  double getTotalAmountPaid(List<Payment> paymentsData) {
    double total = 0;
    for (var payment in paymentsData) {
      if (payment.remarks == "Paid" ||
          payment.remarks == "Fully Paid" ||
          payment.remarks == "Partial (Interest)" ||
          payment.remarks == "Partial (Capital)") {
        total += payment.monthlyPayment;
      }
    }
    return total;
  }

  double getTotalAgentShareCollected(List<Payment> paymentsData) {
    double total = 0;
    for (var payment in paymentsData) {
      if (payment.remarks == "Paid" ||
          payment.remarks == "Partial (Interest)" ||
          payment.remarks == "Partial (Capital)") {
        total += payment.agentShare;
      }
    }
    return total;
  }

  double getTotalInterestPaidCollected(List<Payment> paymentsData) {
    double total = 0;
    for (var payment in paymentsData) {
      if (payment.remarks == "Paid" ||
          payment.remarks == "Partial (Interest)" ||
          payment.remarks == "Partial (Capital)") {
        total += payment.interestPaid;
      }
    }
    return total;
  }

  double getTotalCapitalPaymentsCollected(List<Payment> paymentsData) {
    double total = 0;
    for (var payment in paymentsData) {
      if (payment.remarks == "Paid" ||
          payment.remarks == "Partial (Interest)" ||
          payment.remarks == "Partial (Capital)") {
        total += payment.capitalPayment;
      }
    }
    return total;
  }
}
