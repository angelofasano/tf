import 'package:flutter/material.dart';
import 'package:tf/components/backButton.dart';

class SaveMoneyScreen extends StatefulWidget {
  static String routeName = '/savemoney';
  SaveMoneyScreen({Key? key}) : super(key: key);
  @override
  State<SaveMoneyScreen> createState() => SaveMoneyScreenState();
}

class SaveMoneyScreenState extends State<SaveMoneyScreen> {
  List<bool> isPanelExpanded = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(children: [
                      CustomBackButton(
                          endWidget: Text('Resi',
                              style: (TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)))),

                      ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          _panel(context, '1. Consegna della merce ed accettazione', '1', [
                             _description('''
La spedizione è effettuata da parte di “TF Abbigliamento di Antonio Fasano”  (d’ora in avanti, per brevità, solo TF Abbigliamento), quale titolare del sito www.tfabbigliamento.it, dal momento in cui il consumatore riceve l’e-mail di conferma dell’ordine (che, come precisato nella sezione ‘Condizioni di vendita’, viene inviata una volta accertata la ricezione del pagamento da parte di TF Abbigliamento) usualmente nel termine di giorni lavorativi 4 (quattro).

TF Abbigliamento si impegna a fare quanto nelle proprie possibilità al fine di rispettare i tempi di consegna, che si riserva di indicare al momento della spedizione del prodotto (qualora il cliente lo richieda), e comunque, entro giorni lavorativi 30 (trenta).

In caso di mancata esecuzione dell’ordine da parte del venditore, dovuta ad eventuale indisponibilità, anche temporanea, del prodotto acquistato, il venditore fornirà comunicazione scritta all’acquirente con le stesse modalità e provvederà al rimborso delle somme eventualmente già corrispostegli per il pagamento del prodotto.

Qualora la confezione o l’involucro dei prodotti ordinati dovessero giungere a destinazione palesemente danneggiati, l’acquirente è invitato a rifiutare la consegna da parte del vettore/spedizioniere o ad accettarne la consegna “con riserva”.
                                 ''')
                          ]),
                          _spacer(),
                          _panel(context, '2. Costi di spedizione, imposte e tasse', '2', [
                             _description('''
Il prezzo dei prodotti, così come indicato nelle condizioni di vendita, è quello indicato sul sito tfabbigliamento.it al momento dell’effettuazione dell’ordine da parte dell’acquirente. I prezzi sono comprensivi dei costi di imballaggio standard, IVA (qualora applicabile) e di eventuali imposte indirette (qualora applicabili).

Le spese di spedizione saranno invece indicate in sede di esecuzione dell’ordine. Qualora i prodotti debbano essere consegnati in un Paese non appartenente all’Unione Europea, il prezzo totale indicato nell’ordine e ribadito nella conferma dell’ordine, si intende comprensivo di  imposte indirette e al netto di eventuali dazi doganali e di qualsiasi altra imposta sulle vendite che l’acquirente si impegna sin d’ora a versare, se dovute, in aggiunta al prezzo indicato nell’ordine e confermato nella conferma d’ordine, secondo quanto previsto dalle disposizioni di legge del paese in cui i prodotti saranno consegnati. L’utente/acquirente è invitato ad informarsi presso gli organi competenti del proprio Paese di residenza o di destinazione dei prodotti, al fine di ottenere informazioni su eventuali dazi o tasse applicati nel paese di residenza o di destinazione dei prodotti.

La mancata conoscenza da parte dell’acquirente dei costi, oneri, dazi, tasse e/o imposte di cui sopra al momento dell’invio di un ordine al venditore, non potrà costituire causa di risoluzione del contratto e non potrà in alcun modo costituire fonte di addebito dei suddetti oneri al venditore.                                 
                                 ''')
                          ]),
                          _spacer(),
                          _panel(context, '3. Diritto di recesso', '2', [
                             _description('''
Al consumatore è riconosciuto il diritto di recedere dal contratto concluso ai sensi delle presenti condizioni generali di vendita, senza alcuna penalità, entro il termine di giorni 14 (quattordici) di calendario dalla consegna del prodotto o, nel caso di acquisto di più prodotti consegnati separatamente con un solo ordine, da quando è stato consegnato l’ultimo prodotto.

Per esercitare il diritto di recesso, basterà spedire i capi al seguente indirizzo: via Giovanni Borraccino 6 c/d, 74122, Talsano (TA), inserendo all’interno del pacco l'apposito modulo che riceverà tramite email o che potrà scaricare dal link sottostante.

Scarica il modulo di reso qui.

IMPORTANTE:

Nel caso in cui il pacco venga restituito senza modulo di reso, il reso non sarà accettato.

Tutte le spese di spedizione non sono rimborsabili, verrà rimborsato soltanto il valore dei capi.

I rischi e i costi diretti della restituzione dei prodotti saranno a carico del consumatore, salvo che il prodotto non sia oggetto di restituzione perché pervenuto danneggiato, essendo in tale ipotesi i costi a carico di TF Abbigliamento e salva ogni successiva verifica in merito alle cause del danno subito dal prodotto. Qualora i beni restituiti risultino indossati, danneggiati (ad esempio con segno di usura, abrasione, graffi, deformazioni, scollature ecc.), non completi di tutti i loro elementi ed accessori (ivi incluse le etichette, lacci ed ogni altro elemento annesso), delle confezioni ed imballaggi originali e del certificato di garanzia, ove presente, TF Abbigliamento si riserva la facoltà di non procedere con il rimborso. TF Abbigliamento sarà costretta a rifiutare resi comunicati o rispediti in ritardo, o resi di prodotti che non siano nelle stesse condizioni in cui sono stati ricevuti.

In caso di recesso, TF abbigliamento rimborserà i pagamenti ricevuti entro giorni 14 (quattordici) dal momento in cui viene informata della decisione del consumatore di recedere dal contratto, salvo il diritto di trattenere il rimborso sino alla ricezione della merce restituita e previa verifica della stessa. Detti rimborsi saranno effettuati utilizzando lo stesso mezzo di pagamento utilizzato al momento dell’acquisto dal consumatore in caso di pagamento anticipato tramite PayPal o Carta di Credito, salvo che il consumatore non richieda il rimborso con diverso mezzo di accredito oppure voglia ricevere un codice promozionale dell’importo del rimborso da utilizzare entro 14 giorni.

IPOTESI IN CUI IL DIRITTO DI RECESSO È ESPRESSAMENTE ESCLUSO

AI SENSI DELL’ART. 59 DEL DECRETO LEGISLATIVO DEL N. 206/2005 (COSIDDETTO CODICE DEL CONSUMO) E SUCCESSIVE MODIFICHE ED INTEGRAZIONI, IL DIRITTO DI RECESSO È ESPRESSAMENTE ESCLUSO nelle ipotesi in cui il bene venduto sia stato fatto “su misura” o “personalizzato” in base alle scelte del cliente finale.
                                 ''')
                          ]),
                        ],
                      )

