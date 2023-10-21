import 'package:crud_project/common/widgets/default_button.dart';
import 'package:crud_project/common/widgets/rounded_container.dart';
import 'package:crud_project/data/domain/discount_code.dart';
import 'package:crud_project/common/theme/colors.dart';
import 'package:crud_project/discount_management_screens/discount_bloc/discount_bloc.dart';
import 'package:crud_project/discount_management_screens/discount_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DiscountScreen extends StatelessWidget {
  final DiscountCode discountCode;
  const DiscountScreen({super.key, required this.discountCode});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiscountBloc, DiscountState>(
      listenWhen: (prev, current) =>
          prev is DiscountLoading && current is DiscountLoaded,
      listener: (context, state) => Navigator.of(context).pop(),
      builder: (context, state) {
        bool isCreator = state.username == discountCode.creator;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  discountCode.code,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () => _showDiscountInfo(context),
                    child: const Icon(Icons.info),
                  ),
                ),
              ],
            ),
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          body: Padding(
            padding:
                const EdgeInsets.only(left: 32, right: 32, bottom: 64, top: 32),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _section(context, Icons.language, discountCode.webSite),
                        const Divider(
                          endIndent: 1,
                          indent: 1,
                          thickness: 1,
                        ),
                        _section(
                            context, Icons.category, discountCode.siteType),
                        const Divider(
                          endIndent: 1,
                          indent: 1,
                          thickness: 1,
                        ),
                        _section(context, Icons.person, discountCode.creator),
                        const Divider(
                          endIndent: 1,
                          indent: 1,
                          thickness: 1,
                        ),
                        _section(
                            context,
                            Icons.calendar_month,
                            DateFormat('yyyy/MM/dd')
                                .format(discountCode.expirationDate)),
                        const Divider(
                          endIndent: 1,
                          indent: 1,
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                if(state.username.isEmpty) _buttonIndication(context, "Username not set!") else
                if(!isCreator) _buttonIndication(context, "You are not the creator of this discount code"),
                DefaultButton(
                  text: "Update",
                  onPressed: isCreator ? () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DiscountFormScreen(
                        type: DiscountFormType.update,
                        code: discountCode,
                      ),
                    ),
                  ) : null,
                ),
                DefaultButton(
                  text: "Delete",
                  onPressed: isCreator ? () => BlocProvider.of<DiscountBloc>(context).add(
                    DeleteDiscount(discountCode),
                  ) : null,
                  isLoading: state is DiscountLoading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buttonIndication(context, text){
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.error),
      ),
    );
  }

  Widget _section(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDiscountInfo(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: AppColors.transparent,
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return draggableDiscountInfo();
        });
  }

  Widget draggableDiscountInfo() {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.3,
      maxChildSize: 1,
      builder: (context, controller) => RoundedContainer(
        color: AppColors.white,
        child: SingleChildScrollView(
          controller: controller,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.all(Radius.circular(32))),
                  width: 30,
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    "Unlock exclusive savings with our discount code! Use code 'SAVE20' at checkout to enjoy a 20% discount on your entire order. Whether you're shopping for clothing, electronics, or home goods, this code is your ticket to significant savings. Don't miss out on this limited-time offer to shop your favorite products at a discounted price. Hurry, grab your deals now!",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
