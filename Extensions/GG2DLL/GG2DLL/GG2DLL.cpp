/*  Gang Garrison 2 Accessory DLL
 *  allowing GameMaker to embed textual data in PNG files, along with other
 *  various functions
 *
 *  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
 *  If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

// GG2DLL.cpp : Defines the exported functions for the DLL application.

#include "stdafx.h"
#include "GG2DLL.h"
#include "raii.hpp"
#include <cstdlib>

const char GG2_TEXT_CHUNK_KEYWORD[] = "Gang Garrison 2 Level Data";

std::string temp_filename_return_filename;
GG2DLL_API GM_STRING get_temp_filename(GM_STRING directory, GM_STRING prefix) {
	char buffer[MAX_PATH];
	if(GetTempFileNameA(directory, prefix, 0, buffer) == 0)
	{
		// It failed - return the string "ERROR"
		temp_filename_return_filename = "ERROR";
	}
	temp_filename_return_filename = buffer;
	return temp_filename_return_filename.c_str();
}

int load_png_file(const char* filename, png_structp & png_ptr, png_infop & info_ptr) {
    raii_file file(fopen(filename, "rb"));

	if (!file.fp) {
        return -1;
	}

    if (setjmp(png_jmpbuf(png_ptr))) {
        return -1;
    }

    // read the image into RAM
	png_init_io(png_ptr, file.fp);
	png_read_png(png_ptr, info_ptr, PNG_TRANSFORM_IDENTITY, NULL);

	return 0;
}


int save_png_file(const char* filename, png_structp & png_ptr, png_infop & info_ptr) {
    raii_file file(fopen(filename, "wb"));

    if (setjmp(png_jmpbuf(png_ptr))) {
        return -1;
    }

    if (!file.fp) {
		return -1;
    }

    png_init_io(png_ptr, file.fp);
	png_write_png(png_ptr, info_ptr, PNG_TRANSFORM_IDENTITY, NULL);

	if(fclose(file.fp)) {
	    return -1;
	}

	return 0;
}


GG2DLL_API GM_REAL embed_PNG_leveldata(GM_STRING png_filename, GM_STRING new_leveldata) {
    raii_png_read png_read;
    raii_png_write png_write;

	png_structp &read_ptr = png_read.structp;
	png_structp &write_ptr = png_write.structp;
	png_infop &read_info_ptr = png_read.infop;
    png_infop &write_info_ptr = png_write.infop;

    if(!read_ptr || !write_ptr || !read_info_ptr || !write_info_ptr) {
        return -1;
    }

	// load the PNG into memory
	if(load_png_file(png_filename, read_ptr, read_info_ptr)) {
		return -1;
	}

    if (setjmp(png_jmpbuf(read_ptr))) {
        return -1;
    }

    if (setjmp(png_jmpbuf(write_ptr))) {
        return -1;
    }

	// fill in the png_info structure
	{
		int interlace_type, compression_type, filter_type, bit_depth, color_type;
		png_uint_32 width, height;
		if (png_get_IHDR(read_ptr, read_info_ptr, &width, &height, &bit_depth,
			&color_type, &interlace_type, &compression_type, &filter_type))
		{
			png_set_IHDR(write_ptr, write_info_ptr, width, height, bit_depth,
				color_type, interlace_type, compression_type, filter_type);
		}
	}

	{
		png_fixed_point white_x, white_y, red_x, red_y, green_x, green_y, blue_x,
			blue_y;
		if (png_get_cHRM_fixed(read_ptr, read_info_ptr, &white_x, &white_y, &red_x,
			&red_y, &green_x, &green_y, &blue_x, &blue_y))
		{
			png_set_cHRM_fixed(write_ptr, write_info_ptr, white_x, white_y, red_x,
				red_y, green_x, green_y, blue_x, blue_y);
		}
	}

	{
		png_fixed_point gamma;

		if (png_get_gAMA_fixed(read_ptr, read_info_ptr, &gamma))
		{
			png_set_gAMA_fixed(write_ptr, write_info_ptr, gamma);
		}
	}

	{
		png_charp name;
		png_bytep profile;
		png_uint_32 proflen;
		int compression_type;

		if (png_get_iCCP(read_ptr, read_info_ptr, &name, &compression_type,
			&profile, &proflen))
		{
			png_set_iCCP(write_ptr, write_info_ptr, name, compression_type,
				profile, proflen);
		}
	}

	{
		int intent;

		if (png_get_sRGB(read_ptr, read_info_ptr, &intent))
		{
			png_set_sRGB(write_ptr, write_info_ptr, intent);
		}
	}

	{
		png_colorp palette;
		int num_palette;

		if (png_get_PLTE(read_ptr, read_info_ptr, &palette, &num_palette))
		{
			png_set_PLTE(write_ptr, write_info_ptr, palette, num_palette);
		}
	}

	{
		png_color_16p background;

		if (png_get_bKGD(read_ptr, read_info_ptr, &background))
		{
			png_set_bKGD(write_ptr, write_info_ptr, background);
		}
	}

	{
		png_uint_16p hist;

		if (png_get_hIST(read_ptr, read_info_ptr, &hist))
		{
			png_set_hIST(write_ptr, write_info_ptr, hist);
		}
	}

	{
		png_int_32 offset_x, offset_y;
		int unit_type;

		if (png_get_oFFs(read_ptr, read_info_ptr, &offset_x, &offset_y,
			&unit_type))
		{
			png_set_oFFs(write_ptr, write_info_ptr, offset_x, offset_y, unit_type);
		}
	}

	{
		png_charp purpose, units;
		png_charpp params;
		png_int_32 X0, X1;
		int type, nparams;

		if (png_get_pCAL(read_ptr, read_info_ptr, &purpose, &X0, &X1, &type,
			&nparams, &units, &params))
		{
			png_set_pCAL(write_ptr, write_info_ptr, purpose, X0, X1, type,
				nparams, units, params);
		}
	}

	{
		png_uint_32 res_x, res_y;
		int unit_type;

		if (png_get_pHYs(read_ptr, read_info_ptr, &res_x, &res_y, &unit_type))
		{
			png_set_pHYs(write_ptr, write_info_ptr, res_x, res_y, unit_type);
		}
	}

	{
		png_color_8p sig_bit;

		if (png_get_sBIT(read_ptr, read_info_ptr, &sig_bit))
		{
			png_set_sBIT(write_ptr, write_info_ptr, sig_bit);
		}
	}

	{
		int unit;
		double scal_width, scal_height;

		if (png_get_sCAL(read_ptr, read_info_ptr, &unit, &scal_width,
			&scal_height))
		{
			png_set_sCAL(write_ptr, write_info_ptr, unit, scal_width, scal_height);
		}
	}


	{
		png_textp original_text_ptr = NULL, new_text_ptr = NULL, leveldata_text_ptr = NULL;
		int original_num_text, new_num_text;

		// grab the text
		png_get_text(read_ptr, read_info_ptr, &original_text_ptr, &original_num_text);
		// find the gg2 text in the array (if it exists)
		int gg2_text_index = -1;
		for(int a = 0; a < original_num_text; a++) {
			if(strcmp(original_text_ptr[a].key, GG2_TEXT_CHUNK_KEYWORD) == 0) {
				gg2_text_index = a;
				break;
			}
		}

		// if the gg2 comment wasn't found
		if(gg2_text_index == -1) {

			// we are going to create a new array of text entries, and a new entry for the gg2 text
			new_num_text = original_num_text + 1;
			new_text_ptr = (png_textp)png_malloc(write_ptr, sizeof(png_text) * new_num_text); // new array created
			// copy values from old array to new array
			for(int b = 0; b < original_num_text; b++) {
				new_text_ptr[b] = original_text_ptr[b];
			}
			// the last value in the array is the new gg2 text
			leveldata_text_ptr = &(new_text_ptr[new_num_text - 1]);

		// otherwise we DID find an existing gg2 comment
		} else {
			// use the existing array
			new_text_ptr = original_text_ptr;
			new_num_text = original_num_text;

			// a is the index of the gg2 text
			leveldata_text_ptr = &(original_text_ptr[gg2_text_index]);

			/* we'll be using newly allocated text data in an existing text struct.
			 *  libpng will only allocate what's in the struct when we call the destroy function.
			 *  That'll destroy the new text data (if we allocate it correctly), but not the old stuff.
			 *  So we'll free up the old stuff right now.
			 */
			png_free(read_ptr, leveldata_text_ptr->key);

		}

		// allocate space for the new keyword and text data
		leveldata_text_ptr->key = (char*)png_malloc(write_ptr, strlen(GG2_TEXT_CHUNK_KEYWORD) + strlen(new_leveldata) + 2);

		leveldata_text_ptr->text = leveldata_text_ptr->key + strlen(GG2_TEXT_CHUNK_KEYWORD) + 1;

		leveldata_text_ptr->text_length = strlen(new_leveldata);
		leveldata_text_ptr->compression = PNG_TEXT_COMPRESSION_zTXt;

		// copy the data into the newly allocated space
		strcpy(leveldata_text_ptr->key, GG2_TEXT_CHUNK_KEYWORD);
		strcpy(leveldata_text_ptr->text, new_leveldata);

		// use the resulting text struct in the png
		png_set_text(write_ptr, write_info_ptr, new_text_ptr, new_num_text);

		// tell the write struct that it must deallocate the text data
		png_data_freer(write_ptr, write_info_ptr, PNG_DESTROY_WILL_FREE_DATA, PNG_FREE_TEXT);
	}

	{
		png_bytep trans;
		int num_trans;
		png_color_16p trans_values;

		if (png_get_tRNS(read_ptr, read_info_ptr, &trans, &num_trans,
			&trans_values))
		{
			int sample_max = (1 << png_get_bit_depth(read_ptr, read_info_ptr));
			/* libpng doesn't reject a tRNS chunk with out-of-range samples */
			if (!((png_get_color_type(read_ptr, read_info_ptr) == PNG_COLOR_TYPE_GRAY &&
				(int)trans_values->gray > sample_max) ||
				(png_get_color_type(read_ptr, read_info_ptr) == PNG_COLOR_TYPE_RGB &&
				((int)trans_values->red > sample_max ||
				(int)trans_values->green > sample_max ||
				(int)trans_values->blue > sample_max))))
				png_set_tRNS(write_ptr, write_info_ptr, trans, num_trans,
				trans_values);
		}
	}

	// transfer the rows to the new png struct
	{
		png_bytepp rows;
		rows = png_get_rows(read_ptr, read_info_ptr);
		if(rows != NULL) {
			png_set_rows(write_ptr, write_info_ptr, rows);
		}
	}

	// write out the png to the file
	if(save_png_file(png_filename, write_ptr, write_info_ptr)) {
		return -1;
	}

	return 0;
}

