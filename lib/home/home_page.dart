import 'package:crud_project/common/theme/colors.dart';
import 'package:crud_project/data/domain/discount_code.dart';
import 'package:crud_project/discount_management_screens/discount_bloc/discount_bloc.dart';
import 'package:crud_project/discount_management_screens/discount_form_screen.dart';
import 'package:crud_project/home/discount_code_tile.dart';
import 'package:crud_project/profile/profile_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<DiscountCode> codes;
  @override
  void initState() {
    codes = DiscountCode.getPopulation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Row(
            children: [
              const Text("Discount Manager"),
              const Spacer(),
              GestureDetector(
                onTap: () => ProfileSheet.showAsModalBottomSheet(context),
                child: const Icon(Icons.person),
              )
            ],
          ),
        ),
        body: BlocBuilder<DiscountBloc, DiscountState>(
          builder: (context, state) {
            if(state is! DiscountLoaded){
              return const Center(child: CircularProgressIndicator(),);
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Stack(
                children: [
                  ListView.separated(
                    itemCount: state.codes.length,
                    itemBuilder: (context, index) {
                      return DiscountCodeTile(
                        code: state.codes[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        indent: 1,
                        endIndent: 1,
                        thickness: 1,
                      );
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _addButton(),
                            ]),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
    );
  }

  Widget _addButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DiscountFormScreen(
            type: DiscountFormType.add,
          ),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
            color: AppColors.primary, shape: BoxShape.circle),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
