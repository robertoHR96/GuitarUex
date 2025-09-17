# GuitarUex

GuitarUex is a SwiftUI application for iOS designed for guitar enthusiasts. It allows users to manage their collection of guitars, learn about famous guitarists and bands, and access a built-in guitar tuner. The app also includes a chat feature for users to connect and discuss their passion for music.

## Features

*   **Guitar Collection:** Keep a detailed record of your guitars, including manufacturer, model, and images.
*   **Explore Artists:** Discover information about famous guitarists and their bands.
*   **Guitar Tuner:** A utility to help you tune your guitar accurately.
*   **User Authentication:** Secure login and user management.
*   **Chat:** An in-app chat to connect with other users.

## Project Structure

The project is organized into the following main directories:

-   `GuitarUex/`: Contains the core source code for the application.
    -   `Model/`: Data models for the main entities (Guitar, Guitarist, Band, etc.).
    -   `ModelLogic/`: Business logic and view models.
    -   `Views/`: SwiftUI views for the user interface.
    -   `Interactor/`: Handles data persistence.
    -   `KeyChain/`: Manages user authentication and keychain access.
    -   `Resources/`: Contains static resources like JSON data.

## Technologies Used

*   **SwiftUI:** The user interface is built using Apple's modern declarative framework.
*   **Swift:** The application is written entirely in Swift.
*   **Xcode:** The project is managed and built using Xcode.

## How to Build

1.  Clone the repository.
2.  Open `GuitarUex.xcodeproj` in Xcode.
3.  Select a simulator or a connected iOS device.
4.  Click the "Run" button to build and launch the application.
