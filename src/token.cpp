#include "token.hpp"

#include <cstring>

#include "parser.hpp"
#include "ast.hpp"

Token::Token() : type(T_OTHER) {
}

Token::Token(int _type) : type(_type), vt(val_type::NONE_VAL) {
}

Token::~Token() {
    cleanup();
}

void Token::cleanup() {
    if (vt == val_type::STR_VAL) {                                                                                     \
        free(str_val);                                                                                                 \
    }
}

void Token::set_str_val(char * val) {
    cleanup();

    str_val = (char *)malloc(strlen(val) + 1);
    strcpy(str_val, val);
    vt = val_type::STR_VAL;
}

void Token::set_int_val(int val) {
    cleanup();

    int_val = val;
    vt      = val_type::INT_VAL;
}

void Token::set_float_val(double val) {
    cleanup();

    float_val = val;
    vt        = val_type::FLOAT_VAL;
}

/*---------------------------------------------------------------------------------------------------------------------+
|  CASTS                                                                                                               |
+---------------------------------------------------------------------------------------------------------------------*/

Token::operator ast::ID *() {
    if (type != T_ID) {
        throw std::bad_cast();
    }
    ast::ID * res = new ast::ID(str_val);
    str_val       = 0;
    return res;
}

Token::operator ast::Float *() {
    if (type != T_FLOAT) {
        throw std::bad_cast();
    }
    float new_val = float_val;
    return new ast::Float(new_val);
}

Token::operator ast::Int *() {
    if (type != T_INTEGER) {
        throw std::bad_cast();
    }
    int new_val = int_val;
    return new ast::Int(new_val);
}
