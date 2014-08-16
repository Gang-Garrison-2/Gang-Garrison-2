/*  Gang Garrison 2 Accessory DLL
 *  allowing GameMaker to embed textual data in PNG files, along with other
 *  various functions
 *  Copyright (C) 2008  Andrew Bradley
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

// The following ifdef block is the standard way of creating macros which make exporting
// from a DLL simpler. All files within this DLL are compiled with the GG2DLL_EXPORTS
// symbol defined on the command line. this symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see
// GG2DLL_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef GG2DLL_EXPORTS
#define GG2DLL_API __declspec(dllexport)
#else
#define GG2DLL_API __declspec(dllimport)
#endif

// this define turns off name mangling, allowing gamemaker to use the functions
#define GM_EXPORT extern "C"
// the gamemaker variable types (real and string)
#define GM_REAL double
#define GM_STRING const char*

int load_png_file(const char* filename, png_structp & png_ptr, png_infop & info_ptr, png_infop & end_info);

int save_png_file(const char* filename, png_structp & png_ptr, png_infop & info_ptr, png_infop & end_info);

GM_EXPORT GG2DLL_API GM_STRING get_temp_filename(GM_STRING directory, GM_STRING prefix);

GM_EXPORT GG2DLL_API GM_REAL embed_PNG_leveldata(GM_STRING png_filename, GM_STRING new_leveldata);

GM_EXPORT GG2DLL_API GM_STRING extract_PNG_leveldata(GM_STRING png_filename, GM_STRING walkmask_filename);

GM_EXPORT GG2DLL_API GM_STRING compute_MD5(GM_STRING filename);
