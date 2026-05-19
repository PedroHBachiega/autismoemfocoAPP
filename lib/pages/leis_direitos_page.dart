import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LeisDireitosPage extends StatelessWidget {
  const LeisDireitosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leis e Direitos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Garantia de Direitos',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'As pessoas com Transtorno do Espectro Autista (TEA) possuem direitos garantidos por lei que asseguram sua plena inclusão na sociedade.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildLeiCard(
              context,
              titulo: 'Lei Berenice Piana (Lei 12.764/2012)',
              conteudo:
                  'A principal lei que institui a Política Nacional de Proteção dos Direitos da Pessoa com TEA. Ela garante que autistas são considerados pessoas com deficiência para todos os efeitos legais, assegurando os mesmos direitos (como atendimento prioritário, educação inclusiva e acesso ao mercado de trabalho).',
              url: 'https://www.planalto.gov.br/ccivil_03/_ato2011-2014/2012/lei/l12764.htm'
            ),
            _buildLeiCard(
              context,
              titulo: 'Carteira de Identificação (Ciptea)',
              conteudo:
                  'Garante a expedição gratuita da Carteira de Identificação da Pessoa com Transtorno do Espectro Autista (Ciptea). Esse documento visa facilitar a identificação e assegurar a prioridade no atendimento e no acesso a serviços públicos e privados.',
              url: 'https://www.planalto.gov.br/ccivil_03/_ato2019-2022/2020/lei/l13977.htm#'
            ),
            _buildLeiCard(
              context,
              titulo: 'Educação Inclusiva',
              conteudo:
                  'A lei garante o direito de estudar em escolas regulares, públicas ou privadas. A escola NÃO pode recusar a matrícula do estudante com TEA nem cobrar valores adicionais (mensalidade, taxa extra) por causa do autismo. Se necessário, o aluno tem direito a um acompanhante especializado em sala de aula.',
              url: 'https://www.planalto.gov.br/ccivil_03/_ato2023-2026/2025/decreto/d12686.htm'
            ),
            _buildLeiCard(
              context,
              titulo: 'Atendimento Prioritário',
              conteudo:
                  'Pessoas com TEA e seus acompanhantes têm direito a atendimento prioritário em bancos, supermercados, hospitais, lotéricas, e demais estabelecimentos públicos e privados.',
              url: 'https://www.planalto.gov.br/ccivil_03/leis/l10048.htm'
            ),
            _buildLeiCard(
              context,
              titulo: 'Isenção de Impostos em Veículos',
              conteudo:
                  'Por serem considerados pessoas com deficiência, autistas têm direito a solicitar isenção de impostos (IPI, ICMS, IPVA) na compra de veículos novos. Sendo menores ou não condutores, a isenção pode ser solicitada em nome do representante legal.',
              url: 'https://www.planalto.gov.br/ccivil_03/leis/l8989.htm'
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildLeiCard(BuildContext context, {required String titulo, required String conteudo, required String url}) {
  return Card(
    margin: const EdgeInsets.only(bottom: 16.0),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.gavel, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            conteudo,
            style: TextStyle(
              height: 1.5, 
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.85)
            ),
          ),
          const SizedBox(height: 8), 
          Align(
              alignment: Alignment.centerLeft,
             child: TextButton(
                onPressed: () => _launchUrl(url),
                child: const Text(
                  "Ver lei completa",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    debugPrint('Não foi possível abrir $url');
  }
}
