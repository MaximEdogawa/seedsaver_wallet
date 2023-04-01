import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedsaver_wallet/models/wallet_page_view_model.dart';

class TokenTransferSection extends ConsumerWidget {
  const TokenTransferSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _viewModel = ref.read(walletPageViewModel);

    return Form(
      key: _viewModel.formKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Send XCH to',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _viewModel.toController,
            focusNode: _viewModel.toFocusNode,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabled: true,
              filled: true,
              fillColor: Colors.black12.withOpacity(0.05),
              hintText:
                  'xch1z4d8qxv3xq2h8m2vmy9jpcdvuhw8x5jv529pywdttz9fnygya6cqhvgd8q',
              hintStyle: const TextStyle(
                color: Colors.black12,
              ),
            ),
            cursorColor: Colors.black,
            validator: _viewModel.addressValidator,
            onFieldSubmitted: (val) => _viewModel.send(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
              onPressed: ref.watch(walletPageViewModel).loading
                  ? null
                  : () => _viewModel.send(),
              child: ref.watch(walletPageViewModel).loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Send',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
