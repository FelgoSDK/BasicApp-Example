import VPlayApps 1.0

Page {
  title: qsTr("Profile")

  signal logoutClicked

  AppButton {
    anchors.centerIn: parent
    text: qsTr("Logout")
    onClicked: logoutClicked()
  }
}
