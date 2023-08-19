--Decks to generate

shuffle_decks = {
    --deck size 1
    {},
    --deck size 2
    {
        {
            {type = "PROJECTILE", amount = 2, same_projectiles = false}
        },
        {
            {type = "MODIFIER", amount = 1},
            {type = "PROJECTILE", amount = 1, same_projectiles = true}
        }
    },
    --deck size 3
    {
        {
            {type = "PROJECTILE", amount = 3, same_projectiles = false}
        },
        {
            {type = "MODIFIER", amount = 1},
            {type = "PROJECTILE", amount = 2, same_projectiles = false}
        }
    },
    --deck size 4
    {
        {
            {type = "MODIFIER", amount = 1},
            {type = "PROJECTILE", amount = 3, same_projectiles = false}
        },
        {
            {type = "MODIFIER", amount = 2},
            {type = "PROJECTILE", amount = 2, same_projectiles = false}
        }
    },
    --deck size 5
    {
        {
            {type = "MODIFIER", amount = 1},
            {type = "PROJECTILE", amount = 4, same_projectiles = false}
        },
        {
            {type = "MODIFIER", amount = 2},
            {type = "PROJECTILE", amount = 3, same_projectiles = false}
        },
        {
            {type = "MODIFIER", amount = 1},
            {type = "DRAW_2", amount = 1},
            {type = "PROJECTILE", amount = 3, same_projectiles = false}
        },
        {
            {type = "MODIFIER", amount = 1},
            {type = "DRAW_3", amount = 1},
            {type = "PROJECTILE", amount = 3, same_projectiles = false}
        }
    },
    --deck size 6
    {
        {
            {type = "MODIFIER", amount = 1},
            {type = "PROJECTILE", amount = 5, same_projectiles = false}
        },
        {
            {type = "MODIFIER", amount = 2},
            {type = "PROJECTILE", amount = 4, same_projectiles = false}
        },
        {
            {type = "MODIFIER", amount = 1},
            {type = "DRAW_2", amount = 1},
            {type = "PROJECTILE", amount = 4, same_projectiles = false}
        },
        {
            {type = "MODIFIER", amount = 1},
            {type = "DRAW_3", amount = 1},
            {type = "PROJECTILE", amount = 4, same_projectiles = false}
        },
        {
            {type = "MODIFIER", amount = 1},
            {type = "DRAW_2", amount = 1},
            {type = "PROJECTILE", amount = 4, same_projectiles = false}
        }
    },
    --deck size 7
    {
        {
            {type = "MODIFIER", amount = 1},
            {type = "PROJECTILE", amount = 6, same_projectiles = false}
        },
        {
            {type = "MODIFIER", amount = 2},
            {type = "PROJECTILE", amount = 4, same_projectiles = false}
        },
        {
            {type = "MODIFIER", amount = 2},
            {type = "DRAW_2", amount = 1},
            {type = "PROJECTILE", amount = 4, same_projectiles = false}
        },
        {
            {type = "MODIFIER", amount = 2},
            {type = "DRAW_3", amount = 1},
            {type = "PROJECTILE", amount = 4, same_projectiles = false}
        },
        {
            {type = "MODIFIER", amount = 2},
            {type = "DRAW_3", amount = 1},
            {type = "PROJECTILE", amount = 4, same_projectiles = false}
        }
    }
}

non_shuffle_decks = {
    --deck size 1
    {},
    --deck size 2
    {
        {
            {type = "PROJECTILE", amount = 2, same_projectiles = true}
        },
        {
            {type = "MODIFIER", amount = 1},
            {type = "PROJECTILE", amount = 1, same_projectiles = true}
        },
        {
            {type = "trigger", amount = 1},
            {type = "PROJECTILE", amount = 1, same_projectiles = true}
        }
    },
    --deck size 3
    {
        {
            {type = "PROJECTILE", amount = 3, same_projectiles = true}
        },
        {
            {type = "MODIFIER", amount = 1},
            {type = "PROJECTILE", amount = 2, same_projectiles = true}
        },
        {
            {type = "DRAW_2", amount = 1},
            {type = "PROJECTILE", amount = 2, same_projectiles = true}
        },
        {
            {type = "TRIGGER", amount = 1},
            {type = "MODIFIER", amount = 1},
            {type = "PROJECTILE", amount = 1, same_projectiles = true}
        }
    },
    --deck size 4
    {
        {
            {type = "DRAW_3", amount = 1},
            {type = "PROJECTILE", amount = 3, same_projectiles = true}
        },
        {
            {type = "MODIFIER", amount = 1},
            {type = "DRAW_2", amount = 1},
            {type = "PROJECTILE", amount = 2, same_projectiles = true}
        },
        {
            {type = "TRIGGER", amount = 1},
            {type = "DRAW_2", amount = 1},
            {type = "PROJECTILE", amount = 2, same_projectiles = true}
        }
    },
    --deck size 5
    {
        {
            {type = "MODIFIER", amount = 1},
            {type = "DRAW_3", amount = 1},
            {type = "PROJECTILE", amount = 3, same_projectiles = true}
        },
        {
            {type = "MODIFIER", amount = 2},
            {type = "DRAW_2", amount = 1},
            {type = "PROJECTILE", amount = 2, same_projectiles = true}
        },
        {
            {type = "TRIGGER", amount = 1},
            {type = "MODIFIER", amount = 1},
            {type = "DRAW_2", amount = 1},
            {type = "PROJECTILE", amount = 2, same_projectiles = true}
        },
        {
            {type = "TRIGGER", amount = 1},
            {type = "DRAW_3", amount = 1},
            {type = "PROJECTILE", amount = 3, same_projectiles = true}
        }
    },
    --deck size 6
    {
        {
            {type = "MODIFIER", amount = 1},
            {type = "DRAW_4", amount = 1},
            {type = "PROJECTILE", amount = 4, same_projectiles = true}
        },
        {
            {type = "MODIFIER", amount = 2},
            {type = "DRAW_3", amount = 1},
            {type = "PROJECTILE", amount = 3, same_projectiles = true}
        },
        {
            {type = "TRIGGER", amount = 1},
            {type = "MODIFIER", amount = 1},
            {type = "DRAW_3", amount = 1},
            {type = "PROJECTILE", amount = 3, same_projectiles = true}
        },
        {
            {type = "TRIGGER", amount = 1},
            {type = "DRAW_4", amount = 1},
            {type = "PROJECTILE", amount = 4, same_projectiles = true}
        }
    },
    --deck size 7
    {
        {
            {type = "MODIFIER", amount = 2},
            {type = "DRAW_4", amount = 1},
            {type = "PROJECTILE", amount = 4, same_projectiles = true}
        },
        {
            {type = "TRIGGER", amount = 1},
            {type = "MODIFIER", amount = 1},
            {type = "DRAW_4", amount = 1},
            {type = "PROJECTILE", amount = 4, same_projectiles = true}
        }
    }
}
