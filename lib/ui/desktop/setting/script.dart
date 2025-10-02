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

import 'dart:convert';
import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:proxypin/l10n/app_localizations.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:proxypin/network/components/manager/script_manager.dart';
import 'package:proxypin/network/util/logger.dart';
import 'package:proxypin/ui/component/multi_window.dart';
import 'package:proxypin/ui/component/utils.dart';
import 'package:proxypin/ui/component/widgets.dart';
import 'package:proxypin/utils/lang.dart';

bool _refresh = false;

/// 刷新脚本
Future<void> _refreshScript({bool force = false}) async {
  if (force) {
    _refresh = false;
    await ScriptManager.instance.then((manager) => manager.flushConfig());
    await DesktopMultiWindow.invokeMethod(0, "refreshScript");
  }
  if (_refresh) {
    return;
  }
  _refresh = true;
  Future.delayed(const Duration(milliseconds: 1000), () async {
    _refresh = false;
    await ScriptManager.instance.then((manager) => manager.flushConfig());
    await DesktopMultiWindow.invokeMethod(0, "refreshScript");
  });
}

/// @author wanghongen
/// 2023/10/8
class ScriptWidget extends StatefulWidget {
  final int windowId;

  const ScriptWidget({super.key, required this.windowId});

  @override
  State<ScriptWidget> createState() => _ScriptWidgetState();
}

class _ScriptWidgetState extends State<ScriptWidget> {
  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(onKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(onKeyEvent);
    super.dispose();
  }

  bool onKeyEvent(KeyEvent event) {
    if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.escape) && Navigator.canPop(context)) {
      Navigator.maybePop(context);
      return true;
    }

    if ((HardwareKeyboard.instance.isMetaPressed || HardwareKeyboard.instance.isControlPressed) &&
        event.logicalKey == LogicalKeyboardKey.keyW) {
      HardwareKeyboard.instance.removeHandler(onKeyEvent);
      if (_refresh) {
        _refreshScript(force: true).whenComplete(() => WindowController.fromWindowId(widget.windowId).close());
        return true;
      }
      WindowController.fromWindowId(widget.windowId).close();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        appBar: AppBar(
            title: Text(localizations.script, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            toolbarHeight: 36,
            centerTitle: true),
        body: Padding(
            padding: const EdgeInsets.only(left: 15, right: 10),
            child: futureWidget(
                ScriptManager.instance,
                loading: true,
                (data) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(children: [
                            SizedBox(
                                width: 350,
                                child: ListTile(
                                    title: Text(localizations.enableScript),
                                    subtitle: Text(localizations.scriptUseDescribe),
                                    trailing: SwitchWidget(
                                        value: data.enabled,
                                        scale: 0.8,
                                        onChanged: (value) {
                                          data.enabled = value;
                                          _refreshScript();
                                        }))),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const SizedBox(width: 10),
                                TextButton.icon(
                                    icon: const Icon(Icons.add, size: 18),
                                    onPressed: scriptAdd,
                                    label: Text(localizations.add)),
                                const SizedBox(width: 10),
                                TextButton.icon(
                                  icon: const Icon(Icons.input_rounded, size: 18),
                                  onPressed: import,
                                  label: Text(localizations.import),
                                ),
                                const SizedBox(width: 10),
                                TextButton.icon(
                                  icon: const Icon(Icons.terminal, size: 18),
                                  onPressed: consoleLog,
                                  label: Text(localizations.logger),
                                ),
                              ],
                            )),
                            const SizedBox(width: 15)
                          ]),
                          const SizedBox(height: 5),
                          ScriptList(scripts: data.list, windowId: widget.windowId),
                        ]))));
  }

  void consoleLog() {
    openScriptConsoleWindow();
  }

  //导入js
  Future<void> import() async {
    String? path;
    if (Platform.isMacOS) {
      path = await DesktopMultiWindow.invokeMethod(0, "pickFiles", {
        "allowedExtensions": ['json']
      });
      WindowController.fromWindowId(widget.windowId).show();
    } else {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
      path = result?.files.single.path;
    }

    if (path == null) {
      return;
    }
    try {
      var json = jsonDecode(await File(path).readAsString());
      var scriptManager = (await ScriptManager.instance);
      if (json is List<dynamic>) {
        for (var item in json) {
          var scriptItem = ScriptItem.fromJson(item);
          await scriptManager.addScript(scriptItem, item['script']);
        }
      } else {
        var scriptItem = ScriptItem.fromJson(json);
        await scriptManager.addScript(scriptItem, json['script']);
      }

      _refreshScript();
      if (mounted) {
        FlutterToastr.show(localizations.importSuccess, context);
      }
      setState(() {});
    } catch (e, t) {
      logger.e('导入失败 $path', error: e, stackTrace: t);
      if (mounted) {
        FlutterToastr.show("${localizations.importFailed} $e", context);
      }
    }
  }

  /// 添加脚本
  scriptAdd() async {
    showDialog(barrierDismissible: false, context: context, builder: (_) => const ScriptEdit()).then((value) {
      if (value != null) {
        setState(() {});
      }
    });
  }
}

