import 'package:crud_project/common/theme/colors.dart';
import 'package:crud_project/data/domain/discount_code.dart';
import 'package:crud_project/discount_management_screens/discount_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiscountCodeTile extends StatelessWidget {
  final DiscountCode code;
  const DiscountCodeTile({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DiscountScreen(discountCode: code),
              ),
            ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                code.code,
                                style: Theme.of(context).textTheme.titleLarge,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded)
                          ],
                        ),
                        _subtitle(context, code.webSite),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if(code.expirationDate.isBefore(DateTime.now())) Container(
              color: AppColors.red.withOpacity(0.4),
              padding: const EdgeInsets.all(16),
              child: Row(

                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(child: Text(
                                "Expired",
                                style: Theme.of(context).textTheme.titleLarge,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),),
                            ),
                          ],
                        ),
                        _subtitle(context, DateFormat('yyyy/MM/dd')
                            .format(code.expirationDate)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),);
  }

  Widget _subtitle(BuildContext context, String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.secondary,
            ),
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}
