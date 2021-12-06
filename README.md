# NasaAstro
NASA releases the Astronomy Picture of the Day everyday. This is accompanied by the title of the
picture and a short explanation of about it.
It is a iOS app where the user can see the daily picture released by nasa. It shows title, image and explaination of the astronomy picture on a single page.

# Features
1. This app uses no library to fetch and show data to the ui from the nasa api.
2. This app also has coredata. So the data once fetched is saved to the local database. So, if the device is not connected to the internet then also user can see astronomy data.
3. Also, the images are saved in the document directory and their paths are saved in core data. This is done to avoid excessive use of local database memory.
4. Caching of images is also supported without using any third party library.
5. Test cases are also included. There are 3 test cases files : -
    1. PictureViewModelTests  : - To test the functionality of view model.
    2. PictureSessionSlowTests : - To test the successful valid service call to nasa api.
    3. PictureLocalStorageTest : - To test the core data implementation.
6. Architecture used is MVVM.

# Requirements
1. iOS 11.0+
2. Xcode 12.0

# Installation
1. Download the .zip file from the repository and unzip it.
2. Open the "MohitMathurWalE.xcodeproj" file in xcode and then run the project by clicking play button after selecting desired device.

#Improvements Areas
1. Although the application fullills the acceptance criteria but some components can be added to the ui like refresh button to refresh the astronomy picture. 
2. A protocol can be created as "ImageCacheType" and can add create, read, update, and delete functions to it.
3. Read-write lock can be used for better performance.
4. Only provides an in-memory cache. No matter how many images are cached, once the app terminates, the cache will get cleared out and next time we need to re-download those images. In the future, we can also provide support for disk based caching letting users choose between these two modes based on the use-case.
5. Currently, there is no cache refresh. When images are downloaded, they are cached permanently. They're neither updated nor removed in case of cache limit is reached. We can also make this library bit more intelligent and let it decide where it makes sense to update the cache or purge least used cached image by implementing suitable cache policy.
6. Library only supports downloading png/jpeg images. As a future extension, we can also have this library support gif and webp image formats.
