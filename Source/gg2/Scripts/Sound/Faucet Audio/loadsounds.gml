faudio_init()
if (faudio_init() == 0)
{
    createSamples();
    createGenerators();
}
else
    show_error("ERROR: Failed to initialize Faucet Audio", 0)
