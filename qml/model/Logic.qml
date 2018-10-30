import QtQuick 2.0

Item {

  // actions
  signal fetchTodos()

  signal fetchTodoDetails(int id)

  signal fetchDraftTodos()

  signal createDraftTodo(var todo)

  signal storeDraftTodo(var todo)

  signal clearCache()

  // function to both create and store a draft
  function createAndStoreDraftTodo(todo) {
    createDraftTodo(todo)
    var draft = dataModel.draftTodos[0]
    storeDraftTodo(draft)
  }
}
