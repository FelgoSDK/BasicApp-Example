import QtQuick 2.0

Item {

  // property to configure target logic
  property alias dispatcher: logicConnection.target

  // property to configure target dataModel
  property alias model: modelConnection.target

  // property to hold current page of app, this is useful to track where the user triggered an action
  property var currentPage

  // listen dispatcher signals (to log user actions)
  Connections {
    id: logicConnection

    onFetchTodos: console.log(currentPage.title + " Action - fetchTodos")
    onFetchTodoDetails: console.log(currentPage.title + " Action - fetchTodoDetails: id="+id)
    onFetchDraftTodos: console.log(currentPage.title + " Action - fetchDraftTodos")
    onCreateDraftTodo: console.log(currentPage.title + " Action - createDraftTodo: todo="+JSON.stringify(todo))
    onStoreDraftTodo: console.log(currentPage.title + " Action - storeDraftTodo: todo="+JSON.stringify(todo))
    onClearCache: console.log(currentPage.title + " Action - clearCache")
  }

  // listen to model signals (to log storage success / errors)
  Connections {
    id: modelConnection

    onFetchTodosFailed: console.error("Error - fetchTodosFailed: error="+JSON.stringify(error))
    onFetchTodoDetailsFailed: console.error("Error - fetchTodoDetailsFailed: id="+id+", error="+JSON.stringify(error))
    onStoreDraftTodoFailed: console.error("Error - storeDraftTodoFailed: todo="+JSON.stringify(todo)+", error="+JSON.stringify(error))
    onTodoStored: console.log("Success - todoStored: draftId= "+draftId+", todoId="+todoId)
  }
}
