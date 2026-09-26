class CategoryArt {
  static String cleanCategoryName(String name) {
    return name
        .replaceAll('Entertainment: ', '')
        .replaceAll('Science: ', '')
        .trim();
  }

  static String getAssetPath(int id, String name) {
    // OpenTDB category IDs are stable. Use IDs first to prevent
    // overlapping name matches (e.g. Music vs Musicals, Science vs Computers).
    const idMap = {
      9: 'general_knowledge.png',
      10: 'books.png',
      11: 'film.png',
      12: 'music.png',
      13: 'theatre.png',
      14: 'television.png',
      15: 'video_games.png',
      16: 'board_games.png',
      17: 'science_nature.png',
      18: 'computers.png',
      19: 'mathematics.png',
      20: 'mythology.png',
      21: 'sports.png',
      22: 'geography.png',
      23: 'history.png',
      24: 'politics.png',
      25: 'celebrities.png',
      26: 'animals.png',
      27: 'vehicles.png',
      29: 'comics.png',
      30: 'gadgets.png',
      31: 'anime_manga.png',
      32: 'cartoon_animations.png',
    };

    final file = idMap[id];
    if (file != null) {
      return 'assets/category_images/$file';
    }

    return 'assets/category_images/knowledge_culture.png';
  }
}
