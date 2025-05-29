import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resepi_app/resepi/bloc/bloc.dart';
import 'package:resepi_app/resepi/views/resepi_detail_screen.dart';

import '../../../data/models/models.dart';
import 'package:timeago/timeago.dart' as timeago;

class CardResepiItem extends StatelessWidget {
  final Resepi data;

  const CardResepiItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                BlocProvider.value(
                  value: context.read<ResepiBloc>(),
                  child: ResepiDetailScreen(resep: data),
                ),
          ),
        );
      },
      child: Card.outlined(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150.0,
              width: double.infinity,
              color: Colors.grey[300],
              child: Image.network(
                data.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context,
                    Widget child,
                    ImageChunkEvent? loadingProgress,) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/image-broke.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.nama,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),

                  Text(
                    timeago.format(data.createdAt, locale: 'id'),
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
