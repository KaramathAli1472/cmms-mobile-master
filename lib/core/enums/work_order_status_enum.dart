enum WorkOrderStatusControlEnum {
  backlog(1),
  inProgress(2),
  completed(3),
  closed(5);

  final int controlID;
  const WorkOrderStatusControlEnum(this.controlID);

  static WorkOrderStatusControlEnum fromControlID(int controlID) {
    return WorkOrderStatusControlEnum.values.firstWhere(
      (e) => e.controlID == controlID,
      orElse: () => WorkOrderStatusControlEnum.backlog, // fallback to backlog
    );
  }
}
