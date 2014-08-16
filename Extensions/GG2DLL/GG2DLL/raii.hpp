#pragma once

class raii_file {
public:
    raii_file(FILE *file) : fp(file) {}

    ~raii_file() {
        if(fp != NULL) {
            fclose(fp);
        }
    }

    FILE *fp;

private:
    raii_file(const raii_file& other);
    raii_file operator=(const raii_file& other);
};

class raii_png_read {
public:
    raii_png_read() :
            structp(png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL)),
            infop(png_create_info_struct(structp))  {}

    ~raii_png_read() {
        png_destroy_read_struct(&structp, &infop, NULL);
    }

    png_structp structp;
    png_infop infop;

private:
    raii_png_read(const raii_png_read& other);
    raii_png_read operator=(const raii_png_read& other);
};

class raii_png_write {
public:
    raii_png_write() :
            structp(png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL)),
            infop(png_create_info_struct(structp))  {}

    ~raii_png_write() {
        png_destroy_write_struct(&structp, &infop);
    }

    png_structp structp;
    png_infop infop;

private:
    raii_png_write(const raii_png_write& other);
    raii_png_write operator=(const raii_png_write& other);
};
