part of lastfmScrobbling.lib;



class LastFmUriNonEncoded implements Uri {

  bool isHttps = false;
  String unencodedPath = "";

  LastFmUriNonEncoded(this.unencodedPath, [this.isHttps = false]);

  String get authority => "ws.audioscrobbler.com";

  String get path => "/2.0/";

  String get scheme => isHttps ? "https" : "http";

  int get port => isHttps ? 443 : 80;

  String get host => authority;

  String toString(){
    return scheme + "://" + authority + path + unencodedPath;
  }

  UriData get data => null;
  String get fragment => null;
  bool get hasAbsolutePath => null;
  bool get hasScheme => null;
  bool get hasAuthority => null;
  bool get hasEmptyPath => null;
  bool get hasFragment => null;
  bool get hasPort => null;
  bool get hasQuery => null;
  bool get isAbsolute => null;
  String get origin => null;
  List<String> get pathSegments => null;
  String get query => null;
  Map<String, String> get queryParameters => null;
  Map<String, List<String>> get queryParametersAll => null;
  String toFilePath({bool windows}) => null;
  String get userInfo => "";
  Uri normalizePath() => this;
  Uri removeFragment() => this;
  Uri replace({String scheme, String userInfo, String host, int port, String path, Iterable<String> pathSegments, String query, Map<String, dynamic> queryParameters, String fragment}) => this;
  Uri resolve(String reference) => this;
  Uri resolveUri(Uri reference) => this;
}