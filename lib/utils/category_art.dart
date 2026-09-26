class CategoryArt {
  static String cleanCategoryName(String name) {
    return name
        .replaceAll('Entertainment: ', '')
        .replaceAll('Science: ', '')
        .trim();
  }

  static String getAssetPath(int id, String name) {
    final lower = name.toLowerCase();

    if (lower.contains('general knowledge')) {
      return 'assets/category_images/general_knowledge.png';
    }
    if (lower.contains('book')) {
      return 'assets/category_images/books.png';
    }
    if (lower == 'entertainment: film' || lower.contains('film') || lower.contains('movie')) {
      return 'assets/category_images/film.png';
    }
    if (lower == 'entertainment: music' || lower.contains('music')) {
      return 'assets/category_images/music.png';
    }
    if (lower.contains('theatre') || lower.contains('musical')) {
      return 'assets/category_images/theatre.png';
    }
    if (lower.contains('television') || lower.contains('tv')) {
      return 'assets/category_images/television.png';
    }
    if (lower.contains('video game')) {
      return 'assets/category_images/video_games.png';
    }
    if (lower.contains('board game')) {
      return 'assets/category_images/board_games.png';
    }
    if (lower.contains('science') || lower.contains('nature')) {
      return 'assets/category_images/science_nature.png';
    }
    if (lower.contains('computer')) {
      return 'assets/category_images/computers.png';
    }
    if (lower.contains('mathematics') || lower.contains('math')) {
      return 'assets/category_images/mathematics.png';
    }
    if (lower.contains('mythology')) {
      return 'assets/category_images/mythology.png';
    }
    if (lower.contains('sport')) {
      return 'assets/category_images/sports.png';
    }
    if (lower.contains('geography')) {
      return 'assets/category_images/geography.png';
    }
    if (lower.contains('history')) {
      return 'assets/category_images/history.png';
    }
    if (lower.contains('politic')) {
      return 'assets/category_images/politics.png';
    }
    if (lower == 'art' || lower.contains(' art')) {
      return 'assets/category_images/art.png';
    }
    if (lower.contains('celebrit')) {
      return 'assets/category_images/celebrities.png';
    }
    if (lower.contains('animal')) {
      return 'assets/category_images/animals.png';
    }
    if (lower.contains('vehicle')) {
      return 'assets/category_images/vehicles.png';
    }
    if (lower.contains('comic')) {
      return 'assets/category_images/comics.png';
    }
    if (lower.contains('gadget')) {
      return 'assets/category_images/gadgets.png';
    }
    if (lower.contains('anime') || lower.contains('manga')) {
      return 'assets/category_images/anime_manga.png';
    }
    if (lower.contains('cartoon') || lower.contains('animation')) {
      return 'assets/category_images/cartoon_animations.png';
    }

    return 'assets/category_images/knowledge_culture.png';
  }
}
