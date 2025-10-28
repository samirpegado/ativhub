import 'package:repsys/utils/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriaService {
  Future<Result<String>> deletarPorId(int id) async {
    try {
      await Supabase.instance.client
          .from('categorias')
          .delete()
          .eq('id', id);

      return Result.ok('Categoria deletada com sucesso');
    } on PostgrestException catch (e) {
      if (e.code == '23503') {
        return Result.error(Exception('Essa categoria está sendo usada em despesas.'));
      }
      return Result.error(Exception('Erro ao excluir categoria: ${e.message}'));
    } catch (e) {
      return Result.error(Exception('Erro inesperado: $e'));
    }
  }
}
