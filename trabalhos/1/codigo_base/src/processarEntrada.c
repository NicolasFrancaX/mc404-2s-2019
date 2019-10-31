#include "montador.h"
#include "token.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>

char *strdup(const char *s);

char *listaInstrucoes[] = {
    "ld",
    "ldinv",
    "ldabs",
    "ldmq",
    "ldmqmx",
    "store",
    "jump",
    "jge",
    "add",
    "addabs",
    "sub",
    "subabs",
    "mult",
    "div",
    "lsh",
    "rsh",
    "storend"
};

int listaNumeroParametrosInstrucoes[] = {
    1,
    1,
    1,
    0,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    0,
    0,
    1};

char *listaDiretivas[] = {
    ".set",
    ".org",
    ".align",
    ".wfill",
    ".word"};

int listaNumeroParametrosDiretivas[] = {
    2,
    1,
    1,
    2,
    1};

TipoDoToken analisadorLexico(char *entrada, unsigned tamanho)
{
    bool diretiva = true;
    bool def_rotulo = true;
    bool hexadecimal = true;
    bool decimal = true;
    bool nome = true;
    bool instrucao = true;

    // Verificacao diretiva
    if (entrada[0] == '.')
    {
        // diretiva = true;
        def_rotulo = false;
        hexadecimal = false;
        decimal = false;
        nome = false;
        instrucao = false;

        // verificação
        for (unsigned i = 1; i < tamanho; i++)
        {
            if (!isalpha(entrada[i]))
            {
                diretiva = false;
                continue;
            }
        }

        if (diretiva)
        {
            diretiva = false;

            for (unsigned i = 0; i < 5; i++)
            {
                if (strcmp(entrada, listaDiretivas[i]) == 0)
                {
                    diretiva = true;
                    continue;
                }
            }

            if (diretiva)
                return Diretiva;
        }
    }

    // Verificação def_rotulo
    if (!isdigit(entrada[0]) && entrada[0] != '.' && entrada[tamanho - 1] == ':')
    {
        diretiva = false;
        // def_rotulo = true;
        hexadecimal = false;
        decimal = false;
        nome = false;
        instrucao = false;

        for (unsigned i = 1; i < tamanho - 1; i++)
        {
            if (!isalnum(entrada[i]) && entrada[i] != '_')
            {
                def_rotulo = false;
            }
        }

        if (def_rotulo)
            return DefRotulo;
    }

    // Verificação hexadecimal
    if (entrada[0] == '0' && entrada[1] == 'x')
    {
        diretiva = false;
        def_rotulo = false;
        // hexadecimal = true;
        decimal = false;
        nome = false;
        instrucao = false;

        if (strlen(entrada) > 12)
            hexadecimal = false;

        for (int i = 2; i < tamanho; i++)
        {
            if (!isxdigit(entrada[i]))
            {
                hexadecimal = false;
                continue;
            }
        }

        if (hexadecimal)
            return Hexadecimal;
    }

    // Verificação decimal
    if (isdigit(entrada[0]))
    {
        diretiva = false;
        def_rotulo = false;
        hexadecimal = false;
        // decimal = false;
        instrucao = false;

        for (int i = 1; i < tamanho; i++)
        {
            if (!isdigit(entrada[i]))
            {
                decimal = false;
                continue;
            }
        }

        if (decimal)
            return Decimal;
    }

    // Verificação instrucao
    if (instrucao)
    {
        instrucao = false;

        for (unsigned i = 0; i < 17; i++)
        {
            if (strcmp(entrada, listaInstrucoes[i]) == 0)
            {
                instrucao = true;
                continue;
            }
        }

        if (instrucao)
            return Instrucao;
    }

    // Verificação nome
    if (!isdigit(entrada[0]) && entrada[0] != '.')
    {
        diretiva = false;
        def_rotulo = false;
        hexadecimal = false;
        decimal = false;
        instrucao = false;
        nome = true;

        for (int i = 1; i < tamanho; i++)
        {
            if (!isalnum(entrada[i]) && entrada[i] != '_')
            {
                nome = false;
            }
        }

        if (nome)
            return Nome;
    }

    return -1;
}

