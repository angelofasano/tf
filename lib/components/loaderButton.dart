import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoaderButton extends StatefulWidget {
  LoaderButton(
      {required this.label,
      required this.onEnd,
      required this.onError,
      required this.action,
      required this.params,
      });
  final Function action;
  final Function onEnd;
  final Function onError;
  final String label;
  final List<dynamic> params;
  @override
  State<LoaderButton> createState() => _LoaderButtonState();
}

class _LoaderButtonState extends State<LoaderButton> {
  bool onLoading = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          onLoading = true;
        });

        Function.apply(widget.action, widget.params)
            .then((res) => {
                  setState(() {
                    onLoading = false;
                  }),
                  widget.onEnd()
                })
            .catchError((onError) => {
                  setState(() {
                    onLoading = false;
                  }),
                  widget.onError()
        });
      },
      child: Container(
          height: 50,
          color: Theme.of(context).primaryColor,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
                padding: EdgeInsets.only(right: 15),
                child:
                    Text(widget.label, style: TextStyle(color: Colors.white))),
            this.onLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : Text('')
          ])),
    );
  }
}
