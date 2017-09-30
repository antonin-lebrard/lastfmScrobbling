library lastfmScrobbling.lib;

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'dart:io';

part 'objects.dart';
part 'UriNonEncoded.dart';

String placeholderApiKey = "API_KEY_TO_PLACE_HERE";
String placeholderToken = "TOKEN_TO_PLACE_HERE";
String placeholderApiSig = "API_SIG_TO_PLACE_HERE";
String placeholderArtist = "ARTIST_TO_PLACE_HERE";
String placeholderAlbum = "ALBUM_TO_PLACE_HERE";
String placeholderTrack = "TRACK_TO_PLACE_HERE";
String placeholderTime = "TIME_TO_PLACE_HERE";
String placeholderSession = "SESSION_TO_PLACE_HERE";
String placeholderMBID = "MBID_TO_PLACE_HERE";

String apiKey = "";
String secret = "";
String token = "";
String session_id = "";

String requestToken = "http://ws.audioscrobbler.com/2.0/?method=auth.gettoken&api_key=$placeholderApiKey&api_sig=$placeholderApiSig&format=json";

Future<String> getToken(String api_key) async {
  Map getParams = {
    "method": "auth.gettoken",
    "api_key": api_key
  };
  String api_sig = getAPISig(getParams);
  return await http.get(requestToken.replaceFirst(placeholderApiKey, api_key).replaceFirst(placeholderApiSig, api_sig))
      .then((http.Response resp) => JSON.decode(resp.body)["token"]);
}

String requestSessionId = "http://ws.audioscrobbler.com/2.0/?method=auth.getsession&token=$placeholderToken&api_key=$placeholderApiKey&api_sig=$placeholderApiSig&format=json";

Future<String> getSessionId(String api_key, String token) async {
  Map getParams = {
    "method": "auth.getsession",
    "api_key": api_key,
    "token": token
  };
  String api_sig = getAPISig(getParams);
  return await http.get(requestSessionId.replaceFirst(placeholderToken, token).replaceFirst(placeholderApiKey, api_key).replaceFirst(placeholderApiSig, api_sig))
      .then((http.Response resp) {
        print(resp.body);
        return JSON.decode(resp.body)["session"]["key"];
  });
}

String getAPISig(Map<String, String> parameters) {
  String toMd5 = "";
  List<String> sortedKeys = parameters.keys.toList();
  sortedKeys.sort();
  sortedKeys.forEach((String key){
    toMd5 += "$key${parameters[key]}";
  });
  toMd5 += "$secret";
  print(toMd5);
  Digest d = md5.convert(toMd5.codeUnits);
  return d.toString();
}

String requestTopAlbums = "http://ws.audioscrobbler.com/2.0/?method=artist.gettopalbums&" +
    "&artist=$placeholderArtist&" +
    "api_key=$placeholderApiKey&format=json";

Future<Album> searchAlbumOf(String albumName, String artistName, String api_key) async {
  artistName = Uri.encodeFull(artistName);
  int nbPages = 2, page = 0;
  while (page != nbPages) {
    page++;
    String requestUrl = requestTopAlbums.replaceFirst(placeholderArtist, artistName).replaceFirst(placeholderApiKey, api_key);
    requestUrl = "$requestUrl&page=$page";
    print(requestUrl);
    Map json = await http.get(requestUrl).then((http.Response resp) => JSON.decode(resp.body));
    List<Map> albumsJson = json["topalbums"]["album"];
    page = int.parse(json["topalbums"]["@attr"]["page"]);
    nbPages = int.parse(json["topalbums"]["@attr"]["totalPages"]);
    for (int i = 0; i < albumsJson.length; i++) {
      if ((albumsJson[i]["name"] as String).toLowerCase() == albumName.toLowerCase()){
        print(albumsJson[i]);
        return new Album(albumsJson[i]["name"], albumsJson[i]["mbid"]);
      }
    }
  }
  print("album $albumName of $artistName not found");
  return new Future.value(null);
}