bool validaParametroDiretiva(Token tokens_linha[], unsigned inicio, unsigned fim)
{
    if (strcmp(tokens_linha[inicio].palavra, ".set") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosDiretivas[0])
            return false;

        if (tokens_linha[inicio + 1].tipo == Nome)
            if (tokens_linha[inicio + 2].tipo == Hexadecimal ||
            (tokens_linha[inicio + 2].tipo == Decimal &&
            atoi(tokens_linha[inicio + 2].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 2].palavra) <= 2147483647)) return true;
            else return false;
        else return false;
    } else if (strcmp(tokens_linha[inicio].palavra, ".org") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosDiretivas[1])
            return false;

        if (tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023))
            return true;
        else
            return false;
    } else if (strcmp(tokens_linha[inicio].palavra, ".align") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosDiretivas[2])
            return false;

        if (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 1 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023)
            return true;
        else
            return false;
    } else if (strcmp(tokens_linha[inicio].palavra, ".wfill") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosDiretivas[3])
            return false;

        if (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 1 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023) {
            
            if (tokens_linha[inicio + 2].tipo == Hexadecimal ||
                tokens_linha[inicio + 2].tipo == Nome ||
                (tokens_linha[inicio + 2].tipo == Decimal &&
                atoi(tokens_linha[inicio + 2].palavra) >= -2147483648 &&
                atoi(tokens_linha[inicio + 2].palavra) <= 2147483647))
                return true;
             else
                return false;
        } else return false;
    } else if (strcmp(tokens_linha[inicio].palavra, ".word") == 0) {

        if (fim - inicio - 1 != listaNumeroParametrosDiretivas[4])
            return false;

        if (tokens_linha[inicio + 1].tipo == Nome ||
            tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= -2147483648 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 2147483647))
            return true;
        else
            return false;

    }

    return false;
}

// se o intervalo para uma dada instrucao for muito grande, já podemos descartar automaticamente
bool validaParametroInstrucao(Token tokens_linha[], unsigned inicio, unsigned fim) {
    bool resultado = true;
    
    if (strcmp(tokens_linha[inicio].palavra, "ld") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[0])
            return false;
        
        if (tokens_linha[inicio + 1].tipo == Nome ||
            tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023))
                return true;

    } else if (strcmp(tokens_linha[inicio].palavra, "ldinv") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[1])
            return false;

        if (tokens_linha[inicio + 1].tipo == Nome ||
            tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023))
                return true;
    } else if (strcmp(tokens_linha[inicio].palavra, "ldabs") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[2])
            return false;

        if (tokens_linha[inicio + 1].tipo == Nome ||
            tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023))
                return true;
    } else if (strcmp(tokens_linha[inicio].palavra, "ldmq") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[3])
            return false;

    } else if (strcmp(tokens_linha[inicio].palavra, "ldmqmx") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[4])
            return false;
        
        if (tokens_linha[inicio + 1].tipo == Nome ||
            tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023))
                return true;
    } else if (strcmp(tokens_linha[inicio].palavra, "store") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[5])
            return false;
        
        if (tokens_linha[inicio + 1].tipo == Nome ||
            tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023))
                return true;
    } else if (strcmp(tokens_linha[inicio].palavra, "jump") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[6])
            return false;
        
        if (tokens_linha[inicio + 1].tipo == Nome ||
            tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023))
                return true;
    } else if (strcmp(tokens_linha[inicio].palavra, "jge") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[7])
            return false;
        
        if (tokens_linha[inicio + 1].tipo == Nome ||
            tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023))
                return true;
    } else if (strcmp(tokens_linha[inicio].palavra, "add") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[8])
            return false;
        
        if (tokens_linha[inicio + 1].tipo == Nome ||
            tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023))
                return true;
    } else if (strcmp(tokens_linha[inicio].palavra, "addabs") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[9])
            return false;
        
        if (tokens_linha[inicio + 1].tipo == Nome ||
            tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023))
                return true;
    } else if (strcmp(tokens_linha[inicio].palavra, "sub") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[10])
            return false;
        
        if (tokens_linha[inicio + 1].tipo == Nome ||
            tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023))
                return true;
    } else if (strcmp(tokens_linha[inicio].palavra, "subabs") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[11])
            return false;
        
        if (tokens_linha[inicio + 1].tipo == Nome ||
            tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023))
                return true;
    } else if (strcmp(tokens_linha[inicio].palavra, "mult") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[12])
            return false;
        
        if (tokens_linha[inicio + 1].tipo == Nome ||
            tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023))
                return true;
    } else if (strcmp(tokens_linha[inicio].palavra, "div") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[13])
            return false;
        
        if (tokens_linha[inicio + 1].tipo == Nome ||
            tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023))
                return true;
    } else if (strcmp(tokens_linha[inicio].palavra, "lsh") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[14])
            return false;
        
        return true;
    } else if (strcmp(tokens_linha[inicio].palavra, "rsh") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[15])
            return false;
        
        return true;
    } else if (strcmp(tokens_linha[inicio].palavra, "storend") == 0) {
        if (fim - inicio - 1 != listaNumeroParametrosInstrucoes[16])
            return false;
        
        if (tokens_linha[inicio + 1].tipo == Nome ||
            tokens_linha[inicio + 1].tipo == Hexadecimal ||
            (tokens_linha[inicio + 1].tipo == Decimal &&
            atoi(tokens_linha[inicio + 1].palavra) >= 0 &&
            atoi(tokens_linha[inicio + 1].palavra) <= 1023))
                return true;
    } else {
        resultado = false;
    }
    
    return resultado;
}

