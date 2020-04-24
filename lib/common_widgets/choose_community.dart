import 'package:flutter/material.dart';

class ChooseCommunity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChooseCommunityState();
}

class _ChooseCommunityState extends State<ChooseCommunity> {
//  List<String> _locations = ['Please choose a location', 'A', 'B', 'C', 'D']; // Option 1
//  String _selectedLocation = 'Please choose a location'; // Option 1
  List<String> _locations = ['A', 'B', 'C', 'D']; // Option 2
  String _selectedLocation; // Option 2

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0),
            ),
            hintText: 'Choose Community',
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 18.0,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedLocation,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _selectedLocation = newValue;
                  state.didChange(newValue);
                });
              },
              items: _locations.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}