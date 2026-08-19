import io
import struct


class BinaryReader:
    def __init__(self, data: bytes):
        self.stream = io.BytesIO(data)

    @property
    def position(self):
        return self.stream.tell()

    @position.setter
    def position(self, value):
        self.stream.seek(value)

    def read(self, count):
        return self.stream.read(count)

    def skip(self, count):
        self.stream.seek(count, 1)

    def align(self, alignment=4):
        pos = self.position
        aligned = (pos + alignment - 1) & ~(alignment - 1)
        self.position = aligned

    def u8(self):
        return struct.unpack("<B", self.read(1))[0]

    def i8(self):
        return struct.unpack("<b", self.read(1))[0]

    def u16(self):
        return struct.unpack("<H", self.read(2))[0]

    def i16(self):
        return struct.unpack("<h", self.read(2))[0]

    def u32(self):
        return struct.unpack("<I", self.read(4))[0]

    def i32(self):
        return struct.unpack("<i", self.read(4))[0]

    def u64(self):
        return struct.unpack("<Q", self.read(8))[0]

    def i64(self):
        return struct.unpack("<q", self.read(8))[0]

    def f32(self):
        return struct.unpack("<f", self.read(4))[0]