bool processamentoGramaticalLinha(Token tokens_linha[], int numero_de_tokens) {
    if (tokens_linha[0].tipo == DefRotulo) {
        if (numero_de_tokens == 1) {
            return true;
        } else if (tokens_linha[1].tipo == Instrucao && validaParametroInstrucao(tokens_linha, 1, numero_de_tokens)) {
            return true;
        } else if (tokens_linha[1].tipo == Diretiva && validaParametroDiretiva(tokens_linha, 1, numero_de_tokens)) {
            return true;
        } else {
            return false;
        }
    } else if (tokens_linha[0].tipo == Diretiva && validaParametroDiretiva(tokens_linha, 0, numero_de_tokens)) {
        return true;
    } else if (tokens_linha[0].tipo == Instrucao && validaParametroInstrucao(tokens_linha, 0, numero_de_tokens)) {
        return true;
    } else {
        return false;
    }
}

int processarEntrada(char *entrada, unsigned tamanho)
{

    // Variáveis para processar comentários
    bool comentario = false;

    // Variáveis para processar palavra por palavra (em que uma palavra acaba depois de um espaço ou caractere)
    bool mudanca_palavra = false;
    bool espaco = false;
    char palavra_auxiliar[200];
    unsigned posicao_palavra_auxiliar = 0;
    unsigned numero_de_palavras = 0;
    unsigned linha = 1;

    // Variáveis para processar quebra de linha
    bool quebra_de_linha = false;
    unsigned int numero_da_linha = 1;

    // Variáveis para criação dos Tokens
    TipoDoToken tipo_token;

    // Vetor para processamento linha a linha de tokens para verificação gramatical
    Token tokens_da_linha[500];
    int quantidade_tokens_linha = 0;


    // Obtendo a lista de Tokens
    for (unsigned i = 0; i < strlen(entrada); i++)
    {
        // Tirando comentários
        if (entrada[i] == '#')
            comentario = true;
        if (entrada[i] == '\n' && comentario)
            comentario = false;

        // Identificando espaços
        if (entrada[i] == ' ' || entrada[i] == '\t')
            espaco = true;
        else
            espaco = false;

        // Identificando quebra de linha
        if (entrada[i] == '\n')
            quebra_de_linha = true;
        else
            quebra_de_linha = false;

        // Processando string sem comentário para termos a lista de Tokens
        if (!comentario)
        {

            if (!espaco && !quebra_de_linha)
            {
                if (!quebra_de_linha)
                {
                    // Dessa forma todas as minhas palavras serão em letra minuscula automáticamente
                    palavra_auxiliar[posicao_palavra_auxiliar] = (char)tolower((int)entrada[i]);
                    posicao_palavra_auxiliar++;
                }

                // Se tivermos uma quebra de linha, o número da linha é aumentado.
                mudanca_palavra = true;
            }
            else
            {
                linha = numero_da_linha;

                if (mudanca_palavra)
                {

                    mudanca_palavra = false;

                    palavra_auxiliar[posicao_palavra_auxiliar] = '\0';

                    tipo_token = analisadorLexico(palavra_auxiliar, posicao_palavra_auxiliar);

                    if (tipo_token == -1) {
                        fprintf(stderr, "ERRO LEXICO: palavra inválida na linha %d!\n", linha);
                        return 1;
                    }

                    adicionarToken(tipo_token, strdup(palavra_auxiliar), linha);
                    tokens_da_linha[quantidade_tokens_linha] = *(recuperaToken(getNumberOfTokens()-1));
                    quantidade_tokens_linha++;

                    numero_de_palavras++;

                    posicao_palavra_auxiliar = 0;
                }

                if (quebra_de_linha) {
                    // Aqui eu posso fazer meu processamento gramatical

                    if (quantidade_tokens_linha != 0) {
                        if (!processamentoGramaticalLinha(tokens_da_linha, quantidade_tokens_linha)) {
                            fprintf(stderr, "ERRO GRAMATICAL: palavra na linha %d!\n", numero_da_linha);
                            return 1;
                        }
                    }

                    numero_da_linha++;
                    quantidade_tokens_linha = 0;
                }
            }
        }
    }



    return 0;
}
