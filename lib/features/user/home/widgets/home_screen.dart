import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/widgets/app_text_feild.dart';
import 'package:rehla/features/user/home/widgets/home_categories_widget.dart';
import 'package:rehla/features/user/home/widgets/home_featured_banner_widget.dart';
import 'package:rehla/features/user/home/widgets/home_header_widgets.dart';
import 'package:rehla/features/user/home/widgets/home_popular_destinations_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          HomeHeaderWidget(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: AppTextField(
              hintText: AppStrings.searchHint,
              type: AppTextFieldType.search,
            ),
          ),

          SizedBox(height: 16),
          HomeFeaturedBannerWidget(),
          SizedBox(height: 16),
          HomeCategoriesWidget(),
          SizedBox(height: 16),
          HomePopularDestinationsWidget(),
          SizedBox(height: 16),
          // const HomePromoBannerWidget(),
        ],
      ),
    );
  }
}
