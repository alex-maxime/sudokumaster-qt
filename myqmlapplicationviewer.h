/**
 * Copyright (c) 2011 Nokia Corporation.
 */

#ifndef MYQMLAPPLICATIONVIEWER_H
#define MYQMLAPPLICATIONVIEWER_H

#include <QtDeclarative/QDeclarativeView>


class MyQmlApplicationViewer : public QDeclarativeView
{
    Q_OBJECT

public:
    enum ScreenOrientation {
        ScreenOrientationLockPortrait,
        ScreenOrientationLockLandscape,
        ScreenOrientationAuto
    };

public:
    explicit MyQmlApplicationViewer(QWidget *parent = 0);
    virtual ~MyQmlApplicationViewer();
    void launchWithSplashQmlFile(const QString &file);
    void setMainQmlFile(const QString &file);
    void setOrientation(ScreenOrientation orientation);
    void showExpanded();

public slots:
    void loadMainQml();

private:
    QString m_mainQml;

};

#endif // MYQMLAPPLICATIONVIEWER_H
