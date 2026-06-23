import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_flutter/features/pagination/data/repositories/product_repository.dart';
import 'package:template_flutter/features/pagination/presentation/bloc/products_bloc.dart';
import 'package:template_flutter/features/pagination/presentation/bloc/products_events.dart';
import 'package:template_flutter/features/pagination/presentation/pages/product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: RepositoryProvider(
        create: (_) => ProductsRepository(),
        child: BlocProvider(
          create: (context) => ProductsBloc(
            repository: context.read<ProductsRepository>(),
          )..add(const ProductsFetched()), // kick off first load
          child: const ProductsScreen(),
        ),
      ),
    
    );
  }
}

