import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 1.0

PageStackWindow {


    property bool cp_inPortrait: appWindow.inPortrait
    property string imgUrl : ""
    showStatusBar: !inputContext.visible
    showToolBar: !inputContext.visible
    platformSoftwareInputPanelEnabled: true


    id: appWindow

    //initialPage: mainPage


    Component.onCompleted: {
        // Try to restore the saved credentials
        twitterConnection.restoreCredentials();
        facebookConnection.restoreCredentials();

        // If none of the supported SoMe services proves to be authenticated,
        // present the LaunchWizardPage to the user.
        if (!facebookConnection.authenticated && !twitterConnection.authenticated) {
            pageStack.push(Qt.resolvedUrl("LaunchWizardPage.qml"),
                          {pageStack: pageStack,
                           facebook: facebookConnection,
                           twitter: twitterConnection,
                           webIf: webInterface});
        } else {
            pageStack.push(Qt.resolvedUrl("MainPage.qml"),
                          {pageStack: pageStack,
                           facebook: facebookConnection,
                           twitter: twitterConnection,
                           webIf: webInterface});
        }
    }

    WebInterface {
        id: webInterface
    }

    TwitterConnection {
        id: twitterConnection

        webInterface: webInterface
        consumerKey: consumerKeyC
        consumerSecret: consumerSecretC
        callbackUrl: "http://theweekendcoder.blogspot.com"

        onAuthenticateCompleted: console.debug("TWITTER onAuthenticateCompleted! Success: " + success)
    }

    FacebookConnection {
        id: facebookConnection

        webInterface: webInterface
        //permissions: ["publish_stream", "read_stream", "friends_status"]
        permissions: ["publish_stream"]
        clientId: "	506835416004535" //"399096860123557"

        onAuthenticateCompleted: console.debug("FACEBOOK onAuthenticateCompleted! Success: " + success)
    }

}
