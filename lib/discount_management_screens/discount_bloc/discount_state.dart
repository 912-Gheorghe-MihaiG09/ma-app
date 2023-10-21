part of 'discount_bloc.dart';

abstract class DiscountState extends Equatable {
  final String username;
  final List<DiscountCode> codes;

  const DiscountState({required this.username, required this.codes});

  @override
  List<Object?> get props => [username, codes];
}

class DiscountInitial extends DiscountState {
  const DiscountInitial({required super.username, required super.codes});
}

class DiscountLoading extends DiscountState {
  const DiscountLoading({required super.username, required super.codes});
}

class DiscountLoaded extends DiscountState {
  const DiscountLoaded({required super.username, required super.codes});
}

class DiscountError extends DiscountState {
  final String message;
  final DiscountErrorReason reason;

  const DiscountError(
      {required super.username,
      required super.codes,
      required this.message,
      required this.reason});

  @override
  List<Object> get props => [username, message, reason];
}

enum DiscountErrorReason {
  invalidField;
}
