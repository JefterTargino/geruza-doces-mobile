import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

var maskDate = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

var maskTime = MaskTextInputFormatter(
    mask: '##:##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

var maskValue = MaskTextInputFormatter(
    //mask: '##.##',
    filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
