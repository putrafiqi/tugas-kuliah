part of 'resepi_bloc.dart';

enum ResepiStatus { initial, loading, success, error }

class ResepiState extends Equatable {
  final ResepiStatus status;
  final List<Resepi> resepiList;
  final String message;

  const ResepiState({
    this.status = ResepiStatus.initial,
    this.resepiList = const [],
    this.message = '',
  });

  ResepiState copyWith({
    ResepiStatus? status,
    List<Resepi>? resepiList,
    String? message,
  }) {
    return ResepiState(
      status: status ?? this.status,
      resepiList: resepiList ?? this.resepiList,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, resepiList, message];
}