static std::string load_leveldata(const char *png_filename) {
    raii_png_read png_read;

    if(!png_read.structp || !png_read.infop) {
        return "";
    }

	if(load_png_file(png_filename, png_read.structp, png_read.infop)) {
		return "";
	}

    if (setjmp(png_jmpbuf(png_read.structp))) {
        return "";
    }

	// grab the text info
	png_textp text_ptr;
	int num_text;
	png_get_text(png_read.structp, png_read.infop, &text_ptr, &num_text);

	// find the gg2 text
	int gg2_text_index = -1;
	for(int a = 0; a < num_text; a++) {
		if(strcmp(GG2_TEXT_CHUNK_KEYWORD, text_ptr[a].key) == 0) {
			gg2_text_index = a;
			break;
		}
	}

	if(gg2_text_index == -1) { // if the text wasn't found
		return "";
	} else {
        return text_ptr[gg2_text_index].text;
	}
}

const std::string ENTITYTAG = "{ENTITIES}";
const std::string ENDENTITYTAG = "{END ENTITIES}";
const std::string WALKMASKTAG = "{WALKMASK}";
const std::string ENDWALKMASKTAG = "{END WALKMASK}";
const std::string DIVIDER = "\x0a";

static int writeGreyscalePng(const char *pngFilename, uint8_t *imageData, size_t width, size_t height) {
    raii_png_write png_write;
    png_bytep *row_ptr = (png_bytep*)malloc(height*sizeof(png_bytep));

    if(row_ptr == NULL) {
        return -1;
    }

    if (setjmp(png_jmpbuf(png_write.structp))) {
        free(row_ptr);
        return -1;
    }

    png_set_IHDR(png_write.structp, png_write.infop, width, height, 8, PNG_COLOR_TYPE_GRAY,
            PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_DEFAULT, PNG_FILTER_TYPE_DEFAULT);

    for(size_t i=0; i<height; i++) {
        row_ptr[i] = imageData + i*width;
    }

    png_set_rows(png_write.structp, png_write.infop, row_ptr);
    int returnValue = save_png_file(pngFilename, png_write.structp, png_write.infop);
    free(row_ptr);
    return returnValue;
}

