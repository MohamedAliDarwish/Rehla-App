import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/data_sourse/api_data_sourse.dart';
import 'package:rehla/core/theme/test_styles.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  int _currentStep = 0;
  bool _isLoading = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _coverImageUrlController = TextEditingController();
  final TextEditingController _daysCountController = TextEditingController();

  String? _selectedGovernorate;
  String? _selectedCity;

  final List<String> _governorates = [
    'جنوب سيناء',
    'البحر الأحمر',
    'الأقصر',
    'أسوان',
    'القاهرة',
    'الإسكندرية',
    'مطروح',
  ];

  final List<String> _cities = [
    'شرم الشيخ',
    'دهب',
    'الغردقة',
    'مرسى علم',
    'الأقصر',
    'أسوان',
    'واحة سيوة',
  ];

  final List<Map<String, dynamic>> _steps = const [
    {'title': 'بيانات الرحلة', 'icon': Icons.grid_view_rounded},
    {'title': 'الصور', 'icon': Icons.image_outlined},
    {'title': 'السعر', 'icon': Icons.payments_outlined},
    {'title': 'الأماكن', 'icon': Icons.location_on_outlined},
    {'title': 'مراجعة', 'icon': Icons.check_circle_outline},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    _coverImageUrlController.dispose();
    _daysCountController.dispose();
    super.dispose();
  }

  Future<void> _submitTrip() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى كتابة عنوان الرحلة أولاً'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _currentStep = 0;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final priceVal = double.tryParse(_priceController.text.trim()) ?? 2500.0;
      final capacityVal = int.tryParse(_capacityController.text.trim()) ?? 20;

      final tripData = {
        "title": _titleController.text.trim(),
        "description": _descriptionController.text.trim(),
        "destination": _selectedCity ?? _selectedGovernorate ?? "مصر",
        "from": _selectedGovernorate ?? "القاهرة",
        "price": priceVal,
        "capacity": capacityVal,
        "availableSeats": capacityVal,
        "status": "منشورة",
        "isPublished": true,
        "coverImage": _coverImageUrlController.text.trim().isNotEmpty
            ? _coverImageUrlController.text.trim()
            : "assets/images/dest_hurghada.png",
      };

      await ApiDataSourse().createTrip(tripData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء الرحلة وإرسالها للسيرفر بنجاح!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'فشل في إرسال الرحلة للسيرفر: ${e.toString().replaceAll("Exception: ", "")}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'إنشاء رحلة جديدة',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Horizontal Stepper Bar
              _buildStepperBar(),
              const SizedBox(height: 24),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Header
                      Text(
                        _steps[_currentStep]['title'] as String,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (_currentStep == 0) _buildTripDetailsForm(),
                      if (_currentStep == 1) _buildImagesForm(),
                      if (_currentStep == 2) _buildPriceForm(),
                      if (_currentStep == 3) _buildLocationForm(),
                      if (_currentStep == 4) _buildReviewForm(),
                    ],
                  ),
                ),
              ),

              // Bottom Action Button Container
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: const Color(0xFFE2E8F0).withValues(alpha: 0.8)),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_currentStep < _steps.length - 1) {
                              setState(() {
                                _currentStep++;
                              });
                            } else {
                              _submitTrip();
                            }
                          },
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            _currentStep == _steps.length - 1 ? 'حفظ الرحلة ونشرها' : 'التالي',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepperBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_steps.length, (index) {
          final isSelected = _currentStep == index;
          final isPassed = _currentStep > index;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // Circle Icon
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.primary
                              : (isPassed ? AppColors.primary.withValues(alpha: 0.15) : const Color(0xFFF1F5F9)),
                          border: isPassed
                              ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
                              : null,
                        ),
                        child: Icon(
                          _steps[index]['icon'] as IconData,
                          size: 20,
                          color: isSelected
                              ? Colors.white
                              : (isPassed ? AppColors.primary : const Color(0xFF94A3B8)),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Label
                      Text(
                        _steps[index]['title'] as String,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFF94A3B8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (index < _steps.length - 1)
                  Container(
                    width: 16,
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 18),
                    color: index < _currentStep
                        ? AppColors.primary
                        : const Color(0xFFE2E8F0),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTripDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Trip Name
        Text(
          'اسم الرحلة',
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'مثال: رحلة شرم الشيخ',
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 2. Short Description
        Text(
          'وصف مختصر',
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'اكتب وصفاً مختصراً عن الرحلة...',
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 3. Governorate & City Dropdowns Row
        Row(
          children: [
            // Governorate
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المحافظة',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedGovernorate,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                    hint: const Text(
                      'اختر المحافظة',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    items: _governorates
                        .map((gov) => DropdownMenuItem(
                              value: gov,
                              child: Text(gov, style: const TextStyle(fontSize: 13)),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedGovernorate = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // City
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المدينة',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCity,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                    hint: const Text(
                      'اختر المدينة',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    items: _cities
                        .map((city) => DropdownMenuItem(
                              value: city,
                              child: Text(city, style: const TextStyle(fontSize: 13)),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCity = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildImagesForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'رابط صورة الغلاف',
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _coverImageUrlController,
          decoration: InputDecoration(
            hintText: 'https://example.com/image.jpg (أو اتركها افتراضية)',
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'السعر للفرد (ج.م)',
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'مثال: 2500',
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'السعة الكلية (عدد المقاعد)',
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _capacityController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'مثال: 20',
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مدة الرحلة (عدد الأيام)',
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _daysCountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'مثال: 3',
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.primary, size: 28),
              const SizedBox(width: 10),
              Text(
                'جاهز لحفظ الرحلة ونشرها',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'عنوان الرحلة: ${_titleController.text.isEmpty ? "غير محدد" : _titleController.text}',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'الوجهة: ${_selectedCity ?? _selectedGovernorate ?? "غير محددة"}',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'السعر: ${_priceController.text.isEmpty ? "2,500" : _priceController.text} ج.م',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 12),
          const Text(
            'عند الضغط على "حفظ الرحلة ونشرها"، سيتم إرسال البيانات مباشرة إلى خادم API.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
