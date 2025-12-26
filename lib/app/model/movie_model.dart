class Search {
  Search({
    required this.title,
    required this.year,
    required this.imdbId,
    required this.type,
    required this.poster,
  });

  final String title;
  final String year;
  final String imdbId;
  final String type;
  final String poster;

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      title: json["Title"] ?? "",
      year: json["Year"] ?? "",
      imdbId: json["imdbID"] ?? "",
      type: json["Type"] ?? "",
      poster: json["Poster"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "Title": title,
    "Year": year,
    "imdbID": imdbId,
    "Type": type,
    "Poster": poster,
  };
}
