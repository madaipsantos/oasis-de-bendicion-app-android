import 'package:flutter/material.dart';
import 'package:webradiooasis/core/models/daily_verse.dart';

const String kVerseBackgroundImage = 'assets/verse1.jpg';

/// Widget que exibe o Versículo do Dia em um card com imagem de fundo.
class VerseCardAsync extends StatelessWidget {
  final Future<DailyVerse> verseFuture;
  final double screenWidth;
  final Color buttonColor;
  final double borderRadius;
  final double padding;

  const VerseCardAsync({
    super.key,
    required this.verseFuture,
    required this.screenWidth,
    required this.buttonColor,
    required this.borderRadius,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(kVerseBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
            padding: EdgeInsets.all(padding * 1.2),
            child: FutureBuilder<DailyVerse>(
              future: verseFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar el versículo', style: TextStyle(color: Colors.white)));
                }

                final verse = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Versículo do Dia",
                      style: TextStyle(
                        color: buttonColor,
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(color: Colors.white54, height: 16),
                    Text(
                      "\"${verse.texto}\"",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${verse.livro} ${verse.capitulo}:${verse.versiculo}",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}