class ScriptConsoleWidget extends StatefulWidget {
  final int windowId;

  const ScriptConsoleWidget({super.key, required this.windowId});

  @override
  State<ScriptConsoleWidget> createState() => _ScriptConsoleState();
}

class _ScriptConsoleState extends State<ScriptConsoleWidget> {
  final List<LogInfo> logs = [];
  final ScrollController _scrollController = ScrollController();
  bool scrollEnd = true;

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    DesktopMultiWindow.invokeMethod(0, "registerConsoleLog", widget.windowId);
    DesktopMultiWindow.setMethodHandler((call, fromWindowId) async {
      if (call.method == 'consoleLog') {
        setState(() {
          var logInfo = LogInfo(call.arguments['level'], call.arguments['output']);
          logs.add(logInfo);
        });

        if (scrollEnd) {
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
            }
          });
        }
      }
      return "ok";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        appBar: AppBar(
            title: Text(localizations.logger, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            actions: [
              IconButton(
                tooltip: localizations.scrollEnd,
                onPressed: () {
                  setState(() {
                    scrollEnd = !scrollEnd;
                  });
                  if (scrollEnd) {
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  }
                },
                icon: Icon(Icons.update, color: scrollEnd ? Theme.of(context).colorScheme.primary : null),
              ),
              const SizedBox(width: 10),
              IconButton(
                  tooltip: localizations.clear,
                  onPressed: () => setState(() {
                        logs.clear();
                      }),
                  icon: const Icon(Icons.delete)),
              const SizedBox(width: 10)
            ],
            toolbarHeight: 36,
            centerTitle: true),
        body: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.3))),
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            child: ListView.builder(
              itemCount: logs.length,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                Color? color;
                if (logs[index].level == 'error') {
                  color = Colors.red;
                } else if (logs[index].level == 'warn') {
                  color = Colors.orange;
                }

                //脚本日志 样式展示
                return Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Text(logs[index].time.format(), style: const TextStyle(fontSize: 13, color: Colors.grey)),
                        const SizedBox(width: 10),
                        Text(logs[index].level, style: TextStyle(fontSize: 13, color: color)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: SelectableText(logs[index].output, style: TextStyle(fontSize: 13, color: color))),
                      ],
                    ));
              },
            )));
  }
}

/// 编辑脚本
class ScriptEdit extends StatefulWidget {
  final ScriptItem? scriptItem;
  final String? script;
  final String? url;
  final String? title;

  const ScriptEdit({super.key, this.scriptItem, this.script, this.url, this.title});

  @override
  State<StatefulWidget> createState() => _ScriptEditState();
}

