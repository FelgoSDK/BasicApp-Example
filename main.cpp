#include <QApplication>
#include <VPApplication>

#include <QQmlApplicationEngine>

// uncomment this line to add the Live Client Module and use live reloading with your custom C++ code
//#include <VPLiveClient>


int main(int argc, char *argv[])
{
  QApplication app(argc, argv);
  VPApplication vplay;

  // Use platform-specific fonts instead of V-Play's default font
  vplay.setPreservePlatformFonts(true);

  QQmlApplicationEngine engine;
  vplay.initialize(&engine);

  // use this during development
  // for PUBLISHING, use the entry point below
  vplay.setMainQmlFileName(QStringLiteral("qml/Main.qml"));

  // use this instead of the above call to avoid deployment of the qml files and compile them into the binary with qt's resource system qrc
  // this is the preferred deployment option for publishing games to the app stores, because then your qml files and js files are protected
  // to avoid deployment of your qml files and images, also comment the DEPLOYMENTFOLDERS command in the .pro file
  // also see the .pro file for more details
  // vplay.setMainQmlFileName(QStringLiteral("qrc:/qml/Main.qml"));

  engine.load(QUrl(vplay.mainQmlFileName()));

  // to start your project as Live Client, comment (remove) the lines "vplay.setMainQmlFileName ..." & "engine.load ...",
  // and uncomment the line below
  //VPlayLiveClient client (&engine);

  return app.exec();
}
