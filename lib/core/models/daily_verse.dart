class DailyVerse {
  final String livro;
  final int capitulo;
  final int versiculo;
  final String texto;

  const DailyVerse({
    required this.livro,
    required this.capitulo,
    required this.versiculo,
    required this.texto,
  });

  factory DailyVerse.fromJson(Map<String, dynamic> json) {
    return DailyVerse(
      livro: json['livro'],
      capitulo: json['capitulo'],
      versiculo: json['versiculo'],
      texto: json['texto'],
    );
  }
}