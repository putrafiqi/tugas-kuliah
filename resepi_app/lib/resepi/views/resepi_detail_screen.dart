import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;

import '../../data/models/models.dart';

class ResepiDetailScreen extends StatelessWidget {
  final Resepi resep;

  const ResepiDetailScreen({super.key, required this.resep});

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('id', timeago.IdMessages());

    return Scaffold(
      appBar: AppBar(
        title: Text(resep.nama),
        forceMaterialTransparency: true,

      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Resep
            Image.network(
              resep.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.grey[300],
                  alignment: Alignment.center,

                  child: Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Resep
                  Text(
                    resep.nama,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Informasi Tambahan (Porsi, Created/Updated)
                  Row(
                    children: [
                      Icon(
                        Icons.people_alt_rounded,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${resep.porsi} porsi',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      Text(
                        'Dibuat: ${timeago.format(resep.createdAt, locale: 'id')}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const Divider(height: 32, thickness: 1),

                  // Deskripsi
                  Text(
                    'Deskripsi',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    resep.deskripsi,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  // Bahan-bahan
                  Text(
                    'Bahan-bahan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: resep.bahan.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Expanded(
                              child: Text(
                                resep.bahan[index],
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Langkah-langkah
                  Text(
                    'Langkah-langkah',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: resep.langkah.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}. ',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(
                                resep.langkah[index],
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
