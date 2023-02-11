#include "ast.hpp"

#include <algorithm>
#include <cstdlib>

#include "token.hpp"

namespace ast {

/*---------------------------------------------------------------------------------------------------------------------+
|  ID                                                                                                                  |
+---------------------------------------------------------------------------------------------------------------------*/

void swap(ID & a, ID & b) noexcept {
    using std::swap;
    swap(a.val, b.val);
}

ID::ID(char * _val) : len(strlen(_val)), val(_val) {
}

ID::ID(ID const & id) : len(id.len), val((char *)std::malloc(id.len)) {
    std::copy(id.val, id.val + id.len, val);
}

ID::ID(ID && id) noexcept : ID() {
    swap(*this, id);
}

ID::~ID() {
    std::free(val);
}

ID & ID::operator=(ID id) {
    swap(*this, id);
    return *this;
}

ID & ID::operator=(ID && id) noexcept {
    swap(*this, id);
    return *this;
}

bool ID::operator<(const ID & rhs) const {
    return std::strcmp(this->val, rhs.val) < 0;
}

bool ID::operator>(const ID & rhs) const {
    return std::strcmp(this->val, rhs.val) > 0;
}

std::ostream & operator<<(std::ostream & os, const ID & i) {
    os << "id[" << i.val << "]";
    return os;
}

/*---------------------------------------------------------------------------------------------------------------------+
|  Float                                                                                                               |
+---------------------------------------------------------------------------------------------------------------------*/

Float::Float(f64 _val) : val(_val) {
}

std::ostream & operator<<(std::ostream & os, const Float & f) {
    os << "float[" << f.val << "]";
    return os;
}

/*---------------------------------------------------------------------------------------------------------------------+
|  Int                                                                                                                 |
+---------------------------------------------------------------------------------------------------------------------*/

Int::Int(int _val) : val(_val) {
}

std::ostream & operator<<(std::ostream & os, const Int & i) {
    os << "int[" << i.val << "]";
    return os;
}

} // namespace ast
