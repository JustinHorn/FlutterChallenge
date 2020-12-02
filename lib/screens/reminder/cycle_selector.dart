import 'package:ReminderApp/cycle.dart';
import 'package:flutter/material.dart';

class CycleSelector extends StatelessWidget {
  Function setCycle;
  Cycle _cycle;

  CycleSelector(this._cycle, this.setCycle);

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: Cycle.values
          .map(
            (cycle) => RaisedButton(
              padding: const EdgeInsets.all(0.0),
              onPressed: () => setCycle(cycle),
              color: cycle == _cycle ? Colors.blue : null,
              child: Container(
                decoration: BoxDecoration(),
                child: Text(cycle.name),
              ),
            ),
          )
          .toList(),
    );
  }
}

setCycle(Cycle cycle) {}
