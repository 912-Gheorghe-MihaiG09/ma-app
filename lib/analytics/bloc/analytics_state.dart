part of 'analytics_bloc.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();
}

class AnalyticsLoaded extends AnalyticsState {
  final Map<String, double> data;

  const AnalyticsLoaded(this.data);

  @override
  List<Object> get props => [];
}

class AnalyticsInitial extends AnalyticsState {
  @override
  List<Object> get props => [];
}

class AnalyticsLoading extends AnalyticsState {
  @override
  List<Object> get props => [];
}
