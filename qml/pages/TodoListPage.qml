import VPlayApps 1.0
import QtQuick 2.0

ListPage {
  id: page
  title: qsTr("Todos")
  rightBarItem: NavigationBarRow {
    // network activity indicator
    ActivityIndicatorBarItem {
      enabled: dataModel.busy
      visible: enabled
      showItem: showItemAlways
    }

    // add new todo
    IconButtonBarItem {
      icon: IconType.plus
      onClicked: {
        var draft = {
          completed: false,
          title: "New Todo",
          userId: 1,
        }
        logic.createAndStoreDraftTodo(draft)
      }
    }
  }

  // show todos of data model
  model: dataModel.draftTodos.concat(dataModel.todos)
  delegate: SimpleRow {
    text: modelData.title + (modelData.id < 0 ? " (Draft "+(-modelData.id)+")" : "")
    style.backgroundColor: modelData.id > 0 ? Theme.listItem.backgroundColor : Theme.secondaryBackgroundColor

    // push detail page when selected
    onSelected: page.navigationStack.push(detailPageComponent, { todoId: modelData.id })
  }

  // component for creating detail pages
  Component {
    id: detailPageComponent
    TodoDetailPage { }
  }
}
