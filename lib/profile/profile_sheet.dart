import 'package:crud_project/common/validator/validator.dart';
import 'package:crud_project/common/widgets/default_button.dart';
import 'package:crud_project/common/widgets/rounded_container.dart';
import 'package:crud_project/common/widgets/text_input_field.dart';
import 'package:crud_project/common/theme/colors.dart';
import 'package:crud_project/discount_management_screens/discount_bloc/discount_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSheet extends StatefulWidget {
  const ProfileSheet({super.key});

  static void showAsModalBottomSheet(BuildContext context) =>
      showModalBottomSheet(
        backgroundColor: AppColors.transparent,
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const ProfileSheet(),
        ),
      );

  @override
  State<ProfileSheet> createState() => _ProfileSheetState();
}

class _ProfileSheetState extends State<ProfileSheet> {
  final TextEditingController _controller = TextEditingController();
  bool enableButton = true;

  @override
  void initState() {
    _controller.text = BlocProvider.of<DiscountBloc>(context).state.username;
    enableButton = _controller.text.isNotEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiscountBloc, DiscountState>(
        listenWhen: (prev, current) =>
            prev is DiscountLoading && current is DiscountLoaded,
        listener: (context, state) => Navigator.of(context).pop(),
        builder: (context, state) {
          return RoundedContainer(
            height: 300,
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 32, right: 32, top: 16, bottom: 32),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.all(
                        Radius.circular(32),
                      ),
                    ),
                    width: 30,
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: TextInputField(
                              hintText: "username",
                              validator: Validator.validateEmpty,
                              controller: _controller,
                              enableSpaceKey: true,
                              onChanged: (s) {
                                if (s.isEmpty && enableButton ||
                                    s.isNotEmpty && !enableButton) {
                                  setState(() {
                                    enableButton = !enableButton;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  DefaultButton(
                    text: "Save",
                    onPressed: enableButton
                        ? () => BlocProvider.of<DiscountBloc>(context)
                            .add(UpdateUsername(_controller.text))
                        : null,
                    isLoading: state is DiscountLoading,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
