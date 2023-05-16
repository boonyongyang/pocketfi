import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HelpCenterForm extends StatefulHookConsumerWidget {
  const HelpCenterForm({super.key});

  @override
  HelpCenterFormState createState() => HelpCenterFormState();
}

class HelpCenterFormState extends ConsumerState<HelpCenterForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = useTextEditingController();
    final TextEditingController emailController = useTextEditingController();
    final TextEditingController messageController = useTextEditingController();
    final isSaveButtonEnabled = useState(false);

    useEffect(
      () {
        void listener() =>
            isSaveButtonEnabled.value = nameController.text.isNotEmpty &&
                emailController.text.isNotEmpty &&
                messageController.text.isNotEmpty;
        nameController.addListener(listener);
        emailController.addListener(listener);
        messageController.addListener(listener);
        return () {
          nameController.removeListener(listener);
          emailController.removeListener(listener);
          messageController.removeListener(listener);
        };
      },
      [nameController, emailController, messageController],
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Help Center'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // a form field for the name of the user submitting the form (required)
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  } else {
                    final RegExp nameExp = RegExp(r'^[a-zA-Z ]+$');
                    if (!nameExp.hasMatch(value)) {
                      return 'Please enter a valid name';
                    }
                  }
                  return null;
                },
              ),
              // a form field for the email of the user submitting the form (required)
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else {
                    final RegExp emailExp =
                        RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
                    if (!emailExp.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                  }
                  return null;
                },
              ),
              // a form field for the message of the user submitting the form (required)
              TextFormField(
                controller: messageController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Message',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  } else {
                    final RegExp messageExp = RegExp(r'^[a-zA-Z0-9 ]+$');
                    if (!messageExp.hasMatch(value)) {
                      return 'Please enter a valid message';
                    }
                  }
                  return null;
                },
              ),
              // a button to submit the form
              ElevatedButton(
                onPressed: isSaveButtonEnabled.value
                    ? () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data...')),
                          );
                        }
                      }
                    : null,
                child: const Text('Submit'),
              ),

              // a button to cancel the form
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
