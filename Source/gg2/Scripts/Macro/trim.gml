var len, firstNonspace, firstTrailingSpace;
len = string_length(argument0);

for(firstNonspace = 1; firstNonspace <= len; firstNonspace += 1) {
    if(string_char_at(argument0, firstNonspace) != ' ') {
        break;
    }
}

for(firstTrailingSpace = len+1; firstTrailingSpace > firstNonspace; firstTrailingSpace -= 1) {
    if(string_char_at(argument0, firstTrailingSpace-1) != ' ') {
        break;
    }
}

return string_copy(argument0, firstNonspace, firstTrailingSpace-firstNonspace);
