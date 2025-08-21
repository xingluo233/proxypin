import 'package:flutter/material.dart';
import 'package:proxypin/ui/component/search/search_controller.dart';

class HighlightTextWidget extends StatelessWidget {
  final String text;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final SearchTextController searchController;
  final ScrollController? scrollController;

  const HighlightTextWidget({
    super.key,
    required this.text,
    this.contextMenuBuilder,
    required this.searchController,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: searchController,
      builder: (context, child) {
        final spans = _highlightMatches(context);
        return SelectableText.rich(
          TextSpan(children: spans),
          showCursor: true,
          contextMenuBuilder: contextMenuBuilder,
        );
      },
    );
  }

  List<TextSpan> _highlightMatches(BuildContext context) {
    if (!searchController.shouldSearch()) {
      return [TextSpan(text: text)];
    }

    final pattern = searchController.value.pattern;
    final regex = searchController.value.isRegExp
        ? RegExp(pattern, caseSensitive: searchController.value.isCaseSensitive)
        : RegExp(
            RegExp.escape(pattern),
            caseSensitive: searchController.value.isCaseSensitive,
          );

    final spans = <TextSpan>[];
    int start = 0;
    var allMatches = regex.allMatches(text).toList();
    final currentIndex = searchController.currentMatchIndex.value;
    List<int> matchOffsets = [];
    for (int i = 0; i < allMatches.length; i++) {
      final match = allMatches[i];
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      matchOffsets.add(match.start);
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: TextStyle(
          backgroundColor: i == currentIndex ? Colors.orange : Colors.yellow,
        ),
      ));
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.updateMatchCount(allMatches.length);
      if (scrollController != null && allMatches.isNotEmpty && currentIndex < matchOffsets.length) {
        _scrollToMatch(context, matchOffsets[currentIndex]);
      }
    });

    return spans;
  }

  void _scrollToMatch(BuildContext context, int charOffset) {
    if (scrollController == null) return;
    final textStyle = DefaultTextStyle.of(context).style;
    final span = TextSpan(text: text.substring(0, charOffset), style: textStyle);
    final tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    tp.layout(maxWidth: scrollController!.position.viewportDimension);
    final offset = tp.height;
    scrollController!.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
