# 5CCS2SEG Major Project | Team Bebsi

## Project 2: "Medical Appointments"

## User Mobile Application

### Team Members:
Dario Nunez  
Sarunas Djacenko  
David Tetruashvili  
Arzhan Tong  

### Instructions on how to use the mobile app:

Put the prep.apk file onto an android device. Enable installing from unknown sources. Install the apk file.

To build the app for android from source:
You need to have Flutter and the Android SDK installed and set up (for example via Android Studio). Connect the device via USB, and enable USB debugging on your device. From the prep folder, run the following commands:  
`$ flutter packages get` to get all the necessary packages  
`$ flutter build apk` to build the android apk  
`$ flutter install` to install the app to the device  

To build the app for iOS from source:
Open the project in an editor and run:

`$ flutter packages get` to get all the necessary packages  
`$ open ios/Runner.xcworkspace` to load the project into XCode  

Go to “Runner” → “General” and choose a developer account as well as the name of the app -> “Prep.”
Then, to install to a particular device, connect it and select it on the dropdown next to the Runner icon > Select Device. Then click “Build” and it should install the app on your device.

### Instructions to run automated tests for the mobile app:
You need to have Flutter installed and set up. From the prep folder, run the following commands:  
`$ flutter test --coverage`  
`$ genhtml coverage/lcov.info -o coverage/report`  
This will create the coverage report in the coverage/report folder, which can be viewed from the index.html file.
