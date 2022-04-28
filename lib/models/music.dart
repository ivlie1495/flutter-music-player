class Music {
  int? artistId;
  String? artistName;
  String? trackName;
  String? previewUrl;
  String? artworkUrl30;
  int? trackTimeMillis;
  double? trackPrice;
  String? releaseDate;

  Music.fromJson(Map<String, dynamic> json)
      : artistId = json['artistId'],
        artistName = json['artistName'],
        trackName = json['trackName'],
        previewUrl = json['previewUrl'],
        artworkUrl30 = json['artworkUrl30'],
        trackTimeMillis = json['trackTimeMillis'],
        trackPrice = json['trackPrice'],
        releaseDate = json['releaseDate'];

  Map<String, dynamic> toJson() {
    return {
      'artistId': artistId,
      'artistName': artistName,
      'trackName': trackName,
      'previewUrl': previewUrl,
      'artworkUrl30': artworkUrl30,
      'trackTimeMillis': trackTimeMillis,
      'trackPrice': trackPrice,
      'releaseDate': releaseDate,
    };
  }
}