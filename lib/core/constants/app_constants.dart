class AppConstants {
  const AppConstants._();

  static const String appName = 'PenguinRead';
  static const int defaultWPM = 300;
  static const int minWPM = 100;
  static const int maxWPM = 1000;

  static const List<Map<String, String>> sampleTexts = [
    {
      'title': 'Alice in Wonderland',
      'text':
          'Alice was beginning to get very tired of sitting by her sister on the bank, and of having nothing to do: once or twice she had peeped into the book her sister was reading, but it had no pictures or conversations in it, "and what is the use of a book," thought Alice "without pictures or conversations?"'
    },
    {
      'title': 'The Tech Revolution',
      'text':
          'Technology is rapidly evolving, reshaping how we live and work. Artificial Intelligence is at the forefront of this revolution, automating complex tasks and providing insights that were previously impossible to obtain. As we move forward, the integration of digital solutions into everyday life will become even more seamless.'
    },
    {
      'title': 'Speed Reading 101',
      'text':
          'Rapid Serial Visual Presentation, or RSVP, is a method of displaying information (generally text) in which the text is displayed word-by-word in a fixed focal position. This allows for reading at much faster speeds by eliminating the need for eye movements.'
    },
  ];
}
