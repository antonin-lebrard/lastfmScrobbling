// Copyright (c) 2016, fandegw. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:lastfmScrobbling/lastfmScrobbling.dart';

String albumName = "";
String artistName = "";

int hour = 9;
int minute = 45;

DateTime time = new DateTime.now();


main(List<String> arguments) async {

  /*token = await getToken(apiKey);
  print(token);*/

  /*session_id = await getSessionId(apiKey, token);
  print(session_id);*/

  //print(getAPISig(apiKey, "auth.getSession", token, secret));
  time.subtract(new Duration(days: 8));
  time = new DateTime(time.year, time.month, time.day, hour, minute, time.second, time.millisecond, time.microsecond);
  //Album a = await searchAlbumOf(albumName, artistName, apiKey);
  List<Track> t = await listTracksOf(albumName, artistName, apiKey);
  print(t);
  scrobbleSong(artistName, albumName, t[0].name, time.toUtc().millisecondsSinceEpoch, apiKey, session_id);
}
