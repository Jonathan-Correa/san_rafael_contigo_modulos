import 'package:csr_design_system/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:csr_design_system/csr_design_system.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show HtmlWidget;

import '/models/blog_or_new.dart';

final boldTags = ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'strong'];

class NewsDetailContent extends StatelessWidget {
  const NewsDetailContent({
    Key? key,
    required this.data,
    required this.onTapUrl,
  }) : super(key: key);

  final BlogOrNew data;
  final Function(String url) onTapUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            margin: const EdgeInsets.only(
              top: 20.0,
              bottom: 50.0,
              left: 30.0,
              right: 30.0,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: CsrConstants.circularRadiusLg,
                topRight: CsrConstants.circularRadiusLg,
              ),
            ),
            child: HtmlWidget(
              data.body,
              customStylesBuilder: (element) {
                if (boldTags.contains(element.localName)) {
                  final color = theme.textTheme.headlineLarge!.color;
                  final red = color!.red;
                  final green = color.green;
                  final blue = color.blue;
                  return {'color': '#$red$green$blue'};
                }

                return null;
              },
              textStyle: H6(
                '',
                bold: false,
                color: ThemeChanger.of(context).isDark
                    ? CsrConstants.darkThemeTextColor
                    : CsrConstants.optionColorGrey,
              ).getTextStyle(context),
              onTapUrl: (url) async {
                try {
                  onTapUrl(url);
                  return true;
                } catch (e) {
                  return false;
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
