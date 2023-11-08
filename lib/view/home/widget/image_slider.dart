
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

import '../../../entity/image_slider_entity.dart';
import '../../../utils/app_images.dart';

class ImageSlider extends StatelessWidget {

  List<ImageSliderEntity> imageList = [
    ImageSliderEntity(image: AppImages.appAd1, name: ''),
    ImageSliderEntity(image: AppImages.appAd2, name: ''),
    ImageSliderEntity(image: AppImages.appAd3, name: ''),
    ImageSliderEntity(image: AppImages.appAd2, name: ''),
   // ImageSliderEntity(image: AppImages.appAd2, name: ''),
    // Add more image paths here
  ];


  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: imageList.map((ImageSliderEntity imageSliderEntity) {
        return Container(
           width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0), // Optional: Add rounded corners
            child: Image.asset(
              imageSliderEntity.image,
              fit: BoxFit.cover, // Adjust the image's fit as needed
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        autoPlay: true, // Set to true for automatic sliding
        aspectRatio: 19 / 9, // Adjust the aspect ratio as needed
        enlargeCenterPage: true, // Set to true for the center image to be larger
        viewportFraction: 1.0, // Adjust the fraction of the viewport to show (0.8 = 80% of the screen width)
        pauseAutoPlayOnTouch: true, // Set to true to pause autoplay on touch
        autoPlayInterval: Duration(seconds: 3), // Adjust the autoplay interval
      ),
    );
  }
}
