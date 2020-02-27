import 'package:campo_minado/components/resultado_widget.dart';
import 'package:campo_minado/components/tabuleiro_widget.dart';
import 'package:campo_minado/models/campo.dart';
import 'package:campo_minado/models/explosao_exception.dart';
import 'package:campo_minado/models/tabuleiro.dart';
import 'package:flutter/material.dart';

class CampoMinadoApp extends StatefulWidget {
  @override
  _CampoMinadoAppState createState() => _CampoMinadoAppState();
}

class _CampoMinadoAppState extends State<CampoMinadoApp> {
  bool _venceu = null;
  Tabuleiro _tabuleiro;

  _reiniciar() {
    setState(() {
      _venceu = null;
      _tabuleiro.reiniciar();
    });
  }

  _abrir(Campo campo) {
    if (_venceu != null || campo.marcado) return;

    setState(() {
      try {
        campo.abrir();
        if (_tabuleiro.resolvido) _venceu = true;
      } on ExplosaoException {
        _venceu = false;
        _tabuleiro.revelarBombas();
      }
    });
  }

  _alternarMarcacao(Campo campo) {
    if (_venceu != null) return;

    setState(() {
      campo.alternarMarcacao();
      if (_tabuleiro.resolvido) _venceu = true;
    });
  }

  Tabuleiro _getTabuileiro(double largura, double altura) {
    if (_tabuleiro != null) return _tabuleiro;

    int qtdeColunas = 15;
    double tamanhoCampo = largura / qtdeColunas;
    int qtdLinhas = (altura / tamanhoCampo).floor();
    return _tabuleiro = Tabuleiro(
      linhas: qtdLinhas,
      colunas: qtdeColunas,
      qtdeBombas: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: ResultadoWidget(
          venceu: _venceu,
          onReiniciar: _reiniciar,
        ),
        body: Container(
          color: Colors.grey,
          child: LayoutBuilder(
            builder: (context, constraints) => TabuleiroWidget(
              tabuleiro: _getTabuileiro(
                constraints.maxWidth,
                constraints.maxHeight,
              ),
              onAbrir: _abrir,
              onAlternarMarcacao: _alternarMarcacao,
            ),
          ),
        ),
      ),
    );
  }
}
