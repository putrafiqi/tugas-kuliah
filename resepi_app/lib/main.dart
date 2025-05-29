import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

import 'data/data_sources/data_sources.dart';
import 'data/repositories/resepi_repository.dart';
import 'resepi/bloc/bloc.dart';
import 'resepi/views/views.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timeago.setLocaleMessages('id', timeago.IdMessages());
  await dotenv.load(fileName: ".env");
  final supabase = await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey:
    dotenv.get('SUPABASE_ANON_KEY'),
  );
  runApp(MyApp(supabaseClient: supabase.client));
}

class MyApp extends StatelessWidget {
  final SupabaseClient supabaseClient;
  const MyApp({super.key, required this.supabaseClient});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Resepi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: RepositoryProvider<ResepiRepository>(
        create:
            (context) => ResepiRepositoryImpl(
              remoteDataSource: ResepiRemoteDataSourceImpl(http.Client()),
              imageRemoteDataSource: SupabaseImageRemoteDataSourceImpl(
                supabaseClient,
              ),
            ),
        child: BlocProvider(
          create:
              (context) =>
                  ResepiBloc(context.read<ResepiRepository>())
                    ..add(FetchAllResepi()),
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
