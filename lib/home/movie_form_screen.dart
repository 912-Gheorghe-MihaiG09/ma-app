import 'package:crud_project/common/validator/validator.dart';
import 'package:crud_project/common/widgets/default_button.dart';
import 'package:crud_project/common/widgets/text_input_field.dart';
import 'package:crud_project/data/domain/movie.dart';
import 'package:crud_project/common/theme/colors.dart';
import 'package:crud_project/movie_management_screen/movie_bloc/movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieFormScreen extends StatefulWidget {
  final MovieFormType type;
  final Movie? movie;

  MovieFormScreen({Key? key, required this.type, this.movie})
      : super(key: key) {
    assert(type == MovieFormType.add ||
        (type == MovieFormType.update && movie != null));
  }

  @override
  State<MovieFormScreen> createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends State<MovieFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool enableButton = false;

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      _nameController.text = widget.movie!.name;
      _categoryController.text = widget.movie!.category;
      _imageUrlController.text = widget.movie!.imageUrl;
      _linkController.text = widget.movie!.link;
      _descController.text = widget.movie!.desc;
      enableButton = _validateForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieBloc, MovieState>(
      listenWhen: (prev, current) =>
      prev is MovieLoading && current is MovieLoaded,
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
                      _section(context, Icons.title, "Movie Name",
                          _nameController),
                      _section(context, Icons.category, "Category",
                          _categoryController),
                      _section(context, Icons.image, "Image URL",
                          _imageUrlController),
                      _section(context, Icons.link, "Link", _linkController),
                      _section(context, Icons.info, "Description",
                          _descController, maxLines: 3),
                    ],
                  ),
                ),
              ),
            ),
            _buttonIndication(context),
            DefaultButton(
              text: widget.type.getButtonText(),
              onPressed: enableButton
                  ? () => widget.type.buttonAction(
                context,
                name: _nameController.text,
                category: _categoryController.text,
                imageUrl: _imageUrlController.text,
                link: _linkController.text,
                desc: _descController.text,
              )
                  : null,
              isLoading: state is MovieLoading,
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buttonIndication(context) {
    if (enableButton) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        "* All fields are required",
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
    return Validator.validateEmpty(_nameController.text) == null &&
        Validator.validateEmpty(_categoryController.text) == null &&
        Validator.validateEmpty(_imageUrlController.text) == null &&
        Validator.validateEmpty(_linkController.text) == null &&
        Validator.validateEmpty(_descController.text) == null;
  }

  @override
  void dispose() {
    super.dispose();
    _descController.dispose();
    _linkController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    _nameController.dispose();
  }
}

enum MovieFormType {
  add,
  update;

  String getPageTitle() {
    switch (this) {
      case MovieFormType.add:
        return "Add new movie";
      case MovieFormType.update:
        return "Update movie";
    }
  }

  String getButtonText() {
    switch (this) {
      case MovieFormType.add:
        return "Add movie";
      case MovieFormType.update:
        return "Update";
    }
  }

  void buttonAction(
      context, {
        required String name,
        required String category,
        required String imageUrl,
        required String link,
        required String desc,
      }) {
    switch (this) {
      case MovieFormType.add:
        return BlocProvider.of<MovieBloc>(context).add(
          AddMovie(
            name: name,
            category: category,
            imageUrl: imageUrl,
            link: link,
            desc: desc,
          ),
        );
      case MovieFormType.update:
        return BlocProvider.of<MovieBloc>(context).add(
          UpdateMovie(
            name: name,
            category: category,
            imageUrl: imageUrl,
            link: link,
            desc: desc,
          ),
        );
    }
  }
}
