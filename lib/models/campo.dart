import 'package:campo_minado/models/explosao_exception.dart';
import 'package:flutter/foundation.dart';

class Campo {
  final int linha;
  final int coluna;
  final List<Campo> vizinhos = [];

  bool _aberto = false;
  bool _marcado = false;
  bool _minado = false;
  bool _explodido = false;

  Campo({
    @required this.linha,
    @required this.coluna,
  });

  void adicionarVizinho(Campo vizinho) {
    final deltaLinha = (linha - vizinho.linha).abs();
    final deltaColuna = (coluna - vizinho.coluna).abs();

    if (deltaLinha == 0 && deltaColuna == 0) {
      return;
    }

    if (deltaLinha <= 1 && deltaColuna <= 1) {
      vizinhos.add(vizinho);
    }
  }

  void abrir() {
    if (aberto) return;

    _aberto = true;

    if (minado) {
      _explodido = true;
      throw ExplosaoException();
    }

    if (vizinhancaSegura) {
      vizinhos.forEach((vizinho) => vizinho.abrir());
    }
  }

  void revelarBomba() {
    if (minado) _aberto = true;
  }

  void minar() => _minado = true;

  void alternarMarcacao() => _marcado = !marcado;

  void reiniciar() {
    _aberto = false;
    _marcado = false;
    _minado = false;
    _explodido = false;
  }

  bool get minado => _minado;

  bool get explodido => _explodido;

  bool get aberto => _aberto;

  bool get marcado => _marcado;

  bool get resolvido {
    bool minadoEMarcado = minado && marcado;
    bool seguroEAberto = !minado && aberto;
    return minadoEMarcado || seguroEAberto;
  }

  bool get vizinhancaSegura => vizinhos.every((vizinho) => !vizinho.minado);

  int get qtdeMinasNaVizinhanca =>
      vizinhos.where((vizinho) => vizinho.minado).length;
}
