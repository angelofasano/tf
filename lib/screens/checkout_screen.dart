import 'package:flutter/material.dart';
import 'package:tf/components/addressStep.dart';
import 'package:tf/components/paymentStep.dart';
import 'package:tf/components/shippingRateStep.dart';
import 'package:tf/models/address.dart';
import 'package:tf/utils/checkoutArguments.dart';

class CheckoutScreen extends StatefulWidget {
  static String routeName = '/checkout';
  CheckoutScreen();

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

  Address selectedBillingAddress = new Address(); 

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CheckoutArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                type: stepperType,
                physics: ScrollPhysics(),
                currentStep: _currentStep,
                controlsBuilder: (BuildContext context,
                    {VoidCallback? onStepContinue,
                    VoidCallback? onStepCancel}) {
                  return Text('');
                },
                steps: <Step>[
                  Step(
                    title: new Text('Indirizzo'),
                    content: AddressStep(
                        user: args.user,
                        checkoutID: args.checkoutID,
                        successCallback: (Address address) => {
                          this.selectedBillingAddress = address,
                          goToNextStep()
                        }),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: new Text('Spedizione'),
                    content: ShippingRateStep(
                        checkoutID: args.checkoutID,
                        onBack: goToPreviousStep,
                        successCallback: goToNextStep),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: new Text('Pagamento'),
                    content: PaymentStep(checkoutID: args.checkoutID, selectedBillingAddress: this.selectedBillingAddress),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 2
                        ? StepState.complete
                        : StepState.disabled,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  goToNextStep() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  goToPreviousStep() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
