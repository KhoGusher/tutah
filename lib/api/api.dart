import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

class CallApi {
  final String _url = 'http://base/api/';

  prePostData(userData, apiUrl) async {
    try {
      var fullUrl = _url + apiUrl;
      return await http.post(Uri.parse(fullUrl), body: userData);
    } on TimeoutException catch (e) {
    } on SocketException catch (e) {
    } on Error catch (e) {
    }
  }

  postData(userData, apiUrl, token) async {
    // print('about to');
    // print(_getToken());
    try {
      var fullUrl = _url + apiUrl;
      return await http.post(
        Uri.parse(fullUrl),
        body: userData,
        headers: {
          'Content_type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token
        },
      );
    } on TimeoutException catch (e) {
    } on SocketException catch (e) {
    } on Error catch (e) {
    }
  }

  getCommunities(apiUrl) async {
    try {
      var fullUrl = _url + apiUrl;
      return await http.get(
        Uri.parse(fullUrl),
        headers: _setHeader(),
      );
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      print('Socket Error: $e');
    } on Error catch (e) {
      print('General Error: $e');
    }
  }

  getData(apiUrl, token) async {
    try {
      var fullUrl = _url + apiUrl;
      return await http.get(
        Uri.parse(fullUrl),
        headers: {
          'Content_type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token
        },
      );
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      print('Socket Error: $e');
    } on Error catch (e) {
      print('General Error: $e');
    }
  }

  _setHeader() => {
    'Content_type': 'application/json',
    'Accept': 'application/json',
    // 'Authorization': 'Bearer $token'
  };
}
