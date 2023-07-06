#include <memory>
#include <cstdio>
#include <tuple>
#include <inttypes.h>

#define WORD_ALIGNED(x) ((x & 0b11U) == 0)

std::pair<std::unique_ptr<uint32_t[]>, size_t> load_binary(const char* path);
