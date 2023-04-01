import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class PublicAddressSection extends StatelessWidget {
  const PublicAddressSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Public Key',
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
                Expanded(
                  child: Text(
                    "",
                    style: const TextStyle(
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
          )
        ],
      ),
    );
  }
}
