#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"

// socialconnect additions begin

#include "socialconnectplugin.h"

// socialconnect additions end

Q_DECL_EXPORT int main(int argc, char *argv[])
{

    // socialconnect additions begin

    SocialConnectPlugin plugin;
    plugin.registerTypes("SocialConnect");

    // socialconnect additions end


    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    QString nexus4UA = "Mozilla/5.0 (Linux; U; Android 4.2; ro-ro; LT18i Build/4.1.B.0.431) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30";
    app->setApplicationName(nexus4UA);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.rootContext()->setContextProperty("consumerKeyC","znHwdxch6h8cnWlAiH2Q");
    viewer.rootContext()->setContextProperty("consumerSecretC","igw8TFsJhVv38dIeBKAKfTSDb3G2tBuUJtXwI7g3U");
    viewer.setMainQmlFile(QLatin1String("qml/TweeBook/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
