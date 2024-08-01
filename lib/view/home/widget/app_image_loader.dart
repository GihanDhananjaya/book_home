import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../common/app_rectangle_shimmer.dart';
import '../../../utils/app_colors.dart';

class AppImageLoader extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;

  AppImageLoader({required this.image, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width??MediaQuery.of(context).size.width,
      height: height??MediaQuery.of(context).size.height/4,
      imageUrl: image,
      fit: BoxFit.cover,
      placeholderFadeInDuration: const Duration(milliseconds: 300),
      placeholder: (context, url) => RectangleShimmer(
        color: AppColors.fontColorDark,
        width: width??MediaQuery.of(context).size.width,
        height: height??MediaQuery.of(context).size.height/4,
      ),
      errorWidget: (context, url, error) => SizedBox(
        child: Center(
          child: Text(
            'No Image',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.fontColorDark,
            ),
          ),
        ),
      ),
    );
  }
}
