import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csr_design_system/csr_design_system.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '/models/blog_or_new.dart';
import '/modules/news/ui/widgets/new_date_bar.dart';

class NewsDetailHeader extends StatelessWidget {
  const NewsDetailHeader({
    Key? key,
    required this.news,
  }) : super(key: key);

  final BlogOrNew news;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTitleLarge = news.title.length > 70;
    final sizeScreen = MediaQuery.of(context).size;

    const titleShadows = [
      Shadow(
        blurRadius: 1.0,
        color: Colors.grey,
        offset: Offset(1.0, 1.0),
      )
    ];

    return SliverAppBar(
      expandedHeight: sizeScreen.height * 0.4,
      backgroundColor: theme.primaryColor,
      pinned: true,
      stretch: true,
      floating: true,
      leadingWidth: double.infinity,
      leading: Container(
        alignment: Alignment.topLeft,
        child: TextButton.icon(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(
            CSRIcons.angleLeft,
            color: Colors.white,
            size: sizeScreen.width * 0.047,
          ),
          label: const Subtitle1('Volver', color: Colors.white, bold: false),
        ),
      ),
      collapsedHeight: sizeScreen.height * 0.3,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: Stack(
        children: [
          FlexibleSpaceBar(
            stretchModes: const [StretchMode.zoomBackground],
            background: CachedNetworkImage(
              imageUrl: news.picturePath,
              errorWidget: (context, error, stackTrace) {
                return Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(30),
                  child: Image.asset(
                    'assets/images/logo_csr_big.png',
                    fit: BoxFit.contain,
                  ),
                );
              },
              imageBuilder: (context, imageProvider) {
                return Image(
                  fit: BoxFit.cover,
                  image: imageProvider,
                  excludeFromSemantics: true,
                );
              },
            ),
          ),
          Container(
            width: sizeScreen.width,
            height: sizeScreen.width,
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isTitleLarge
                    ? Subtitle2(
                        news.title,
                        center: true,
                        color: Colors.white,
                        shadows: titleShadows,
                      )
                    : Subtitle1(
                        news.title,
                        center: true,
                        color: Colors.white,
                        shadows: titleShadows,
                      ),
              ],
            ),
          ),
          NewDateBar(date: news.date),
        ],
      ),
    );
  }

  BoxDecoration gradiantHeader() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: const [0, 0.6, 1],
        colors: [
          Colors.black.withOpacity(1),
          Colors.black.withOpacity(0.0),
          Colors.black.withOpacity(0)
        ],
      ),
    );
  }
}
