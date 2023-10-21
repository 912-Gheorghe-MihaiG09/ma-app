import 'package:crud_project/common/validator/validator.dart';
import 'package:crud_project/common/widgets/default_button.dart';
import 'package:crud_project/common/widgets/text_input_field.dart';
import 'package:crud_project/data/domain/discount_code.dart';
import 'package:crud_project/common/theme/colors.dart';
import 'package:crud_project/discount_management_screens/discount_bloc/discount_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DiscountFormScreen extends StatefulWidget {
  final DiscountFormType type;
  final DiscountCode? code;
  DiscountFormScreen({super.key, required this.type, this.code}) {
    assert(type == DiscountFormType.add ||
        (type == DiscountFormType.update && code != null));
  }

  @override
  State<DiscountFormScreen> createState() => _DiscountFormScreenState();
}

class _DiscountFormScreenState extends State<DiscountFormScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool enableButton = false;
  bool isUsernameSet = false;

  @override
  void initState() {
    super.initState();
    if (widget.code != null) {
      _codeController.text = widget.code!.code;
      _websiteController.text = widget.code!.webSite;
      _typeController.text = widget.code!.siteType;
      _dateController.text =
          DateFormat('yyyy-MM-dd').format(widget.code!.expirationDate);
      _descriptionController.text = widget.code!.description;
      enableButton = _validateForm();
    }
    isUsernameSet =
        BlocProvider.of<DiscountBloc>(context).state.username.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiscountBloc, DiscountState>(
      listenWhen: (prev, current) =>
      prev is DiscountLoading && current is DiscountLoaded,
      listener: (context, state) => Navigator.of(context).pop(),
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Row(
            children: [
              Text(
                widget.type.getPageTitle(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
            ],
          ),
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(left: 32, right: 32, bottom: 32, top: 32),
          child: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  onChanged: () => setState(() {
                    enableButton = _validateForm();
                  }),
                  child: Column(
                    children: [
                      _section(context, Icons.numbers, "Discount code",
                          _codeController),
                      _section(context, Icons.language, "Website",
                          _websiteController),
                      _section(context, Icons.category, "Website type",
                          _typeController),
                      _section(context, Icons.calendar_month,
                          "Exp Date (yyyy-MM-dd)", _dateController,
                          validator: Validator.validateDate),
                      _section(
                        context,
                        Icons.info,
                        "Description",
                        _descriptionController,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buttonIndication(context),
            DefaultButton(
              text: widget.type.getButtonText(),
              onPressed: enableButton && isUsernameSet
                  ? () => widget.type.buttonAction(context,
                      codeId: widget.type == DiscountFormType.update
                          ? widget.code!.id.toString()
                          : null,
                      code: _codeController.text,
                      description: _descriptionController.text,
                      webSite: _websiteController.text,
                      siteType: _typeController.text,
                      expirationDate: _dateController.text)
                  : null,
              isLoading: state is DiscountLoading,
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buttonIndication(context) {
    if (enableButton && isUsernameSet) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        !enableButton
            ? "* All fields are required"
            : !isUsernameSet
                ? "Username is not set"
                : "",
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.error),
      ),
    );
  }

  Widget _section(BuildContext context, IconData icon, String text,
      TextEditingController controller,
      {int? maxLines, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextInputField(
                controller: controller,
                hintText: text,
                validator: validator ?? Validator.validateEmpty,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                maxLines: maxLines,
                fillColor: AppColors.white,
                enableSpaceKey: true,
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _validateForm() {
    return Validator.validateEmpty(_codeController.text) == null &&
        Validator.validateEmpty(_descriptionController.text) == null &&
        Validator.validateDate(_dateController.text) == null &&
        Validator.validateEmpty(_typeController.text) == null &&
        Validator.validateEmpty(_websiteController.text) == null;
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _typeController.dispose();
    _websiteController.dispose();
    _codeController.dispose();
  }
}

enum DiscountFormType {
  add,
  update;

  String getPageTitle() {
    switch (this) {
      case DiscountFormType.add:
        return "Add new code";
      case DiscountFormType.update:
        return "Update code";
    }
  }

  String getButtonText() {
    switch (this) {
      case DiscountFormType.add:
        return "Add code";
      case DiscountFormType.update:
        return "Update";
    }
  }

  void buttonAction(
    context, {
    String? codeId,
    required String code,
    required String description,
    required String webSite,
    required String siteType,
    required String expirationDate,
  }) {
    switch (this) {
      case DiscountFormType.add:
        return BlocProvider.of<DiscountBloc>(context).add(
          AddDiscount(
            code: code,
            description: description,
            webSite: webSite,
            siteType: siteType,
            expirationDate: DateTime.parse(expirationDate),
          ),
        );
      case DiscountFormType.update:
        assert(codeId != null);
        return BlocProvider.of<DiscountBloc>(context).add(
          UpdateDiscount(
            codeId: codeId!,
            code: code,
            description: description,
            webSite: webSite,
            siteType: siteType,
            expirationDate: DateTime.parse(expirationDate),
          ),
        );
    }
  }
}
