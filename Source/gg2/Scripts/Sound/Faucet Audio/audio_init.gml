if (faudio_init() == 0)
{
    sample_init();
}
else
    show_error("ERROR: Failed to initialize Faucet Audio", 0)
