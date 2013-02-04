Tabelas Protheus 1.2.1
======================

1. Descrição do programa
2. Histórico de Versões
3. Requisitos do sistema
4. Obtendo o programa
5. Instalação
6. Informações técnicas
7. Agradecimentos
8. Contato


1. Descrição do programa
------------------------

O Tabela Protheus surgiu de uma necessidade minha, cujo objetivo principal é: facilitar ao máximo as consultas
às configurações de tabelas do Protheus. Eu achava muito cansativo, além de anti-produtivo entrar toda hora
no Configurador para checar configurações de tabelas, como nomes de campos, tamanhos, validações etc, já
que na maioria das vezes era só pra consultar mesmo, sem alterar nada no dicionário de dados. Sem contar que se
alguém já estiver com o Configurador aberto você não pode acessar /:

O programa funciona de uma forma extremamente simples, acompanhe este exemplo:

a) No tipo de pesquisa selecione "Sigla" e "começa".
b) Digite "SZ", sem as aspas.
c) Pressione ENTER ou clique no botão "Localizar". Todas as tabelas que começa com "SZ" (neste caso sabemos que
   são as tabelas de usuário) serão retornadas.
d) Agore mude o tipo de pesquisa para "Nome" e "contém".
e) Digite "CADASTRO".
f) Pressione ENTER ou clique no botão "Localizar". As tabelas que contém o texto "CADASTRO" em sua descrição serão
   retornadas. É importante notar que o programa não faz distinção entre MAIÚSCULAS/minúsculas (case insensitive).
g) Agora pesquise pela tabela de cadastro de clientes, a SA1 (sigla > começa com > "SA1").
h) Vá até a aba Campos e dê um clique duplo no campo do nome, o A1_NOME. Informações detalhadas do campo serão exibidas.
   Para fechar você pode clicar no "X" ou pressionar Esc. Repare também que você pode deslocar para outro campo sem fechar
   a tela de detalhes, bastando pressionar as setas de deslocamento (< << >> >).
i) Visualize as informações dos índices também.

Basicamente o funcionamento do programa é este. Agora você pode brincar um pouco para sentir-se mais a vontade (-:

Procure utilizar as teclas de atalho (eu trabalhei bastante nelas - deixe o mouse parado sobre algum botão para visualizar
a tecla correspondente), elas facilitarão sua vida (-:

IMPORTANTE: O PROGRAMA NÃO ALTERA NENHUMA INFORMAÇÃO DAS TABELAS DO PROTHEUS, ELE É "READ-ONLY", OU SEJA, APENAS LÊ.


2. Histórico de Versões
------------------------

>> 1.2.1 (14/01/2005)
   - Inclusão da opção de utilizar o SINDEX como arquivo de índices.
   - Velocidade máxima na leitura das tabelas, graças a várias otimizações internas e a utilização de índices (-:
   - Tela adaptada para 800x600.
   - Corrigido bug de ACCESS VIOLATION que ocorria em alguns casos.

>> 1.2 (05/01/2005)
   - Mudanças cosméticas na interface do programa (ícones, alinhamentos etc.).
   - Adição de um ícone na bandeja do sistema (systray) para oferecer maior comodidade:
     com um clique duplo neste ícone você pode exibir/ocultar a tela principal do programa.
   - Revisão geral do código-fonte: várias melhorias foram feitas, o que resulta em um código
     mais enxuto e rápido.
   - Visualização detalhada dos campos e dos índices. Dê um clique duplo nestes itens que você verá!
   - Mudança total no driver de acesso aos arquivos DBF do Protheus: agora o programa utiliza a conceituada
     suíte Apollo, que briga lado-a-lado com Advantage (o APSDU do Microsiga utiliza essa), com a vantagem
     de ser menor e mais rápida. Isso impacta diretamente na velocidade de acesso, o que você perceberá assim
     que o programa for aberto. Pelos meus cálculos, a velocidade aumentou mais de 1000% em relação ao antigo
     driver do "VisualFox Pro OLEDB" - que agora não é mais necessário.
   - Uma tela que facilita ao máximo as configurações de localização das tabelas foi incluída. Você ainda pode
     manipular o .INI diretamente, mas eu recomendo utilizar esta tela, para evitar perda de tempo e possíveis
     erros.
   - Inclusão deste documento LEIAME (-:

>> 1.1 (24/08/2004)
   - Primeira versão usável do programa, disponibilizada à lista do siga-br.

>> 1.0
   - Versão Interna, apenas para testes.


3. Requisitos do sistema
------------------------

- Windows 9x, ME, NT4, 2000, XP ou 2003
- Protheus 7.10 (Alguém que possuir versões anteriores poderia me confirmar se funciona com as elas?)
- Driver Apollo de acesso às tabelas DBF


4. Obtendo o programa
---------------------

- Tabelas Protheus
  http://paginas.terra.com.br/informatica/glrp/TabProt_v1.2.1.zip

- Driver Apollo
  As DLL's mais atuais do Apollo já acompanham o programa, portanto não é necessário você baixar da Internet, mas mesmo
  assim, se você quiser:

     a) Acesse o site: http://www.vistasoftware.com/downloads.asp
     b) Faça o download do pacote "SDE 6.11 DLLs Only (Free Update)" e descompacte seu conteúdo nas pasta onde está
        o Tabelas Protheus ou na pasta System do Windows (Win9x/ME -> Windows\System, NT4/2000 -> WINNT\System32,
        XP/2003 -> WINDOWS\System32)


5. Instalação
-------------

Basta descompactar o conteúdo do pacote .zip do programa em uma pasta qualquer. Na primeira vez que você entrar no programa
ele exibirá uma mensagem avisando que ainda não estã configurado. Basta dar OK que logo em seguida surgirá a tela de
configurações. Como a tela é auto-explicativa, apenas siga-a. No final clique em OK para salvar as configurações.

Pronto, programa instalado e configurado. Pronto para uso!


6. Informações técnicas
-----------------------

- O Tabelas Protheus foi desenvolvido utilizando o ambiente Delphi 7 (linguagem Object Pascal).
- Apenas 1 componente de terceiros foi utilizado, o Apollo VCL, que é responsável pela comunicação do aplicativo com
  as DLL's do Apollo.
- Driver de acesso a DBF Apollo.


7. Agradecimentos
-----------------

Agradeço a todos os amigos do grupo de discussão siga-br (siga-br@yahoogrupos.com.br), pelas sugestões dadas ao programa.


8. Contato
----------

E-mail.: glauber_lima@yahoo.com.br
MSN....: glauber_lima@hotmail.com


Glauber Lima, 14 de Janeiro de 2005