static int decodeWalkmaskToPng(const char *pngFilename, std::string walkmaskSection) {
    size_t scanpos = 0;
    size_t lineEnd = walkmaskSection.find(DIVIDER, scanpos);
    if(lineEnd == std::string::npos) {
        return -1;
    }
    std::string line = walkmaskSection.substr(scanpos, lineEnd-scanpos);
    scanpos = lineEnd+1;
    size_t width = atol(line.c_str());

    lineEnd = walkmaskSection.find(DIVIDER, scanpos);
    if(lineEnd == std::string::npos) {
        return -1;
    }
    line = walkmaskSection.substr(scanpos, lineEnd-scanpos);
    scanpos = lineEnd+1;
    size_t height = atol(line.c_str());

    if(width > 1000000 || height > 1000000) {
        return -1;
    }

    uint8_t *imageData = (uint8_t*)malloc(width*height + 6);
    if(imageData == NULL) {
        return -1;
    }

    for(size_t imageIndex = 0; imageIndex < width*height && scanpos < walkmaskSection.length(); imageIndex+=6, scanpos++) {
        uint8_t currentData = walkmaskSection.at(scanpos) - 32;
        for(int bitpos=0; bitpos<6; bitpos++) {
            if(currentData&(1<<(5-bitpos))) {
                imageData[imageIndex+bitpos] = 0;
            } else {
                imageData[imageIndex+bitpos] = 255;
            }
        }
    }

    int returnValue = writeGreyscalePng(pngFilename, imageData, width, height);
    free(imageData);
    return returnValue;
}

