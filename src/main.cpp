#include <iostream>
#include <fstream>

#include <unistd.h>
#include <iostream>

#include "lexer_def.hpp"
#include "parser_def.hpp"

struct Opts {
    char * in_file = nullptr;
};

void parse_opts(int argc, char **argv, Opts & opts) {

    for(;;) {
        switch(getopt(argc, argv, "i:h")) {
            case 'i': {
                opts.in_file = optarg; 
                break;
            }
            case 'h': {
                std::cout << "Specify input file\n"; 
                std::exit(-1);
            }
            case -1: {
                break;
            }
        }
        break;
    }
}

int main(int argc, char ** argv) {

    Opts opts;
    parse_opts(argc, argv, opts);

    void * parser = parser_alloc();

    std::ifstream in(opts.in_file, std::ios::binary);
    if (in.fail()) {
        std::cerr << "Unable to open file" << std::endl;
        std::exit(-1);
    }

    Token * t = nullptr;
    bool keep = true;
    for (;;) {
        t = lex(in, keep);

        if (t->type == T_OTHER) {
            keep = true; // bug!
            continue;
        } else if (t->type == T_END) {
            break;
        }

        keep = true;

        parser_parse(parser, t->type, t);
    }

    return 0;
}
