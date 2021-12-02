import 'package:flutter/material.dart';

class SortModal extends StatefulWidget {
  SortModal(
      {Key? key,
      required this.setSort,
      required this.selectedSort,
      required this.reverse})
      : super(key: key);

  final Function setSort;
  final bool reverse;
  final String selectedSort;

  @override
  State<SortModal> createState() => _SortModal();
}

class _SortModal extends State<SortModal> {
  @override
  void initState() {
    selectedSort = widget.selectedSort;
    reverse = widget.reverse;
    super.initState();
  }

  final List<String> sortTypes = [
    'TITLE',
    'BEST_SELLING',
    'PRICE',
    'CREATED',
  ];

  final Map<String, String> sortTypeTranslate = {
    'TITLE': 'Titolo',
    'BEST_SELLING': 'Più venduto',
    'PRICE': 'Prezzo',
    'CREATED': 'Più recente',
  };

  // reverse true -> Z A
  // reverse false -> A Z

  String? selectedSort;
  bool? reverse;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...sortTypes
          .map(
            (sortType) => ListTile(
              title: Text(sortTypeTranslate[sortType]!),
              leading: Radio<String>(
                value: sortType,
                groupValue: selectedSort,
                onChanged: (String? value) {
                  setState(() {
                    selectedSort = value;
                  });
                },
              ),
            ),
          )
          .toList(),
      Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: DropdownButton<String>(
        value: _getValue(reverse!),
        items: ['Crescente', 'Decrescente']
            .map((option) =>
                DropdownMenuItem(value: option, child: Text(option)))
            .toList(),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Theme.of(context).primaryColor),
        underline: Container(
          height: 2,
          color: Theme.of(context).primaryColor,
        ),
        onChanged: (String? newValue) {
          setState(() {
            reverse = newValue == 'Decrescente' ? true : false;
          });
        },
      )),
      ElevatedButton(
        onPressed: () => widget.setSort(selectedSort, reverse),
        child: const Text('Conferma'),
      ),
    ]);
  }

  String _getValue(bool reverse) {
    return reverse ? 'Decrescente' : 'Crescente';
  }
}
