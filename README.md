# BoxerLuv

BoxerLuv is a mobile app designed for the Boxer rescue organization of the same name (http://www.boxerluv.org/). It enables the user to view a list of current dogs available from the rescue. The list provides basic information on the dog and a thumbnail image. Tapping on a dog in the list will take the user to a detail page where the user can see a larger description, more pictures (when these are available), and can favorite a dog for easier searching later on. The user can also tap on the image carousel to see the dogs pictures in full screen. There is a separate table view that lists all the user's favorited dogs, and a tab with more information about the rescue. The dogs will persist offline using Core Data (Note: only the thumbnail image is persisted in the database, all other images are downloaded when accessed to help keep the app lightweight). 

<p align="center">
  <img src="/..//screenshots-hidden/Screenshot%202016-12-09%2018.40.55.png" width="200"/>
  <img src="/..//screenshots-hidden/Screenshot%202016-12-09%2018.41.06.png" width="200"/>
  <img src="/..//screenshots-hidden/Screenshot%202016-12-09%2018.41.12.png" width="200"/>
  <img src="/..//screenshots-hidden/Screenshot%202016-12-09%2018.41.28.png" width="200"/>
</p>

## To Install and Run
  This project uses cocoapods. In order to build and run this app locally, you must have cocoapods installed on your machine and then run 'pod install' in the app root directory. The app will then be able to be built using the BoxerLuv.xcworkspace.

