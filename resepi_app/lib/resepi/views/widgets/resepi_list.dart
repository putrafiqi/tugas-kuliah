import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../data/models/models.dart';
import '../../bloc/bloc.dart';
import '../edit_resepi_screen.dart';
import 'card_resepi_item.dart';

class ResepiList extends StatelessWidget {
  const ResepiList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResepiBloc, ResepiState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.message != current.message,
      listener: (context, state) {
        if (state.status == ResepiStatus.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state.status == ResepiStatus.success && state.message.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar( SnackBar(content: Text(state.message)));
          // Tetap tidak memanggil FetchAllResepi() di sini,
          // biarkan layar parent yang mengelola refresh jika diperlukan.
        }
      },
      builder: (context, state) {
        if (state.status == ResepiStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = state.resepiList;
        if (data.isEmpty) {
          return const Center(child: Text('Tidak Ada Data Resepi'));
        }
        return ListView.builder(
          shrinkWrap: true, // Biarkan ini jika ResepiList adalah bagian dari SingleChildScrollView
          physics: const NeverScrollableScrollPhysics(), // Biarkan ini juga
          itemCount: data.length,
          itemBuilder: (context, index) {
            final resepi = data[index];
            return Slidable(
              key: ValueKey(resepi.id),
              startActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (BuildContext slidableContext) { // Gunakan slidableContext di sini
                      Navigator.push(
                        slidableContext, // Gunakan slidableContext atau context dari build method
                        MaterialPageRoute(
                          builder: (context) => EditResepiScreen(resep: resepi),
                        ),
                      );
                    },
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const BehindMotion(),
                children: [
                  SlidableAction(
                    onPressed: (BuildContext slidableContext) { // Gunakan slidableContext di sini
                      // Panggil dialog dengan context dari _ResepiListState (yang lebih stabil)
                      _showDeleteConfirmationDialog(slidableContext, resepi);
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Hapus',
                  ),
                ],
              ),
              child: CardResepiItem(data: resepi),
            );
          },
        );
      },
    );
  }

  // Penting: _showDeleteConfirmationDialog harus menerima `context` dari widget yang memanggilnya.
  // Dalam kasus ini, itu adalah `context` dari `build` method ResepiList atau `slidableContext`.
  void _showDeleteConfirmationDialog(BuildContext parentContext, Resepi resep) {
    showDialog(
      context: parentContext, // Gunakan parentContext untuk dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Resep?'),
          content: Text('Apakah Anda yakin ingin menghapus resep "${resep.nama}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Panggil event BLoC menggunakan parentContext (lebih stabil)
                // Ini dilakukan SEBELUM dialog di-pop
                parentContext.read<ResepiBloc>().add(DeleteResepiEvent(resep.id));

                // Tutup dialog setelah BLoC event dipicu
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
