// import 'package:dio/dio.dart';
// import 'package:go_router/go_router.dart';
// import 'package:material_ui/material_ui.dart';
// import 'package:rehla/core/constants/app_colors.dart';
// import 'package:rehla/core/data_sourse/api_data_sourse.dart';
// import 'package:rehla/core/routes/route_names.dart';
// import 'package:rehla/core/storage/secure_storage_service.dart';

// class TripFavoriteButton extends StatefulWidget {
//   const TripFavoriteButton({
//     super.key,
//     required this.tripId,
//     this.iconSize = 20,
//     this.showBackground = false,
//   });

//   final String tripId;
//   final double iconSize;
//   final bool showBackground;

//   @override
//   State<TripFavoriteButton> createState() => _TripFavoriteButtonState();
// }

// class _TripFavoriteButtonState extends State<TripFavoriteButton> {
//   final ApiDataSourse _apiDataSource = ApiDataSourse();

//   bool _isFavorite = false;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadFavoriteStatus();
//   }

//   @override
//   void didUpdateWidget(covariant TripFavoriteButton oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.tripId != widget.tripId) {
//       _isFavorite = false;
//       _isLoading = true;
//       _loadFavoriteStatus();
//     }
//   }

//   Future<void> _loadFavoriteStatus() async {
//     final tripId = widget.tripId;
//     try {
//       final isLoggedIn = await SecureStorageService.instance.hasToken();
//       if (!mounted || tripId != widget.tripId) return;
//       if (!isLoggedIn) {
//         setState(() => _isLoading = false);
//         return;
//       }

//       final isFavorite = await _apiDataSource.checkFavorite(tripId);
//       if (!mounted || tripId != widget.tripId) return;
//       setState(() {
//         _isFavorite = isFavorite;
//         _isLoading = false;
//       });
//     } on DioException catch (error) {
//       if (!mounted || tripId != widget.tripId) return;
//       setState(() => _isLoading = false);
//       if (error.response?.statusCode == 401) {
//         _openLogin();
//       } else {
//         _showMessage('تعذر التحقق من حالة المفضلة', true);
//       }
//     } catch (_) {
//       if (!mounted || tripId != widget.tripId) return;
//       setState(() => _isLoading = false);
//       _showMessage('تعذر التحقق من حالة المفضلة', true);
//     }
//   }

//   Future<void> _addFavorite() async {
//     if (_isLoading) return;
//     final tripId = widget.tripId;
//     try {
//       final isLoggedIn = await SecureStorageService.instance.hasToken();
//       if (!mounted || tripId != widget.tripId) return;
//       if (!isLoggedIn) {
//         _openLogin();
//         return;
//       }
//       if (_isFavorite) return;

//       setState(() => _isLoading = true);
//       await _apiDataSource.addFavorite(tripId);
//       if (!mounted || tripId != widget.tripId) return;
//       setState(() {
//         _isFavorite = true;
//         _isLoading = false;
//       });
//       _showMessage('تمت إضافة الرحلة إلى المفضلة', false);
//     } on DioException catch (error) {
//       if (!mounted || tripId != widget.tripId) return;
//       setState(() => _isLoading = false);
//       if (error.response?.statusCode == 401) {
//         _openLogin();
//       } else {
//         _showMessage('تعذر إضافة الرحلة إلى المفضلة', true);
//       }
//     } catch (_) {
//       if (!mounted || tripId != widget.tripId) return;
//       setState(() => _isLoading = false);
//       _showMessage('تعذر إضافة الرحلة إلى المفضلة', true);
//     }
//   }

//   void _openLogin() {
//     context.push<void>(RouteNames.login);
//   }

//   void _showMessage(String message, bool? isError) {
//     ScaffoldMessenger.maybeOf(context)?.showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError != null && isError
//             ? AppColors.error
//             : AppColors.success,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final icon = _isLoading
//         ? SizedBox(
//             width: widget.iconSize,
//             height: widget.iconSize,
//             child: const CircularProgressIndicator(strokeWidth: 2),
//           )
//         : Icon(
//             _isFavorite ? Icons.favorite : Icons.favorite_border,
//             size: widget.iconSize,
//             color: _isFavorite
//                 ? AppColors.error
//                 : widget.showBackground
//                 ? AppColors.primary
//                 : AppColors.textHint,
//           );
//     final button = IconButton(
//       onPressed: _addFavorite,
//       icon: icon,
//       padding: EdgeInsets.zero,
//       constraints: widget.showBackground
//           ? const BoxConstraints(minWidth: 48, minHeight: 48)
//           : const BoxConstraints(minWidth: 32, minHeight: 32),
//       visualDensity: VisualDensity.compact,
//       tooltip: _isFavorite ? 'في المفضلة' : 'إضافة إلى المفضلة',
//     );

//     if (!widget.showBackground) return button;

//     return CircleAvatar(
//       backgroundColor: Colors.white.withValues(alpha: 0.85),
//       child: button,
//     );
//   }
// }
