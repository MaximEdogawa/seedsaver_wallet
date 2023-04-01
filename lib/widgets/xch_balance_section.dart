import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class XCHBalanceSection extends StatelessWidget {
  const XCHBalanceSection({
    Key? key,
    required this.xchBalance,
  }) : super(key: key);

  final int xchBalance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'assets/images/chia-logo.svg',
                height: 40,
              ),
              Text(
                'XCH 1',
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.black12,
        ),
      ],
    );
  }
}
