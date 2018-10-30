import VPlayApps 1.0
import QtQuick 2.0

Page {
  id: page

  title: qsTr("Details")
  rightBarItem: NavigationBarRow {
    // network activity indicator
    ActivityIndicatorBarItem {
      enabled: dataModel.busy
      visible: enabled
      showItem: showItemAlways
    }

    // add new todo
    IconButtonBarItem {
      icon: IconType.save
      visible: !!todoData && todoData.id < 0
      onClicked: logic.storeDraftTodo(todoData)
    }
  }

  // target id
  property int todoId: 0

  // data property for page
  property var todoData: dataModel.todoDetails[todoId]

  // load data initially or when id changes
  onTodoIdChanged: {
    logic.fetchTodoDetails(todoId)
  }

  // update todo id when stored
  Connections {
    target: dataModel
    onTodoStored: {
      if(page.todoId === draftId)
        page.todoId = todoId
    }
  }

  // show all todo object properties in a column, if data is available
  Column {
    y: dp(Theme.navigationBar.defaultBarItemPadding)
    width: parent.width
    visible: !!todoData

    Repeater {
      enabled: parent.visible
      model: visible ? Object.keys(todoData) : null
      AppText {
        width: parent.width - 2 * dp(Theme.navigationBar.defaultBarItemPadding)
        anchors.horizontalCenter: parent.horizontalCenter
        height: implicitHeight
        text: "<strong>"+modelData+":</strong> "+todoData[modelData]
        wrapMode: AppText.WrapAtWordBoundaryOrAnywhere
      }
    }
  }

  // show message if data is loading
  AppText {
    text: "Loading todo data..."
    anchors.centerIn: parent
    visible: !todoData && dataModel.busy
  }

  // show message if data not available
  AppText {
    text: "Todo data not available."
    anchors.centerIn: parent
    visible: !todoData && !dataModel.busy
  }
}
