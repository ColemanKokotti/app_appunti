abstract class BaseFormatter {
  static bool isNewParagraphStart(String line) {
    return line.startsWith('I.') || line.startsWith('II.') ||
        line.startsWith('III.') || line.startsWith('IV.') ||
        line.startsWith('V.') || line.startsWith('VI.') ||
        line.startsWith('VII.') || line.startsWith('VIII.') ||
        line.startsWith('IX.') || line.startsWith('X.') ||
        line.startsWith('XI.') || line.startsWith('XII.')||
        line.startsWith('XIII.') || line.startsWith('XIV.')||
        line.startsWith('XV.') || line.startsWith('XVI.')||
        line.startsWith('XVII.') || line.startsWith('XVIII.')||
        line.startsWith('XIX.') || line.startsWith('XX.')||
        line.startsWith('XXI.') || line.startsWith('XXII.')||
        line.startsWith('XXIII.') || line.startsWith('XXIV.')||
        line.startsWith('XXV.') || line.startsWith('XXVI.')||
        line.startsWith('XXVII.') || line.startsWith('XXVIII.')||
        line.startsWith('XXIX.') || line.startsWith('XXX.')
    ;
  }

  // Nuovo metodo per riconoscere elementi di lista
  static bool isListItemStart(String line) {
    final trimmedLine = line.trim();

    // Regex per riconoscere il pattern "- [lettera]."
    // Supporta sia lettere minuscole che maiuscole
    final listItemRegex = RegExp(r'^-\s*[a-zA-Z]\.$');

    return listItemRegex.hasMatch(trimmedLine);
  }

  static bool isCodeBlockStart(String trimmedLine) {
    // Riconoscimento del delimitatore di codice Markdown
    if (trimmedLine.startsWith('```')) {
      return true;
    }

    // Riconoscimento di C# (esistente)
    if (trimmedLine == 'C#' ||
        trimmedLine.startsWith('int[') ||
        trimmedLine.startsWith('int ') ||
        trimmedLine.startsWith('double ') ||
        trimmedLine.startsWith('string ') ||
        trimmedLine.startsWith('bool ') ||
        trimmedLine.startsWith('List<') ||
        trimmedLine.startsWith('Stack<') ||
        trimmedLine.startsWith('Queue<') ||
        trimmedLine.startsWith('Dictionary<') ||
        trimmedLine.startsWith('HashSet<') ||
        trimmedLine.startsWith('class ') ||
        trimmedLine.startsWith('interface ') ||
        trimmedLine.startsWith('abstract class ') ||
        trimmedLine.startsWith('void ') ||
        trimmedLine.startsWith('static ') ||
        trimmedLine.startsWith('public ') ||
        trimmedLine.startsWith('private ') ||
        trimmedLine.startsWith('protected ') ||
        trimmedLine.startsWith('for (') ||
        trimmedLine.startsWith('while (') ||
        trimmedLine.startsWith('switch (') ||
        trimmedLine.startsWith('if (') ||
        trimmedLine.startsWith('else ') ||
        trimmedLine.contains(' => ') ||
        trimmedLine == 'do' ||
        (trimmedLine.startsWith('using ') && trimmedLine.contains('('))) {
      return true;
    }

    // Aggiunta del riconoscimento per XML
    // I tag XML iniziano con '<' seguito da una lettera o '/'
    if (trimmedLine.startsWith('<') && (RegExp(r'^<[a-zA-Z/]').hasMatch(trimmedLine))) {
      return true;
    }
    // Aggiunta del riconoscimento per Kotlin/Compose
    // Parole chiave Kotlin comuni che possono indicare l'inizio di un blocco di codice
    // e parole chiave specifiche di Compose
    if (trimmedLine.startsWith('fun ') ||
        trimmedLine.startsWith('val ') ||
        trimmedLine.startsWith('var ') ||
        trimmedLine.startsWith('class ') ||
        trimmedLine.startsWith('object ') ||
        trimmedLine.startsWith('interface ') ||
        trimmedLine.startsWith('import ') ||
        trimmedLine.startsWith('@Composable') ||
        trimmedLine.startsWith('Column') ||
        trimmedLine.startsWith('Row') ||
        trimmedLine.startsWith('Box') ||
        trimmedLine.startsWith('Text(') ||
        trimmedLine.startsWith('Button(') ||
        trimmedLine.startsWith('Modifier.')) {
      return true;
    }

    return false;
  }
}