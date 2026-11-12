import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_assets.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/features/user/home/widgets/destination_card.dart';

class HomePopularDestinationsWidget extends StatelessWidget {
  const HomePopularDestinationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.popularDestinations,
                style: AppTextStyles.titleMedium,
              ),
              Text(
                AppStrings.viewAll,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 200,

          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: [
              DestinationCard(
                image: AppAssets.destLuxor,
                title: 'الغردقة',
                price: '2,450',
              ),
              SizedBox(width: 12),
              DestinationCard(
                image: AppAssets.destDahab,
                title: 'دهب',
                price: '1,850',
              ),
              SizedBox(width: 12),

              DestinationCard(
                image: AppAssets.destLuxor,
                title: 'الأقصر وأسوان',
                price: '3,750',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