//                          ExpansionPanelList(
//                         animationDuration: Duration(milliseconds: 500),
//                         children: [
//                           _panel(
//                               '1. Consegna della merce ed accettazione',
//                               Column(children: [
//                                 _description('''
// La spedizione è effettuata da parte di “TF Abbigliamento di Antonio Fasano”  (d’ora in avanti, per brevità, solo TF Abbigliamento), quale titolare del sito www.tfabbigliamento.it, dal momento in cui il consumatore riceve l’e-mail di conferma dell’ordine (che, come precisato nella sezione ‘Condizioni di vendita’, viene inviata una volta accertata la ricezione del pagamento da parte di TF Abbigliamento) usualmente nel termine di giorni lavorativi 4 (quattro).

// TF Abbigliamento si impegna a fare quanto nelle proprie possibilità al fine di rispettare i tempi di consegna, che si riserva di indicare al momento della spedizione del prodotto (qualora il cliente lo richieda), e comunque, entro giorni lavorativi 30 (trenta).

// In caso di mancata esecuzione dell’ordine da parte del venditore, dovuta ad eventuale indisponibilità, anche temporanea, del prodotto acquistato, il venditore fornirà comunicazione scritta all’acquirente con le stesse modalità e provvederà al rimborso delle somme eventualmente già corrispostegli per il pagamento del prodotto.

// Qualora la confezione o l’involucro dei prodotti ordinati dovessero giungere a destinazione palesemente danneggiati, l’acquirente è invitato a rifiutare la consegna da parte del vettore/spedizioniere o ad accettarne la consegna “con riserva”.
//                                 '''),
//                               ]),
//                               this.isPanelExpanded[0],
//                               context),
//                           _panel(
//                               '2. Costi di spedizione, imposte e tasse',
//                               Column(children: [
//                                 _description('''
// Il prezzo dei prodotti, così come indicato nelle condizioni di vendita, è quello indicato sul sito tfabbigliamento.it al momento dell’effettuazione dell’ordine da parte dell’acquirente. I prezzi sono comprensivi dei costi di imballaggio standard, IVA (qualora applicabile) e di eventuali imposte indirette (qualora applicabili).

// Le spese di spedizione saranno invece indicate in sede di esecuzione dell’ordine. Qualora i prodotti debbano essere consegnati in un Paese non appartenente all’Unione Europea, il prezzo totale indicato nell’ordine e ribadito nella conferma dell’ordine, si intende comprensivo di  imposte indirette e al netto di eventuali dazi doganali e di qualsiasi altra imposta sulle vendite che l’acquirente si impegna sin d’ora a versare, se dovute, in aggiunta al prezzo indicato nell’ordine e confermato nella conferma d’ordine, secondo quanto previsto dalle disposizioni di legge del paese in cui i prodotti saranno consegnati. L’utente/acquirente è invitato ad informarsi presso gli organi competenti del proprio Paese di residenza o di destinazione dei prodotti, al fine di ottenere informazioni su eventuali dazi o tasse applicati nel paese di residenza o di destinazione dei prodotti.

