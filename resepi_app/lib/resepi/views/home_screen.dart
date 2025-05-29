import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:resepi_app/resepi/views/add_resepi_screen.dart';
import 'package:resepi_app/resepi/views/edit_resepi_screen.dart';
import 'package:resepi_app/resepi/views/search_screen.dart';
import 'package:resepi_app/resepi/views/widgets/widgets.dart';

import '../bloc/bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider.value(
                    value: context.read<ResepiBloc>(),
                    child: AddResepiScreen(),
                  ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<ResepiBloc>().add(FetchAllResepi());
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              spacing: 16,
              children: [
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider.value(
                              value: context.read<ResepiBloc>(),
                              child: SearchScreen(),
                            ),
                      ),
                    );
                  },
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Resep apa yang ingin anda cari?',
                    ),
                  ),
                ),
                BlocConsumer<ResepiBloc, ResepiState>(
                  listener: (context, state) {
                    if (state.status == ResepiStatus.error) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(state.message)));
                    } else if(state.status == ResepiStatus.success && state.message.isNotEmpty) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(state.message)));

                    }
                  },
                  builder: (context, state) {
                    if (state.status == ResepiStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final listResepi = state.resepiList;

                    if (listResepi.isEmpty) {
                      return const Center(child: Text('Tidak ada data resep'));
                    }

                    return ListView.builder(
                      itemCount: listResepi.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final resep = listResepi[index];
                        return Slidable(
                          key: ValueKey(resep.id),
                          startActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => BlocProvider.value(
                                            value: context.read<ResepiBloc>(),
                                            child: EditResepiScreen(
                                              resep: resep,
                                            ),
                                          ),
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
                                onPressed: (context) {
                                  context.read<ResepiBloc>().add(DeleteResepiEvent(resep.id));

                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Hapus',
                              ),
                            ],
                          ),
                          child: CardResepiItem(data: resep),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
