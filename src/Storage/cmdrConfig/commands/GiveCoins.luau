return {
    Name = "addcoins",
    Aliases = {"ac"},
    Description = "Gives player coins.",
    Group = "Admin",
    Args = {
        {
            Type = "player",
            Name = "player",
            Description = "The player receiving the coins."
        },
        {
            Type = "number",
            Name = "amount",
            Description = "The amount of coins to give to the player."
        }
    }
    
}