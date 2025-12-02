import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'src/features/salon/domain/customer.dart';
import 'src/features/salon/domain/transaction.dart';
import 'src/features/real_estate/domain/real_estate.dart';
import 'src/features/salon/data/salon_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [CustomerSchema, TransactionSchema, RealEstateSchema],
    directory: dir.path,
  );

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: const CoBayManagerApp(),
    ),
  );
}