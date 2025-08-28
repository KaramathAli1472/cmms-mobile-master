enum SectionStepTypeEnum {
  pm(1),
  workOrder(2),
  procedure(3);

  final int value;
  const SectionStepTypeEnum(this.value);

  static SectionStepTypeEnum fromValue(int value) {
    return SectionStepTypeEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SectionStepTypeEnum.pm, // Default fallback
    );
  }
}
