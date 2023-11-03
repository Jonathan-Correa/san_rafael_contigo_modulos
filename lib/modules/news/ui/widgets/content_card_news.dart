import 'package:csr_design_system/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:csr_design_system/csr_design_system.dart';

class ContentCardNews extends StatelessWidget {
  final String title;
  final String content;
  final String publishDate;
  final bool isLargeCard;

  const ContentCardNews({
    Key? key,
    required this.title,
    required this.content,
    required this.publishDate,
    required this.isLargeCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleText = Subtitle1(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      color: ThemeChanger.of(context).isDark
          ? CsrConstants.darkThemeTextColor
          : theme.colorScheme.secondary,
    );

    final titleNew = isLargeCard ? Center(child: titleText) : titleText;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: LimitedBox(
        maxHeight: CsrConstants.heightImgSmallCard * 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleNew,
              Flexible(
                child: Caption(
                  content,
                  maxLines: 4,
                  bold: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
