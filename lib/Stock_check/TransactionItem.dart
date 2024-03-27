class TransactionItem {
  String? item_id;
  String item_name;
  String item_type;
  int item_amount;
  String date_added;
  String date_expired;

  TransactionItem({
    this.item_id,
    required this.item_name,
    required this.item_type,
    required this.item_amount,
    required this.date_added,
    required this.date_expired,
  });

  Map<String, dynamic> toMap() {
    return {
      'item_id': item_id,
      'item_name': item_name,
      'item_type': item_type,
      'item_amount': item_amount,
      'date_added': date_added,
      'date_expired': date_expired,
    };
  }
  
  factory TransactionItem.fromMap(Map<String, dynamic> map) {
  return TransactionItem(
    item_id: map['item_id'] as String?, // Use as String? instead of as String
    item_name: map['item_name'] as String,
    item_type: map['item_type'] as String,
    item_amount: map['item_amount'] as int,
    date_added: map['date_added'] as String,
    date_expired: map['date_expired'] as String,
  );
}

}
