import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

var phoneFormatter = MaskTextInputFormatter(
  mask: '(##) #####-####', 
  filter: { "#": RegExp(r'[0-9]') },
  type: MaskAutoCompletionType.lazy
);

var telefoneFormatter = MaskTextInputFormatter(
  mask: '(##) ####-####', 
  filter: { "#": RegExp(r'[0-9]') },
  type: MaskAutoCompletionType.lazy
);

var cpfFomatter = MaskTextInputFormatter(
  mask: '###.###.###-##', 
  filter: { "#": RegExp(r'[0-9]') },
  type: MaskAutoCompletionType.lazy
);

var cnpjFormatter = MaskTextInputFormatter(
  mask: '##.###.###/####-##', 
  filter: { "#": RegExp(r'[0-9]') },
  type: MaskAutoCompletionType.lazy
);