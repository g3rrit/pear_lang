#ifndef LEXER_DEF_HPP_
#define LEXER_DEF_HPP_

#include <cstring>
#include <string>
#include <iostream>
#include <cstdio>
#include <fstream>

#include "token.hpp"
#include "parser.hpp"

Token * lex(std::ifstream & in, bool keep);

#endif /* LEXER_DEF_HPP_ */
