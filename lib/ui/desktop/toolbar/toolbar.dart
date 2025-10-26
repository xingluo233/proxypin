/*
 * Copyright 2023 Hongen Wang
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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proxypin/network/bin/server.dart';
import 'package:proxypin/ui/desktop/toolbar/phone_connect.dart';
import 'package:proxypin/ui/desktop/setting/setting.dart';
import 'package:proxypin/ui/desktop/ssl/ssl.dart';
import 'package:proxypin/ui/launch/launch.dart';
import 'package:proxypin/utils/ip.dart';
import 'package:window_manager/window_manager.dart';
import 'package:proxypin/l10n/app_localizations.dart';

import '../request/list.dart';

/// @author wanghongen
/// 2023/10/8
class Toolbar extends StatefulWidget {
  final ProxyServer proxyServer;
  final GlobalKey<DesktopRequestListState> requestListStateKey;

  const Toolbar(this.proxyServer, this.requestListStateKey, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _ToolbarState();
  }
}

class _ToolbarState extends State<Toolbar> {
  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(onKeyEvent);
  }

  bool onKeyEvent(KeyEvent event) {
    if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.escape)) {
      if (ModalRoute.of(context)?.isCurrent == false) {
        Navigator.maybePop(context);
        return true;
      }
    }

    if (HardwareKeyboard.instance.isMetaPressed && event.logicalKey == LogicalKeyboardKey.keyW) {
      windowManager.blur();
      return true;
    }

    if (HardwareKeyboard.instance.isMetaPressed && event.logicalKey == LogicalKeyboardKey.keyQ) {
      windowManager.close();
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(onKeyEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Padding(padding: EdgeInsets.only(left: Platform.isMacOS ? 80 : 20)),
      SocketLaunch(proxyServer: widget.proxyServer, startup: widget.proxyServer.configuration.startup),
      const Padding(padding: EdgeInsets.only(left: 18)),
      IconButton(
          tooltip: localizations.clear,
          icon: const Icon(Icons.delete_outline, size: 21),
          onPressed: () {
            widget.requestListStateKey.currentState?.clean();
          }),
      const Padding(padding: EdgeInsets.only(left: 18)),
      SslWidget(proxyServer: widget.proxyServer), // SSL配置
      const Padding(padding: EdgeInsets.only(left: 18)),
      Setting(proxyServer: widget.proxyServer), // 设置
      const Padding(padding: EdgeInsets.only(left: 18)),
      IconButton(
          tooltip: localizations.mobileConnect,
          icon: const Icon(Icons.phone_iphone_outlined, size: 21),
          onPressed: () async {
            final ips = await localIps(readCache: false);
            phoneConnect(ips, widget.proxyServer.port);
          }),
      const Padding(padding: EdgeInsets.only(left: 10)),
    ]);
  }

  void phoneConnect(List<String> hosts, int port) {
    showDialog(
        context: context,
        builder: (context) {
          return PhoneConnect(proxyServer: widget.proxyServer, hosts: hosts);
        });
  }
}
