extension ExtString on String {
  bool get isValidEmail {
    return RegExp(r'^[\S]+(\.[\S]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(this);
  }

  bool get isValidPassword {
    return RegExp(
            r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()\-_=+{};:,<.>])[A-Za-z\d!@#$%^&*()\-_=+{};:,<.>.]{8,}$')
        .hasMatch(this);
  }
}
