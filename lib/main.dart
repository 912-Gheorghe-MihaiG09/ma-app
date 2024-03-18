import 'package:crud_project/analytics/bloc/analytics_bloc.dart';
import 'package:crud_project/common/theme/theme_builder.dart';
import 'package:crud_project/data/repository/discount_code_repository.dart';
import 'package:crud_project/data/repository/discount_code_repository_impl.dart';
import 'package:crud_project/data/repository/discount_code_repository_local.dart';
import 'package:crud_project/discount_management_screens/discount_bloc/discount_bloc.dart';
import 'package:crud_project/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DiscountCodeRepository _discountCodeRepository =
      DiscountCodeRepositoryImpl();

  final DiscountCodeRepository _discountCodeRepositoryLocal =
      DiscountCodeRepositoryLocal();

  MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    var discountBloc = DiscountBloc(_discountCodeRepository);
    return RepositoryProvider(
      create: (_) => _discountCodeRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => discountBloc
              ..add(
                const FetchDiscountCodes(),
              ),
          ),
          BlocProvider(
            create: (_) =>
                AnalyticsBloc(discountBloc),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeBuilder.getThemeData(),
          home: const HomePage(),
        ),
      ),
    );
  }
}