std::string entitySectionWithTags_return;
GG2DLL_API GM_STRING extract_PNG_leveldata(GM_STRING png_filename, GM_STRING walkmask_filename) {
    std::string leveldata = load_leveldata(png_filename);

    size_t entityTagPos = leveldata.find(ENTITYTAG);
    size_t endEntityTagPos = leveldata.find(ENDENTITYTAG);
    size_t walkmaskTagPos = leveldata.find(WALKMASKTAG);
    size_t endWalkmaskTagPos = leveldata.find(ENDWALKMASKTAG);

    if(entityTagPos == std::string::npos
            || endEntityTagPos == std::string::npos
            || walkmaskTagPos == std::string::npos
            || endWalkmaskTagPos == std::string::npos
            || entityTagPos > endEntityTagPos
            || walkmaskTagPos > endWalkmaskTagPos) {
        return "";
    }

    // Extract the inner content of the walkmask section
    size_t startWalkmaskSection = walkmaskTagPos + WALKMASKTAG.length() + DIVIDER.length();
    size_t walkmaskSectionLength = endWalkmaskTagPos - startWalkmaskSection - DIVIDER.length();
    std::string walkmaskSection = leveldata.substr(startWalkmaskSection, walkmaskSectionLength);

    // Extract the entity tag section including the tags, for returning back to gg2
    size_t entitySectionWithTagsLength = endEntityTagPos - entityTagPos + ENDENTITYTAG.length();
    entitySectionWithTags_return = leveldata.substr(entityTagPos, entitySectionWithTagsLength);

    if(decodeWalkmaskToPng(walkmask_filename, walkmaskSection)) {
        return "";
    }

    return entitySectionWithTags_return.c_str();
}

char compute_MD5_hex_output[16*2 + 1];
GG2DLL_API GM_STRING compute_MD5(GM_STRING filename) {
	// open the file for binary reading
    raii_file file(fopen(filename, "rb"));

	if(file.fp == NULL) {
		return ""; // error, couldn't load the file
	}

	// setup the md5 algorithm
	md5_state_t state;
	md5_byte_t digest[16];
	int di;
	md5_init(&state);

	while(!feof(file.fp) && !ferror(file.fp)) { // while there's more stuff in the file
		char buffer[201];
		size_t amount = fread(buffer, 1, 200, file.fp); // read 200 bytes
		md5_append(&state, (const md5_byte_t *)buffer, amount); // give them to the md5 algorithm
	}

	if(ferror(file.fp)) {
	    return "";
	}

	// put the md5sum into digest
	md5_finish(&state, digest);
	// write the digest into a readable hex string
	for (di = 0; di < 16; ++di)
	    sprintf(compute_MD5_hex_output + di * 2, "%02x", digest[di]);

	return compute_MD5_hex_output;
}
