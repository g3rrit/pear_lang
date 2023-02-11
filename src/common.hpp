#ifndef COMMON_HPP_
#define COMMON_HPP_

#include <vector>
#include <map>
#include <set>
#include <cstdint>

// - PRIMITIVE TYPES ---------------------------------------------------------------------------------------------------

using f32 = float;
static_assert(sizeof(float) == 4, "Float is not four bytes");
using f64 = double;
static_assert(sizeof(double) == 8, "Double is not eight bytes");

using i8  = int8_t;
using i16 = int16_t;
using i32 = int32_t;
using i64 = int64_t;

using u8  = uint8_t;
using u16 = uint16_t;
using u32 = uint32_t;
using u64 = uint64_t;

using isize = ssize_t;
using usize = size_t;

// bool
// int
using uint = unsigned int;

// - TYPES -------------------------------------------------------------------------------------------------------------

template <class T>
using vec = std::vector<T>;

template <class K, class V>
using map = std::map<K, V>;

template <class T>
using set = std::set<T>;

#endif /* COMMON_HPP_ */