class _ScriptEditState extends State<ScriptEdit> {
  late CodeController script;
  late TextEditingController nameController;
  late List<TextEditingController> urlControllers;

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    script = CodeController(language: javascript, text: widget.script ?? ScriptManager.template);
    nameController = TextEditingController(text: widget.scriptItem?.name ?? widget.title);
    final urls = widget.scriptItem?.urls ?? (widget.url != null && widget.url!.isNotEmpty ? [widget.url!] : []);
    urlControllers =
        urls.isNotEmpty ? urls.map((u) => TextEditingController(text: u)).toList() : [TextEditingController()];
  }

  @override
  void dispose() {
    script.dispose();
    nameController.dispose();
    for (final c in urlControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey formKey = GlobalKey<FormState>();
    bool isCN = Localizations.localeOf(context) == const Locale.fromSubtags(languageCode: 'zh');

    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      titlePadding: const EdgeInsets.only(left: 15, top: 5, right: 15),
      title: Row(children: [
        Text(localizations.scriptEdit, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(width: 10),
        Text.rich(TextSpan(
            text: localizations.useGuide,
            style: const TextStyle(color: Colors.blue, fontSize: 14),
            recognizer: TapGestureRecognizer()
              ..onTap = () => DesktopMultiWindow.invokeMethod(
                  0,
                  "launchUrl",
                  isCN
                      ? 'https://gitee.com/wanghongenpin/proxypin/wikis/%E8%84%9A%E6%9C%AC'
                      : 'https://github.com/wanghongenpin/proxypin/wiki/Script'))),
        const Expanded(child: Align(alignment: Alignment.topRight, child: CloseButton()))
      ]),
      actionsPadding: const EdgeInsets.only(right: 10, bottom: 10),
      actions: [
        ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text(localizations.cancel)),
        FilledButton(
            onPressed: () async {
              if (!(formKey.currentState as FormState).validate()) {
                FlutterToastr.show("${localizations.name} URL ${localizations.cannotBeEmpty}", context,
                    position: FlutterToastr.top);
                return;
              }
              final urls = urlControllers.map((c) => c.text.trim()).where((u) => u.isNotEmpty).toSet().toList();
              if (urls.isEmpty) {
                FlutterToastr.show("URL ${localizations.cannotBeEmpty}", context, position: FlutterToastr.top);
                return;
              }
              if (widget.scriptItem == null) {
                var scriptItem = ScriptItem(true, nameController.text, urls);
                await (await ScriptManager.instance).addScript(scriptItem, script.text);
              } else {
                widget.scriptItem?.name = nameController.text;
                widget.scriptItem?.urls = urls;
                widget.scriptItem?.urlRegs = null;
                (await ScriptManager.instance).updateScript(widget.scriptItem!, script.text);
              }
              _refreshScript();
              if (context.mounted) {
                Navigator.of(context).maybePop(true);
              }
            },
            child: Text(localizations.save)),
      ],
      content: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name section
              Card(
                  color: Theme.of(context).colorScheme.surfaceContainerLow.withOpacity(0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: textField("${localizations.name}:", nameController, localizations.pleaseEnter))),
              const SizedBox(height: 10),

              // URLs section
              Card(
                  color: Theme.of(context).colorScheme.surfaceContainerLow.withOpacity(0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          const Text("URL(s):"),
                          const SizedBox(width: 8),
                          IconButton(
                              icon: const Icon(Icons.add_outlined, size: 20),
                              tooltip: localizations.add,
                              onPressed: () {
                                setState(() {
                                  urlControllers.add(TextEditingController());
                                });
                              }),
                          const Spacer(),
                          Text("${urlControllers.length}", style: const TextStyle(fontSize: 12, color: Colors.grey))
                        ]),
                        const SizedBox(height: 6),
                        ...List.generate(
                            urlControllers.length,
                            (i) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: urlControllers[i],
                                    validator: (val) => val?.isNotEmpty == true ? null : "",
                                    keyboardType: TextInputType.url,
                                    decoration: InputDecoration(
                                      hintText: "github.com/api/*",
                                      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                                      contentPadding: const EdgeInsets.all(10),
                                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                                      focusedBorder: focusedBorder(),
                                      isDense: true,
                                      border: const OutlineInputBorder(),
                                    ),
                                  )),
                                  if (urlControllers.length > 1)
                                    IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                        tooltip: localizations.delete,
                                        onPressed: () {
                                          setState(() {
                                            urlControllers[i].dispose();
                                            urlControllers.removeAt(i);
                                          });
                                        }),
                                ])))
                      ]))),
              const SizedBox(height: 10),

              // Script section
              Card(
                  color: Theme.of(context).colorScheme.surfaceContainerLow.withOpacity(0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text("${localizations.script}:", style: const TextStyle(fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Tooltip(
                              message: localizations.copy,
                              child: IconButton(
                                  icon: const Icon(Icons.copy_all_outlined, size: 20),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: script.text));
                                    FlutterToastr.show(localizations.copied, context, position: FlutterToastr.top);
                                  })),
                          Tooltip(
                              message: 'Paste',
                              child: IconButton(
                                  icon: const Icon(Icons.content_paste_go_outlined, size: 19),
                                  onPressed: () async {
                                    final data = await Clipboard.getData('text/plain');
                                    final paste = data?.text;
                                    if (paste == null || paste.isEmpty) return;
                                    final sel = script.selection;
                                    if (sel.isValid) {
                                      final text = script.text;
                                      final start = sel.start;
                                      final end = sel.end;
                                      final newText = text.replaceRange(start, end, paste);
                                      script.value = script.value.copyWith(
                                          text: newText,
                                          selection: TextSelection.collapsed(offset: start + paste.length));
                                    } else {
                                      script.text += paste;
                                    }
                                  })),
                          Tooltip(
                              message: localizations.clear,
                              child: IconButton(
                                  icon: const Icon(Icons.delete_sweep_outlined, size: 22),
                                  onPressed: () {
                                    script.text = '';
                                  })),
                          const SizedBox(width: 5)
                        ]),
                        const SizedBox(height: 5),
                        SizedBox(
                            width: 850,
                            height: 380,
                            child: CodeTheme(
                                data: CodeThemeData(styles: monokaiSublimeTheme),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade900,
                                            border: Border.all(color: Colors.grey.withOpacity(0.2))),
                                        child: SingleChildScrollView(
                                            child: CodeField(
                                          textStyle: const TextStyle(fontSize: 13, color: Colors.white),
                                          controller: script,
                                          gutterStyle: const GutterStyle(width: 50, margin: 0),
                                          onTapOutside: (event) => FocusScope.of(context).unfocus(),
                                        ))))))
                      ])))
            ],
          )),
    );
  }

  Widget textField(String label, TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return Row(children: [
      SizedBox(width: 50, child: Text(label)),
      Expanded(
          child: TextFormField(
        controller: controller,
        validator: (val) => val?.isNotEmpty == true ? null : "",
        keyboardType: keyboardType,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            contentPadding: const EdgeInsets.all(10),
            errorStyle: const TextStyle(height: 0, fontSize: 0),
            focusedBorder: focusedBorder(),
            isDense: true,
            border: const OutlineInputBorder()),
      ))
    ]);
  }

  InputBorder focusedBorder() {
    return OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2));
  }
}

