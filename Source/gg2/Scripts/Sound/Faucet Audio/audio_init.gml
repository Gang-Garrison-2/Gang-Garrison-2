if (faudio_init() == 0)
{
    sample_init();
}
else
{
    show_error(faudio_get_error(), 0)
}
