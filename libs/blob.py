import base64

from .lz4util import decompress
from .shader_json import load_shader_json


class ShaderBlob:

    def __init__(self, json_path):
        self.json_path = json_path

        self.data = load_shader_json(json_path)

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
