import 'package:loan_app/database/agent_crud.dart';
import 'package:loan_app/database/balanceSheet_crud.dart';
import 'package:loan_app/database/client_crud.dart';
import 'package:loan_app/database/partial_crud.dart';
import 'package:loan_app/database/payment_crud.dart';

// Global instance of AgentCrud
final AgentCrud agentCrud = AgentCrud();
final ClientCrud clientCrud = ClientCrud();
final PaymentCrud paymentCrud = PaymentCrud();
final PartialCrud partialCrud = PartialCrud();
final BalanceSheetCrud balanceSheetCrud = BalanceSheetCrud();
