enum Cycle { once, minutely, daily, weekly, all_4_weeks }

extension CycleExtension on Cycle {
  String get name {
    switch (this) {
      case Cycle.once:
        return "once";
      case Cycle.minutely:
        return "minutely";
      case Cycle.daily:
        return "daily";
      case Cycle.weekly:
        return "weekly";
      case Cycle.all_4_weeks:
        return "all 4 weeks";
      default:
        return "";
    }
  }

  int get id {
    switch (this) {
      case Cycle.minutely:
        return 5;
      case Cycle.once:
        return 1;
      case Cycle.daily:
        return 2;
      case Cycle.weekly:
        return 3;
      case Cycle.all_4_weeks:
        return 4;
      default:
        return 0;
    }
  }

  Duration getTimeDistance(int x) {
    switch (this) {
      case Cycle.minutely:
        return Duration(minutes: x);
      case Cycle.once:
        return Duration();
      case Cycle.daily:
        return Duration(days: x);
      case Cycle.weekly:
        return Duration(days: 7 * x);
      case Cycle.all_4_weeks:
        return Duration(days: 7 * 4 * x);
      default:
        return Duration();
    }
  }

  static Cycle getById(int id) {
    print("cycle");
    return Cycle.values.where((element) => element.id == id).first;
  }
}
