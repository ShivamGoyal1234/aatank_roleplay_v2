if not um.property.apartments then return end

if GetResourceState('ps-housing') ~= 'started' then return end

Debug('ps-housing ready for apartment list')

UM_apartments = {
    ['Integrity Way'] = {
        type = 'apartment3',
        coords = vector4(224.52, -625.15, 40.46, 248.28),
        text = 'Integrity Way',
        image = 'https://files.fivemerr.com/images/e5a352a3-afb1-4452-ab52-e239e53d901a.png',
        features = {
            beds = 'Studio',
            bath = '1 ba',
            sqft = '1,100 sqft'
        },
        desc = 'A comfortable and well-maintained apartment, offering a balance between convenience and affordability.',
        star = 3,
        tag = "rent"
    },
    ['South Rockford Drive'] = {
        type = 'apartment1',
        coords = vector4(-693.8, -1089.88, 13.69, 247.9),
        text = 'South Rockford Drive',
        image = 'https://files.fivemerr.com/images/aa88b5df-c4c8-4706-beb0-8d8197e0ccff.png',
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
    ['Morningwood Blvd'] = {
        type = 'apartment2',
        coords = vector4(-1254.77, -404.6, 34.57, 124.53),
        text = 'Morningwood Blvd',
        image = 'https://files.fivemerr.com/images/c53dbc10-d161-4b34-a095-316949588f33.png',
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
    ['Tinsel Towers'] = {
        type = 'apartment4',
        coords = vector4(-617.55, 5.74, 41.85, 359.29),
        text = 'Tinsel Towers',
        image = 'https://files.fivemerr.com/images/0663c90e-2e90-426d-80ea-a780727b4a76.png',
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
    ['Fantastic Plaza'] = {
        type = 'apartment5',
        coords = vector4(311.69, -1080.13, 29.4, 100.58),
        text = 'Fantastic Plaza',
        image = 'https://files.fivemerr.com/images/d618a25e-2f88-47c5-b065-515cbd34cb3f.png',
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
    --- ipl
    ['Modern 1 Apartment'] = {
        type = 'apartment6',
        coords = vector4(311.69, -1080.13, 29.4, 100.58),
        text = 'Modern 1 Apartment',
        image = 'https://files.fivemerr.com/images/d618a25e-2f88-47c5-b065-515cbd34cb3f.png',
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
