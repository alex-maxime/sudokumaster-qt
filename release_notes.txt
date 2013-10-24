Sudokumaster Qt Quick
=====================

The QML Sudokumaster application is a Qt Quick port of the originally Symbian-
based game Sudokumaster with some minor changes and improvements. It is a 
typical Sudoku game with a 9x9 grid, consisting of nine 3x3 sub-grids, and the
symbols used are digits from 1 to 9.

The application generates 'fully random' puzzles with unique solutions. The
algorithms used are recursive and use backtracking, so they are relatively
simple but not very fast. New puzzles can still be generated in a reasonable 
amount of time.

The goal has been to keep QML Sudokumaster a pure Qt Quick application, so all 
the functionality is implemented in JavaScript and QML. The database for the
ranking list is implemented using SQLite.

The example has been tested to work with Qt 4.7.3 and Qt Mobility 1.1.3 on 
Symbian^3, Maemo, MeeGo 1.2 Harmattan, and Windows.


INSTALLATION INSTRUCTIONS
-------------------------------------------------------------------------------

Mobile device (Symbian^1 and Symbian^3)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are two ways to install the application on the device.

0. The Qt libraries (4.7.2 or higher) must be installed. See the section
   COMPATIBILITY for more information about the installation.

1. a) Drag the Sudokumaster SIS file to the Nokia Ovi Suite while the device
      is connected with the USB cable.

   OR

   b) Send the application directly to the Messaging Inbox (for example,
      through Bluetooth).

2. After the installation is complete, return to the Application menu and
   select the Applications folder.

3. Locate the QML Sudokumaster icon and select it to launch the application.


Mobile device (Maemo)
~~~~~~~~~~~~~~~~~~~~~
0. The Qt libraries (4.7.0 or higher) must be installed. See the section 
   COMPATIBILITY for more information about the installation.

1. Copy the Maemo Debian file into a specific folder on the device (for
   example, 'MyDocs').

2. Start XTerm. Type 'sudo gainroot' to get root access.

3. 'cd' to the directory to which you copied the package 
   (for example, 'cd MyDocs').

4. As root, install the package:
   dpkg -i <debian file>

5. Launch the Applications menu.

6. Locate the QML Sudokumaster icon and select it to launch the application.


Windows desktop
~~~~~~~~~~~~~~~

1. Extract the ZIP file containing the windows binary to the folder of your
   choosing.

2. Launch the application from the extracted executable file.


RUNNING THE APPLICATION
-------------------------------------------------------------------------------

The application can be used via a touchscreen or physical keys. When the 
application is started and a new game is selected, the application generates a 
new sudoku puzzle. The selected shell is indicated by the intersection of the 
highlighted row and column. A different shell can be selected by using the 
arrow keys and enter/select button, clicking the shell, or dragging a 
finger/mouse over the Sudoku game board and lifting the finger/mousebutton up 
when the desired shell is reached. This pops up the number pad which can be 
used to select a number for the previously selected shell. If the number 
cannot be inserted in the shell, the conflicting shells will blink red. The 
number of moves, the number of empty shells, and the time used is shown at the 
bottom of the screen. The game can be paused or restarted at any time via the 
options menu. When the Sudoku game board is filled and the player's time is 
good enough to entitle the player to the top ten list, the player can input 
his/her name and it will be saved in the database.


COMPATIBILITY
-------------------------------------------------------------------------------

- Symbian^1 and Symbian^3 with Qt version 4.7.2 or higher

  1. Download Qt for Symbian (4.7.2 or higher) from qt.nokia.com.
 
  2. Drag qt_installer.sis on top of the device in Nokia Ovi Suite while the
     device is connected. The SIS package is found in the installation folder
     of Qt for Symbian (4.7.2 or higher).

- Maemo with PR1.3 which includes Qt 4.7.0.

  1. Use Nokia Ovi Suite to update the device's firmware to PR1.3.

- MeeGo 1.2 Harmattan

- Windows desktop, the required Qt libraries are provided with the QML 
  Sudokumaster binary.

Tested on:

  - Nokia 5800 XpressMusic
  - Nokia E7-00
  - Nokia N8-00
  - Nokia X7-00
  - Nokia N900
  - Nokia N950
  - Windows 7
  
Developed with:

  - Qt SDK 1.1


VERSION HISTORY
-------------------------------------------------------------------------------

v1.1 Added MeeGo 1.2 Harmattan support.
v1.0 The first release.
v0.3 Support for number keys added.
v0.2 Maemo support added.
v0.1 The initial version.