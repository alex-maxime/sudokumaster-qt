/**
 * Copyright (c) 2011 Nokia Corporation.
 */

#include "myqmlapplicationviewer.h"
#include <QDeclarativeEngine>
#include <QGraphicsObject>
#include <QTimer>
#include <QUrl>


/*!
  \class MyQmlApplicationViewer
  \brief Contains simple methods for screen orientation and QML UI handling.
*/


/*!
  Constructor.
*/
MyQmlApplicationViewer::MyQmlApplicationViewer(QWidget *parent) :
    QDeclarativeView(parent)
{
}


/*!
  Destructor.
*/
MyQmlApplicationViewer::~MyQmlApplicationViewer()
{
}


/*!
  Sets the main QML file as \a file.
*/
void MyQmlApplicationViewer::setMainQmlFile(const QString &file)
{
    m_mainQml = file;
}


/*!
  Launches the application with a splash screen defined by \a file.
*/
void MyQmlApplicationViewer::launchWithSplashQmlFile(const QString &file)
{
    setSource(QUrl(file));
    showExpanded();

    // To delay the loading of main QML file so that the splash screen
    // would show, we use single shot timer.
    QTimer::singleShot(0, this, SLOT(loadMainQml()));
}


/*!
  Sets the screen orientation as \a orientation.
*/
void MyQmlApplicationViewer::setOrientation(ScreenOrientation orientation)
{
#if defined(Q_OS_SYMBIAN)
    // If the version of Qt on the device is < 4.7.2, that attribute won't work
    if (orientation != ScreenOrientationAuto) {
        const QStringList v = QString::fromAscii(qVersion()).split(QLatin1Char('.'));
        if (v.count() == 3 && (v.at(0).toInt() << 16 | v.at(1).toInt() << 8 | v.at(2).toInt()) < 0x040702) {
            qWarning("Screen orientation locking only supported with Qt 4.7.2 and above");
            return;
        }
    }
#endif // Q_OS_SYMBIAN

    Qt::WidgetAttribute attribute;
    switch (orientation) {
#if QT_VERSION < 0x040702
    // Qt < 4.7.2 does not yet have the Qt::WA_*Orientation attributes
    case ScreenOrientationLockPortrait:
        attribute = static_cast<Qt::WidgetAttribute>(128);
        break;
    case ScreenOrientationLockLandscape:
        attribute = static_cast<Qt::WidgetAttribute>(129);
        break;
    default:
    case ScreenOrientationAuto:
        attribute = static_cast<Qt::WidgetAttribute>(130);
        break;
#else // QT_VERSION < 0x040702
    case ScreenOrientationLockPortrait:
        attribute = Qt::WA_LockPortraitOrientation;
        break;
    case ScreenOrientationLockLandscape:
        attribute = Qt::WA_LockLandscapeOrientation;
        break;
    default:
    case ScreenOrientationAuto:
        attribute = Qt::WA_AutoOrientation;
        break;
#endif // QT_VERSION < 0x040702
    };

    setAttribute(attribute, true);
}


/*!
  Shows the UI expanded.
*/
void MyQmlApplicationViewer::showExpanded()
{
#if defined(Q_OS_SYMBIAN) || defined(Q_WS_SIMULATOR) || \
    defined(Q_WS_MAEMO_5) || defined(Q_WS_MAEMO_6)
    showFullScreen();
#else
    show();
#endif
}


/*!
  Loads the set main QML file.
*/
void MyQmlApplicationViewer::loadMainQml()
{
    connect(engine(), SIGNAL(quit()), SLOT(close()));
    setSource(QUrl(m_mainQml));

#if defined(Q_OS_SYMBIAN) || defined(Q_WS_MAEMO_5)
    int initWidth(width());
    int initHeight(height());
    rootObject()->setProperty("width", initWidth);
    rootObject()->setProperty("height", initHeight);
    setGeometry(0, 0, initWidth, initHeight);
#endif
}
