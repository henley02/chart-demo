import 'package:chart_demo/markdown/latex.dart';
import 'package:chart_demo/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:markdown_widget/config/all.dart';

class MessageContent extends StatelessWidget {
  const MessageContent({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: MarkdownGenerator(
        generators: [
          latexGenerator,
        ],
        inlineSyntaxes: [
          LatexSyntax(),
        ],
      ).buildWidgets(message.content),
    );
  }
}
