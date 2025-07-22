# Flutter To-Do App with Clean Architecture and BLoC

A simple yet robust To-Do list application built with Flutter, using Firebase Firestore as the backend. This project is a practical demonstration of implementing Clean Architecture principles and the BLoC (Business Logic Component) pattern for state management.

## Features

- **Create, Read, Update, Delete (CRUD)** operations for to-do items.
- **Real-time data synchronization** with Firebase Firestore.
- **Scalable and maintainable project structure** based on Clean Architecture.
- **Predictable state management** using the BLoC pattern.
- **Dependency Injection** for decoupled components using `get_it`.

## Project Structure

The project is organized into three core layers as prescribed by Clean Architecture, ensuring a clear separation of concerns.

```
lib/
├── data/
│   ├── datasources/  # Handles direct communication with APIs, databases (Firebase)
│   │   └── todo_remote_data_source.dart
│   ├── models/       # Extends Domain Entities, adds data-specific methods (e.g., fromJson)
│   │   └── todo_model.dart
│   └── repositories/   # Implements the Repository contract from the Domain layer
│       └── todo_repository_impl.dart
├── domain/
│   ├── entities/     # Core business objects (Plain Dart Objects)
│   │   └── todo.dart
│   ├── repositories/ # Abstract contracts for data handling
│   │   └── todo_repository.dart
│   └── usecases/     # Encapsulates a single piece of business logic
│       ├── add_todo.dart
│       ├── delete_todo.dart
│       ├── get_todos.dart
│       └── update_todo.dart
├── presentation/
│   ├── bloc/         # BLoC logic: Events, States, and the BLoC itself
│   │   ├── todo_bloc.dart
│   │   ├── todo_event.dart
│   │   └── todo_state.dart
│   └── pages/        # UI Widgets and Screens
│       └── home_page.dart
├── core/             # Shared code, e.g., error handling (not used in this simple example)
├── firebase_options.dart
├── injection_container.dart # Dependency Injection setup (Service Locator)
└── main.dart              # Application entry point
```

## Architectural Overview

### 1. Domain Layer
- **The Core:** This is the center of the architecture. It contains the business logic (`usecases`), the business objects (`entities`), and the contracts for what the outer layers must implement (`repositories`).
- **Independence:** It has **zero dependencies** on any other layer. It doesn't know about Flutter, Firebase, or how the UI looks.

### 2. Data Layer
- **The How:** This layer is responsible for all data-related operations. It implements the repository contracts defined in the Domain layer.
- **Data Sources:** It fetches data from external sources (Firebase Firestore).
- **Models:** It uses `TodoModel` to convert raw data (from Firestore) into Dart objects that the application can use.

### 3. Presentation Layer
- **The What We See:** This layer contains everything related to the UI.
- **BLoC:** It uses the BLoC pattern to manage the state of the UI. The UI sends events to the BLoC, and the BLoC responds with states that the UI can react to.
- **Widgets:** The Flutter widgets are responsible for rendering the UI based on the current BLoC state and dispatching user-initiated events.

## How It Works: The Flow of Adding a To-Do

1.  **UI (`HomePage`):** The user types a task and taps the "Add" button. This dispatches an `AddTodoRequested` event to the `TodoBloc`.
2.  **BLoC (`TodoBloc`):** The BLoC receives the event and calls the `AddTodo` use case.
3.  **Use Case (`AddTodo`):** The use case calls the `addTodo` method on the `TodoRepository` contract.
4.  **Repository Impl (`TodoRepositoryImpl`):** The repository implementation, which lives in the Data Layer, calls its `TodoRemoteDataSource`.
5.  **Data Source (`TodoRemoteDataSourceImpl`):** The data source executes the actual Firebase command to add a new document to the 'todos' collection.
6.  **Real-time Update:** Because the app is listening to a stream from Firestore, Firebase automatically pushes the new data set.
7.  **Stream to BLoC:** The stream listener in the `TodoBloc` receives the updated list of todos and emits a new `TodoLoadSuccess` state.
8.  **UI Rebuild:** The `BlocBuilder` in `HomePage` receives the new state and rebuilds the `ListView` to display the new to-do item.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- A Firebase project.

### Setup

1.  **Clone the repository:**
    ```sh
    git clone <your-repo-url>
    cd todolist_flutter
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Firebase Configuration:**
    - Create a new Firebase project at [console.firebase.google.com](https://console.firebase.google.com/).
    - Follow the instructions to add a Flutter app to your project.
    - Run the FlutterFire CLI to configure your app:
      ```sh
      flutterfire configure
      ```
    - This will generate a `firebase_options.dart` file with your project's specific credentials.
    - In the Firebase console, go to **Firestore Database**, create a database, and start in **test mode** for this example.

4.  **Run the application:**
    ```sh
    flutter run
    ```

## Key Dependencies

- `flutter_bloc`: For state management.
- `get_it`: For service location / dependency injection.
- `equatable`: For simple value-based object comparison.
- `cloud_firestore`: For interacting with Firebase Firestore.