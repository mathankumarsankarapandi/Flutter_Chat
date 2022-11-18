class ChatModel {
  ChatModel(this.totalSize, this.items);

  int totalSize = 0;
  int items = 0;

  // final List<int> items;



  ChatModel.fromJson(Map<String, dynamic> json)
      : totalSize = (json['totalSize'] as int),
        items = (json['totalSize'] as int)/*(json["items"] as List)
            .map((i) => new GraphModel.fromJson(i))
            .toList()*/;
}