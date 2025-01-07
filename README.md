# RESTCalculatePI
A simple REST service used to calculate PI given the # of fractional digits required

# Setup
- Download/Install DART
- Clone Repo: https://github.com/bamservers/RESTCalculatePI.git

# To Run
```
dart run RESTCalculatePI.dart
```

# To Build (Windows, Optional)
```
dart compile exe RESTCalculatePI.dart
```

# Usage
By default, the project runs on port 8080 (configurable in the code). When running, the following URLs will be available:

http://127.0.0.1:8080/HelloWorld
- Confirms the web server is up

http://127.0.0.1:8080/pi/5
- Calculates PI from the 5th fractional digit onwards. 

