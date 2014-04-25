# Copyright (c) 2011-2014 Microsoft Mobile.

QT += declarative sql
TARGET = sudokumaster
VERSION = 1.1

HEADERS += \
    myqmlapplicationviewer.h

SOURCES += \
    main.cpp \
    myqmlapplicationviewer.cpp

OTHER_FILES += \
    qml/Block.qml \
    qml/Button.qml \
    qml/Cell.qml \
    qml/HighScores.qml \
    qml/main.qml \
    qml/Menu.qml \
    qml/NumberPad.qml \
    qml/SplashScreen.qml \
    qml/WaitNote.qml \
    qml/View.qml \
    qml/WinNote.qml \
    qml/dbHandling.js \
    qml/gameLogic.js

RESOURCES += rsc/sudokumaster.qrc


symbian: {
    TARGET = Sudokumaster
    TARGET.UID3 = 0xE0253A00
    TARGET.EPOCHEAPSIZE = 0x20000 0x2000000

    ICON = icons/sudoku.svg

    RESOURCES += rsc/no_components.qrc
    OTHER_FILES += qml/no_components.qml
}


unix:!symbian {
    INSTALLS += target

    contains(DEFINES, DESKTOP) {
        target.path = /usr/local/bin

        RESOURCES += rsc/no_components.qrc
        OTHER_FILES += qml/no_components.qml
    }
    else {
        BINDIR = /opt/usr/bin
        DATADIR = /usr/share
        DEFINES += DATADIR=\\\"$$DATADIR\\\" \
                   PKGDATADIR=\\\"$$PKGDATADIR\\\"

        target.path = $$BINDIR

        iconxpm.path = $$DATADIR/pixmap
        iconxpm.files += icons/xpm/sudokumaster.xpm

        icon26.path = $$DATADIR/icons/hicolor/26x26/apps
        icon26.files += icons/26x26/sudokumaster.png

        icon40.path = $$DATADIR/icons/hicolor/40x40/apps
        icon40.files += icons/40x40/sudokumaster.png

        icon64.path = $$DATADIR/icons/hicolor/64x64/apps
        icon64.files += icons/64x64/sudokumaster.png


        maemo5 {
            RESOURCES += rsc/no_components.qrc
            OTHER_FILES += qml/no_components.qml

            desktopfile.path = $$DATADIR/applications/hildon
            desktopfile.files += qtc_packaging/debian_fremantle/$${TARGET}.desktop
        }
        else {
            # Harmattan specific
            message(Harmattan build)
            DEFINES += Q_WS_MAEMO_6

            RESOURCES += rsc/harmattan.qrc
            OTHER_FILES += qml/harmattan.qml

            desktopfile.files = qtc_packaging/debian_harmattan/$${TARGET}.desktop
            desktopfile.path = /usr/share/applications
        }

        INSTALLS += \
            desktopfile \
            iconxpm \
            icon26 \
            icon40 \
            icon64
    }
}

win32 {
    message(Windows environment)
    RESOURCES += rsc/no_components.qrc
    OTHER_FILES += qml/no_components.qml
}
