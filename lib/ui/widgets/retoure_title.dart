import 'package:flutter/material.dart';

import 'package:retoure/model/retoure.dart';

class RetoureTitle extends StatelessWidget {
  final Retoure retoure;
  final double padding;

  RetoureTitle(this.retoure, this.padding);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        // Default value for crossAxisAlignment is CrossAxisAlignment.center.
        // We want to align title and description of recipes left:
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            retoure.name,
            style: Theme.of(context).textTheme.title,
          ),
          // Empty space:
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
