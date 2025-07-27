/*
 * Copyright 2025 Hongen Wang All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:convert';

import 'package:proxypin/network/components/interceptor.dart';
import 'package:proxypin/network/http/http.dart';
import 'package:proxypin/network/util/file_read.dart';

import 'manager/request_map_manager.dart';

///  RequestRewriteComponent is a component that can rewrite the request before sending it to the server.
/// @author Hongen Wang
class RequestMapInterceptor extends Interceptor {
  static RequestMapInterceptor instance = RequestMapInterceptor._();

  final managerInstance = RequestMapManager.instance;

  RequestMapInterceptor._();

  @override
  Future<HttpResponse?> execute(HttpRequest request) async {
    final manager = await managerInstance;
    if (!manager.enabled) {
      return null;
    }

    return null;
  }

  /// 重写响应
  Future<void> mapLocalResponse(String url, HttpResponse response) async {
    final manager = await RequestMapManager.instance;
    var mapRule = manager.findMatch(url);
    if (mapRule == null) {
      return;
    }

    if (mapRule.type == RequestMapType.script) {
      // var rewriteItems = await manager.getMapItem(rewriteRule);
      // await _replaceResponse(response, item);
    }
  }

  //替换相应
  Future<HttpResponse> _replaceResponse(RequestMapRule rule, RequestMapItem item) async {
    // if (rule.type == RequestMapType.script) {
    //   response.status = HttpStatus.valueOf(item.statusCode!);
    //   return;
    // }

    HttpResponse response = HttpResponse(HttpStatus.valueOf(item.statusCode ?? 200));
    item.headers?.forEach((key, value) {
      response.headers.set(key, value);
    });

    if (item.bodyType == MapBodyType.file.name) {
      if (item.bodyFile == null) return response;
      response.body = await FileRead.readFile(item.bodyFile!);
    } else if (item.body != null) {
      response.body =
          response.charset == 'utf-8' || response.charset == 'utf8' ? utf8.encode(item.body!) : item.body?.codeUnits;
    }
    return response;
  }
}
