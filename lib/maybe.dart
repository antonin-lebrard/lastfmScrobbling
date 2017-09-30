/// should not be used anymore
/*String requestToken = "http://ws.audioscrobbler.com/2.0/?method=auth.gettoken&api_key=API_KEY_TO_PLACE_HERE&format=json";

Future<String> getToken(String api_key) async {
  return await http.get(requestToken.replaceFirst(placeholderApiKey, api_key)).then((http.Response resp) => JSON.decode(resp.body)["token"]);
}*/

/// cannot work in command line
/*String requestSession = "http://ws.audioscrobbler.com/2.0/?method=auth.getSession&"
    "api_key=API_KEY_TO_PLACE_HERE&"
    "token=TOKEN_TO_PLACE_HERE&"
    "api_sig=API_SIG_TO_PLACE_HERE&format=json";

Future<String> getSession(String token, String api_key, String api_sig) async {
  return await http.get()
}*/