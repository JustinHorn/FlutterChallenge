enum Cycle { once, daily, weekly, monthly }

extension CycleExtension on Cycle {
  String get name {
    switch (this) {
      case Cycle.once:
        return "once";
      case Cycle.daily:
        return "daily";
      case Cycle.weekly:
        return "weekly";
      case Cycle.monthly:
        return "monthly";
      default:
        return "";
    }
  }

  int get id {
    switch (this) {
      case Cycle.once:
        return 1;
      case Cycle.daily:
        return 2;
      case Cycle.weekly:
        return 3;
      case Cycle.monthly:
        return 4;
      default:
        return 0;
    }
  }

  static Cycle getById(int id) {
    print("cycle");
    return Cycle.values.where((element) => element.id == id).first;
  }
}
