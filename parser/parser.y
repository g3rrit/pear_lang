%include {
#include <iostream>
#include "parser.hpp"
#include "lexer_def.hpp"
#include "ast.hpp"
}

%name FParse

/* %extra_argument { state *state } */

%token_type {Token*}
%default_type {Token*}

/*---------------------------------------------------------------------------------------------------------------------+
|  PRECEDENCE                                                                                                          |
+---------------------------------------------------------------------------------------------------------------------*/

%right T_OTHER T_MODULE T_U8 T_U16 T_U32 T_U64 T_I8 T_I16 T_I32 T_I64 T_F32 T_F64 T_BOOL T_VOID T_TRIPLE_DOT T_DOUBLE_LESS_EQUALS T_DOUBLE_GREATER_EQUALS T_DOUBLE_COLON T_ARROW T_DOUBLE_AMPERSAND T_DOUBLE_PIPE T_DOUBLE_PLUS T_DOUBLE_MINUS T_DOUBLE_LESS_THAN T_DOUBLE_GREATER_THAN T_LESS_EQUALS T_GREATER_EQUALS T_DOUBLE_EQUALS T_NOT_EQUALS T_PLUS_EQUALS T_MINUS_EQUALS T_ASTERIX_EQUALS T_SLASH_EQUALS T_PERCENT_EQUALS T_AMPERSAND_EQUALS T_CIRCUMFLEX_EQUALS T_PIPE_EQUALS T_AMPERSAND T_CIRCUMFLEX T_COLON T_SEMICOLON T_COMMA T_L_C_BRACKET T_L_R_BRACKET T_R_R_BRACKET T_L_S_BRACKET T_R_S_BRACKET T_ASTERIX T_PLUS T_MINUS T_SLASH T_DOT T_EQUALS T_PERCENT T_EXCLAMATIONMARK T_QUESTIONMARK T_LESS_THAN T_GREATER_THAN T_PIPE T_TILDE T_INTEGER T_FLOAT T_ID T_R_C_BRACKET .

/*---------------------------------------------------------------------------------------------------------------------+
|  TYPES                                                                                                               |
+---------------------------------------------------------------------------------------------------------------------*/

%type module                        {ast::Module*}

%type id                            {ast::ID*}
%type integer                       {ast::Int*}
%type float                         {ast::Float*}

%destructor module {
}

%syntax_error {
    std::cout << "Syntax error\n";
}

/*---------------------------------------------------------------------------------------------------------------------+
|  GRAMMAR                                                                                                             |
+---------------------------------------------------------------------------------------------------------------------*/

module(A) ::= T_MODULE id(B) float(D) integer(E) T_END . {
    (void)A;
    (void)B;
    (void)D;
    (void)E;
}

/*---------------------------------------------------------------------------------------------------------------------+
|  EXPRESSIONS                                                                                                         |
+---------------------------------------------------------------------------------------------------------------------*/

id(A) ::= T_ID(B) . {
    A = static_cast<ast::ID*>(*B);
}
float(A) ::= T_FLOAT(B) . {
    A = static_cast<ast::Float*>(*B);
}
integer(A) ::= T_INTEGER(B) . {
    A = static_cast<ast::Int*>(*B);
}

