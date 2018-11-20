import VPlayApps 1.0
import QtQuick 2.0
import "model"
import "pages"

App {
  // You get free licenseKeys from https://v-play.net/licenseKey
  // With a licenseKey you can:
  //  * Publish your games & apps for the app stores
  //  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
  //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
  //licenseKey: "<generate one from https://v-play.net/licenseKey>"

  // model
  DataModel {
    id: dataModel
    dispatcher: logic // data model handles actions sent by logic

    // error handling
    onFetchTodosFailed: nativeUtils.displayMessageBox("Unable to load todos", error, 1)
    onFetchTodoDetailsFailed: nativeUtils.displayMessageBox("Unable to load todo "+id, error, 1)
    onStoreDraftTodoFailed: nativeUtils.displayMessageBox("Failed to store "+todo.title)
  }

  // business logic
  Logic {
    id: logic
  }

  // Logging (Console)
  ConsoleLogger {
    dispatcher: logic
    logicLogging: true // set false to disable logging for logic actions

    model: dataModel
    modelLogging: true // set false to disable logging signals model signals
    currentPage: stack.currentPage
  }

  // view
  NavigationStack {
    id: stack
    initialPage: TodoListPage { }
  }

  // app initialization
  Component.onCompleted: {
    // if device has network connection, clear cache at startup
    // you'll probably implement a more intelligent cache cleanup for your app
    // e.g. to only clear the items that aren't required regularly
    if(isOnline) {
      logic.clearCache()
    }

    // fetch todo list data
    logic.fetchTodos()
    logic.fetchDraftTodos()
  }
}
