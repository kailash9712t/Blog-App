class Conversion {
  _DynamicList get dynamicList => _DynamicList();
}

class _DynamicList {
  List<String> toStringList(List<dynamic> list) {
    List<String> data = [];

    list.map((e) {
      data.add(e as String);
    });

    return data;
  }

  // List<Object> toObjectList(List<Object> list) {
  //   List<Object> data = [];

  //   list.map((e) {
  //     data.add(e);
  //   });
  // }
}
