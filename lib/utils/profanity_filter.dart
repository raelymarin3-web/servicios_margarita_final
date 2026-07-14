class ProfanityFilter {
  static final List<String> _malasPalabras = [
    // ============================================
    // ESPAÑOL - PALABRAS OFENSIVAS
    // ============================================
    
    // Groserías comunes
    'mierda', 'puta', 'puto', 'coño', 'joder', 'cabron', 'cabrón',
    'pendejo', 'pendeja', 'gilipollas', 'capullo', 'subnormal',
    'imbecil', 'imbécil', 'estupido', 'estúpido', 'idiota',
    'tonto', 'tonta', 'zorra', 'perra', 'maricon', 'maricón',
    'bollera', 'tortillera', 'madre', 'verga', 'culo',
    'chupame', 'chupamela', 'mamame', 'mamame', 'hijueputa',
    'hijo de puta', 'malparido', 'malparida', 'gonorrea',
    'careculo', 'carechimba', 'chucha', 'chucha', 'ñoño',
    'ñera', 'ñero', 'guisa', 'guiso',
    
    // NUEVAS PALABRAS AGREGADAS
    'mamahuevo', 'mmhv', 'hjdp', 'come', 'marisco', 
    'lambusio', 'lambucio', 'bastardo', 'becerro', 'beserro',
    'basura', 'estiercol', 'guevo',
    
    // ============================================
    // INGLÉS
    // ============================================
    'fuck', 'shit', 'bitch', 'asshole', 'bastard',
    'damn', 'hell', 'cunt', 'dick', 'pussy',
  ];

  static bool hasProfanity(String text) {
    final lowerText = text.toLowerCase();
    for (var word in _malasPalabras) {
      if (lowerText.contains(word.toLowerCase())) {
        return true;
      }
    }
    return false;
  }
}