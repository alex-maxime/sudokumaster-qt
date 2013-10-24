/**
 * Copyright (c) 2011 Nokia Corporation.
 */

#include <QtGui/QApplication>
#include <QtDeclarative>

#include "myqmlapplicationviewer.h"


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    MyQmlApplicationViewer viewer;
    viewer.setAttribute(Qt::WA_NoSystemBackground);
    viewer.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    viewer.setOrientation(MyQmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile("qrc:/main.qml");
    viewer.launchWithSplashQmlFile("qrc:/SplashScreen.qml");

    return app.exec();
}
