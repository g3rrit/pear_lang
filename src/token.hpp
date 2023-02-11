#ifndef TOKEN_HPP_
#define TOKEN_HPP_

#include "parser.hpp"

#include <iostream>
#include <string>
#include <cstring>
#include <typeinfo>
#include <vector>
#include <ostream>

#include "ast.hpp"

struct Token {
    int type;

    enum val_type { STR_VAL, INT_VAL, FLOAT_VAL, NONE_VAL } vt;

    union {
        char * str_val;
        int int_val;
        double float_val;
    };

    Token();
    Token(int _type);
    ~Token();

    void cleanup();

    void set_str_val(char * val);
    void set_int_val(int val);
    void set_float_val(double val);

    /* OVERLOADED CASTS */

    operator ast::ID *();
    operator ast::Float *();
    operator ast::Int *();
};

#endif /* TOKEN_HPP_ */
