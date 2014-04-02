import QtQuick 1.1
import com.nokia.symbian 1.1
import QtMobility.gallery 1.1

Page {
    id: imagePickerPage

    QueryDialog{
        property string fileName : ""
        property int fileSize : 0
        property string url : ""

        id: qDialog
        height: 300
        acceptButtonText: "Attach"
        rejectButtonText: "Cancel"
        titleText: "Confirm attachment"
        message: "Select image " + fileName + "?"
                 + "\n\nFile size : " + ((fileSize/(1024)).toFixed(2)) + " KB"
        onAccepted: {
            imgUrl = url
            pageStack.pop()

        }
    }

    GridView {
        id: imageGrid

        width: parent.width
        height: parent.height
        cellWidth: 120
        cellHeight: 120
        clip: true

        model: DocumentGalleryModel {
            id: galleryModel

            rootType: DocumentGallery.Image
            scope: DocumentGallery.Image
            properties: [ "url","fileSize","title" ]

            sortProperties: [ "-lastModified" ]
            limit: 300
            autoUpdate: false
        }

        delegate: Image {
            source: url

            sourceSize.width: 120
            height: sourceSize.width
            width: sourceSize.width
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            clip: true

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    qDialog.fileName = model.title
                    qDialog.fileSize = model.fileSize*1
                    qDialog.url = (model.url)
                    qDialog.open()
                }
            }
        }

        ScrollDecorator {
            flickableItem: imageGrid
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: pageStack.pop();
        }
    }
}
