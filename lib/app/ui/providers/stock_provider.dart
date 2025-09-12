import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_stock/app/config/dependencies.dart';
import 'package:smart_stock/app/data/repositories/part_repository.dart';
import 'package:smart_stock/app/domain/entities/part_entity.dart';

part 'stock_provider.g.dart';

enum RequestStatus { idle, loading, success, error }

@immutable
class StockState {
  final List<CarPart>? parts;
  final RequestStatus reqStatus;
  final String? errorMessage;

  const StockState({this.reqStatus = RequestStatus.idle, this.parts, this.errorMessage});

  StockState copyWith({List<CarPart>? parts, RequestStatus? reqStatus, String? errorMessage}) {
    return StockState(
      parts: parts ?? this.parts,
      reqStatus: reqStatus ?? this.reqStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class Stock extends _$Stock {
  @override
  StockState build() {
    _fetchData();
    return const StockState();
  }

  Future<void> _fetchData() async {
    state = state.copyWith(reqStatus: RequestStatus.loading);
    final respository = injector.get<CarPartRepository>();
    try {
      final parts = await respository.getAllCarParts();
      state = state.copyWith(reqStatus: RequestStatus.success, parts: parts);
    } catch (e) {
      state = state.copyWith(
        reqStatus: RequestStatus.error,
        errorMessage: 'Erro ao buscar peças: $e',
      );
      print(e);
    }
  }
}
