with (Player)
{
    if (object != -1)
    {
        with (object)
        {
            instance_destroy();
        }
        object = -1;
    }
    PlayerSpawn();
}
