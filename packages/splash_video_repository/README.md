# Splash Video Repository

A Flutter package for managing splash video content in applications. Uses the repository pattern for clean architecture.

## Features

- Check if a splash video should be shown based on configurable criteria
- Download and cache video from a remote URL
- Track when a video was last shown
- Limit video display to once per day
- Enforce video expiration dates

## Usage

```dart
import 'package:persistent_storage/persistent_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_video_repository/splash_video_repository.dart';

// Initialize shared preferences
final sharedPreferences = await SharedPreferences.getInstance();
  
// Create persistent storage
final storage = PersistentStorage(sharedPreferences: sharedPreferences);
  
// Create splash video storage and repository
final splashVideoStorage = SplashVideoStorage(storage: storage);
final splashVideoRepository = SplashVideoRepository(storage: splashVideoStorage);

// Check if video should be shown
final videoStatus = await splashVideoRepository.checkVideoStatus(
  videoUrl: 'https://example.com/splash.mp4',
  endDate: '2023-12-31', // ISO format date
);

// Check if video is ready to be shown
if (videoStatus.isReady) {
  // Show video using the videoStatus.videoPath
  showSplashVideo(videoStatus.videoPath!);
  
  // After showing the video, mark it as shown
  await splashVideoRepository.markVideoShown();
}
```

## Architecture

The package follows the repository pattern:

1. **SplashVideoRepository**: Central class that manages video display logic
2. **SplashVideoStorage**: Interface for storage operations using persistent_storage
3. **VideoStatus**: Data class representing the status of a splash video

## Additional Information

This package is designed to provide a clean and testable approach to managing splash video content in Flutter applications. 
