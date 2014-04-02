import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 1.0

Page {
    id: launchWizardPage

    property PageStack pageStack

    property FacebookConnection facebook
    property TwitterConnection twitter
    property WebInterface webIf

    Flickable {
        width: parent.width
        height: parent.height
        contentHeight: 110 + titleText.height + descriptionText.height + facebookConnected.height + twitterConnected.height
        flickableDirection: Flickable.VerticalFlick
        Item {
            width: parent.width
            height: 110 + titleText.height + descriptionText.height + facebookConnected.height + twitterConnected.height
            Label {
                id: titleText

                anchors {
                    top: parent.top
                    topMargin: 30
                    horizontalCenter: parent.horizontalCenter
                }
                width: parent.width * 0.8
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 26
                text: qsTr("ShareBoard 1.1.3")
            }

            Label {
                id: descriptionText

                anchors {
                    top: titleText.bottom
                    topMargin: 30
                    horizontalCenter: parent.horizontalCenter
                }
                width: parent.width -10
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                text: qsTr("You may log in to Facebook and/or Twitter and post updates with or without an image to both networks simultaneously"
                           + "\n\nReport problems and feedbacks to @Anand_Bibek on Twitter")
            }


            SocialMediaItem {
                id: facebookConnected

                anchors {
                    top: descriptionText.bottom
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }
                text: facebook.authenticated ? "Logout " + facebook.name : "Connect to Facebook"
                imageSource: "gfx/thumb1.png"
                onClicked: {
                    if(facebook.authenticated) {
                        facebook.removeCredentials()
                        facebookConnected.visible = false
                        facebookButton.visible = true
                    }
                    else {
                        busyIndicatorLoader.loading = true;
                        // TODO! Check the authenticate return value!
                        facebook.authenticate();
                    }
                }
            }

            SocialMediaItem {
                id: twitterConnected

                anchors {
                    top: facebookConnected.bottom
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }
                text: twitter.authenticated ? "Logout " + twitter.name : "Connect to Twitter"
                imageSource: "gfx/thumb2.png"
                onClicked: {
                    if(twitter.authenticated) {
                    twitter.removeCredentials()
                    twitterConnected.visible = false
                    twitterButton.visible = true
                    }
                    else {
                        busyIndicatorLoader.loading = true;
                        // TODO! Check the authenticate return value!
                        twitter.authenticate();
                    }
                }
            }

        }
    }

    Loader {
        id: busyIndicatorLoader

        property bool loading: false

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 50
        }
        sourceComponent: loading ? busyIndicator : undefined

        Component {
            id: busyIndicator

            BusyIndicator {
                running: true
                width: 300
                height: 300
            }
        }
    }

    WebViewLoader {
        id: webViewLoader

        webIf: launchWizardPage.webIf
        anchors.fill: parent
    }

    Connections {
        target: twitter

        onAuthenticateCompleted: {
            busyIndicatorLoader.loading = false;

            if (success) {
                // Save the access token etc.
                twitter.storeCredentials();
                // Let the user continue!
                twitterButton.visible = false;
                twitterConnected.visible = true;
                continueButton.enabled = true;
            }
        }
    }

    Connections {
        target: facebook

        onAuthenticateCompleted: {
            busyIndicatorLoader.loading = false;

            if (success) {
                facebook.storeCredentials();
                facebookButton.visible = false;
                facebookConnected.visible = true;
                continueButton.enabled = true;
            }
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"

            onClicked: {
                if (webViewLoader.active) {
                    busyIndicatorLoader.loading = false;
                    twitter.cancel();
                    facebook.cancel();
                } else if(pageStack.depth <=1)
                    Qt.quit()
                else {
                    pageStack.pop()
                }
            }
        }

        ToolButton {
            id: continueButton

            text: qsTr("Skip")
            enabled: !webViewLoader.active

            onClicked: {
                pageStack.replace(Qt.resolvedUrl("MainPage.qml"),
                                  {pageStack: pageStack,
                                      webIf: webInterface,
                                      twitter: twitterConnection,
                                      facebook: facebookConnection});
            }
        }
    }
}
