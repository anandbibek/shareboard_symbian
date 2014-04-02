# Add more folders to ship with the application, here
folder_01.source = qml/TweeBook
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

#symbian:TARGET.UID3 = 0x2006b4d5
symbian:TARGET.UID3 = 0xE12EBE37
symbian:VERSION = 1.1.4
symbian {
    ICON = share.svg

    my_deployment.pkg_prerules += \
        "; Dependency to Symbian Qt Quick components" \
        "(0x200346DE), 1, 1, 0, {\"Qt Quick components for Symbian\"}"

    my_deployment.pkg_prerules += vendorinfo

    DEPLOYMENT += my_deployment

    DEPLOYMENT.display_name += ShareBoard

    vendorinfo += "%{\"Anand\"}" ":\"Anand\""
}

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
 CONFIG += mobility
 MOBILITY += gallery

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
# CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp


# socialconnect additions begin

QT += declarative network script

INCLUDEPATH += socialconnect

HEADERS += \
    socialconnect/socialconnectplugin.h \
    socialconnect/socialconnection.h \
    socialconnect/webinterface.h \
    socialconnect/facebook/facebookconnection.h \
    socialconnect/facebook/facebook.h \
    socialconnect/facebook/facebookrequest.h \
    socialconnect/facebook/facebookreply.h \
    socialconnect/facebook/facebookdatamanager.h \
    socialconnect/twitter/twitterconnection.h \
    socialconnect/twitter/twitterrequest.h \
    socialconnect/twitter/twitterconstants.h

SOURCES += \
    socialconnect/socialconnectplugin.cpp \
    socialconnect/socialconnection.cpp \
    socialconnect/webinterface.cpp \
    socialconnect/facebook/facebookconnection.cpp \
    socialconnect/facebook/facebook.cpp \
    socialconnect/facebook/facebookrequest.cpp \
    socialconnect/facebook/facebookreply.cpp \
    socialconnect/facebook/facebookdatamanager.cpp \
    socialconnect/twitter/twitterconnection.cpp \
    socialconnect/twitter/twitterrequest.cpp

# socialconnect additions end


# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

