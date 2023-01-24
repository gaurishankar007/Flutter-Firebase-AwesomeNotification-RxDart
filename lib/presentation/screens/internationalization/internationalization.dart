import 'package:firebase_crud/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../cubits/language/language_bloc.dart';

class Internationalization extends StatefulWidget {
  const Internationalization({super.key});

  @override
  State<Internationalization> createState() => _InternationalizationState();
}

class _InternationalizationState extends State<Internationalization> {
  String selectedLanguage = "en";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.flutterInternationalization),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: sWidth(context) * .04,
          vertical: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              onDateChanged: (value) {},
            ),
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.languageSelection,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            RadioListTile(
              value: "en",
              groupValue: selectedLanguage,
              onChanged: (language) {
                if (language == null) return;
                setState(() {
                  selectedLanguage = language;
                });
                BlocProvider.of<LanguageCubit>(context)
                    .changeLanguage(locale: Locale(language));
              },
              title: Text(AppLocalizations.of(context)!.english),
            ),
            RadioListTile(
              value: "ne",
              groupValue: selectedLanguage,
              onChanged: (language) {
                if (language == null) return;
                setState(() {
                  selectedLanguage = language;
                });
                BlocProvider.of<LanguageCubit>(context)
                    .changeLanguage(locale: Locale(language));
              },
              title: Text(AppLocalizations.of(context)!.nepali),
            ),
            RadioListTile(
              value: "es",
              groupValue: selectedLanguage,
              onChanged: (language) {
                if (language == null) return;
                setState(() {
                  selectedLanguage = language;
                });
                BlocProvider.of<LanguageCubit>(context)
                    .changeLanguage(locale: Locale(language));
              },
              title: Text(AppLocalizations.of(context)!.spanish),
            ),
            RadioListTile(
              value: "hi",
              groupValue: selectedLanguage,
              onChanged: (language) {
                if (language == null) return;
                setState(() {
                  selectedLanguage = language;
                });
                BlocProvider.of<LanguageCubit>(context)
                    .changeLanguage(locale: Locale(language));
              },
              title: Text(AppLocalizations.of(context)!.hindi),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/product"),
              child: Text("View Product"),
            ),
          ],
        ),
      ),
    );
  }
}
