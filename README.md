<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">

</head>
<body>

  <h1> Movie App (Flutter)</h1>

  <p>
    A Flutter movie browsing application built using the
    <strong>OMDb API</strong>.
    Users can search for movies, view detailed information,
    and access cached data when offline.
  </p>

  <p>
    This project focuses on clean code, StateX state management,
    and a simple MVC-style architecture.
  </p>

  <hr />

<h2> Features</h2>
  <ul>
    <li>Search movies using OMDb API</li>
    <li>View movie details (poster, plot, rating, cast)</li>
    <li>Local caching with SQLite</li>
    <li>State management using StateX</li>
    <li>Cached images for better performance</li>
    <li>Responsive UI using ScreenUtil</li>
  </ul>

  <hr />

<h2> Tech Stack</h2>
  <ul>
    <li>Flutter</li>
    <li>Dart</li>
    <li>StateX</li>
    <li>HTTP</li>
    <li>SQLite (sqflite)</li>
    <li>Cached Network Image</li>
    <li>Flutter ScreenUtil</li>
  </ul>

  <hr />

<h2>📂 Project Structure</h2>

  <pre>
lib/
├── app/
│   ├── config/
│   │   └── app_security.dart
│   └── services/
│       └── api_services.dart
│
├── features/
│   ├── home/
│   │   ├── controller/
│   │   ├── view/
│   │   └── widgets/
│   ├── movie_details/
│   │   ├── controller/
│   │   └── view/
│
├── model/
│   └── movie_model.dart
│
├── services/
│   └── db_helper.dart
│
└── main.dart
  </pre>

  <p>
    The project follows a feature-based structure with clear
    separation between UI, controller, API services,
    and database logic.
  </p>


  <hr />

<h2> How to Run</h2>

  <ol>
    <li>
      Clone the repository
      <pre>git clone https://github.com/FlutterSanjay/Movie_App.git</pre>
    </li>
    <li>
      Install dependencies
      <pre>flutter pub get</pre>
    </li>
    <li>
      Run the app
      <pre>flutter run</pre>
    </li>
  </ol>

  <hr />

<h2> Architecture Notes</h2>
  <ul>
    <li>Controllers manage state and lifecycle using StateX</li>
    <li>API calls are handled in a dedicated service layer</li>
    <li>Database logic is isolated inside DbHelper</li>
    <li>UI widgets are clean and reusable</li>
    <li>No business logic inside widgets</li>
  </ul>

  <hr />









</body>
</html>
