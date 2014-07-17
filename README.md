## About this Project

Everyone has materials sitting around their house that they don't know what to do with — old or broken appliances, burnt-out fluorescent light bulbs, bags of dead batteries waiting to find a final resting place.

__*What Do I Do With...?*__ was inspired by King County's [original recycling website](http://your.kingcounty.gov/solidwaste/wdidw/), which provides information on local businesses willing to accept and responsibly dispose of a variety of unwanted materials.

The application you see here builds on King County's website by incorporating geolocation, distance, and mapping features, as well as an improved user experience, particularly for mobile devices. It pulls data on a weekly basis from a [public dataset](https://data.kingcounty.gov/Environment/What-do-I-do-with-Recycling-options-in-King-County/zqwi-c5q3) to ensure up-to-date information and includes a public API for easy location-based querying.

This project was created by [Audrey Carlsen](http://www.audreycarlsen.com/) through [Ada Developers Academy](http://adadevelopersacademy.org/).

Special thanks goes to Al Boss and Jay Beach at King County for their enthusiasm and encouragement.

**Publicity:**
+ [Washington Business Alliance](http://www.wacatalyst.org/seattle-women-in-software-design-student-improves-on-king-county-web-app/)
+ [Seattle.io](http://www.seattle.io/posts/civic-apps-built-by-students-at-ada-developers-academy)

## What Do I Do With . . . this API?

###Requests

A WDIDW Location API request takes the following form:

    http://www.wdidw.com/api/locations?parameters

Output is in JavaScript Object Notation (JSON).

###Parameters

All parameters are optional and should be separated using the ampersand (&) character. If no parameters are provided, the response will include all locations.

One or more material categories can be included in the query string, separated by commas. Response will only include locations that match all specified materials.

    materials="Gaming+Devices,Air+Conditioners"

Locations can also be filtered by address:

    city=Seattle
    state=WA
    zipcode=98105
    
Or by service type:
    
    business=true
    residents=true
    drop_off=true
    mail_in=true
    pick_up=true

###Responses

A sample HTTP request is shown below:

    http://www.wdidw.com/api/locations?materials=TVs,Monitors&zipcode=98006&residents=true
    
The JSON result is shown below:

    [ { "_id":
            { "$oid": "534c73c76c61739a298e0000" },
        "business": false,
        "city": "Bellevue",
        "cost": "FREE for E-Cycle Washington eligible groups including residents, small businesses (\u003C 50 employees corporate-wide), school districts (no colleges or universities), charities and non-profit groups.",
        "description":"Authorized E-Cycle Washington Collector. Accepts computer monitors for recycling. Non-store donation centers that collect electronics for E-cycle Washington will only take 3 products per donor, per day.",
        "drop_off": true,
        "hours": "Mon-Sun: 7:30am - 6pm",
        "latitude": "47.56053000035939",
        "location_type": "Business",
        "longitude": "-122.1525500001822",
        "mail_in": false,
        "materials": 
            [ "Monitors", "Computers, Laptops, Tablets", "TVs" ],
        "max_volume": "3 products per donor, per day.",
        "min_volume": null,
        "name": "Goodwill Newport Hills Donation Center",
        "phone": "()",
        "pick_up": false,
        "residents": true,
        "state": "WA",
        "street": "5115 112th PL SE",
        "website": "http://www.seattlegoodwill.org/",
        "zipcode": "98006" } ]

###Materials API

The static materials data used to build WDIDW, including subcategories and descriptions, can be accessed through the following API request:

    http://www.wdidw.com/api/materials