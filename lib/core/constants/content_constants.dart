class ContentConstants {
  static const String appName = "PenguinRead";
  static const String appTagline = "Read Faster. Retain More.";
  static const String appVersion = "v1.0.0 (Beta)";

  // The "Soul" - Quotes to show on Dashboard
  static const List<String> dailyQuotes = [
    "Reading is to the mind what exercise is to the body. — Joseph Addison",
    "The more that you read, the more things you will know. — Dr. Seuss",
    "A reader lives a thousand lives before he dies. — George R.R. Martin",
    "Once you learn to read, you will be forever free. — Frederick Douglass",
    "Speed reading is not just about speed, it's about efficiency."
  ];

  // The "Brain" - Pro Tips for the bottom of Dashboard
  static const List<Map<String, String>> proTips = [
    {
      "title": "Stop Subvocalization",
      "body":
          "Try not to 'say' the words in your head as you read. This inner voice limits your reading speed to your speaking speed (avg 150 wpm)."
    },
    {
      "title": "Focus on the Red",
      "body":
          "Keep your eyes fixed on the red letter (ORP). Let the words change while your eyes stay still to reduce fatigue."
    },
    {
      "title": "Blink at Breaks",
      "body":
          "Try to blink only when you see a period or comma. This keeps your visual cortex focused during the sentence."
    },
    {
      "title": "Start Slow",
      "body":
          "Don't jump to 500 WPM immediately. Start at 200, get comfortable, then increase by 50 WPM every day."
    }
  ];

  static const String aboutDescription =
      "PenguinRead is a minimalist speed reading tool designed to help you consume content 3x faster using the RSVP (Rapid Serial Visual Presentation) method.\n\n"
      "By eliminating eye movements (saccades), we reduce fatigue and increase retention.";

  static const String githubRepoUrl = "https://github.com/shiks2/penguin-read";
  static const String githubIssuesUrl =
      "https://github.com/shiks2/penguin-read/issues";

  static const String contributeTitle = "Help Build PenguinRead";
  static const String contributeBody =
      "Have a suggestion, found a bug, or want to contribute code? This project is Open Source!";
}
