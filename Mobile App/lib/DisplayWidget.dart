import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:watery/Segoe.dart';

class DisplayWidget extends StatefulWidget {
  final String icon;
  final String title;
  final int value;
  final String unit;

  DisplayWidget({this.icon, this.title, this.value, this.unit});

  @override
  _DisplayWidgetState createState() => _DisplayWidgetState();
}

class _DisplayWidgetState extends State<DisplayWidget> {
  int displayValue;

  @override
  Widget build(BuildContext context) {
    if (widget.value < 0)
      displayValue = 0;
    else
      displayValue = widget.value;

    if (widget.value > 100) {
      displayValue = 100;
    }

    return Container(
      height: 200.0,
      width: (MediaQuery.of(context).size.width - 60) * 0.5,
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF).withOpacity(0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: widget.value >= 100 ? 50.0 : 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/${widget.icon}",
                width: 20.0,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                widget.title,
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 18.0,
                  fontFamily: Segoe.regular,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.unit == "degree"
                  ? SizedBox(
                      width: 10.0,
                    )
                  : Container(),
              Text(
                widget.value >= 100 && widget.title == "Water Level" ? "Full" : displayValue.toString(),
                style: TextStyle(
                  color: Color(0xff323232),
                  fontSize: widget.value >= 100 ? 65.0 : 93.0,
                  fontFamily: Segoe.bold,
                ),
              ),
              widget.unit == "degree"
                  ? Text(
                      "°",
                      style: TextStyle(
                        color: Color(0xffA3A3A3),
                        fontSize: widget.unit == "degree" ? 93.0 : 35.0,
                        fontFamily: Segoe.bold,
                      ),
                    )
                  : Container(
                      height: widget.value >= 100 ? 65.0 : 93.0,
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        widget.title == "Water Level" && widget.value >= 100 ? "" : "%",
                        style: TextStyle(
                          color: Color(0xffA3A3A3),
                          fontSize: widget.unit == "degree" ? 93.0 : 35.0,
                          fontFamily: Segoe.bold,
                        ),
                      ),
                    )
            ],
          ),
        ],
      ),
    );
  }
}
