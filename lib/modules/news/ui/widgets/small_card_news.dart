import 'package:flutter/material.dart';
import 'package:csr_design_system/config/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'content_card_news.dart';

class SmallCardNews extends StatelessWidget {
  const SmallCardNews({
    Key? key,
    required this.title,
    required this.image,
    required this.content,
    required this.press,
    required this.publishDate,
  }) : super(key: key);

  final String title, image, content, publishDate;
  final void Function()? press;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        borderRadius: CsrConstants.circularBorder,
        border: Border.all(width: 0.07, color: theme.shadowColor),
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 7.0,
            offset: const Offset(0, 0),
            color: theme.shadowColor,
          ),
        ],
      ),
      height: size.height * 0.15,
      child: InkWell(
        onTap: press,
        highlightColor: theme.scaffoldBackgroundColor,
        child: Row(
          children: [
            SizedBox(
              height: size.height * 0.23,
              width: size.height * 0.2,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  CsrConstants.circularRadius8,
                ),
                child: CachedNetworkImage(
                  imageUrl: image,
                  errorWidget: (context, url, error) {
                    return Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.all(0),
                      child: Image.asset(
                        'assets/images/logo_csr_big.png',
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                  imageBuilder: (context, imageProvider) {
                    return Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ContentCardNews(
                title: title,
                content: content,
                publishDate: publishDate,
                isLargeCard: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
