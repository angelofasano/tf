import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:tf/components/backButton.dart';

class SizeGuideScreen extends StatelessWidget {
  static String routeName = '/sizeguide';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            CustomBackButton(
                endWidget: Text('Guida alle taglie',
                    style: (TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)))),
            _textCard(
                context,
                'In molti casi troverai scritto Taglia unica (TU)',
                Column(children: [
                  _spacer(),
                  _description(
                      'Si tratta di tutti quei capi, il cui tessuto morbido ed elastico, oppure il taglio standard,  consente di vestire tranquillamente da una S a una L!'),
                  _spacer(),
                  _listElement('Skinny',
                      'Lo troverai scritto tendenzialmente nella descrizione di  pantaloni e jeans. Skinny è quella vestibilità molto aderente, caratterizzata da tele super elastiche e morbide!'),
                  _spacer(),
                  _listElement('Loose fit',
                      'Quella vestibilità molto morbida e larga sulla gamba, caratterizzata da cavallo basso, che non fa le forme! Lo troverai spesso nella descrizione di jeans e pantaloni.')
                ])),
            _spacer(),
            _textCard(
                context,
                'Cosa significa invece OVERSIZE?',
                Column(children: [
                  _spacer(),
                  _description(
                      '''Oversize sono tutti quei capi la cui misura è più grande del normale, che tendono a vestire larghi e comodi! Ciò ti permette di giocare con il tipo di vestibilità in base all'effetto che vuoi ottenere : 

- Scegli una taglia più piccola di quella che prendi normalmente se vuoi una vestibilità regolare.

- Scegli la tua taglia abituale se vuoi la classica vestibilità oversize.

N.B. Il taglio abbondante abbraccerà anche chi indossa taglie più grandi, prestandosi perfettamente su tutti i corpi! 
                      '''),
                ])),
            _spacer(),
            _textCard(
                context,
                'Donna',
                Column(children: [
                  _spacer(),
                  _womanSizeTable(context),
                  _spacer(),
                  _womanShoesTable(context)
                ])),
            _spacer(),
            _textCard(
                context,
                'Uomo',
                Column(children: [
                  _spacer(),
                  _manSizeFitTable(context),
                  _spacer(),
                  _manSizeSkinnyTable(context),
                  _spacer(),
                  _manSizeShirtTable(context)
                ])),
            _spacer(),
            _textCard(
                context,
                'Attenzione',
                Column(children: [
                  _spacer(),
                  _description(
                      'Le misure riportate nelle tabelle sono ORIENTATIVE! Ogni produttore adotta un criterio di taglio differente per cui le misure potrebbero variare rispetto a quelle sopra riportate.'),
                ]))
          ],
        ),
      ))),
    );
  }

  Widget _description(String title) {
    return Text(title, style: TextStyle(), textAlign: TextAlign.justify);
  }

  Widget _textCard(context, String title, Widget text) {
    Color primaryColorDark = Theme.of(context).primaryColorDark;
    return Card(
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(25),
          child: Column(children: [
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 17,
                    color: primaryColorDark,
                    fontWeight: FontWeight.bold)),
            text,
          ])),
    );
  }

  Widget _listElement(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
            flex: 3,
            child: Text('$title: ',
                style: TextStyle(fontWeight: FontWeight.w700))),
        Flexible(flex: 7, child: Text(description))
      ],
    );
  }

  Widget _spacer() {
    return SizedBox(height: 20);
  }

  TableRow _tableSpacer() {
    return TableRow(children: [
      SizedBox(
        height: 8,
      ),
      SizedBox(
        height: 8,
      ),
      SizedBox(
        height: 8,
      )
    ]);
  }

  Widget _womanSizeTable(context) {
    Color primaryColorDark = Theme.of(context).primaryColorDark;
    return Table(
      children: [
        TableRow(children: [
          TableCell(
              child: Text(
            'Gonne/Shorts',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Container(
              child: Text('Taglia',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColorDark)),
              alignment: Alignment.topCenter),
          Container(
              child: Text('Cm',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColorDark)),
              alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('XS-34'), alignment: Alignment.topCenter),
          Container(child: Text('83-87'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('S-36'), alignment: Alignment.topCenter),
          Container(child: Text('87-93'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(
              child: Text(
            'Pantaloni/Jeans',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Container(child: Text('M-38'), alignment: Alignment.topCenter),
          Container(child: Text('93-97'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('L-40'), alignment: Alignment.topCenter),
          Container(child: Text('97-101'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('XL-42'), alignment: Alignment.topCenter),
          Container(child: Text('101-106'), alignment: Alignment.topCenter),
        ]),
      ],
    );
  }

  Widget _womanShoesTable(context) {
    Color primaryColorDark = Theme.of(context).primaryColorDark;
    return Table(
      children: [
        TableRow(children: [
          TableCell(
              child: Text(
            'Scarpe',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Container(
              child: Text('Numero',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColorDark)),
              alignment: Alignment.topCenter),
          Container(
              child: Text('Cm',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColorDark)),
              alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('36'), alignment: Alignment.topCenter),
          Container(child: Text('23'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('37'), alignment: Alignment.topCenter),
          Container(child: Text('24'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('38'), alignment: Alignment.topCenter),
          Container(child: Text('25'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('39'), alignment: Alignment.topCenter),
          Container(child: Text('26'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('40'), alignment: Alignment.topCenter),
          Container(child: Text('27'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('41'), alignment: Alignment.topCenter),
          Container(child: Text('28'), alignment: Alignment.topCenter),
        ]),
      ],
    );
  }

  Widget _manSizeFitTable(context) {
    Color primaryColorDark = Theme.of(context).primaryColorDark;
    return Table(
      children: [
        TableRow(children: [
          TableCell(
              child: Text(
            'Jeans/Pantaloni',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Container(
              child: Text('Taglia',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColorDark)),
              alignment: Alignment.topCenter),
          Container(
              child: Text('Cm',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColorDark)),
              alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(
              child: Text(
            'Loose fit',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Container(child: Text('42'), alignment: Alignment.topCenter),
          Container(child: Text('41-42x95'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('44'), alignment: Alignment.topCenter),
          Container(child: Text('43-44x95'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('46'), alignment: Alignment.topCenter),
          Container(child: Text('45-46x98'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(
              child: Text(
            'Tela rigida',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Container(child: Text('48'), alignment: Alignment.topCenter),
          Container(child: Text('47-48x98'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('50'), alignment: Alignment.topCenter),
          Container(child: Text('49-50x105'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('52'), alignment: Alignment.topCenter),
          Container(child: Text('51-52x105'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('54'), alignment: Alignment.topCenter),
          Container(child: Text('53-54x106'), alignment: Alignment.topCenter),
        ]),
      ],
    );
  }

  Widget _manSizeSkinnyTable(context) {
    Color primaryColorDark = Theme.of(context).primaryColorDark;
    return Table(
      children: [
        TableRow(children: [
          TableCell(
              child: Text(
            'Jeans/Pantaloni',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Container(
              child: Text('Taglia',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColorDark)),
              alignment: Alignment.topCenter),
          Container(
              child: Text('Cm',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColorDark)),
              alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(
              child: Text(
            'Skinny-normale',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Container(child: Text('42'), alignment: Alignment.topCenter),
          Container(child: Text('35-36x99-100'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('44'), alignment: Alignment.topCenter),
          Container(
              child: Text('37-38x100-101'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('46'), alignment: Alignment.topCenter),
          Container(
              child: Text('39-40x101-102'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(
              child: Text(
            'Tela elastica',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Container(child: Text('48'), alignment: Alignment.topCenter),
          Container(
              child: Text('41-42x102-103'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('50'), alignment: Alignment.topCenter),
          Container(
              child: Text('43-44x103-104'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('52'), alignment: Alignment.topCenter),
          Container(
              child: Text('45-46x104-105'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('54'), alignment: Alignment.topCenter),
          Container(
              child: Text('47-48x105-106'), alignment: Alignment.topCenter),
        ]),
      ],
    );
  }

  Widget _manSizeShirtTable(context) {
    Color primaryColorDark = Theme.of(context).primaryColorDark;
    return Table(
      children: [
        TableRow(children: [
          TableCell(
              child: Text(
            'T-shirt/Felpe',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Container(
              child: Text('Taglia',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColorDark)),
              alignment: Alignment.topCenter),
          Container(
              child: Text('Cm',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColorDark)),
              alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('S'), alignment: Alignment.topCenter),
          Container(child: Text('50-51x64'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('M'), alignment: Alignment.topCenter),
          Container(child: Text('52-53x65'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('L'), alignment: Alignment.topCenter),
          Container(child: Text('54-55x66'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('XL'), alignment: Alignment.topCenter),
          Container(child: Text('56-57x67'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('XXL'), alignment: Alignment.topCenter),
          Container(child: Text('58-59x68'), alignment: Alignment.topCenter),
        ]),
        _tableSpacer(),
        TableRow(children: [
          TableCell(child: Text('')),
          Container(child: Text('XXXL'), alignment: Alignment.topCenter),
          Container(child: Text('60-61x69'), alignment: Alignment.topCenter),
        ]),
      ],
    );
  }
}
