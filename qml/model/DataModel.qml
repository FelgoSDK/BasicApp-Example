import QtQuick 2.0
import VPlay 2.0

Item {

  // property to configure target dispatcher / logic
  property alias dispatcher: logicConnection.target

  // whether api is busy
  readonly property bool busy: api.busy

  // model data properties
  readonly property alias todos: _.todos
  readonly property alias todoDetails: _.todoDetails
  readonly property alias draftTodos: _.draftTodos

  // signals
  signal fetchTodosFailed(var error)
  signal fetchTodoDetailsFailed(int id,var error)
  signal storeDraftTodoFailed(var todo, var error)
  signal todoStored(int draftId, int todoId)

  // listen to actions from dispatcher
  Connections {
    id: logicConnection

    // action 1 - fetchTodos
    onFetchTodos: {
      // check cached value first
      var cached = cache.getValue("todos")
      if(cached)
        _.todos = cached

      // load from api
      api.getTodos(
            function(data) {
              // cache data before updating model property
              cache.setValue("todos",data)
              _.todos = data
            },
            function(error) {
              // action failed if no cached data
              if(!cached)
                fetchTodosFailed(error)
            })
    }

    // action 2 - fetchTodoDetails
    onFetchTodoDetails: {
      // fetch from drafts if id < 0
      if(id < 0) {
        _.draftTodos.forEach(function(item) {
          if(item.id === id) {
            _.todoDetails[id] = item
          }
        })
        return
      }

      // check cached todo details first
      var cached = cache.getValue("todo_"+id)
      if(cached) {
        _.todoDetails[id] = cached
        todoDetailsChanged() // signal change within model to update UI
      }

      // load from api
      api.getTodoById(id,
                      function(data) {
                        // cache data first
                        cache.setValue("todo_"+id, data)
                        _.todoDetails[id] = data
                        todoDetailsChanged()
                      },
                      function(error) {
                        // action failed if no cached data
                        if(!cached) {
                          fetchTodoDetailsFailed(id, error)
                        }
                      })
    }

    // action 3 - fetchDraftTodos
    onFetchDraftTodos: {
      // check cached value first
      var cached = cache.getValue("draftTodos")
      if(cached)
        _.draftTodos = cached

      // drafts are not stored with api, only locally in cache
    }

    // action 4 - createDraftTodo
    onCreateDraftTodo: {
      // add to draft todos
      var tempTodo = JSON.parse(JSON.stringify(todo)) // copy object
      var latestDraftNr = _.draftTodos.length > 0 ? _.draftTodos[0].id : 0
      tempTodo["id"] = latestDraftNr - 1 // negative id means its a draft
      _.draftTodos.unshift(tempTodo) // add to top of draft list

      // cache draft todos
      cache.setValue("draftTodos", _.draftTodos)
      draftTodosChanged()

      // drafts are not stored with api, only locally
    }

    // action 5 - storeDraftTodo
    onStoreDraftTodo: {
      // copy draft and delete id (is set by api)
      var newTodo = JSON.parse(JSON.stringify(todo)) // copy
      delete newTodo["id"]

      // store with api
      api.addTodo(newTodo,
                  function(data) {
                    // cache newly added item details
                    cache.setValue("todo_"+data.id, data)

                    // remove draft item
                    for(var i=0; i < _.draftTodos.length; i++) {
                      if(_.draftTodos[i].id === todo.id) {
                        _.draftTodos.splice(i, 1)
                      }
                    }

                    // add new item to todos
                    _.todos.unshift(data)

                    // cache updated todo list and drafts
                    cache.setValue("draftTodos", _.draftTodos)
                    cache.setValue("todos", _.todos)
                    draftTodosChanged()
                    todosChanged()

                    todoStored(todo.id, data.id)
                  },
                  function(error) {
                    storeDraftTodoFailed(todo, error)
                  })
    }

    // action 6 - clearCache
    onClearCache: {
      // only clear todos and details, not drafts
      cache.clearValue("todos")
      _.todoDetails.forEach(function(item) {
        cache.clearValue("todo_"+item.id)
      })
    }
  }

  // rest api for data access
  RestAPI {
    id: api
    maxRequestTimeout: 3000 // use max request timeout of 3 sec
  }

  // storage for caching
  Storage {
    id: cache
  }

  // private
  Item {
    id: _

    property var todos: []
    property var todoDetails: []
    property var draftTodos: []
  }
}
