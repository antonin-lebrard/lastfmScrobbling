part of lastfmScrobbling.lib;


class Album {
  String name;
  String mbid;
  Album(this.name, this.mbid);
  toString() => "{$name : $mbid}";
}

class Track {
  String name;
  int duration;
  Track(this.name, this.duration);
  toString() => "{$name : $duration}";
}