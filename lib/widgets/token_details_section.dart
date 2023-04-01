import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TokenDetailsSection extends StatelessWidget {
  const TokenDetailsSection({
    Key? key,
    required this.tokenBalance,
  }) : super(key: key);

  final int tokenBalance;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.black12,
        ),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12)),
                  child: SvgPicture.asset(
                    'assets/images/chia-logo.svg',
                    height: 100,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'XCH ${tokenBalance}',
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            InkWell(
                              onTap: () => "",
                              child: Icon(
                                Icons.refresh,
                                color: Colors.grey,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'Smart Coin',
                              style: TextStyle(fontSize: 12.0),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            SizedBox(
                              width: 120,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () => FlutterClipboard.copy(
                                      "",
                                    ),
                                    child: const Icon(
                                      Icons.copy,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
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
