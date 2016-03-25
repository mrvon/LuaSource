#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <zlib.h>

#define CHUNK 16384

static int 
def(FILE* source, FILE* dest, int level) {
    int ret;
    int flush;
    unsigned int have;
    z_stream stream;
    unsigned char in[CHUNK];
    unsigned char out[CHUNK];

    // allocate deflate state
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;

    ret = deflateInit(&stream, level);

    if (ret != Z_OK) {
        return ret;
    }

    // compress until end of file
    do {
        stream.avail_in = fread(in, 1, CHUNK, source);
        stream.next_in = in;

        if (ferror(source)) {
            deflateEnd(&stream);
            return Z_ERRNO;
        }

        flush = feof(source) ? Z_FINISH : Z_NO_FLUSH;

        // run deflate() on input until output buffer not full, finish
        // compression if all of source has been read in
        do {
            stream.avail_out = CHUNK;
            stream.next_out = out;

            ret = deflate(&stream, flush);
            assert(ret != Z_STREAM_ERROR);

            have = CHUNK - stream.avail_out;
            if (fwrite(out, 1, have, dest) != have || ferror(dest)) {
                deflateEnd(&stream);
                return Z_ERRNO;
            }
        } while (stream.avail_out == 0);

        assert(stream.avail_in == 0); // all input will be used

        // done when last data is file processed
    } while (flush != Z_FINISH);

    assert(ret = Z_STREAM_END); // stream will be complete

    // clean up and return
    deflateEnd(&stream);

    return Z_OK;
}

static int 
inf(FILE* source, FILE* dest) {
    int ret;
    unsigned int have;
    z_stream stream;
    unsigned char in[CHUNK];
    unsigned char out[CHUNK];

    // allocate inflate state
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = 0;
    stream.next_in = Z_NULL;

    ret = inflateInit(&stream);

    if (ret != Z_OK) {
        return ret;
    }

    // decompress until inflate stream ends or end of file
    do {
        stream.avail_in = fread(in, 1, CHUNK, source);
        stream.next_in = in;

        if (ferror(source)) {
            inflateEnd(&stream);
            return Z_ERRNO;
        }

        if (stream.avail_in == 0) {
            break;
        }

        // run inflate() on input until output buffer not full
        do {
            stream.avail_out = CHUNK;
            stream.next_out = out;

            ret = inflate(&stream, Z_NO_FLUSH);
            assert(ret != Z_STREAM_ERROR);

            switch(ret) {
                case Z_NEED_DICT:
                    ret = Z_DATA_ERROR;
                    // and fall through
                case Z_DATA_ERROR:
                case Z_MEM_ERROR:
                    inflateEnd(&stream);
                    return ret;
            }

            have = CHUNK - stream.avail_out;

            if (fwrite(out, 1, have, dest) != have || ferror(dest)) {
                inflateEnd(&stream);
                return Z_ERRNO;
            }
            
        } while (stream.avail_out == 0);

        // done when inflate() says it's done
    } while (ret != Z_STREAM_END);

    // clean up and return
    inflateEnd(&stream);

    return ret == Z_STREAM_END ? Z_OK : Z_DATA_ERROR;
}

int 
main(int argc, char const* argv[]) {
    const char* error_message = "wrong argument\n";

    if (argc != 2) {
        printf("%s", error_message);
        return 0;
    }

    const char* cmd = argv[1];

    if (strcmp(cmd, "compress") == 0) {
        def(stdin, stdout, Z_DEFAULT_COMPRESSION);
    } else if (strcmp(cmd, "uncompress") == 0) {
        inf(stdin, stdout);
    } else {
        printf("%s", error_message);
    }

    return 0;
}
