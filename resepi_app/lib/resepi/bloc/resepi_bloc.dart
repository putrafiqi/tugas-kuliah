import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';

part 'resepi_event.dart';
part 'resepi_state.dart';

class ResepiBloc extends Bloc<ResepiEvent, ResepiState> {
  final ResepiRepository _resepiRepository;

  ResepiBloc(this._resepiRepository)
    : super(const ResepiState(status: ResepiStatus.initial)) {
    on<FetchAllResepi>((event, emit) async {
      emit(state.copyWith(status: ResepiStatus.loading));
      final result = await _resepiRepository.getAllResepi();
      result.fold(
        (failure) => emit(
          state.copyWith(status: ResepiStatus.error, message: failure.message),
        ),
        (resepiList) => emit(
          state.copyWith(status: ResepiStatus.success, resepiList: resepiList),
        ),
      );
    });

    on<AddResepiEvent>((event, emit) async {
      final result = await _resepiRepository.addResepi(
        nama: event.nama,
        deskripsi: event.deskripsi,
        imageFile: event.imageFile,
        bahan: event.bahan,
        langkah: event.langkah,
        porsi: event.porsi,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(status: ResepiStatus.error, message: failure.message),
        ),
        (success) {
          emit(state.copyWith(message: 'Resepi berhasil ditambahkan'));

          add(FetchAllResepi());
        },
      );
    });

    on<UpdateResepiEvent>((event, emit) async {
      final result = await _resepiRepository.updateResepiById(
        id: event.id,
        nama: event.nama,
        deskripsi: event.deskripsi,
        imageFile: event.imageFile,
        bahan: event.bahan,
        langkah: event.langkah,
        porsi: event.porsi,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(status: ResepiStatus.error, message: failure.message),
        ),
        (success) {
          emit(state.copyWith(message: 'Resepi berhasil diperbarui'));

          add(FetchAllResepi());
        },
      );
    });

    on<DeleteResepiEvent>((event, emit) async {
      final result = await _resepiRepository.deleteResepiById(event.id);
      result.fold(
        (failure) => emit(
          state.copyWith(status: ResepiStatus.error, message: failure.message),
        ),
        (success) {
          emit(state.copyWith(message: 'Resepi berhasil dihapus'));

          add(FetchAllResepi());
        },
      );
    });
  }
}
