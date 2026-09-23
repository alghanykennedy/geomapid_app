import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

class FeaturePopupCard extends StatelessWidget {
  final Map<String, dynamic> properties;
  final VoidCallback onClose;

  const FeaturePopupCard({
    super.key,
    required this.properties,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final title = properties['NAMA']?.toString() ??
        properties['title']?.toString() ??
        properties['name']?.toString() ??
        'Feature Details';

    final address = properties['ALAMAT']?.toString();
    final district = properties['KECAMATAN']?.toString();
    final regency = properties['KABKOT']?.toString();
    final province = properties['PROVINSI']?.toString();
    final time = properties['WAKTU']?.toString();

    return Card(
      margin: const EdgeInsets.all(AppDimens.paddingMd),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      ),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimens.paddingSm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppDimens.paddingSm),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: onClose,
                ),
              ],
            ),
            const Divider(height: AppDimens.paddingLg),

            // Attributes List
            if (address != null && address.isNotEmpty)
              _buildAttributeRow(
                icon: Icons.map_outlined,
                label: 'Address',
                value: address,
              ),
            if (district != null && district.isNotEmpty)
              _buildAttributeRow(
                icon: Icons.location_city_outlined,
                label: 'Kecamatan / Kab',
                value: regency != null ? '$district, $regency' : district,
              ),
            if (province != null && province.isNotEmpty)
              _buildAttributeRow(
                icon: Icons.public_outlined,
                label: 'Provinsi',
                value: province,
              ),
            if (time != null && time.isNotEmpty)
              _buildAttributeRow(
                icon: Icons.access_time_outlined,
                label: 'Waktu Data',
                value: time,
              ),

            // Additional dynamic key-values if default fields aren't found
            ..._buildExtraProperties(),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.paddingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: AppDimens.paddingSm),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyLarge,
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExtraProperties() {
    final knownKeys = {'NAMA', 'ALAMAT', 'PROVINSI', 'KABKOT', 'KECAMATAN', 'DESA', 'WAKTU'};
    final extras = <Widget>[];

    properties.forEach((key, val) {
      if (!knownKeys.contains(key) && val != null && val.toString().isNotEmpty) {
        extras.add(
          _buildAttributeRow(
            icon: Icons.info_outline,
            label: key,
            value: val.toString(),
          ),
        );
      }
    });

    return extras;
  }
}
