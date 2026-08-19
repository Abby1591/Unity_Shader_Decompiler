import lz4.block


def decompress(data, compressed_size, decompressed_size):
    return lz4.block.decompress(
        data[:compressed_size],
        uncompressed_size=decompressed_size,
    )