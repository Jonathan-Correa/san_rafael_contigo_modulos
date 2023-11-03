import 'dart:async';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:csr_design_system/config/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageCarouselItem<T> {
  final String image;
  final T data;

  const ImageCarouselItem({
    required this.image,
    required this.data,
  });
}

class ImageCarousel<T> extends StatefulWidget {
  const ImageCarousel({
    Key? key,
    required this.items,
    required this.onPressed,
  }) : super(key: key);

  final List<ImageCarouselItem<T>> items;
  final Future<void> Function(ImageCarouselItem) onPressed;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState<T>();
}

class _ImageCarouselState<T> extends State<ImageCarousel> {
  late final StreamController<int> _currentIndexStream;

  @override
  void initState() {
    _currentIndexStream = StreamController();
    super.initState();
  }

  @override
  void dispose() {
    _currentIndexStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            onPageChanged: onPageChanged,
            height: sizeScreen.height * 0.18,
            autoPlayAnimationDuration: const Duration(seconds: 5),
          ),
          items: widget.items.map(
            (ImageCarouselItem item) {
              return InkWell(
                onTap: () => widget.onPressed(item),
                child: CachedNetworkImage(
                  imageUrl: item.image,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      width: sizeScreen.width,
                      margin: EdgeInsets.only(
                        left: sizeScreen.height * 0.025,
                        top: sizeScreen.height * 0.022,
                        right: sizeScreen.height * 0.025,
                        bottom: sizeScreen.height * 0.018,
                      ),
                      decoration: BoxDecoration(
                        color: CsrConstants.optionColorGrey,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                    );
                  },
                ),
              );
            },
          ).toList(),
        ),
        _SliderPositionIndicator(
          items: widget.items,
          currentIndexStream: _currentIndexStream,
        ),
      ],
    );
  }

  void onPageChanged(index, reason) {
    _currentIndexStream.sink.add(index);
  }
}

class _SliderPositionIndicator<T> extends StatelessWidget {
  const _SliderPositionIndicator({
    Key? key,
    required this.items,
    required this.currentIndexStream,
  }) : super(key: key);

  final List<ImageCarouselItem<T>> items;
  final StreamController<int> currentIndexStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: currentIndexStream.stream,
      builder: (context, AsyncSnapshot<int> snapshot) {
        var index = 0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.map((e) {
            return Container(
              width: 12.0,
              height: 12.0,
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              decoration: BoxDecoration(
                border:
                    Border.all(color: CsrConstants.optionColorGrey, width: 1.5),
                shape: BoxShape.circle,
                color: snapshot.data == index++
                    ? CsrConstants.optionColorGrey
                    : Colors.transparent,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
