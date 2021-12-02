import 'package:flutter/material.dart';
import 'package:tf/components/backButton.dart';
import 'package:tf/components/header.dart';

class DeliveryScreen extends StatelessWidget {
  static String routeName = '/delivery';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(children: [
                      CustomBackButton(
                          endWidget: Text('Spedizioni e consegne',
                              style: (TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)))),
                      _textCard(
                          context,
                          'SPEDIZIONE GRATUITA PER TUTTI GLI ORDINI SUPERIORI A €100!',
                          Column(children: [
                            _spacer(),
                            _description('''
Altrimenti potrai ricorrere al classico metodo di spedizione: Inserisci i tuoi dati al checkout (controlla di aver inserito correttamente i dati in tutti i campi prima di premere invio!)

Il costo della spedizione è di €8,00 in tutta Italia.
Il tuo pacco impiegherà tra i 2 e i 7 giorni lavorativi (sabato, domenica e festivi esclusi) per arrivare a casa tua!
                                '''),
                          ])),
                      _spacer(),
                      _textCard(
                          context,
                          'CONSEGNA A DOMICILIO SU TARANTO CITTA E TALSANO',
                          Column(children: [
                            _spacer(),
                            _description('''
Se ti trovi a Talsano oppure a Taranto (solo città. Province e zone limitrofe escluse.) puoi ordinare i tuoi capi preferiti e riceverli comodamente a casa tua SENZA COSTI DI SPEDIZIONE AGGIUNTIVI!

Ti basterà spuntare la casella "Spedisci" e nella fase successiva "Consegna a domicilio".

Se ti trovi nelle zone limitrofe, (come il quartiere Tamburi, la città vecchia, il quartiere Paolo VI) il costo della spedizione è di €3,00 (minimo di spesa €20,00).
                                '''),
                          ])),
                      _spacer(),
                      _textCard(
                          context,
                          'RITIRO IN SEDE',
                          Column(children: [
                            _spacer(),
                            _description('''
Se ti trovi vicino a noi, risparmia le spese di spedizione! Vieni personalmente a ritirare i tuoi acquisti in store in Via Borraccino 6/c spuntando al checkout la voce "Ritiro in shop".

Ti basterà presentare un documento d'identità e la tua ricevuta di pagamento con il numero d'ordine!
                                '''),
                          ])),
                    ])))));
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

  Widget _spacer() {
    return SizedBox(height: 20);
  }
}
