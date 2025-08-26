if not um.property.apartments then return end

if GetResourceState('qbx_apartments') ~= 'started' then return end

Debug('qbx-apartments ready for list', 'debug')

UM_apartments = {
    ['SouthRockfordDrive'] = {
        type = 'apartment1',
        coords = vector4(-693.8, -1089.88, 13.69, 247.9),
        text = 'South Rockford Drive',
        image = 'https://files.fivemerr.com/images/b4260d0e-2637-48b6-84f3-530be5b0960e.png',
        features = {
            beds = '2 bd',
            bath = '2 ba',
            sqft = '2,300 sqft'
        },
        desc =
        'An upscale dwelling featuring modern amenities and a desirable location, ideal for professionals and city enthusiasts.',
        star = 4,
        tag = "rent"
    },
    ['MorningwoodBlvd'] = {
        type = 'apartment2',
        coords = vector4(-1254.77, -404.6, 34.57, 124.53),
        text = 'Morningwood Blvd',
        image = 'https://files.fivemerr.com/images/21898068-c4ab-44cc-a6e3-7c1d80b13e08.png',
        features = {
            beds = '2 bd',
            bath = '2 ba',
            sqft = '1,800 sqft'
        },
        desc =
        'A luxurious and prestigious residence, offering the finest amenities and a prime location for those who demand the best in urban living.',
        star = 5,
        tag = "rent"
    },
    ['IntegrityWay'] = {
        type = 'apartment3',
        coords = vector4(224.52, -625.15, 40.46, 248.28),
        text = 'Integrity Way',
        image = 'https://files.fivemerr.com/images/e73f75e6-1d5e-4a21-8280-a76ebd32266a.png',
        features = {
            beds = 'Studio',
            bath = '1 ba',
            sqft = '1,100 sqft'
        },
        desc = 'A comfortable and well-maintained apartment, offering a balance between convenience and affordability.',
        star = 3,
        tag = "rent"
    },
    ['TinselTowers'] = {
        type = 'apartment4',
        coords = vector4(-617.55, 5.74, 41.85, 359.29),
        text = 'Tinsel Towers',
        image = 'https://files.fivemerr.com/images/3632fd69-dbda-4114-b587-aa5352e808bf.png',
        features = {
            beds = '1 bd',
            bath = '1 ba',
            sqft = '2,200 sqft'
        },
        desc =
        'An upscale dwelling featuring modern amenities and a desirable location, ideal for professionals and city enthusiasts.',
        star = 5,
        tag = "rent"
    },
    ['FantasticPlaza'] = {
        type = 'apartment5',
        coords = vector4(311.69, -1080.13, 29.4, 100.58),
        text = 'Fantastic Plaza',
        image = 'https://files.fivemerr.com/images/37cf5188-a90c-4705-b100-f25bba4dadb9.png',
        features = {
            beds = 'Studio',
            bath = '1 ba',
            sqft = '800 sqft'
        },
        desc =
        'A basic residence that provides essential amenities, suitable for those who prioritize budget over luxury.',
        star = 3,
        tag = "rent"
    },
}
