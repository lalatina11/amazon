// lib/feature/search/widget/highlighted_text.dart
import 'package:flutter/material.dart';

class HighlightedTextWidget extends StatelessWidget {
  final String text;
  final String query;

  const HighlightedTextWidget({
    super.key,
    required this.text,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final matchIndex = lowerText.indexOf(lowerQuery);

    if (matchIndex == -1) {
      return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text.substring(0, matchIndex)),
          TextSpan(
            text: text.substring(matchIndex, matchIndex + query.length),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          TextSpan(text: text.substring(matchIndex + query.length)),
        ],
        style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
