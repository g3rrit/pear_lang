#ifndef PARSER_DEF_H_
#define PARSER_DEF_H_

#include <cstdlib>

struct Token;

void * FParseAlloc(void * (*)(std::size_t));
void FParse(void *, int, Token *);
void FParseFree(void *, void (*)(void *));

#define parser_alloc()                       FParseAlloc(std::malloc)
#define parser_parse(_parser, _type, _value) FParse(_parser, _type, _value)
#define parser_free(_parser)                 FParseFree(_parser, std::free)

#endif /* PARSER_DEF_H_ */
