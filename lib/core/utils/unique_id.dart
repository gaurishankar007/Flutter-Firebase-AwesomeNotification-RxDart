int uniqueId() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.remainder(100000);
}
