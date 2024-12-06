import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const arrKey = 'arr';

  final FormGroup fg = FormGroup({
    arrKey: FormArray<String>(
      [],
      validators: [
        Validators.minLength(1),
      ],
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('FormArray bug'),
      ),
      body: SafeArea(
        child: ReactiveForm(
          formGroup: fg,
          child: ReactiveFormArray(
            formArrayName: arrKey,
            builder: (context, formArray, _) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          formArray.invalid ? "INVALID" : "VALID",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: formArray.hasErrors ? Colors.red : null,
                              ),
                        ),
                        Text(
                          formArray.touched ? "TOUCHED" : "NOT TOUCHED",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: formArray.touched ? Colors.red : null,
                              ),
                        ),
                        Text(
                          formArray.dirty ? "DIRTY" : "NOT DIRTY",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: formArray.dirty ? Colors.red : null,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  if (formArray.invalid && formArray.touched)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        formArray.errors.toString(),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: formArray.controls.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ReactiveTextField(
                                  formControlName: index.toString(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () => formArray.removeAt(index),
                                icon: const Icon(Icons.delete),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: FilledButton.tonal(
                      onPressed: () {
                        if (!formArray.dirty) formArray.markAsDirty();
                        if (!formArray.touched) formArray.markAsTouched();
                        formArray.add(FormControl<String>());
                      },
                      child: const Text("Add new form control"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: FilledButton(
                      onPressed: fg.markAllAsTouched,
                      child: const Text("Submit"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: FilledButton(
                      onPressed: () {
                        final actuallyTouched = fg.control(arrKey).touched;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'FormArray is actually $actuallyTouched',
                            ),
                          ),
                        );
                      },
                      child: const Text("Is actually touched?"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: FilledButton.tonal(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text("Force rebuild"),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
