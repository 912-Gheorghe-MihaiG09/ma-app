import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crud_project/data/domain/discount_code.dart';
import 'package:crud_project/discount_management_screens/discount_bloc/discount_bloc.dart';
import 'package:equatable/equatable.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final DiscountBloc _discountBloc;
  late StreamSubscription<DiscountState> deviceListSubscription;

  AnalyticsBloc(this._discountBloc) : super(AnalyticsInitial()) {
    on<DataUpdated>(_onDataUpdated);
    print("called");
    if(_discountBloc.state is DiscountLoaded){
      add(DataUpdated(_discountBloc.state.codes));
    }
    deviceListSubscription = _discountBloc.stream.asBroadcastStream().listen((event) {
      print("called");
      if(event is DiscountLoaded) {
        add(DataUpdated(event.codes));
      }
    });
  }

  FutureOr<void> _onDataUpdated(DataUpdated event, Emitter<AnalyticsState> emit) {
    Map<String, double> data = {};
    for(DiscountCode discount in event.newList){
      if (data.containsKey(discount.creator)) {
        data[discount.creator] = data[discount.creator]! + 1;
      } else {
        data[discount.creator] = 1;
      }
    }
    emit(AnalyticsLoaded(data));
  }
}
