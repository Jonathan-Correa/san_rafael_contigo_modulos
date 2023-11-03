import 'package:flutter/material.dart';
import 'package:csr_design_system/config/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'content_card_news.dart';

class LargeCardNews extends StatelessWidget {
  const LargeCardNews({
    Key? key,
    required this.title,
    required this.image,
    required this.content,
    required this.onPress,
    required this.publishDate,
  }) : super(key: key);

  final String title, image, content, publishDate;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sizeScreen = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: CsrConstants.heightImgSmallCard * 1.35,
        width: sizeScreen.width * 1,
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
        child: ClipRRect(
          borderRadius: CsrConstants.circularBorder,
          child: Column(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.all(CsrConstants.circularRadius8),
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
                      width: sizeScreen.width * 1,
                      height: sizeScreen.width * 0.4,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Flexible(
                child: ContentCardNews(
                  title: title,
                  content: content,
                  publishDate: publishDate,
                  isLargeCard: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
