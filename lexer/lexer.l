#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <fstream>

#include "token.hpp"
#include "parser.hpp"
#include "lexer_def.hpp"

Token* lex(std::ifstream &in, bool keep)
{
#define TOKEN_BUFFER_SIZE 256
    static Token token_buffer[TOKEN_BUFFER_SIZE];
    static size_t token_buffer_pos = 0;
    static Token* current_token = nullptr;

    current_token = &token_buffer[token_buffer_pos];

    if(keep) {
        token_buffer_pos++;
    }
    token_buffer_pos %= TOKEN_BUFFER_SIZE;

    std::streampos mar;
    size_t pos = 0;
    size_t line_num = 0;

#define BUFFER_SIZE 1024
    static char buffer[BUFFER_SIZE];
    bzero(buffer, BUFFER_SIZE);
#   define YYCTYPE     char
#   define YYPEEK()    in.peek(); {if(in.eof()) {*current_token = Token(T_END); return current_token;}}
#   define YYSKIP()    do { in.get(buffer[pos]); pos++; if (in.eof()) { *current_token = Token(T_END); return current_token; }} while(0)
#   define YYBACKUP()  mar = in.tellg()
#   define YYRESTORE() in.seekg(mar)

    /*!re2c
        re2c:yyfill:enable = 0;
        [ \t\r]                             {
                                                *current_token = Token(T_OTHER);
                                                return current_token;
                                            }
        [\n]                                {
                                                line_num++;
                                                *current_token = Token(T_OTHER);
                                                return current_token;
                                            }
        "module"                            {
                                                *current_token = Token(T_MODULE);
                                                return current_token;
                                            }
        "u8"                                {
                                                *current_token = Token(T_U8);
                                                return current_token;
                                            }
        "u16"                               {
                                                *current_token = Token(T_U16);
                                                return current_token;
                                            }
        "u32"                               {
                                                *current_token = Token(T_U32);
                                                return current_token;
                                            }
        "u64"                               {
                                                *current_token = Token(T_U64);
                                                return current_token;
                                            }
        "i8"                                {
                                                *current_token = Token(T_I8);
                                                return current_token;
                                            }
        "i16"                               {
                                                *current_token = Token(T_I16);
                                                return current_token;
                                            }
        "i32"                               {
                                                *current_token = Token(T_I32);
                                                return current_token;
                                            }
        "i64"                               {
                                                *current_token = Token(T_I64);
                                                return current_token;
                                            }
        "f32"                               {
                                                *current_token = Token(T_F32);
                                                return current_token;
                                            }
        "f64"                               {
                                                *current_token = Token(T_F64);
                                                return current_token;
                                            }
        "bool"                              {
                                                *current_token = Token(T_BOOL);
                                                return current_token;
                                            }
        "void"                              {
                                                *current_token = Token(T_VOID);
                                                return current_token;
                                            }
        "..."                               {
                                                *current_token = Token(T_TRIPLE_DOT);
                                                return current_token;
                                            }
        "<<="                               {
                                                *current_token = Token(T_DOUBLE_LESS_EQUALS);
                                                return current_token;
                                            }
        ">>="                               {
                                                *current_token = Token(T_DOUBLE_GREATER_EQUALS);
                                                return current_token;
                                            }
        "::"                                {
                                                *current_token = Token(T_DOUBLE_COLON);
                                                return current_token;
                                            }
        "->"                                {
                                                *current_token = Token(T_ARROW);
                                                return current_token;
                                            }
        "&&"                                {
                                                *current_token = Token(T_DOUBLE_AMPERSAND);
                                                return current_token;
                                            }
        "||"                                {
                                                *current_token = Token(T_DOUBLE_PIPE);
                                                return current_token;
                                            }
        "++"                                {
                                                *current_token = Token(T_DOUBLE_PLUS);
                                                return current_token;
                                            }
        "--"                                {
                                                *current_token = Token(T_DOUBLE_MINUS);
                                                return current_token;
                                            }
        "<<"                                {
                                                *current_token = Token(T_DOUBLE_LESS_THAN);
                                                return current_token;
                                            }
        ">>"                                {
                                                *current_token = Token(T_DOUBLE_GREATER_THAN);
                                                return current_token;
                                            }
        "<="                                {
                                                *current_token = Token(T_LESS_EQUALS);
                                                return current_token;
                                            }
        ">="                                {
                                                *current_token = Token(T_GREATER_EQUALS);
                                                return current_token;
                                            }
        "=="                                {
                                                *current_token = Token(T_DOUBLE_EQUALS);
                                                return current_token;
                                            }
        "!="                                {
                                                *current_token = Token(T_NOT_EQUALS);
                                                return current_token;
                                            }
        "+="                                {
                                                *current_token = Token(T_PLUS_EQUALS);
                                                return current_token;
                                            }
        "-="                                {
                                                *current_token = Token(T_MINUS_EQUALS);
                                                return current_token;
                                            }
        "*="                                {
                                                *current_token = Token(T_ASTERIX_EQUALS);
                                                return current_token;
                                            }
        "/="                                {
                                                *current_token = Token(T_SLASH_EQUALS);
                                                return current_token;
                                            }
        "%="                                {
                                                *current_token = Token(T_PERCENT_EQUALS);
                                                return current_token;
                                            }
        "&="                                {
                                                *current_token = Token(T_AMPERSAND_EQUALS);
                                                return current_token;
                                            }
        "^="                                {
                                                *current_token = Token(T_CIRCUMFLEX_EQUALS);
                                                return current_token;
                                            }
        "|="                                {
                                                *current_token = Token(T_PIPE_EQUALS);
                                                return current_token;
                                            }
        [&]                                 {
                                                *current_token = Token(T_AMPERSAND);
                                                return current_token;
                                            }
        [\x5e]                              {
                                                *current_token = Token(T_CIRCUMFLEX);
                                                return current_token;
                                            }
        [:]                                 {
                                                *current_token = Token(T_COLON);
                                                return current_token;
                                            }
        [;]                                 {
                                                *current_token = Token(T_SEMICOLON);
                                                return current_token;
                                            }
        [,]                                 {
                                                *current_token = Token(T_COMMA);
                                                return current_token;
                                            }
        [\x7b]                              {
                                                *current_token = Token(T_L_C_BRACKET);
                                                return current_token;
                                            }
        [\x7d]                              {
                                                *current_token = Token(T_R_C_BRACKET);
                                                return current_token;
                                            }
        [\x28]                              {
                                                *current_token = Token(T_L_R_BRACKET);
                                                return current_token;
                                            }
        [\x29]                              {
                                                *current_token = Token(T_R_R_BRACKET);
                                                return current_token;
                                            }
        [\x5b]                              {
                                                *current_token = Token(T_L_S_BRACKET);
                                                return current_token;
                                            }
        [\x5d]                              {
                                                *current_token = Token(T_R_S_BRACKET);
                                                return current_token;
                                            }
        [\x2a]                              {
                                                *current_token = Token(T_ASTERIX);
                                                return current_token;
                                            }
        [\x2b]                              {
                                                *current_token = Token(T_PLUS);
                                                return current_token;
                                            }
        [\x2d]                              {
                                                *current_token = Token(T_MINUS);
                                                return current_token;
                                            }
        [\x2f]                              {
                                                *current_token = Token(T_SLASH);
                                                return current_token;
                                            }
        [\x2e]                              {
                                                *current_token = Token(T_DOT);
                                                return current_token;
                                            }
        [\x3d]                              {
                                                *current_token = Token(T_EQUALS);
                                                return current_token;
                                            }
        [%]                                 {
                                                *current_token = Token(T_PERCENT);
                                                return current_token;
                                            }
        [!]                                 {
                                                *current_token = Token(T_EXCLAMATIONMARK);
                                                return current_token;
                                            }
        [?]                                 {
                                                *current_token = Token(T_QUESTIONMARK);
                                                return current_token;
                                            }
        [<]                                 {
                                                *current_token = Token(T_LESS_THAN);
                                                return current_token;
                                            }
        [>]                                 {
                                                *current_token = Token(T_GREATER_THAN);
                                                return current_token;
                                            }
        [\x7c]                              {
                                                *current_token = Token(T_PIPE);
                                                return current_token;
                                            }
        [\x7e]                              {
                                                *current_token = Token(T_TILDE);
                                                return current_token;
                                            }
        [0-9]+                              {
                                                *current_token = Token(T_INTEGER);
                                                current_token->set_int_val(atoi(buffer));
                                                return current_token;
                                            }
        [0-9]+[\x2e][0-9]+                  {
                                                *current_token = Token(T_FLOAT);
                                                current_token->set_float_val(atof(buffer));
                                                return current_token;
                                            }
        [a-zA-Z_][a-zA-Z0-9_]*              {
                                                *current_token = Token(T_ID);
                                                current_token->set_str_val(buffer);
                                                return current_token;
                                            }
    */
}
