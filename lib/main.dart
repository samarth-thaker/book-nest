import 'package:booknest/models/bookModel.dart';
import 'package:booknest/models/lentBookModel.dart';
import 'package:booknest/providers/bookProvider.dart';
import 'package:booknest/onboarding/onboarding.dart';
import 'package:booknest/providers/lendingProvider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BookAdapter());
  Hive.registerAdapter(BookStatusAdapter()); // Did not addd this.
  await Hive.openBox<Book>('books');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => LendingProvider()..loadLentBooksFromHive()),
        ChangeNotifierProvider(
            create: (_) => BookProvider()..loadBooksFromHive()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Onboarding(),
    );
  }
}
