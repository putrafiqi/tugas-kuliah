part of 'resepi_bloc.dart';

sealed class ResepiEvent extends Equatable {
  const ResepiEvent();

  @override
  List<Object> get props => [];
}

class FetchAllResepi extends ResepiEvent {
  const FetchAllResepi();
}

class FetchResepiById extends ResepiEvent {
  final int id;
  const FetchResepiById(this.id);

  @override
  List<Object> get props => [id];
}

class AddResepiEvent extends ResepiEvent {
  final String nama;
  final String deskripsi;
  final File imageFile;
  final List<String> bahan;
  final List<String> langkah;
  final int porsi;

  const AddResepiEvent({
    required this.nama,
    required this.deskripsi,
    required this.imageFile,
    required this.bahan,
    required this.langkah,
    required this.porsi,
  });

  @override
  List<Object> get props => [nama, deskripsi, imageFile, bahan, langkah, porsi];
}

class UpdateResepiEvent extends ResepiEvent {
  final int id;
  final String nama;
  final String deskripsi;
  final File imageFile;
  final List<String> bahan;
  final List<String> langkah;
  final int porsi;

  const UpdateResepiEvent({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.imageFile,
    required this.bahan,
    required this.langkah,
    required this.porsi,
  });

  @override
  List<Object> get props => [
    id,
    nama,
    deskripsi,
    imageFile,
    bahan,
    langkah,
    porsi,
  ];
}

class DeleteResepiEvent extends ResepiEvent {
  final int id;
  const DeleteResepiEvent(this.id);

  @override
  List<Object> get props => [id];
}
