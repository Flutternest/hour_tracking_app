# Flux - Hour & Pricing Tracker for Drivers

Welcome to the Hour & Pricing Tracker for Drivers! This Flutter application is designed to help drivers track their working hours and calculate their earnings efficiently.

![Splash](https://dummyimage.com/600x400/000/fff&text=FLUX)

## Screenshots

| Screenshot 1 | Screenshot 2 |
|--------------|--------------|
| ![Screenshot 11](https://github.com/Flutternest/hour_tracking_app/blob/main/screenshots/11.jpg?raw=true) | ![Screenshot 12](https://github.com/Flutternest/hour_tracking_app/blob/main/screenshots/12.jpg?raw=true) |
| Screenshot 3 | Screenshot 4 |
| ![Screenshot 3](https://github.com/Flutternest/hour_tracking_app/blob/main/screenshots/3.jpg?raw=true) | ![Screenshot 4](https://github.com/Flutternest/hour_tracking_app/blob/main/screenshots/4.jpg?raw=true) |
| Screenshot 5 | Screenshot 6 |
| ![Screenshot 5](https://github.com/Flutternest/hour_tracking_app/blob/main/screenshots/6.jpg?raw=true) | ![Screenshot 6](https://github.com/Flutternest/hour_tracking_app/blob/main/screenshots/7.jpg?raw=true) |
| Screenshot 7 | Screenshot 8 |
| ![Screenshot 7](https://github.com/Flutternest/hour_tracking_app/blob/main/screenshots/8.jpg?raw=true) | ![Screenshot 8](https://github.com/Flutternest/hour_tracking_app/blob/main/screenshots/9.jpg?raw=true) |
| Screenshot 9 | Screenshot 10 |
| ![Screenshot 9](https://github.com/Flutternest/hour_tracking_app/blob/main/screenshots/10.jpg?raw=true) | ![Screenshot 10](https://github.com/Flutternest/hour_tracking_app/blob/main/screenshots/11.jpg?raw=true) |
| Screenshot 11 |  |
| ![Screenshot 1](https://github.com/Flutternest/hour_tracking_app/blob/main/screenshots/12.jpg?raw=true) 

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Getting Started](#getting-started)
- [Architecture](#architecture)
- [Screenshots](#screenshots)
- [Dependencies](#dependencies)
- [Contributing](#contributing)
- [License](#license)

## Introduction

The Hour & Pricing Tracker for Drivers is a next-generation payroll application tailored for the trucking industry. It allows drivers to log their hours, manage their schedules, and calculate their earnings seamlessly.

## Features

- **Admin Login**: Secure login for administrators to manage driver data.
- **Driver Login**: Secure login for drivers to track their hours and earnings.
- **Real-time Data Sync**: Syncs data with Firebase for real-time updates.
- **User-friendly Interface**: Easy-to-use interface with intuitive navigation.

## Getting Started

To get started with the project, follow these steps:

1. **Clone the repository**:
    ```bash
    git clone https://github.com/Flutternest/hour_tracking_app.git
    cd hour_tracking_app
    ```

2. **Install dependencies**:
    ```bash
    flutter pub get
    ```

3. **Run the application**:
    ```bash
    flutter run
    ```

For more detailed instructions, refer to the [Flutter documentation](https://docs.flutter.dev/).

## Architecture

The application follows the Model-View-Presenter (MVP) architecture pattern, which helps in separating the concerns and making the codebase more maintainable and testable.
Also, the application follows a modular architecture with a focus on maintainability and scalability. Here are the key components:

- **State Management**: Using `hooks_riverpod` for state management.
- **Routing**: Managed by a custom router (`AppRouter`).
- **Firebase Integration**: Utilizes `firebase_core`, `firebase_auth`, and `cloud_firestore` for backend services.
- **Local Storage**: Uses `shared_preferences` for local data storage.

## Dependencies

The project relies on several key dependencies:

- `flutter`: The core framework.
- `hooks_riverpod`: State management.
- `firebase_core`: Firebase core services.
- `firebase_auth`: Firebase authentication.
- `cloud_firestore`: Firestore database.
- `shared_preferences`: Local storage.
- `flutter_svg`: SVG rendering.

For a complete list of dependencies, refer to the [pubspec.yaml](https://github.com/Flutternest/hour_tracking_app/blob/main/pubspec.yaml) file.

## Contributing

We welcome contributions from the community! If you would like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes and commit them (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Create a pull request.