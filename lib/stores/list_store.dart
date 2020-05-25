import 'package:mobx/mobx.dart';
import 'package:todo_mobx/stores/todo_store.dart';

part 'list_store.g.dart';

class ListStore = _ListStore with _$ListStore;

abstract class _ListStore with Store {

  @observable
  String newTodoTitle = "";

  @action
  void setNewTodoTitle(String value) => newTodoTitle = value;

  @computed
  bool get isFormValid => newTodoTitle.isNotEmpty;

  /*@observable
  List<String> todoList = [];*/

  ObservableList<TodoStore> todoList = ObservableList<TodoStore>();

  @action
  void addTodo(){
    //todoList = List.from(todoList..add(newTodoTitle));
    todoList.insert(0, TodoStore(newTodoTitle));
    print(todoList);
    newTodoTitle = "";
  }

}