import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crud_project/data/domain/discount_code.dart';
import 'package:crud_project/data/domain/discount_code_create_request.dart';
import 'package:crud_project/data/repository/discount_code_repository.dart';
import 'package:crud_project/data/repository/discount_code_repository_remote.dart';
import 'package:crud_project/network/network_bloc.dart';
import 'package:equatable/equatable.dart';

part 'discount_event.dart';
part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final DiscountCodeRepository _discountCodeRepository;
  final NetworkBloc _networkBloc;

  DiscountBloc(this._discountCodeRepository, this._networkBloc)
      : super(const DiscountInitial(username: "", codes: [])) {
    on<AddDiscount>(_onAddDiscountCode);
    on<UpdateDiscount>(_onUpdateDiscountCode);
    on<DeleteDiscount>(_onDeleteDiscountCode);
    on<FetchDiscountCodes>(_onFetchDiscountCodes);
    on<UpdateUsername>(_onUpdateUsername);
    on<SyncDiscounts>(_onSyncDiscounts);
    _networkBloc.stream.asBroadcastStream().listen((networkState) async{
      if(networkState is NetworkSuccess){
        if(_discountCodeRepository is DiscountCodeRepositoryRemote){
          add(SyncDiscounts());
        }
      }
    });
  }

  FutureOr<void> _onSyncDiscounts(SyncDiscounts event, Emitter<DiscountState> emit) async{
    emit(DiscountLoading(username: state.username, codes: state.codes));
    await (_discountCodeRepository as DiscountCodeRepositoryRemote).syncServer();

    add(const FetchDiscountCodes());
  }

  FutureOr<void> _onAddDiscountCode(
      AddDiscount event, Emitter<DiscountState> emit) async {
    emit(DiscountLoading(username: state.username, codes: state.codes));
    await _discountCodeRepository.databaseInitialized.future;

    await _discountCodeRepository.addDiscount(
      DiscountCodeCreateRequest(
          code: event.code,
          description: event.description,
          webSite: event.webSite,
          siteType: event.siteType,
          expirationDate: event.expirationDate,
          creator: state.username),
    );

    var newList = await _discountCodeRepository.getDiscounts();

    emit(DiscountLoaded(username: state.username, codes: newList));
  }

  FutureOr<void> _onUpdateDiscountCode(
      UpdateDiscount event, Emitter<DiscountState> emit) async {
    emit(DiscountLoading(username: state.username, codes: state.codes));
    await _discountCodeRepository.databaseInitialized.future;

    await _discountCodeRepository.updateDiscount(DiscountCode(
        id: int.parse(event.codeId),
        code: event.code,
        description: event.description,
        webSite: event.webSite,
        siteType: event.siteType,
        expirationDate: event.expirationDate,
        creator: state.username));

    var newList = await _discountCodeRepository.getDiscounts();

    emit(DiscountLoaded(username: state.username, codes: newList));
  }

  Future<FutureOr<void>> _onDeleteDiscountCode(
      DeleteDiscount event, Emitter<DiscountState> emit) async {
    emit(DiscountLoading(username: state.username, codes: state.codes));
    await _discountCodeRepository.databaseInitialized.future;

    await _discountCodeRepository.deleteDiscount(event.discountCode);

    var newList = await _discountCodeRepository.getDiscounts();

    emit(DiscountLoaded(username: state.username, codes: newList));
  }

  FutureOr<void> _onFetchDiscountCodes(
      FetchDiscountCodes event, Emitter<DiscountState> emit) async {
    emit(DiscountLoading(username: state.username, codes: state.codes));
    await _discountCodeRepository.databaseInitialized.future;


    var newList = await _discountCodeRepository.getDiscounts();

    emit(DiscountLoaded(username: state.username, codes: newList));
  }

  FutureOr<void> _onUpdateUsername(
      UpdateUsername event, Emitter<DiscountState> emit) {
    emit(DiscountLoading(username: state.username, codes: state.codes));
    emit(DiscountLoaded(username: event.username, codes: state.codes));
  }
}