/// 脚本列表
class ScriptList extends StatefulWidget {
  final int windowId;
  final List<ScriptItem> scripts;

  const ScriptList({super.key, required this.scripts, required this.windowId});

  @override
  State<ScriptList> createState() => _ScriptListState();
}

class _ScriptListState extends State<ScriptList> {
  Set<int> selected = {};
  bool isPressed = false;
  Offset? lastPressPosition;

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onSecondaryTap: () {
          if (lastPressPosition == null) {
            return;
          }
          showGlobalMenu(lastPressPosition!);
        },
        onTapDown: (details) {
          if (selected.isEmpty) {
            return;
          }
          if (HardwareKeyboard.instance.isMetaPressed || HardwareKeyboard.instance.isControlPressed) {
            return;
          }
          setState(() {
            selected.clear();
          });
        },
        child: Listener(
            onPointerUp: (event) => isPressed = false,
            onPointerDown: (event) {
              lastPressPosition = event.localPosition;
              if (event.buttons == kPrimaryMouseButton) {
                isPressed = true;
              }
            },
            child: Container(
                padding: const EdgeInsets.only(top: 10),
                height: 530,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2))),
                child: SingleChildScrollView(
                    child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Container(width: 200, padding: const EdgeInsets.only(left: 10), child: Text(localizations.name)),
                    SizedBox(width: 50, child: Text(localizations.enable, textAlign: TextAlign.center)),
                    const VerticalDivider(),
                    const Expanded(child: Text("URL")),
                  ]),
                  const Divider(thickness: 0.5),
                  Column(children: rows(widget.scripts))
                ])))));
  }

  List<Widget> rows(List<ScriptItem> list) {
    var primaryColor = Theme.of(context).colorScheme.primary;

    return List.generate(list.length, (index) {
      return InkWell(
          // onTap: () {
          //   selected[index] = !(selected[index] ?? false);
          //   setState(() {});
          // },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: primaryColor.withOpacity(0.3),
          onDoubleTap: () => showEdit(index),
          onSecondaryTapDown: (details) => showMenus(details, index),
          onHover: (hover) {
            if (isPressed && !selected.contains(index)) {
              setState(() {
                selected.add(index);
              });
            }
          },
          onTap: () {
            if (HardwareKeyboard.instance.isMetaPressed || HardwareKeyboard.instance.isControlPressed) {
              setState(() {
                selected.contains(index) ? selected.remove(index) : selected.add(index);
              });
              return;
            }
            if (selected.isEmpty) {
              return;
            }
            setState(() {
              selected.clear();
            });
          },
          child: Container(
              color: selected.contains(index)
                  ? primaryColor.withOpacity(0.6)
                  : index.isEven
                      ? Colors.grey.withOpacity(0.1)
                      : null,
              height: 30,
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  SizedBox(width: 200, child: Text(list[index].name!, style: const TextStyle(fontSize: 13))),
                  SizedBox(
                      width: 40,
                      child: Transform.scale(
                          scale: 0.6,
                          child: SwitchWidget(
                              value: list[index].enabled,
                              onChanged: (val) {
                                list[index].enabled = val;
                                _refreshScript();
                              }))),
                  const SizedBox(width: 20),
                  Expanded(child: Text(list[index].urls.join(', '), style: const TextStyle(fontSize: 13))),
                ],
              )));
    });
  }

  void showGlobalMenu(Offset offset) {
    showContextMenu(context, offset, items: [
      PopupMenuItem(height: 35, child: Text(localizations.newBuilt), onTap: () => showEdit()),
      PopupMenuItem(height: 35, child: Text(localizations.export), onTap: () => export(selected.toList())),
      const PopupMenuDivider(),
      PopupMenuItem(height: 35, child: Text(localizations.enableSelect), onTap: () => enableStatus(true)),
      PopupMenuItem(height: 35, child: Text(localizations.disableSelect), onTap: () => enableStatus(false)),
      const PopupMenuDivider(),
      PopupMenuItem(height: 35, child: Text(localizations.deleteSelect), onTap: () => removeScripts(selected.toList())),
    ]);
  }

  //点击菜单
  void showMenus(TapDownDetails details, int index) {
    if (selected.length > 1) {
      showGlobalMenu(details.globalPosition);
      return;
    }
    setState(() {
      selected.add(index);
    });

    showContextMenu(context, details.globalPosition, items: [
      PopupMenuItem(height: 35, child: Text(localizations.edit), onTap: () => showEdit(index)),
      PopupMenuItem(height: 35, child: Text(localizations.export), onTap: () => export([index])),
      PopupMenuItem(
          height: 35,
          child: widget.scripts[index].enabled ? Text(localizations.disabled) : Text(localizations.enable),
          onTap: () {
            widget.scripts[index].enabled = !widget.scripts[index].enabled;
            _refreshScript();
          }),
      const PopupMenuDivider(),
      PopupMenuItem(
          height: 35,
          child: Text(localizations.delete),
          onTap: () async {
            var scriptManager = await ScriptManager.instance;
            await scriptManager.removeScript(index);
            _refreshScript();
          }),
    ]).then((value) {
      if (mounted) {
        setState(() {
          selected.remove(index);
        });
      }
    });
  }

  Future<void> showEdit([int? index]) async {
    String? script = index == null ? null : await (await ScriptManager.instance).getScript(widget.scripts[index]);
    if (!mounted) {
      return;
    }

    showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => ScriptEdit(scriptItem: index == null ? null : widget.scripts[index], script: script))
        .then((value) {
      if (value != null) {
        setState(() {});
      }
    });
  }

  //导出js
  Future<void> export(List<int> indexes) async {
    if (indexes.isEmpty) return;
    //文件名称
    String fileName = 'proxypin-scripts.json';
    String? path;
    if (Platform.isMacOS) {
      path = await DesktopMultiWindow.invokeMethod(0, "saveFile", {"fileName": fileName});
      WindowController.fromWindowId(widget.windowId).show();
    } else {
      path = await FilePicker.platform.saveFile(fileName: fileName);
    }
    if (path == null) {
      return;
    }
    var scriptManager = await ScriptManager.instance;
    List<dynamic> json = [];
    for (var idx in indexes) {
      var item = widget.scripts[idx];
      var map = item.toJson();
      map.remove("scriptPath");
      map['script'] = await scriptManager.getScript(item);
      json.add(map);
    }

    await File(path).writeAsBytes(utf8.encode(jsonEncode(json)));
    if (mounted) FlutterToastr.show(localizations.exportSuccess, context);
  }

  void enableStatus(bool enable) {
    for (var idx in selected) {
      widget.scripts[idx].enabled = enable;
    }
    setState(() {});
    _refreshScript();
  }

  Future<void> removeScripts(List<int> indexes) async {
    if (indexes.isEmpty) return;
    showConfirmDialog(context, content: localizations.confirmContent, onConfirm: () async {
      var scriptManager = await ScriptManager.instance;
      for (var idx in indexes) {
        await scriptManager.removeScript(idx);
      }

      setState(() {
        selected.clear();
      });
      _refreshScript();

      if (mounted) FlutterToastr.show(localizations.deleteSuccess, context);
    });
  }
}
