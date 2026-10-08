import '../models/fee_model.dart';

abstract class FeeRepository {
  Future<FeeModel?> getFeeByStudentId(String studentId);
  Future<void> updateFeeStatus(FeeModel fee);
}
