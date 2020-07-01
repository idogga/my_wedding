
import 'package:wedding/news/new_item.dart';

class DebugData{
  List<NewsItem> get items => _items;
  List<NewsItem> _items;
  DebugData(){
    _items = List<NewsItem>.generate(30, (index) => NewsItem("Название $index", "Иконка $index"));
  }
}