String requestTracksOfAlbum = "http://ws.audioscrobbler.com/2.0/?method=album.getinfo&" +
    "artist=$placeholderArtist&" +
    "album=$placeholderAlbum&" +
    "api_key=$placeholderApiKey&format=json";

Future<List<Track>> listTracksOf(String albumName, String artistName, String api_key) async {
  albumName = Uri.encodeFull(albumName);
  artistName = Uri.encodeFull(artistName);
  String requestUrl = requestTracksOfAlbum.replaceFirst(placeholderApiKey, api_key)
                                          .replaceFirst(placeholderArtist, artistName)
                                          .replaceFirst(placeholderAlbum, albumName);
  print(requestUrl);
  Map json = await http.get(requestUrl).then((http.Response resp) => JSON.decode(resp.body));
  List<Map> tracksJson = json["album"]["tracks"]["track"];
  List<Track> tracks = new List();
  tracksJson.forEach((Map trackJson){
    tracks.add(new Track(trackJson["name"], int.parse(trackJson["duration"])));
  });
  return tracks;
}

String requestScrobbleTrack = "http://ws.audioscrobbler.com/2.0/?method=track.scrobble&" +
    "timestamp[0]=$placeholderTime&track[0]=$placeholderTrack&" +
    "album[0]=$placeholderAlbum&artist[0]=$placeholderArtist&" +
    "api_key=$placeholderApiKey&sk=$placeholderSession&api_sig=$placeholderApiSig";

Future scrobbleSong(String artistName, String albumName, String trackName, num timestamp, String api_key, String session_key) async {
  albumName = Uri.encodeFull(albumName);
  artistName = Uri.encodeFull(artistName);
  trackName = Uri.encodeFull(trackName);
  Map postBody = {
    "method"      : "track.scrobble",
    "artist[0]"   : artistName,
    "album[0]"    : albumName,
    "track[0]"    : trackName,
    "timestamp[0]": timestamp.toString(),
    "api_key"     : api_key,
    "sk"          : session_key
  };
  String api_sig = getAPISig(postBody);
  postBody["api_sig"] = api_sig;

  String requestUrl = requestScrobbleTrack
      .replaceFirst(placeholderTime, timestamp.toString())
      .replaceFirst(placeholderTrack, trackName)
      .replaceFirst(placeholderAlbum, albumName)
      .replaceFirst(placeholderArtist, artistName)
      .replaceFirst(placeholderApiKey, api_key)
      .replaceFirst(placeholderSession, session_key)
      .replaceFirst(placeholderApiSig, api_sig);

  String testAuth = "ws.audioscrobbler.com";
  String unencodedPath = "/2.0/?method=track.scrobble&" +
    "timestamp[0]=$placeholderTime&track[0]=$placeholderTrack&" +
    "album[0]=$placeholderAlbum&artist[0]=$placeholderArtist&" +
    "api_key=$placeholderApiKey&sk=$placeholderSession&api_sig=$placeholderApiSig";
  unencodedPath = unencodedPath.replaceFirst(placeholderTime, timestamp.toString())
      .replaceFirst(placeholderTrack, trackName)
      .replaceFirst(placeholderAlbum, albumName)
      .replaceFirst(placeholderArtist, artistName)
      .replaceFirst(placeholderApiKey, api_key)
      .replaceFirst(placeholderSession, session_key)
      .replaceFirst(placeholderApiSig, api_sig);

  Uri u = new Uri.https(testAuth, unencodedPath);

  String truePath = unencodedPath.substring(5);
  LastFmUriNonEncoded l = new LastFmUriNonEncoded(truePath, true);

  var h = new HttpClient();
  h.postUrl(l).then((HttpClientRequest h){

  });

  await http.post(l).then((http.Response resp) => print(resp.body));
  /*print(json);*/
}


