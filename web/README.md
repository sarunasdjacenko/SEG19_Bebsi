# 5CCS2SEG Major Project

## Project 2: "Medical Appointment"

## Administrative Web Client

### Team Members:
David Temple  
Xin Quan  
Mufid Alkhaddour  
Preslav Kisyov  
### Website URL
https://prep-232116.firebaseapp.com

### Compile and Run commands
Run the following commands inside the web project folder.  

`npm install` to install all the needed dependencies  
`npm install -g firebase-tools` in order to be able to deploy to firebase  
`npm run dev` to start a localhost server  
`npm test -- -u` to run vue/js testing and to update all the snapshots  

**Note:** The website will not run, unless `npm install` is ran beforehand!

### To redeploy the website

1. `npm run build` to build the vue project  
2. `firebase deploy` to deploy to firebase  
3. You might be asked if you would like to delete firebase functions - type `N`

**Note:** You will need to login to firebase by using `firebase login`!
