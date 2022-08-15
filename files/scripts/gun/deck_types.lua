--[[
    TYPES:

    PROJECTILE
    MODIFIER
    TRIGGER
    MULTICAST_2
    MULTICAST_3
    MULTICAST_4
]]

deck_types = {
    --DECK SIZE 1
    {
        deck_size = 1,
        shuffle_decks = {},
        non_shuffle_decks = {}
    },
    --DECK SIZE 2
    {
        deck_size = 2,
        shuffle_decks = {
            {
                deck = {
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            },
            {
                deck = {
                    "MODIFIER",
                    "PROJECTILE"
                },
                same_projectiles = true
            }
        },
        non_shuffle_decks = {
            {
                deck = {
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            },
            {
                deck = {
                    "MODIFIER",
                    "PROJECTILE"
                },
                same_projectiles = true
            },
            {
                deck = {
                    "TRIGGER",
                    "PROJECTILE"
                },
                same_projectiles = true
            }
        }
    },
    --DECK SIZE 3
    {
        deck_size = 3,
        shuffle_decks = {
            {
                deck = {
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            },
            {
                deck = {
                    "MODIFIER",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            }
        },
        non_shuffle_decks = {
            {
                deck = {
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            },
            {
                deck = {
                    "MODIFIER",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            },
            {
                deck = {
                    "MULTICAST_2",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            },
            {
                deck = {
                    "TRIGGER",
                    "MODIFIER",
                    "PROJECTILE"
                },
                same_projectiles = true
            }
        }
    },
    --DECK SIZE 4
    {
        deck_size = 4,
        shuffle_decks = {
            {
                deck = {
                    "MODIFIER",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            },
            {
                deck = {
                    "MODIFIER",
                    "MODIFIER",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            }
        },
        non_shuffle_decks = {
            {
                deck = {
                    "MULTICAST_3",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            },
            {
                deck = {
                    "MODIFIER",
                    "MULTICAST_2",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            },
            {
                deck = {
                    "TRIGGER",
                    "MULTICAST_2",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            }
        }
    },
    --DECK SIZE 5
    {
        deck_size = 5,
        shuffle_decks = {
            {
                deck = {
                    "MODIFIER",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            },
            {
                deck = {
                    "MODIFIER",
                    "MODIFIER",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            },
            {
                deck = {
                    "MODIFIER",
                    "MULTICAST_2",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            },
            {
                deck = {
                    "MODIFIER",
                    "MULTICAST_3",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            }
        },
        non_shuffle_decks = {
            {
                deck = {
                    "MODIFIER",
                    "MULTICAST_3",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            },
            {
                deck = {
                    "MODIFIER",
                    "MODIFIER",
                    "MULTICAST_2",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            },
            {
                deck = {
                    "TRIGGER",
                    "MODIFIER",
                    "MULTICAST_2",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            },
            {
                deck = {
                    "TRIGGER",
                    "MULTICAST_3",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            }
        }
    },
    --DECK SIZE 6
    {
        deck_size = 6,
        shuffle_decks = {
            {
                deck = {
                    "MODIFIER",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            },
            {
                deck = {
                    "MODIFIER",
                    "MODIFIER",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            },
            {
                deck = {
                    "MODIFIER",
                    "MULTICAST_2",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            },
            {
                deck = {
                    "MODIFIER",
                    "MULTICAST_3",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            },
            {
                deck = {
                    "MODIFIER",
                    "MULTICAST_4",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            }
        },
        non_shuffle_decks = {
            {
                deck = {
                    "MODIFIER",
                    "MULTICAST_4",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            },
            {
                deck = {
                    "MODIFIER",
                    "MODIFIER",
                    "MULTICAST_3",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            },
            {
                deck = {
                    "TRIGGER",
                    "MODIFIER",
                    "MULTICAST_3",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            },
            {
                deck = {
                    "TRIGGER",
                    "MULTICAST_4",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            }
        }
    },
    --DECK SIZE 7
    {
        deck_size = 7,
        shuffle_decks = {
            {
                deck = {
                    "MODIFIER",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            },
            {
                deck = {
                    "MODIFIER",
                    "MODIFIER",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            },
            {
                deck = {
                    "MODIFIER",
                    "MODIFIER",
                    "MULTICAST_2",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            },
            {
                deck = {
                    "MODIFIER",
                    "MODIFIER",
                    "MULTICAST_3",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            },
            {
                deck = {
                    "MODIFIER",
                    "MODIFIER",
                    "MULTICAST_4",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = false
            }
        },
        non_shuffle_decks = {
            {
                deck = {
                    "MODIFIER",
                    "MODIFIER",
                    "MULTICAST_4",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            },
            {
                deck = {
                    "TRIGGER",
                    "MODIFIER",
                    "MULTICAST_4",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE",
                    "PROJECTILE"
                },
                same_projectiles = true
            }
        }
    }
}
