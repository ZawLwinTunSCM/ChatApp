String emailXConverter(String email) {
  final mailName = email.split('@')[0];
  final mailDomain = email.split('@')[1];
  final x = mailName.length <= 3
      ? mailName
      : '${mailName.substring(0, 3)}${'x' * (mailName.length - 3)}';
  return '$x@$mailDomain';
}
