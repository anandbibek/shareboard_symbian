import QtQuick 1.1
import com.nokia.symbian 1.1
import SocialConnect 1.0


Page {
    id: page1


    property PageStack pageStack
    property WebInterface webIf
    property TwitterConnection twitter
    property FacebookConnection facebook

    property bool twitSuccess : false
    property bool fbSuccess : false
    property bool autoExit : false
    property bool delTags : false

    property int fbStat : 0
    property int twitStat : 0
    //0:reset ; 1:sending; 2:finished; 3:Error

    onTwitStatChanged: {
        if(autoExit && twitStat==2 && (fbStat==0||fbStat==2)){
            console.debug("AutoExiting with twitStat "+twitStat+" and fbStat "+fbStat)
            Qt.quit()
        }
    }
    onFbStatChanged: {
        if(autoExit && fbStat==2 && (twitStat==0||twitStat==2)){
            console.debug("AutoExiting with twitStat "+twitStat+" and fbStat "+fbStat)
            Qt.quit()
        }
    }


    function __sendMessage() {
        var message = noteField.text;
        var image = imgUrl;
        console.debug("SEND, message: " + message
                      + (image !== "" ? " , with image: " + image : ""));
        //var tooLong = __checkCharLimit(message)

        if (twit.check && (imgUrl==""? noteField.text.length>140 : noteField.text.length>120)) {
            dlgLoader.sourceComponent = charCountExceededDlg;
            dlgLoader.item.open();
        } else {

            if (twit.check) {
                twitter.postMessage({"text": message,
                                        "url": image});
                twitStat = 1;
                if(!busyIndicatorLoader.loading)
                busyIndicatorLoader.loading = true;
            }

            if (fb.check) {

                if(delTags)
                    message = message.replace("#","");

                facebook.postMessage({"text": message,
                                         "url": image});
                fbStat = 1;
                if(!busyIndicatorLoader.loading)
                busyIndicatorLoader.loading = true;
            }
        }
    }



    Flickable {
        id: container
        anchors.top: rectangle1.bottom
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        contentWidth: col.width
        contentHeight: col.height + 40
        flickableDirection: Flickable.VerticalFlick
        pressDelay: 300
        clip: true

        Column {
            id: col
            spacing: 10
            width: container.width

            Image {
                id : shareImg
                source: imgUrl
                asynchronous: true
                sourceSize.width: page1.width
                width : imgUrl==""? 0 : page1.width/2
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                clip : true
                fillMode: Image.PreserveAspectFit
            }

            TextArea {
                id: noteField
                anchors {left: parent.left; right: parent.right; margins: 15}
                placeholderText: "Tap here to write..."
                textFormat: Text.PlainText
                // Set the minimum height to be 200
                height:cp_inPortrait ? page1.height - 2*toolbutton1.height - 30 : page1.height - toolbutton1.height - 30


            }



            Item{
                id: item1
                width: parent.width
                height: toolbutton1.height

                Image{
                    id: settingsImg
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    source: "gfx/settings.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            dlgLoader.sourceComponent = settingsDialog
                        }
                    }
                }

                ToolButton{
                    id: toolbutton1
                    text: "Image"
                    checkable: true
                    checked: imgUrl !== ""
                    anchors.left: settingsImg.right
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: imgUrl==""? pageStack.push(Qt.resolvedUrl("ImageGallery.qml")) : imgUrl = ""
                }

                Text{
                    width: 360
                    color: ((imgUrl==""? noteField.text.length>140 : noteField.text.length>120) && twit.check) ? "red" : "white"
                    text: noteField.text.length
                    anchors.left: toolbutton1.right
                    anchors.leftMargin: 10
                    anchors.verticalCenter: toolbutton1.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    opacity: 0.250
                    font.pixelSize: 16
                }

                Image{
                    property bool check : facebookConnection.authenticated
                    id: fb
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    anchors.verticalCenter: toolbutton1.verticalCenter
                    asynchronous: true
                    source: check ? "gfx/f_logo.png" : "gfx/f_logoU.png"

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {

                            if(facebookConnection.authenticated)
                                fb.check = !fb.check
                            else
                                pageStack.push(Qt.resolvedUrl("LaunchWizardPage.qml"),
                                               {pageStack: pageStack,
                                                   facebook: facebookConnection,
                                                   twitter: twitterConnection,
                                                   webIf: webInterface});
                        }
                        onPressAndHold: pageStack.push(Qt.resolvedUrl("LaunchWizardPage.qml"),
                                                       {pageStack: pageStack,
                                                           facebook: facebookConnection,
                                                           twitter: twitterConnection,
                                                           webIf: webInterface});
                    }
                }

                Image{
                    property bool check : (twitterConnection.authenticated)
                    id: twit
                    anchors.right: fb.left
                    anchors.rightMargin: 10
                    asynchronous: true
                    anchors.verticalCenter: toolbutton1.verticalCenter
                    source: check ? "gfx/t_logo.png" : "gfx/t_logoU.png"

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {

                            if(twitterConnection.authenticated)
                                twit.check = !twit.check
                            else
                                pageStack.push(Qt.resolvedUrl("LaunchWizardPage.qml"),
                                               {pageStack: pageStack,
                                                   facebook: facebookConnection,
                                                   twitter: twitterConnection,
                                                   webIf: webInterface});

                        }
                        onPressAndHold: pageStack.push(Qt.resolvedUrl("LaunchWizardPage.qml"),
                                                       {pageStack: pageStack,
                                                           facebook: facebookConnection,
                                                           twitter: twitterConnection,
                                                           webIf: webInterface});
                    }
                }

            }
        }
    }

    ScrollBar {
        anchors.right: container.right
        anchors.top: container.top
        anchors.bottom: container.bottom
        flickableItem: container
        policy: Symbian.ScrollBarWhenNeeded
    }

    Rectangle {
        id: rectangle1
        width: parent.width
        height: 1
        color: "#4591ff"
        anchors.top: parent.top
        anchors.topMargin: shareButton.height + 5
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: text1
            color: "#4591ff"
            text: qsTr("ShareBoard")
            anchors.leftMargin: 6
            anchors.left: parent.left
            verticalAlignment: Text.AlignBottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
            font.pixelSize: 25
        }
    }


    ToolButton{
        id : shareButton
        text: "Share!"
        anchors.right: parent.right
        anchors.rightMargin: 12
        enabled : (noteField.text!=="" || imgUrl!== "")
        onClicked: __sendMessage()
    }


    Connections {
        target: twitter

        onPostMessageCompleted: {
            console.debug("Posting message to Twitter completed! Success: " + success);
            //__sendMessageCompleted(success);
            //busyIndicatorLoader.loading = false;
            //dlgLoader.sourceComponent = msgPostedDlg;
            twitSuccess = success;
            if(success)
                twitStat = 2;
            else
                twitStat = 3
            //dlgLoader.item.open();
        }
    }

    Connections {
        target: facebook

        //TODO : ERROR HANDLING

        onPostMessageCompleted: {
            console.debug("Posting message to Facebook completed! Success: " + success);
            //__sendMessageCompleted(success);
            //busyIndicatorLoader.loading = false;
            //dlgLoader.sourceComponent = msgPostedDlg;
            fbSuccess = success;
            if(success)
                fbStat = 2;
            else
                fbStat = 3
            //dlgLoader.item.open();
        }
    }


    Loader {
        id: dlgLoader

        anchors.fill: parent

        Component {
            id: charCountExceededDlg

            QueryDialog {
                property bool success: false

                anchors.centerIn: parent
                titleText: qsTr("Update too long!")
                message: qsTr("You are trying to send an update that exceeds "
                              + "Twitter's status update character count.\n\n"
                              +"Ignore if you have links in the msg.")

                //TODO : URL HANDLING

                acceptButtonText: qsTr("Ignore & send")
                rejectButtonText: qsTr("Edit message")

                onAccepted: {
                    var message = noteField.text;
                    var image = imgUrl;
                    console.debug("SEND, message: " + message
                                  + (image !== "" ? " , with image: " + image : ""));

                        if (twit.check) {
                            twitter.postMessage({"text": message,
                                                    "url": image});
                            twitStat = 1;
                            if(!busyIndicatorLoader.loading)
                            busyIndicatorLoader.loading = true;
                        }

                        if (fb.check) {

                            if(delTags)
                                message = message.replace("#","");

                            facebook.postMessage({"text": message,
                                                     "url": image});
                            fbStat = 1;
                            if(!busyIndicatorLoader.loading)
                            busyIndicatorLoader.loading = true;
                        }
                }

                onRejected: dlgLoader.sourceComponent = undefined;
            }
        }
    }

    Loader {
        id: busyIndicatorLoader

        property bool loading: false

        anchors.fill: parent
        sourceComponent: loading ? busyIndicator : undefined

        Component{
            id: settingsDialog

            Item{
                anchors.fill: parent

                Rectangle{
                    color: "black"
                    opacity: 0.80
                    anchors.fill: parent
                }
                MouseArea{
                    anchors.fill: parent
                }

                Column{
                    spacing: 24
                    width : buttonAcc.width
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter

                    Button{
                        id : buttonAcc
                        text: "Accounts"
                        onClicked: {
                                pageStack.push(Qt.resolvedUrl("LaunchWizardPage.qml"),
                                               {pageStack: pageStack,
                                                   facebook: facebookConnection,
                                                   twitter: twitterConnection,
                                                   webIf: webInterface});
                        }
                    }

                    CheckBox{
                        text: "Remove #tags for FB"
                        checked: delTags
                        onClicked: delTags=checked
                    }

                    CheckBox{
                        text: "Auto exit on finish"
                        checked: autoExit
                        onClicked: autoExit=checked
                    }

                    ToolButton{
                        text: "Done"
                        width: buttonAcc.width
                        onClicked: dlgLoader.sourceComponent = undefined
                    }
                    ToolButton{
                        text: "Exit"
                        width: buttonAcc.width
                        onClicked: Qt.quit()
                    }
                }
        }
        }

        Component {
            id: busyIndicator

            Item {
                //color: "black"
                opacity: 1
                anchors.fill: parent

                Rectangle{
                    color: "black"
                    opacity: 0.80
                    anchors.fill: parent
                }


                MouseArea {
                    // Capture all clicks.
                    anchors.fill: parent
                }

                Column{
                    spacing: 24
                    width : 272
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    Row{
                        spacing: 12
                        visible: (twitStat!=0)
                        //height: 60

                        Image{
                            source: "gfx/t_logo.png"
                        }
                        ToolButton{
                            text: (twitStat==1)? "Cancel" : (twitStat==2)? "Done" : "Error"
                            enabled: (twitStat==1)
                            width : 200
                            onClicked: {
                                page1.twitter.cancel();
                                twitStat = 3
                                text = "Cancelled"
                            }
                            anchors.verticalCenter: parent.verticalCenter
                            BusyIndicator{
                                running: true
                                visible: (twitStat==1)
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                            }
                        }
                    }

                    Row{
                        spacing: 12
                        visible: (fbStat!=0)
                        //height: 60

                        Image{
                            source: "gfx/f_logo.png"
                        }
                        ToolButton{
                            text: (fbStat==1)? "Cancel" : (fbStat==2)? "Done" : "Error"
                            enabled: (fbStat==1)
                            width : 200
                            onClicked: {
                                fbStat=3;
                                page1.facebook.cancel();
                                text = "Cancelled"
                            }
                            anchors.verticalCenter: parent.verticalCenter
                            BusyIndicator{
                                running: true
                                visible: (fbStat==1)
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                            }
                        }
                    }

                    CheckBox{
                        visible : (twitStat == 1 || fbStat == 1)
                        text: "Auto exit on finish"
                        checked: autoExit
                        onClicked: autoExit=checked
                    }

                    Button {
                        visible: (twitStat != 1 && fbStat != 1)
                        width : 300
                        text: "Done"
                        onClicked: {
                            fbStat = 0
                            twitStat = 0
                            autoExit = false
                            busyIndicatorLoader.loading = false
                        }
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

            }
        }
    }
}
