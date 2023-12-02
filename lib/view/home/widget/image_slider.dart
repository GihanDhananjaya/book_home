import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../entity/image_slider_entity.dart';
import '../../../utils/app_images.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  List<ImageSliderEntity> imageList = [
    ImageSliderEntity(image: AppImages.appAd7, name: ''),
    ImageSliderEntity(image: AppImages.appAd10, name: ''),
    ImageSliderEntity(image: AppImages.appAd5, name: ''),
    ImageSliderEntity(image: AppImages.appAd9, name: ''),
    // Add more image paths here
  ];

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: imageList.map((ImageSliderEntity imageSliderEntity) {
            return Container(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  imageSliderEntity.image,
                  fit: BoxFit.fill,
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 19 / 9,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            pauseAutoPlayOnTouch: true,
            autoPlayInterval: Duration(seconds: 3),
            onPageChanged: (index, reason) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),

        _buildSlideCircle(),
      ],
    );
  }

  Widget _buildSlideCircle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        imageList.length,
            (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
