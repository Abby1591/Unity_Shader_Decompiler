import base64
import json

from .lz4util import decompress


class ShaderBlob:

    def __init__(self, json_path):
        self.json_path = json_path

        with open(json_path, "r", encoding="utf8") as f:
            self.data = json.load(f)

    @property
    def name(self):
        return self.data["m_Name"]

    def get_blob(self):

        compressed = base64.b64decode(self.data["m_CompressedBlob"])

        compressed_length = self.data["m_CompressedLengths"][0][0]

        decompressed_length = self.data["m_DecompressedLengths"][0][0]

        return decompress(
            compressed,
            compressed_length,
            decompressed_length,
        )