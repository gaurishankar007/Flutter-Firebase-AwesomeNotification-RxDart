import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
import 'package:firebase_crud/data/remote/repositories/firebase_auth_repo.dart';
import 'package:firebase_crud/presentation/blocs/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';

import '../../core/constant.dart';
import '../../core/firebase_operation_type.dart';
import '../../data/remote/models/person_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController firstName = TextEditingController(),
      lastName = TextEditingController(),
      email = TextEditingController(),
      phone = TextEditingController();
  DateTime? birthday;

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color surface = Theme.of(context).colorScheme.surface;

    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeLoadedEvent()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (blocContext, state) {
          if (state is HomeLoadedState) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  state.userEmail,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      firstName.text = "";
                      lastName.text = "";
                      email.text = "";
                      phone.text = "";
                      birthday = null;

                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (builder) => userMBS(
                          context: blocContext,
                          firebaseOpt: FirebaseOpt.add,
                          formKey: state.formKey,
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.person_add_alt_rounded,
                    ),
                  ),
                  IconButton(
                    onPressed: () => AuthFirebase().signOut(),
                    icon: Icon(
                      Icons.logout_rounded,
                    ),
                  ),
                ],
              ),
              body: StreamBuilder(
                  stream: state.personStream,
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      List<Person> personList = streamSnapshot.data!.docs
                          .map((doc) => Person.fromJson(doc.data()))
                          .toList();

                      if (personList.isEmpty) {
                        return Center(
                          child: Text("No Users"),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: sWidth(context) * .04,
                          vertical: 10,
                        ),
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          List<Person> personList = streamSnapshot.data!.docs
                              .map((doc) => Person.fromJson(doc.data()))
                              .toList();
                          return ListTile(
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (builder) => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: surface,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          firstName.text =
                                              personList[index].firstName;
                                          lastName.text =
                                              personList[index].lastName;
                                          email.text = personList[index].email;
                                          phone.text = personList[index]
                                              .phone
                                              .toString();
                                          birthday = personList[index].birthday;

                                          Navigator.pop(context);

                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            builder: (builder) => userMBS(
                                              context: blocContext,
                                              firebaseOpt: FirebaseOpt.update,
                                              formKey: state.formKey,
                                              personId: streamSnapshot
                                                  .data!.docs[index].id,
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: secondary,
                                        ),
                                        child: Text("Edit"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);

                                          BlocProvider.of<HomeBloc>(context)
                                              .add(DeletePersonEvent(
                                                  personId: streamSnapshot
                                                      .data!.docs[index].id));

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text("Person is deleted."),
                                          ));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: Text("Delete"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("${index + 1}.")],
                            ),
                            title: Text(
                                "${personList[index].firstName} ${personList[index].lastName}"),
                            subtitle: Text(
                                "${personList[index].email}, ${personList[index].phone.toString()}"),
                            trailing: Text(personList[index]
                                .birthday
                                .toIso8601String()
                                .split("T")[0]),
                          );
                        },
                      );
                    } else if (streamSnapshot.hasError) {
                      return Center(
                        child: Text("${streamSnapshot.error}"),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: primary,
                        ),
                      );
                    }
                  }),
            );
          }
          return Scaffold(
            appBar: AppBar(),
          );
        },
      ),
    );
  }

  Widget userMBS(
      {required BuildContext context,
      required FirebaseOpt firebaseOpt,
      required GlobalKey<FormState> formKey,
      String personId = ""}) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color surface = Theme.of(context).colorScheme.surface;
    Color onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                firebaseOpt == FirebaseOpt.add
                    ? "Add New Users"
                    : "Update Person Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: firstName,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "First name is required."),
                        LengthRangeValidator(
                            min: 2, max: 25, errorText: "Invalid Name."),
                      ]),
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        hintText: 'Enter your first name',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: lastName,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Last name is required."),
                        LengthRangeValidator(
                            min: 2, max: 25, errorText: "Invalid Name."),
                      ]),
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        hintText: 'Enter your last name',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: phone,
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: "Phone number is required."),
                        MinLengthValidator(10,
                            errorText: "Phone number must be 10 digits."),
                      ]),
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        hintText: 'Enter your phone',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: DateTimeField(
                      onChanged: (value) {
                        birthday = value!;
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Birthday is required";
                        }

                        return null;
                      },
                      format: DateFormat("yyyy-MM-dd"),
                      initialValue: birthday,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          initialDate: currentValue ?? DateTime.now(),
                        );
                      },
                      decoration: InputDecoration(
                        label: Text("Birthday"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: email,
                validator: MultiValidator([
                  RequiredValidator(errorText: "Email is required."),
                  EmailValidator(errorText: "Invalid email."),
                ]),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    if (firebaseOpt == FirebaseOpt.add) {
                      BlocProvider.of<HomeBloc>(context).add(AddPersonEvent(
                          person: Person(
                        firstName: firstName.text,
                        lastName: lastName.text,
                        email: email.text,
                        phone: int.parse(phone.text),
                        birthday: birthday!,
                      )));

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("A new person is added."),
                      ));
                    } else if (firebaseOpt == FirebaseOpt.update) {
                      BlocProvider.of<HomeBloc>(context).add(UpdatePersonEvent(
                        person: Person(
                          firstName: firstName.text,
                          lastName: lastName.text,
                          email: email.text,
                          phone: int.parse(phone.text),
                          birthday: birthday!,
                        ),
                        personId: personId,
                      ));

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Person is updated."),
                      ));
                    }

                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(bBorderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: onSurface.withOpacity(.05),
                        offset: Offset(2, 2),
                        spreadRadius: 1,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    firebaseOpt == FirebaseOpt.add ? "Submit" : "Update",
                    style: TextStyle(
                      color: surface,
                      fontSize: subtitle1["size"],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10 + MediaQuery.of(context).viewInsets.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
