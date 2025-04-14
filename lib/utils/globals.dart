import 'package:loan_app/database/agent_crud.dart';
import 'package:loan_app/database/balanceSheet_crud.dart';
import 'package:loan_app/database/client_crud.dart';
import 'package:loan_app/database/payment_crud.dart';
import 'package:loan_app/utils/calculate_totals.dart';

// Global instance of AgentCrud
final AgentCrud agentCrud = AgentCrud();
final ClientCrud clientCrud = ClientCrud();
final PaymentCrud paymentCrud = PaymentCrud();
final BalanceSheetCrud balanceSheetCrud = BalanceSheetCrud();
final CalculateTotals calculateTotals = CalculateTotals();
