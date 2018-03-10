#ifndef ADDRESSES_H
#define ADDRESSES_H

#include "iota_types.h"

#define MAX_SECURITY 3

void get_public_addr(const unsigned char *seed_bytes, uint32_t idx, uint8_t security,
                   unsigned char *address_bytes);

void add_checksum(const unsigned char *address_bytes, unsigned char *checksum_bytes);

#endif // ADDRESSES_H
