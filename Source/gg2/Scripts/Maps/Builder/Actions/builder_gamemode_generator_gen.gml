// builder_init: addGamemode("Generator (gen)")
var redgen, bluegen;
redgen = 0;
bluegen = 0;
with(LevelEntity) {
    if (type == "GeneratorRed") redgen += 1;
    else if (type == "GeneratorBlue") bluegen += 1;
}
if (redgen != 1 || bluegen != 1) return false;
return true;
