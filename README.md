# Smart Trip Planner App

This Flutter app provides an intelligent itinerary planning experience utilizing the Cohere AI API. Users can input a trip description or vision, and the app responds with a detailed multi-day itinerary, which can be refined through a chat interface. Additionally, users can save their generated trip plans locally using Hive for offline access and later review.

## Features

- **Smart Itinerary Generation:** Generate day-wise multi-activity travel plans based on user inputs.
- **Interactive Chat Interface:** Communicate with the AI assistant to refine and customize the itinerary.
- **Richly Styled Output:** Well-formatted and visually clear itinerary display with day-wise plans.
- **Save Trips Locally:** Store multiple trip plans persistently using Hive, accessible anytime.
- **Responsive Design:** Scales across a variety of mobile device screen sizes.
- **Copy, Download, and Refresh Options:** Easy access to managing itinerary details.

## Installation

### Prerequisites

- Flutter SDK installed (version >= 3.x recommended)
- Dart SDK
- Valid [Cohere AI](https://cohere.ai/) API key

### Setup

1. **Clone the repository:**

```bash
git clone
cd smart-trip-planner-app
```

2. **Install dependencies:**

```bash
flutter pub get
```

3. **Configure API Key:**

Replace the placeholder in your code with your actual Cohere API key:

```dart
static const String _apiKey = 'YOUR_COHERE_API_KEY_HERE';
```

4. **Initialize Hive in `main.dart`:**

```dart
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('tripBox');
  runApp(MyApp());
}
```

**Note:** Ensure to include dependencies in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  http: any
  # other dependencies as needed
```

## Application Structure

- **Screens:**

  - `TripPlannerScreen`: Allows users to input their trip vision and generate itineraries.
  - `ItineraryChatPage`: Chat interface for interacting with the AI to refine plans.
  - `SavedTripsPage`: View and manage saved trip plans from local storage.

- **Widgets:**

  - `BotCard`: Displays AI-generated itinerary messages with formatted styles.
  - `UserCard`: Displays user messages in the chat.
  - `InputBar`: Text input field with send button.
  - `BotThinking`: Loading indicator during AI response wait.
  - `ItineraryView`: Renders formatted itinerary JSON into a readable UI.
  - `CreateButton` & `FillBox`: UI elements for user prompts and actions.

- **Data Storage:**
  - **Hive:** Stores all generated trip plans locally under the `tripBox`.

## Usage

1. **Start the app.**
2. **Enter your trip vision description** on the main screen and tap “Create My Itinerary”.
3. Once the itinerary is generated, switch to the chat page to refine your plan interactively.
4. At any point, **save your itinerary** using the save button in the chat page.
5. View all saved trips in the “Saved Trips” section accessible from your app.

## Notes

- All API calls require a valid and active Cohere AI API key.
- Saved trips are stored locally; clearing hive storage will remove saved plans.
- The app is designed to be responsive; however, UI tweaks might be needed for tablets or very small devices.
- API key should be secured during production deployment.

## Contributing

Feel free to fork the repository and open pull requests for improvements or bug fixes. Please report issues via the GitHub issue tracker.

## License

Specify your project license here (e.g., MIT License).

For detailed documentation and API references, visit [Cohere AI Documentation](https://docs.cohere.ai/).

Happy trip planning! 🚀🌍🗺️
