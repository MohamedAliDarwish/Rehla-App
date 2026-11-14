import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_assets.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';
import 'package:rehla/features/user/trip_details/cubit/trip_details_cubit.dart';

class TripImageHeader extends StatefulWidget {
  final TripModel trip;

  const TripImageHeader({super.key, required this.trip});

  @override
  State<TripImageHeader> createState() => _TripImageHeaderState();
}

class _TripImageHeaderState extends State<TripImageHeader> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  List<String> get _allImages {
    final images = <String>[];
    if (widget.trip.coverImage.isNotEmpty) {
      images.add(widget.trip.coverImage);
    }
    for (final img in widget.trip.gallery) {
      if (img.isNotEmpty && !images.contains(img)) {
        images.add(img);
      }
    }
    if (images.isEmpty) {
      images.add(AppAssets.destLuxor);
    }
    return images;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildImage(String imagePath) {
    final isNetwork =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) => Image.asset(
          AppAssets.destLuxor,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = _allImages;
    final cubit = context.watch<TripDetailsCubit>();

    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          // Image PageView
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => _buildImage(images[index]),
          ),

          // Gradient overlay for contrast
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Top Action Bar (Back button + Favorite)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.85),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.85),
                    child: IconButton(
                      icon: Icon(
                        cubit.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: cubit.isFavorite
                            ? AppColors.error
                            : AppColors.primary,
                        size: 20,
                      ),
                      onPressed: () => cubit.toggleFavorite(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Indicators and Rating Badge
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Rating Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star,
                          color: AppColors.secondary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        widget.trip.averageRating.toStringAsFixed(1),
                        style: AppTextStyles.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.trip.reviewsCount > 0) ...[
                        const SizedBox(width: 4),
                        Text(
                          '(${widget.trip.reviewsCount})',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Page Indicator dots
                if (images.length > 1)
                  Row(
                    children: List.generate(
                      images.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _currentPage == index ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.secondary
                              : Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
