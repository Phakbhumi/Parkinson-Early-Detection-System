class SpiralData {
  final bool isSpiral;
  final List<double> probabilitySpiral;
  final bool isParkinson;
  final List<double> probabilityParkinson;

  SpiralData({
    required this.isSpiral,
    required this.probabilitySpiral,
    required this.isParkinson,
    required this.probabilityParkinson,
  });

  factory SpiralData.fromJson(List<dynamic> jsonList) {
    bool isSpiral = false;
    List<double> probabilitySpiral = [];
    bool isParkinson = false;
    List<double> probabilityParkinson = [];

    for (var item in jsonList) {
      if (item.containsKey('spiral')) {
        isSpiral = item['spiral'] == 1;
        probabilitySpiral = List<double>.from(item['prob_spiral']);
      } else if (item.containsKey('parkinson')) {
        isParkinson = item['parkinson'] == 1;
        probabilityParkinson = List<double>.from(item['prob_parkinson']);
      }
    }
    return SpiralData(
      isSpiral: isSpiral,
      probabilitySpiral: probabilitySpiral,
      isParkinson: isParkinson,
      probabilityParkinson: probabilityParkinson,
    );
  }
}
