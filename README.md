# Flutter Expense Tracker with Google Sheets

Welcome to the Flutter Expense Tracker! This application helps users manage their expenses efficiently while utilizing Google Sheets as a backend to store and retrieve data.

## Features

- **Expense Management**: Add, view, edit, and delete expense records.
- **Google Sheets Integration**: Seamlessly store and fetch expense data from Google Sheets.
- **Intuitive UI**: A user-friendly interface designed with Flutter.

## Prerequisites

Before running this application, ensure you have the following:

1. **Flutter SDK** installed. [Get Flutter](https://flutter.dev/docs/get-started/install)
2. **Google Sheets API** enabled in your Google Cloud project.
3. **API Credentials** file (`credentials.json`) downloaded for Google Sheets API.

## Installation

Follow these steps to set up the project locally:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/usman-29/Expenses-Tracker-Flutter.git
   cd flutter-expense-tracker
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Set up Google Sheets API:**
   - Create a new Google Cloud project or use an existing one.
   - Enable the Google Sheets API.
   - Download the `credentials.json` file and place it in the project directory.

4. **Configure your Google Sheet:**
   - Create a new Google Sheet for expenses.
   - Share the sheet with the email address of the service account from your `credentials.json`.

5. **Run the application:**
   ```bash
   flutter run
   ```

## Usage

1. Launch the application on your device or emulator.
2. Add new expenses by providing the amount, category, and a brief description.
3. View and manage your expense history directly in the app.
4. Data is automatically synced with your configured Google Sheet.

## Contributing

Contributions are welcome! If you would like to contribute to this project, follow these steps:

1. Fork the repository.
2. Create your feature branch: `git checkout -b feature-name`.
3. Commit your changes: `git commit -am 'Add some feature'`.
4. Push to the branch: `git push origin feature-name`.
5. Submit a pull request.

