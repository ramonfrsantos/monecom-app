import 'package:flutter/material.dart';

class PaisagemView extends StatelessWidget {
  final double valor;
  final int inc = 0;

  PaisagemView(this.valor);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        valor < inc + 5
            ? "assets/images/gelado.png"
            : valor < inc + 15
                ? "assets/images/frio.png"
                : valor < inc + 30
                    ? "assets/images/normal.png"
                    : "assets/images/calor.png",
      ),
    );
  }
}
