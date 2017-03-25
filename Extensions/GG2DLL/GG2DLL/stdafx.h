/*  Gang Garrison 2 Accessory DLL
 *  allowing GameMaker to embed textual data in PNG files, along with other
 *  various functions
 *  Copyright (C) 2008  Andrew Bradley
 *
 *  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
 *  If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
#include <windows.h>

#include <iostream>
#include <fstream>
#include <png.h>
#include "md5.h"
#include <string>
