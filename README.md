# Game Night README

## Prerequisites

* **Flutter SDK** (Last development on version 3.27.0)
* **Dart SDK** (Last development on version 3.6.0)
* **Git**

## Getting started

1. Installing dependencies

   ```bash
   flutter pub get
   ```

2. Generating files (Currently test related files only)

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. Running the app

> :notebook: The <ENV> placeholder can take the following values: `development`, `staging`, `production`
> If this project was acquired through a zip, as is the intended format for Saxion submission;
> a `settings.production` file is provided, but when cloning this is in the .gitignore and thus not
> there.

```bash
flutter run --dart-define-from-file=settings.<ENV>
```

The app should now be fully functional, please see the submission details for the credentials to a
data rich account, or go through the process of creating a new account!

## Experiencing the quality

To verify how squeaky clean the code in this app is you can:

1. Formatting the project based on the dart rules.

   ```bash
   dart format .
   ```

2. Analyzing the project on flaws based on the `analysis_options.yaml` file.

   ```bash
   flutter analyze
   ```

3. And last but not least, run the tests and let the sea of green checkmarks flow over you

   ```bash
   flutter test --reporter github
   ```

## Contributing

Do you want to contribute to this project? Great! Please see the `CONTRIBUTING.md` file for details
on how, and to get a gist of the architecture.

When making a pull request please ensure that you have filled out
the `.gitlab/merge_request_templates/template.md` with care.