// La mancata conoscenza da parte dell’acquirente dei costi, oneri, dazi, tasse e/o imposte di cui sopra al momento dell’invio di un ordine al venditore, non potrà costituire causa di risoluzione del contratto e non potrà in alcun modo costituire fonte di addebito dei suddetti oneri al venditore.
//                                 '''),
//                               ]),
//                               this.isPanelExpanded[1],
//                               context),
//                           _panel(
//                               '3. Diritto di recesso',
//                               Column(children: [
//                                 _description('''
// Al consumatore è riconosciuto il diritto di recedere dal contratto concluso ai sensi delle presenti condizioni generali di vendita, senza alcuna penalità, entro il termine di giorni 14 (quattordici) di calendario dalla consegna del prodotto o, nel caso di acquisto di più prodotti consegnati separatamente con un solo ordine, da quando è stato consegnato l’ultimo prodotto.

// Per esercitare il diritto di recesso, basterà spedire i capi al seguente indirizzo: via Giovanni Borraccino 6 c/d, 74122, Talsano (TA), inserendo all’interno del pacco l'apposito modulo che riceverà tramite email o che potrà scaricare dal link sottostante.

// Scarica il modulo di reso qui.

// IMPORTANTE:

// Nel caso in cui il pacco venga restituito senza modulo di reso, il reso non sarà accettato.

// Tutte le spese di spedizione non sono rimborsabili, verrà rimborsato soltanto il valore dei capi.

// I rischi e i costi diretti della restituzione dei prodotti saranno a carico del consumatore, salvo che il prodotto non sia oggetto di restituzione perché pervenuto danneggiato, essendo in tale ipotesi i costi a carico di TF Abbigliamento e salva ogni successiva verifica in merito alle cause del danno subito dal prodotto. Qualora i beni restituiti risultino indossati, danneggiati (ad esempio con segno di usura, abrasione, graffi, deformazioni, scollature ecc.), non completi di tutti i loro elementi ed accessori (ivi incluse le etichette, lacci ed ogni altro elemento annesso), delle confezioni ed imballaggi originali e del certificato di garanzia, ove presente, TF Abbigliamento si riserva la facoltà di non procedere con il rimborso. TF Abbigliamento sarà costretta a rifiutare resi comunicati o rispediti in ritardo, o resi di prodotti che non siano nelle stesse condizioni in cui sono stati ricevuti.

// In caso di recesso, TF abbigliamento rimborserà i pagamenti ricevuti entro giorni 14 (quattordici) dal momento in cui viene informata della decisione del consumatore di recedere dal contratto, salvo il diritto di trattenere il rimborso sino alla ricezione della merce restituita e previa verifica della stessa. Detti rimborsi saranno effettuati utilizzando lo stesso mezzo di pagamento utilizzato al momento dell’acquisto dal consumatore in caso di pagamento anticipato tramite PayPal o Carta di Credito, salvo che il consumatore non richieda il rimborso con diverso mezzo di accredito oppure voglia ricevere un codice promozionale dell’importo del rimborso da utilizzare entro 14 giorni.

// IPOTESI IN CUI IL DIRITTO DI RECESSO È ESPRESSAMENTE ESCLUSO

// AI SENSI DELL’ART. 59 DEL DECRETO LEGISLATIVO DEL N. 206/2005 (COSIDDETTO CODICE DEL CONSUMO) E SUCCESSIVE MODIFICHE ED INTEGRAZIONI, IL DIRITTO DI RECESSO È ESPRESSAMENTE ESCLUSO nelle ipotesi in cui il bene venduto sia stato fatto “su misura” o “personalizzato” in base alle scelte del cliente finale.
//                                 '''),
//                               ]),
//                               this.isPanelExpanded[2],
//                               context)
//                         ],
//                         dividerColor: Theme.of(context).primaryColorDark,
//                         expansionCallback: (panelIndex, isExpanded) {
//                           this.isPanelExpanded[panelIndex] =
//                               !this.isPanelExpanded[panelIndex];
//                           setState(() {});
//                         },
//                       ),
                    ])))));
  }

  Widget _description(String title) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Text(title, style: TextStyle(), textAlign: TextAlign.justify));
  }

  Widget _panel(context, String title, String key, List<Widget> children) {
    Color primaryColorDark = Theme.of(context).primaryColorDark;
    return Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ExpansionTile(
      key: Key(key),
      title: Text(title, style: TextStyle(color: primaryColorDark, fontWeight: FontWeight.bold)),
      children: children,
    )));
  }

  Widget _spacer() {
    return SizedBox(height: 20);
  }
}
