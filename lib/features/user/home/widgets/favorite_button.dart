import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/features/user/home/cubit/home_cubit.dart';
import 'package:rehla/features/user/home/cubit/home_states.dart';

class FavoriteButton extends StatelessWidget {
  final String tripId;

  const FavoriteButton({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      buildWhen: (previous, current) => current is HomeFavoritesState,
      listenWhen: (previous, current) =>
          current is HomeFavoritesState && current.errorMessage != null,
      listener: (context, state) {
        if (state is HomeFavoritesState && state.errorMessage != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('فشل تحديث المفضلة')));
        }
      },
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();

        final isFavorite = cubit.favoriteTripIds.contains(tripId);
        final isLoading = cubit.favoriteLoadingIds.contains(tripId);

        return IconButton(
          onPressed: isLoading ? null : () => cubit.toggleFavorite(tripId),
          icon: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                  color: isFavorite ? Colors.red : AppColors.textSecondary,
                  size: 20,
                ),
        );
      },
    );
  }
}
