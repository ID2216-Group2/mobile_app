import 'package:flutter/material.dart';

class BillItem extends StatelessWidget {
  const BillItem({
    super.key,
    required this.otherUsername,
    required this.amountLent,
    required this.onPressed,
  });

  final String otherUsername;
  final double amountLent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60,
        child: Row(children: [
          const SizedBox(width: 20),
          const CircleAvatar(
            child: ClipOval(),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(otherUsername),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'You ',
                        style: TextStyle(color: Colors.black),
                      ),
                      amountLent > 0
                          ? const TextSpan(
                              text: 'borrowed ',
                              style: TextStyle(color: Colors.black),
                            )
                          : const TextSpan(
                              text: 'lent ',
                              style: TextStyle(color: Colors.black),
                            ),
                      amountLent > 0
                          ? TextSpan(
                              text: "\$${amountLent.toStringAsFixed(2)}",
                              style: const TextStyle(color: Colors.red),
                            )
                          : TextSpan(
                              text: "\$${amountLent.abs().toStringAsFixed(2)}",
                              style: const TextStyle(color: Colors.green),
                            ),
                    ],
                  ),
                )
              ],
            )
          ),
          OutlinedButton(onPressed: onPressed, child: const Text('Settle Up')),
        ]));
  }
}
