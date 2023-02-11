#ifndef AST_HPP_
#define AST_HPP_

#include <iostream>

#include "common.hpp"

namespace ast {

struct Node {
    int n;
};

struct ID : Node {
    size_t len;
    char * val;

    ID(char * _val = nullptr);

    ID(ID const & id);    

    ID(ID&& id) noexcept;

    ~ID();

    ID & operator=(ID id);

    ID & operator=(ID && id) noexcept;

    friend void swap(ID & a, ID & b) noexcept;

    bool operator<(const ID &) const;
    bool operator>(const ID &) const;

    friend std::ostream & operator<<(std::ostream &, const ID &);
};

struct String : ID {
};

struct Float : Node {
    f64 val;
    Float(f64 _val);
    friend std::ostream & operator<<(std::ostream &, const Float &);
};

struct Int : Node {
    int val;
    Int(int _val);
    friend std::ostream & operator<<(std::ostream &, const Int &);
};

struct Module : Node {
    int n;
};

} // namespace ast

#endif /* AST_HPP_ */
