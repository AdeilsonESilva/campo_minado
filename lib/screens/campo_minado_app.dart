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
  Tabuleiro _tabuleiro = Tabuleiro(
    linhas: 12,
    colunas: 12,
    qtdeBombas: 3,
  );

  _reiniciar() {
    setState(() {
      _venceu = null;
      _tabuleiro.reiniciar();
    });
  }

  _abrir(Campo campo) {
    if (_venceu != null) return;

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: ResultadoWidget(
          venceu: _venceu,
          onReiniciar: _reiniciar,
        ),
        body: Container(
          child: TabuleiroWidget(
            tabuleiro: _tabuleiro,
            onAbrir: _abrir,
            onAlternarMarcacao: _alternarMarcacao,
          ),
        ),
      ),
    );
  }
}
