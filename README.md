FAZ Flutter Application

A modern Flutter application implementing a Notes Mini-App, Posts API Viewer, and Dynamic Theme Playground. The project follows MVVM architecture and Material 3 design principles for a responsive, aesthetic, and accessible UI.

Table of Contents

Features

Architecture & Decisions

Setup

Folder Structure

How to Operate

Technologies Used

Features
1. Notes Mini-App (Offline + Undo)

Add, edit, and delete notes (title + description).

Undo deletion via SnackBar.

Persist notes locally using Hive.

Validation prevents empty titles.

Modern, responsive note cards.

2. Posts API Viewer (Paged + Retry)

Fetch posts from JSONPlaceholder
.

Styled cards with title and preview of the body.

Loading state with shimmer skeletons.

Error handling with retry button.

Paging with “Load More” button or infinite scroll.

3. Theme Playground (Dynamic)

Toggle between light and dark mode.

Switch between 4 preset seed colors.

Theme choice is persisted across app restarts.

UI updates instantly across all screens.

Architecture & Decisions

MVVM Pattern:

View: Flutter widgets in features/*/view

ViewModel: State management in features/*/viewmodel

Repository/Service: Data persistence & API calls in data/repositories & data/services

State Management: ChangeNotifier + Provider

Local Persistence: Hive for notes and SharedPreferences for theme selection.

Material 3: For modern theming, with light & dark modes.

Responsive Design: All UI widgets adapt to different screen sizes.

Error Handling: Robust API error handling, loading skeletons, empty states, retry buttons.

**Setup
Prerequisites**

Flutter >= 3.13.0

Dart >= 3.1.0

How to Operate
Notes Mini-App

Navigate to Notes tab.

Tap + to add a new note.

Tap an existing note to edit.

Swipe or tap delete → SnackBar appears for undo.

Posts Viewer

Navigate to Posts tab.

Pull down to refresh.

Scroll down to load more posts.

On network error, retry button appears.

Theme Playground

Navigate to Settings/Theme tab.

Toggle Light/Dark Mode.

Select one of the preset seed colors.

Changes are saved and persist on app restart.

Technologies Used

Flutter 3.13+

Dart 3.1+

Hive for local storage

Provider for state management

JSONPlaceholder API for posts

Material 3 for modern design

Notes

    All UI is responsive and accessible.

    Undo & theme persistence features are fully implemented.

    App follows clean MVVM architecture with separation of concerns.

video recording link: https://drive.google.com/file/d/1KKlb-mnebg9LuxpKoYrYVH5rHM8UJMJv/view?usp=sharing
screenshots link: https://docs.google.com/document/d/1uq5cpsch2OZZJwnL8Tt00jPXhgSjTLcu/edit?usp=drive_link&ouid=108214558321543319144&rtpof=true&sd=true