import sys
from binascii import unhexlify

if len(sys.argv) != 4:
    print("Usage: hex2txt.py <INPUT_FILE> <OUTPUR_FILE> <SOURCE_ENCODING>")
    exit(1)

finp = sys.argv[1]
fout = sys.argv[2]
fenc = sys.argv[3]

print("INPUT_FILE:\t\t" + finp)
print("OUTPUR_FILE:\t\t" + fout)
print("SOURCE_ENCODING:\t" + fenc)

def hex2file(input_file, output_file):
    with open(input_file, "rb") as fd_in, open(output_file, "wb") as fd_out:
        for line in fd_in:
            data = unhexlify(line.rstrip())
            data = data.decode(fenc)
            data = data.encode('utf8')
            fd_out.write(data)

hex2file(finp, fout)
