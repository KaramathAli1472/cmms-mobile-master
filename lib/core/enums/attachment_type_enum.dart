enum AttachmentTypeEnum {
  workRequestPhoto(1),
  workOrderPhoto(2),
  assetPhoto(3),
  assetWarranty(4),
  assetAmc(5),
  assetDocuments(6),
  contactPhoto(7),
  procedureStepAttachment(8),
  pmStepAttachment(9),
  workOrderStepAttachment(10);

  final int value;
  const AttachmentTypeEnum(this.value);

  static AttachmentTypeEnum fromValue(int value) {
    return AttachmentTypeEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () =>
          throw ArgumentError('Invalid AttachmentTypeEnum value: $value'),
    );
  }
}
