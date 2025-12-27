// lib/core/constants/list_status.dart
enum ListStatus {
  watching('Watching'),
  completed('Completed'),
  onHold('On Hold'),
  dropped('Dropped'),
  planToWatch('Plan to Watch');

  final String value;
  const ListStatus(this.value);

  static ListStatus fromString(String value) {
    return ListStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ListStatus.planToWatch,
    );
  }
}