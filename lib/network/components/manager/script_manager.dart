/*
 * Copyright 2023 Hongen Wang All rights reserved.
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
import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:proxypin/network/http/http.dart';
import 'package:proxypin/network/util/logger.dart';
import 'package:proxypin/network/util/random.dart';
import 'package:proxypin/ui/component/device.dart';
import 'package:path_provider/path_provider.dart';

import '../js/script_engine.dart';

/// @author wanghongen
/// 2023/10/06
/// js脚本
class ScriptManager {
  static String template = """
// 在请求到达服务器之前,调用此函数,您可以在此处修改请求数据
// e.g. Add/Update/Remove：Queries、Headers、Body
async function onRequest(context, request) {
  console.log(request.url);
  //Update or add Header
  //request.headers["X-New-Headers"] = "My-Value";
  
  // Update Body use fetch API request，具体文档可网上搜索fetch API
  //request.body = await fetch('https://www.baidu.com/').then(response => response.text());
  return request;
}

//You can modify the Response Data here before it goes to the client
async function onResponse(context, request, response) {
   //Update or add Header
  // response.headers["Name"] = "Value";
  // response.statusCode = 200;

  //var body = JSON.parse(response.body);
  //body['key'] = "value";
  //response.body = JSON.stringify(body);
  return response;
}
  """;

  static String separator = Platform.pathSeparator;
  static ScriptManager? _instance;
  bool enabled = true;
  List<ScriptItem> list = [];

  final Map<ScriptItem, String> _scriptMap = {};

  static late JavascriptRuntime flutterJs;

  static String? deviceId;

  static final List<LogHandler> _logHandlers = [];

  ScriptManager._();

  ///单例
  static Future<ScriptManager> get instance async {
    if (_instance == null) {
      _instance = ScriptManager._();
      await _instance?.reloadScript();
      flutterJs = await JavaScriptEngine.getJavaScript(consoleLog: consoleLog);
      deviceId = await DeviceUtils.deviceId();

      logger.d('init script manager $deviceId');
    }
    return _instance!;
  }

  static void registerConsoleLog(int fromWindowId) {
    LogHandler logHandler = LogHandler(
        channelId: fromWindowId,
        handle: (logInfo) {
          DesktopMultiWindow.invokeMethod(fromWindowId, "consoleLog", logInfo.toJson()).onError((e, t) {
            logger.e("consoleLog error: $e");
            removeLogHandler(fromWindowId);
          });
        });
    registerLogHandler(logHandler);
  }

  static void registerLogHandler(LogHandler logHandler) {
    if (!_logHandlers.any((it) => it.channelId == logHandler.channelId)) _logHandlers.add(logHandler);
  }

  static void removeLogHandler(int channelId) {
    _logHandlers.removeWhere((element) => channelId == element.channelId);
  }

  static dynamic consoleLog(dynamic args) async {
    if (_logHandlers.isEmpty) {
      return;
    }

    var level = args.removeAt(0);
    String output = args.join(' ');
    if (level == 'info') level = 'warn';
    LogInfo logInfo = LogInfo(level, output);
    for (int i = 0; i < _logHandlers.length; i++) {
      _logHandlers[i].handle.call(logInfo);
    }
  }

  ///重新加载脚本
  Future<void> reloadScript() async {
    List<ScriptItem> scripts = [];
    var file = await _path;
    logger.d("reloadScript ${file.path}");

    if (await file.exists()) {
      var content = await file.readAsString();
      if (content.isEmpty) {
        return;
      }
      var config = jsonDecode(content);
      enabled = config['enabled'] == true;
      for (var entry in config['list']) {
        scripts.add(ScriptItem.fromJson(entry));
      }
    }
    list = scripts;
    _scriptMap.clear();
  }

  static String? _homePath;

  static Future<String> homePath() async {
    if (_homePath != null) {
      return _homePath!;
    }

    if (Platform.isMacOS) {
      _homePath = await DesktopMultiWindow.invokeMethod(0, "getApplicationSupportDirectory");
    } else {
      _homePath = await getApplicationSupportDirectory().then((it) => it.path);
    }
    return _homePath!;
  }

  static Future<File> get _path async {
    final path = await homePath();
    var file = File('$path${separator}script.json');
    if (!await file.exists()) {
      await file.create();
    }
    return file;
  }

  Future<String> getScript(ScriptItem item) async {
    if (_scriptMap.containsKey(item)) {
      return _scriptMap[item]!;
    }
    final home = await homePath();
    var script = await File(home + item.scriptPath!).readAsString();
    _scriptMap[item] = script;
    return script;
  }

  ///添加脚本
  Future<void> addScript(ScriptItem item, String script) async {
    final path = await homePath();
    String scriptPath = "${separator}scripts$separator${RandomUtil.randomString(16)}.js";
    var file = File(path + scriptPath);
    await file.create(recursive: true);
    file.writeAsString(script);
    item.scriptPath = scriptPath;
    list.add(item);
    _scriptMap[item] = script;
  }

  ///更新脚本
  Future<void> updateScript(ScriptItem item, String script) async {
    if (_scriptMap[item] == script) {
      return;
    }
    final home = await homePath();
    File(home + item.scriptPath!).writeAsString(script);
    _scriptMap[item] = script;
  }

  ///删除脚本
  Future<void> removeScript(int index) async {
    var item = list.removeAt(index);
    final home = await homePath();
    File(home + item.scriptPath!).delete();
  }

  Future<void> clean() async {
    while (list.isNotEmpty) {
      var item = list.removeLast();
      final home = await homePath();
      File(home + item.scriptPath!).delete();
    }
    await flushConfig();
  }

  ///刷新配置
  Future<void> flushConfig() async {
    await _path.then((value) => value.writeAsString(jsonEncode({'enabled': enabled, 'list': list})));
  }

  Map<dynamic, dynamic> scriptSession = {};

  ///脚本上下文
  Map<String, dynamic> scriptContext(ScriptItem item) {
    return {'scriptName': item.name, 'os': Platform.operatingSystem, 'session': scriptSession, "deviceId": deviceId};
  }

  ///运行脚本
  Future<HttpRequest?> runScript(HttpRequest request) async {
    if (!enabled) {
      return request;
    }
    var url = request.domainPath;
    for (var item in list) {
      if (item.enabled && item.match(url)) {
        var context = jsonEncode(scriptContext(item));
        var jsRequest = jsonEncode(await JavaScriptEngine.convertJsRequest(request));
        String script = await getScript(item);
        var jsResult = await flutterJs.evaluateAsync(
            """var request = $jsRequest, context = $context;  request['scriptContext'] = context; $script\n  onRequest(context, request)""");
        var result = await JavaScriptEngine.jsResultResolve(flutterJs, jsResult);
        if (result == null) {
          return null;
        }
        request.attributes['scriptContext'] = result['scriptContext'];
        scriptSession = result['scriptContext']['session'] ?? {};
        request = JavaScriptEngine.convertHttpRequest(request, result);
      }
    }
    return request;
  }

  ///运行脚本
  Future<HttpResponse?> runResponseScript(HttpResponse response) async {
    if (!enabled || response.request == null) {
      return response;
    }

    var request = response.request!;
    var url = request.domainPath;
    for (var item in list) {
      if (item.enabled && item.match(url)) {
        var context = jsonEncode(request.attributes['scriptContext'] ?? scriptContext(item));
        var jsRequest = jsonEncode(await JavaScriptEngine.convertJsRequest(request));
        var jsResponse = jsonEncode(await JavaScriptEngine.convertJsResponse(response));
        String script = await getScript(item);
        var jsResult = await flutterJs.evaluateAsync(
            """var response = $jsResponse, context = $context;  response['scriptContext'] = context; $script
            \n  onResponse(context, $jsRequest, response);""");
        // print("response: ${jsResult.isPromise} ${jsResult.isError} ${jsResult.rawResult}");
        var result = await JavaScriptEngine.jsResultResolve(flutterJs, jsResult);
        if (result == null) {
          return null;
        }
        scriptSession = result['scriptContext']['session'] ?? {};
        response = JavaScriptEngine.convertHttpResponse(response, result);
      }
    }
    return response;
  }
}

class LogHandler {
  final int channelId;
  final Function(LogInfo logInfo) handle;

  LogHandler({required this.channelId, required this.handle});
}

class LogInfo {
  final DateTime time;
  final String level;
  final String output;

  LogInfo(this.level, this.output, {DateTime? time}) : time = time ?? DateTime.now();

  factory LogInfo.fromJson(Map<String, dynamic> json) {
    return LogInfo(json['level'], json['output'], time: DateTime.fromMillisecondsSinceEpoch(json['time']));
  }

  Map<String, dynamic> toJson() {
    return {'time': time.millisecondsSinceEpoch, 'level': level, 'output': output};
  }

  @override
  String toString() {
    return '{time: $time, level: $level, output: $output}';
  }
}

class ScriptItem {
  bool enabled = true;
  String? name;
  List<String> urls;
  String? scriptPath;
  List<RegExp?>? urlRegs;

  ScriptItem(this.enabled, this.name, dynamic urls, {this.scriptPath})
      : urls = urls is String
            ? (urls.contains(',') ? urls.split(',').map((e) => e.trim()).toList() : [urls])
            : (urls is List<String> ? urls : <String>[]);

  // 匹配url，任意一个规则匹配即可
  bool match(String url) {
    urlRegs ??= urls.map((u) => RegExp(u.replaceAll("*", ".*"))).toList();
    for (final reg in urlRegs!) {
      if (reg!.hasMatch(url)) return true;
    }
    return false;
  }

  factory ScriptItem.fromJson(Map<dynamic, dynamic> json) {
    final urlField = json['url'];
    List<String> urls;
    if (urlField is List) {
      urls = urlField.cast<String>();
    } else if (urlField is String) {
      urls = urlField.contains(',') ? urlField.split(',').map((e) => e.trim()).toList() : [urlField];
    } else {
      urls = <String>[];
    }
    return ScriptItem(json['enabled'], json['name'], urls, scriptPath: json['scriptPath']);
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'name': name,
      'url': urls.length == 1 ? urls[0] : urls,
      'scriptPath': scriptPath
    };
  }

  @override
  String toString() {
    return 'ScriptItem{enabled: $enabled, name: $name, url: $urls, scriptPath: $scriptPath}';
  }
}
