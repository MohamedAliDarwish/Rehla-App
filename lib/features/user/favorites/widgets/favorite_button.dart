import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';
import 'package:rehla/features/user/favorites/cubit/fav_states.dart';
import 'package:rehla/features/user/favorites/cubit/fav_cubit.dart';


class FavoriteButton extends StatelessWidget {
  final TripModel trip;
  final double size;

  const FavoriteButton({super.key, required this.trip, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FavoritesCubit, FavoritesStates, bool>(
      selector: (_) => context.read<FavoritesCubit>().isFavorite(trip.id),
      builder: (context, isFavorite) {
        return IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? AppColors.error : AppColors.primary,
            size: size,
          ),
          onPressed: () async {
            final ok = await context.read<FavoritesCubit>().toggleFavorite(
              trip,
            );
            if (!ok && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تعذر تحديث المفضلة، حاول مرة أخرى'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
        );
      },
    );
  }
}