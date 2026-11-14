import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/core/widgets/app_text_feild.dart';
import 'package:rehla/features/user/home/cubit/home_cubit.dart';
import 'package:rehla/features/user/home/widgets/home_categories_widget.dart';
import 'package:rehla/features/user/home/widgets/home_featured_banner_widget.dart';
import 'package:rehla/features/user/home/widgets/home_header_widgets.dart';
import 'package:rehla/features/user/home/widgets/home_popular_destinations_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getHomeData(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<HomeCubit>().getHomeData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HomeHeaderWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: AppTextField(
                hintText: AppStrings.searchHint,
                type: AppTextFieldType.search,
                readOnly: true,
                onTap: () => context.push(RouteNames.filter),
              ),
            ),
            const SizedBox(height: 16),
            const HomeFeaturedBannerWidget(),
            const SizedBox(height: 16),
            const HomeCategoriesWidget(),
            const SizedBox(height: 16),
            const HomePopularDestinationsWidget(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
