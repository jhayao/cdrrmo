
import 'package:medicare/constants/icons_constants.dart';
class IconModel {
  String icon;
  String title;
  IconModel({required this.icon, required this.title});

  static List<IconModel> icons = [
    IconModel(
        icon: IconsConstants.instance.iconDiscovery,
        title: "Makaleler",
    ),
    IconModel(
      icon: IconsConstants.instance.iconArbitrary,
      title: "Kitaplar",
    ),
    IconModel(
      icon: IconsConstants.instance.iconANearby,
      title: "Ödüllüler",
    ),
    IconModel(
      icon: IconsConstants.instance.iconWordWide,
      title: "Üniversite",
    ),
    IconModel(
      icon: IconsConstants.instance.iconAudioBook,
      title: "Bilimsel",
    ),
    IconModel(
      icon: IconsConstants.instance.iconQuickSearch,
      title: "Dünya Geneli",
    ),
    IconModel(
      icon: IconsConstants.instance.iconMyCountry,
      title: "Enerjik",
    )
  ];
}
