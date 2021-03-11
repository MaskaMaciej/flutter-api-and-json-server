import 'package:api_and_json_server/screens/home/widgets/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api_and_json_server/screens/form/bloc/form_bloc.dart';

class FormView extends StatefulWidget {
  final int id;
  final String name;

  FormView({this.id, this.name});

  @override
  _FormViewState createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  static final RegExp _lettersOnly =
      RegExp(r'^([a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ]+\s)*[a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ]+$');
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameTextController;
  double _formProgress = 0;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController(text: widget.name);
  }

  void _updateFormProgress() {
    var progress = 0.0;

    if (_nameTextController.value.text.length == 0) {
      progress = 0.0;
    } else if (_nameTextController.value.text.length == 1) {
      progress = 0.33;
    } else if (_nameTextController.value.text.length == 2) {
      progress = 0.66;
    } else if (_nameTextController.value.text.length == 3) {
      progress = 1.0;
    } else if (_nameTextController.value.text.length > 3) {
      progress = 1.0;
    }

    setState(() {
      _formProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name == null ? "Enter new name" : "Update name"),
      ),
      body: BlocBuilder<FormBloc, FormPageState>(
        builder: (context, state) {
          if (state is FormErrorState) {
            return ErrorScreen(error: state.error.toString());
          } else if (state is FormEditState) {
            return Form(
              key: _formKey,
              onChanged: _updateFormProgress,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: _formProgress,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (!_lettersOnly.hasMatch(value)) {
                            return 'New name must only contains letters.';
                          }
                          return null;
                        },
                        autofocus: true,
                        controller: _nameTextController,
                        decoration: InputDecoration(
                            hintText: 'Enter new name', labelText: 'New name'),
                      ),
                    ),
                    ElevatedButton(
                      child: Text(widget.name == null
                          ? "Enter new name"
                          : "Update name"),
                      onPressed: _nameTextController.value.text.length > 2
                          ? () async {
                              if (_formKey.currentState.validate()) {
                                widget.id == null
                                    ? context.read<FormBloc>().add(
                                        FormInsertUserEvent(
                                            id: state.id,
                                            name:
                                                _nameTextController.value.text))
                                    : context.read<FormBloc>().add(
                                        FormUpdateNameEvent(
                                            id: widget.id,
                                            name: _nameTextController
                                                .value.text));
                                Navigator.of(context).pop();
                                setState(() {
                                  _nameTextController.clear();
                                });
                              }
                            }
                          : null,
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
