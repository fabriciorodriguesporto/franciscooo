# Grupo de Acólitos · Comunidade São Francisco

Sistema web para consultar e administrar as escalas das missas.

## Configuração do compartilhamento

O GitHub Pages hospeda o site e o Supabase compartilha os dados entre os dispositivos. Configure antes de publicar:

1. Crie um projeto no Supabase.
2. No **SQL Editor** do Supabase, execute o conteúdo de [`supabase-setup.sql`](./supabase-setup.sql). O script cria o armazenamento compartilhado, protege os telefones dos acólitos e permite que visitantes leiam somente os dados públicos das escalas.
3. Em **Authentication → Users**, crie o usuário administrador `acolitossaofrancisco@gmail.com`. Escolha a senha no Supabase; ela não fica gravada no código do site. A política do banco permite alterações somente para esse e-mail.
4. Copie a URL do projeto e a chave **publishable/anon** para [`supabase-config.js`](./supabase-config.js). Essa chave é pública por definição; nunca use a chave `service_role` no site.
5. Publique `index.html`, `sao-francisco-logo.png`, `supabase-config.js` e os demais arquivos no GitHub e ative o GitHub Pages.

Na primeira entrada do administrador, dados antigos do mesmo endereço do site são importados se o banco ainda não tiver sido inicializado. O armazenamento de uma página aberta como arquivo local (`file://`) não é compartilhado com o domínio do GitHub Pages; esses dados terão de ser cadastrados novamente ou migrados separadamente. Depois da configuração, alterações de cadastro, escala, data e observações ficam no Supabase e são atualizadas nas páginas abertas dos acólitos. Para testar localmente, sirva a pasta por um servidor local; a abertura direta de `index.html` pode impedir requisições ao Supabase.

Se o endereço ou a chave do Supabase ainda estiverem como valores de exemplo, o site mostrará que a configuração está pendente e não permitirá alterações locais que pareçam compartilhadas.

## Login do administrador

O e-mail autorizado é `acolitossaofrancisco@gmail.com`. A senha é gerenciada pelo Supabase Auth e pode ser alterada no painel do projeto.

## Funcionamento

As missas são consideradas no 2º sábado de cada mês às **18:00** e no 4º sábado às **17:00**. A lista de próximas missas mostra a data, o nome e o horário; clique em uma missa para ver a escala e eventuais observações. Na área do administrador, use **Data** para mover uma missa para outro sábado do mesmo mês; o horário e a equipe serão mantidos. Use **Editar** para alterar a equipe e adicionar observações opcionais. Escalas existentes não são duplicadas ao gerar novamente.

A geração automática usa a escala de junho a dezembro de 2026 como histórico. Na primeira missa, distribui três acólitos entre Turíbulo, Naveta e Microfone; na segunda, distribui acólitos entre Missal e Microfone. O sistema varia equipes e funções, só reutiliza uma combinação após esgotar as permutações possíveis para os acólitos cadastrados e inclui automaticamente novos acólitos nas próximas escalas geradas. O histórico de combinações é mantido entre períodos de geração.
