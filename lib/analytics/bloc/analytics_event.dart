part of 'analytics_bloc.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();
}

class DataUpdated extends AnalyticsEvent {
  final List<DiscountCode> newList;

  const DataUpdated(this.newList);

  @override
  List<Object?> get props => [newList];
}
