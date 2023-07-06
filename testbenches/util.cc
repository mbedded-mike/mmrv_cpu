#include "util.hh"
#include <memory>

std::pair<std::unique_ptr<uint32_t[]>, size_t> load_binary(const char* path)
{
    FILE* fp = fopen(path, "rb");
    
    fseek(fp, 0UL, SEEK_END);
    size_t length = ftell(fp);
    rewind(fp);
    std::unique_ptr<uint32_t[]> contents(new uint32_t[length]); 

    fread(reinterpret_cast<void*>(contents.get()), 1UL, length, fp);
    
    return std::make_pair(std::move(contents), length); 
}

